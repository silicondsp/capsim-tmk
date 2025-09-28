

/*
    Capsim (r) Text Mode Kernel (TMK)
    Copyright (C) 1989-2017  Silicon DSP  Corporation

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

    http://www.silicondsp.com
    Silicon DSP  Corporation
    Las Vegas, Nevada
*/



#include "capsim.h"
#include <string.h>

#define MEMSEG

/* buffer.c */
/*********************************************************************

			BUFFER MANAGEMENT

**********************************************************************

Routines to manage the random access buffer data structures.

Programmer: D.G.Messerschmitt
Date: November 2, 1984
Date of last modification: October, 1988

Modified UNIX version
D. J. Hait
July 15, 1985

Mods: 10/88 L.J. Faber  add memory freeing mechanism
Mods: 1/89 L.J. Faber  clean up, bug correction
*/


extern void ErrorAlloc();
extern block_Pt pb_error;
extern block_Pt pg_current;
#ifndef EMBEDDED_ECOS
extern	FILE *krn_bufferGrowth_F;
#endif

void add_cells(cell_t * pcell_ins,int cellsize,int no_cells);


/********************************************************************

		DATA STRUCTURE OF A BUFFER

********************************************************************
A buffer is a doubly linked list of cell structures, each with
a pointer to a data storage location */
#ifdef  IGNORE
typedef struct cell {

	/* pointer to the next newest cell */
	struct cell *pnew;

	/* pointer to the next oldest cell */
	struct cell *pold;

	/* pointer to the cell data storage location */
	POINTER pdata;

	} cell_t;


/* Data structure of a BUFFER */
typedef struct {

	/* size of one cell in bytes */
	int cellsize;

	/* maximum samples delay which must be retained in buffer */
	int dmax;

	/* minimum samples delay when this buffer is used for input  */
	int dmin;

	/* current number of allocated buffer cells */
	int cells_alloc;

	/* pointer to last (input/output) cell accessed by the user */
	cell_t *plast_rd;
	cell_t *plast_wr;

	/* delay of the 'plast' cell relative to current sample */
	int dlast_rd;
	int dlast_wr;

	/* pointer to the cell where the most recent new sample
	  was stored in the buffer by the outputting block */
	cell_t *pnewest;

	/* number of samples currently stored in the buffer:
	  the current and any newer samples, and past samples
	  with delay less than or equal to dmin -- these are
	  samples accessible by the inputting block */
	int cells_stored;

	/* have the buffer cells been initialized? */
	int init_buffer;

	/* table to hold pointers for allocated memory segments,
	  needed to free them later */
	cell_t **memseg;

	} buffer_t, *buffer_Pt;
#endif


/* a variable used to keep track of whether a buffer is successfully
  accessed or not -- it is set to one whenever a STAR adds a sample
  to a buffer, or time is successfully incremented; reset to zero
  by BufferActive() */

static int active = 0;

/******************************************************************

			CreateBuffer()

*******************************************************************

Function to create a new buffer

Returns: a pointer to the new BUFFER data structure
*/

buffer_Pt CreateBuffer()

{
	buffer_Pt pbuffer;

/* Dynamically allocate storage for BUFFER data structure */
pbuffer = (buffer_Pt) calloc(1,sizeof(buffer_t));
if(!pbuffer) ErrorAlloc("Create Buffer in krn_buffer");

/* initialize maximum delay; it can be reset from user stars */
pbuffer->dmax = 5;

/* initialize minimum delay; it can be reset from user stars */
pbuffer->dmin = 0;

/* the cellsize is set negative to indicate that it has not
  been set by the connected stars */
pbuffer->cellsize = -1;

/* the buffer has not been initialized */
pbuffer->init_buffer = 0;

/*
 * allocate space for memeory segments
 */
#ifdef MEMSEG
pbuffer->memseg = (cell_t **) calloc(krn_maxMemSegments,sizeof(cell_t *));
if(!pbuffer->memseg) {
        fprintf(stderr,"maxMemSegments=%d\n",krn_maxMemSegments);
        ErrorAlloc("Create Buffer could not allocate memory segment");
}
#endif
return(pbuffer);
}


/***********************************************************************

			FreeBuffer()

************************************************************************

Function de-allocates a buffer.  Argument is a pointer to the buffer.

Written: 7/88 ljfaber.  Needed to stop growing memory problems!
Mod: 8/88 ljfaber. make sure buffer has been initialized.
Mod: 10/88 ljfaber. return if buffer is null.
*/

void FreeBuffer(buffer_Pt pbuf)

{
	int i;
#if 00
if(pbuf == NULL)
	return;

/* check that buffer has been initialized */
if(pbuf->init_buffer == 1) {
        // KrnFreeBuffer(pbuf);
	/* free the buffer cell and data segments */
#ifdef MEMSEG
	for(i=0; pbuf->memseg[i] != NULL; i++) {
//fprintf(stderr,"freeing segment %d \n",i);
//		free((pbuf->memseg[i])->pdata);
//		free(pbuf->memseg[i]);
	}
#endif
}
#ifdef MEMSEG
free(pbuf->memseg);
#endif

/* now free buffer */
free(pbuf);
#endif

return;

}

/***********************************************************************

			CellSize()

************************************************************************

Function sets the size of a cell

Arguments:
	cellsize: size of a single cell in the buffer, in bytes

(A cell is said to contain a single sample, where sample can be
an arbitrary data structure such as a union or structure)

*/

CellSize(buffer_Pt  pbuffer,int cellsize)


{
//fprintf(stderr," CellSize Current  :%d ==================\n",pbuffer->cellsize);
if(pbuffer->cellsize <  0) {
	/* cellsize has not been set before */
	pbuffer->cellsize = cellsize;
//	fprintf(stderr,"Buffer CellSize set  to:%d\n",cellsize);
}

else if(pbuffer->cellsize != cellsize) {
	/* inconsistent definition of cellsize: the input
	  and output star have different notions of
	  cellsize and we had better abort */

//	fprintf(stderr,"CellSize to set:%d buffer cell size=%d \n",cellsize,pbuffer->cellsize);
    ErrorPrint("",800);
}
}

/***********************************************************************

			delay_max()

************************************************************************

Function sets the maximum delay of the buffer, i.e., the number of
past samples which must be retained.
If this routine is never called, dmax defaults to the value of dmin.

Arguments:
	pbuffer, pointer to the buffer
	dmax, the new value of the maximum delay

Returns:
	nothing
*/

void delay_max(buffer_Pt  pbuffer,int dmax)


{

/* since this routine can be called by both the input and output star,
  only keep the largest value requested */
if(dmax > pbuffer->dmax)
	pbuffer->dmax = dmax;

}


/***********************************************************************

			delay_min()

************************************************************************

Function sets the minimum delay of the buffer, i.e., the minimum delay
with which a buffer is ever accessed, when it is the input to a star.
The function is only called by inputting stars.

Functionally, the minimum delay determines the number of preliminary
zero samples which are placed in a buffer, seen by the inputting star.

If this routine is never called dmin_in defaults to zero.
The delay maximum is always >= delay minimum.

Arguments:
	pbuffer, pointer to the buffer
	dmin, the new value of the minimum delay

Returns:
	nothing
*/

void delay_min(buffer_Pt pbuffer,int dmin)


{
pbuffer->dmin = dmin;

/* since dmax >= dmin, we will default dmax to dmin */
if(pbuffer->dmax < dmin)
	pbuffer->dmax = dmin;
}

/***********************************************************************

			init_buffer()

************************************************************************

Function initializes a buffer, allocating memory for cells and
setting up the double linked list.

This routine is called the first time a star tries to access a buffer;
it cannot be called by the kernel because parameters of the buffer,
like minimum delay and cellsize, are set when stars execute.

The number of cells allocated is dmax (to store past samples)
plus two: an initial sample and room for the first output sample.

Arguments:
	pbuffer, pointer to the buffer to be initialized

Returns:
	nothing
*/

void init_buffer(buffer_Pt  pbuffer)


{
	cell_t *pcell;		/* pointer to a CELL */

/* the cellsize will default to a floating value */
if(pbuffer->cellsize < 0)
	pbuffer->cellsize = sizeof(float);

/* Start with a circularly linked list with just one cell */
pcell = (cell_t *) calloc(1,sizeof(cell_t));
if(!pcell) ErrorAlloc("Cell Allocation in krn_buffer");
KrnListInsNext(krn_bufferMemory,NULL,pcell);

pcell->pnew = pcell;
pcell->pold = pcell;

/* Allocate memory for the data itself */
pcell->pdata = calloc(1,pbuffer->cellsize);
if(!pcell->pdata) ErrorAlloc("Data in cell in krn_buffer");
KrnListInsNext(krn_bufferMemory,NULL,pcell->pdata);

/* store allocation point */
//HERE
#if 000
       if(pbuffer->memseg[0]) {
                if(pbuffer->memseg[0]->pdata)
                      free((pbuffer->memseg[0])->pdata);
                free(pbuffer->memseg[0]);
        }
#endif
#ifdef MEMSEG
pbuffer->memseg[0] = pcell;
pbuffer->memseg[1] = NULL;
#endif
/* Add cells to the circularly linked list */
add_cells(pcell,pbuffer->cellsize,pbuffer->dmax+1);

/* store allocation point */
#if 0000
       if(pbuffer->memseg[1]) {
                if(pbuffer->memseg[1]->pdata)
                      free((pbuffer->memseg[1])->pdata);
                free(pbuffer->memseg[1]);
        }
#endif
#ifdef MEMSEG
pbuffer->memseg[1] = pcell->pnew;
pbuffer->memseg[2] = NULL;
#endif


pbuffer->cells_alloc = pbuffer->dmax+2;
pbuffer->cells_stored = pbuffer->dmin;

/* begin at arbitrary cell */
pbuffer->plast_wr = pbuffer->pnewest = pcell;
pbuffer->dlast_wr = 0;
pbuffer->plast_rd = pcell;
pbuffer->dlast_rd = 0;

pbuffer->init_buffer = 1;

/* simulation is active because a buffer has been initialized */
active = 1;

}


extern char *FindSignalNameFromBuffer();

/**********************************************************************

			IncWrPtr()

***********************************************************************

Function increments the buffer write-pointer to an available cell,
allocating an additional chunk of cells if there is no space.

Additional memory is always allocated, up to the limit of krn_maxMemSegments
chunks, each of size CELL_INC.  If this (large) limit is exceeded,
an error message is given; the custom star design is probably faulty,
with excessive outputs during a single star visit.

This routine does not actually store data in the buffer cell, but
rather sets the write pointer to a valid cell.  The calling routine
(user star) will actually store the sample in the cell -- this allows
the size of a cell to be arbitrary and unknown to the buffer routines.

Arguments:
	pbuffer: pointer to the buffer for the new sample
Returns:
 1 if Buffer is FULL
 0 Otherwise

Modified: Sasan Ardalan. Added buffer growth monitoring. Results are
	  stored in a file(buffer.dat).
	  The file contains the name of the connection
	  and the number of segments (128 cells) associated with the
	  buffer.
	  Also inc_wr_ptr returns a 1 if buffer is full. That is,
	  the maximum number of segments is exceeded.
*/

int IncWrPtr(buffer_Pt pbuffer)


{
	block_Pt	pgalaxy;
	int i;

/*
 * if the buffer has not been initialized, this is the first access
 */
if(!pbuffer->init_buffer)
	init_buffer(pbuffer);

/*
 * Check if there is adequate memory for a new sample
 */
if(pbuffer->cells_alloc <=
	1 + pbuffer->cells_stored + pbuffer->dmax - pbuffer->dmin) {

	/*
	 * add a chunk of cells to the linked list after pnewest
 	 */
	add_cells(pbuffer->pnewest,pbuffer->cellsize,CELL_INC);
	pbuffer->cells_alloc += CELL_INC;

	/*
	 * New...store memory segment pointer
	 * Do this to free buffer allocated memory
	 * for multiple runs.
	 */
#ifdef MEMSEG
	for(i=0; pbuffer->memseg[i] != NULL; i++)
		;
#endif
#if 1
	/*
	 * Find the name of the connection with buffer pointer pbuffer.
	 * Print the maximum segments into a file
	 */
	pgalaxy = pg_current;
	/*
	 * auto move to top level
	 */
	while(pgalaxy->type != UTYPE)
        	pgalaxy = pgalaxy->pparent;
#ifndef EMBEDDED_ECOS
	if(krn_bufferGrowth_F)
	       fprintf(krn_bufferGrowth_F,"%s %d\n",
			FindSignalNameFromBuffer(pbuffer,pgalaxy),i-1);
#endif
#endif
	if(i > krn_maxMemSegments - 2) {
		/*
		 * too many buffer segments
		 * Don't print error since we can now
 		 * control buffer growth.
		 * Let star print error message if necessary
		 * ErrorPrint("",805);
		 */
		return(1);
	}
#ifdef MEMSEG
        if(pbuffer->memseg[i]) {
                if(pbuffer->memseg[i]->pdata)
                      free((pbuffer->memseg[i])->pdata);
                free(pbuffer->memseg[i]);
        }

	pbuffer->memseg[i] = pbuffer->pnewest->pnew;
	pbuffer->memseg[i+1] = NULL;
#endif

}

/*
 * point to the next buffer input cell
 */
pbuffer->pnewest = pbuffer->pnewest->pnew;

/*
 * for efficiency, reset the write-pointer to the newest sample and the
 *  access delay to zero, since usually a block will write into the
 *  newest sample first
 */
pbuffer->plast_wr = pbuffer->pnewest;
pbuffer->dlast_wr = 0;

++(pbuffer->cells_stored);

active = 1;
return(0);

}


/***********************************************************************

			IncRdPtr()

************************************************************************

Routine increments the buffer read-pointer, if possible.
It returns the number of (readable) samples stored in the buffer.

Whether the pointer can be incremented depends on whether there are
any samples stored -- this number decreases upon every increment.

Returns:
	The number of samples stored in the buffer before
	the time increment (if there were no samples,
	the buffer state is not changed)

Arguments:
	pbuffer: pointer to the buffer in question
*/

int IncRdPtr(buffer_Pt pbuffer)


{

/* initialize the buffer if necessary */
if(!pbuffer->init_buffer)
	init_buffer(pbuffer);

/* If no cells are currently stored in the buffer, do nothing */
if(pbuffer->cells_stored == 0)
	return(0);

/* The pointer increment is a call from an inputting block --
  hence increment the plast_rd pointer by one cell. */
pbuffer->plast_rd = pbuffer->plast_rd->pnew;

/* The time increment has decremented the number of cells available */
--(pbuffer->cells_stored);

/* the calling STAR is active and not deadlocked */
active = 1;

return((pbuffer->cells_stored)+1);

}


/**********************************************************************

			BufferAccess()

***********************************************************************

Routine returns a pointer to cell data structure, either for inputting
or outputting stars.

The delay of the requested sample can be expressed either relative to
the write-pointer (newest sample), appropriate for outputting stars,
or relative to the read-pointer, appropriate for inputting stars.

Returns:
	pointer to the cell containing the requested
		sample

Arguments:
	pbuffer: pointer to the buffer from which the sample is
		requested
	rd_flag: 1 for data request relative to read pointer
		 0 for data request relative to write pointer
	delay: delay of the sample requested
*/

POINTER BufferAccess(pbuffer, rd_flag, delay)

	buffer_Pt pbuffer;
	int rd_flag;
	int delay;
{
	cell_t *pcell;
	int i,dinc;

/* if the buffer has not been initialized, this is the first access */
if(!pbuffer->init_buffer)
	init_buffer(pbuffer);

/* check that the delay is legal */
if(delay < 0) ErrorPrint("",801);
if(delay > pbuffer->dmax) ErrorPrint("",802);
if(rd_flag && delay < pbuffer->dmin) ErrorPrint("",803);

if(rd_flag) {
	/* delay is specified relative to the read-pointer */
	/* move forward or backward in the buffer, relative to the
	  last reference, to find the requested sample */
	pcell = pbuffer->plast_rd;
	dinc = delay - pbuffer->dlast_rd;

	if(dinc != 0) {
		if(dinc > 0)
			for(i=0; i<dinc; ++i)
				pcell = pcell->pold;
		else
			for(i=0; i<-dinc; ++i)
				pcell = pcell->pnew;

		/* store offset for future access */
		pbuffer->plast_rd = pcell;
		pbuffer->dlast_rd = delay;
	}

	/* Return a pointer to data */
	return(pcell->pdata);
}

else {
	/* delay is specified relative to the write-pointer */
	/* move forward or backward in the buffer, relative to the
	  last reference, to find the requested sample */
	pcell = pbuffer->plast_wr;
	dinc = delay - pbuffer->dlast_wr;

	if(dinc != 0) {
		if(dinc > 0)
			for(i=0; i<dinc; ++i)
				pcell = pcell->pold;
		else
			for(i=0; i<-dinc; ++i)
				pcell = pcell->pnew;

		/* store offset for future access */
		pbuffer->plast_wr = pcell;
		pbuffer->dlast_wr = delay;
	}

	/* Return a pointer to data */
	return(pcell->pdata);
}

}


/******************************************************************

			add_cells()

********************************************************************

Function adds cells to a circularly linked list

Returns: nothing

Auguments:
	pcell_ins: pointer to the cell where memory is to be added
		in the direction of pnew
	cellsize: size of each cell in bytes
	no_cells: number of cells to be added

*/

void add_cells(cell_t * pcell_ins,int cellsize,int no_cells)

{
	cell_t *pcell;
	POINTER pdata;
	int i;

/* Do nothing if the number of cells to add is zero */
if(no_cells == 0) return;

/* Allocate memory for the CELL data structures */
pcell = (cell_t *)calloc(no_cells,sizeof(cell_t));
if(!pcell) ErrorAlloc("Cell in krn_buffer add cells");
KrnListInsNext(krn_bufferMemory,NULL,pcell);
/* allocate memory for the data samples */
pdata = calloc(no_cells,cellsize);
if(!pdata) ErrorAlloc("Data in cell in krn_buffer add cells");

KrnListInsNext(krn_bufferMemory,NULL,pdata);
/* set the CELL pointers to the cells just allocated */
for(i=0; i<no_cells; ++i)
	(pcell+i)->pdata = pdata + i*cellsize;

/* insert new cells in the circular linked list after pcell_ins */
if(no_cells == 1) {
	pcell->pnew = pcell_ins->pnew;
	pcell->pold = pcell_ins;
	pcell_ins->pnew->pold = pcell;
	pcell_ins->pnew = pcell;
}
else {
	/* situation is more complicated:
	  link the new array of cells, then attach
	  the ends into the old circular list */

	for(i=1; i<no_cells-1; ++i) {
		(pcell+i)->pold = pcell+i-1;
		(pcell+i)->pnew = pcell+i+1;
	}
	(pcell+no_cells-1)->pnew = pcell_ins->pnew;
	(pcell+no_cells-1)->pold = pcell+no_cells-2;
	pcell->pold = pcell_ins;
	pcell->pnew = pcell+1;
	pcell_ins->pnew->pold = (pcell+no_cells-1);
	pcell_ins->pnew = pcell;
}

return;

}

/*****************************************************************

			BufferLength()

******************************************************************

Returns the number of samples currently stored in a buffer.
*/

int BufferLength(buffer_Pt pbuffer)


{
/* star may call this function without accessing a buffer --
  check if the buffer has been initialized */
if(!pbuffer->init_buffer)
	init_buffer(pbuffer);

return(pbuffer->cells_stored);

}

/*****************************************************************

			BufferActive()

******************************************************************

Routine checks the active flag, and resets that flag

Returns:
	1 if buffer was successfully accessed since last reset
	0 otherwise
*/

BufferActive()

{

if(active) {		/* buffer accessed since last reset */
	active = 0;	/* reset flag */
	return(1);
}

return(0);

}


/*****************************************************************

			examine_buffer()

******************************************************************

This routine prints out the contents of the passed buffer.

It also prints out the contents assuming that
the samples are floating point numbers.
This routine is meant to aid in debugging and is not used under
normal circumstances.
*/

examine_buffer(pbuffer)
	buffer_Pt pbuffer;
{
	int i;
	cell_t *pcell;

/* if the buffer has not been initialized, this is the first access,
  we must initialize it */
if(!pbuffer->init_buffer)
	init_buffer(pbuffer);

fprintf(stdout,
"\ncellsize = %d, max. delay = %d, no. of cells allocated = %d\n",
		pbuffer->cellsize, pbuffer->dmax, pbuffer->cells_alloc);
fprintf(stdout,
"delay for last read-pointer = %d, no. of cells stored = %d\n",
		pbuffer->dlast_rd, pbuffer->cells_stored);
fprintf(stdout,
"last read-pointer = %d, newest write-pointer = %d\n",
		pbuffer->plast_rd, pbuffer->pnewest);

/* print all cells that have something stored in them */
fprintf(stdout,"\nStarting with the newest:\n");
pcell = pbuffer->pnewest;
for(i=0;i< pbuffer->cells_stored + pbuffer->dmax - pbuffer->dmin; ++i) {
	fprintf(stdout,"	Pointer %d	%f",
		pcell, *(float *)(pcell->pdata));

	/* Identify future, current, and past samples */
	if(i < pbuffer->cells_stored-pbuffer->dmin-1)
		fprintf(stdout,"  (future sample");

	else if(i == pbuffer->cells_stored-pbuffer->dmin-1)
		fprintf(stdout,"  (current sample");

	else
		fprintf(stdout," (past sample");

	/* Identify the last access pointer */
	if(pcell == pbuffer->plast_rd)
		fprintf(stdout,",last access)\n");
	else
		fprintf(stdout,")\n");

	pcell = pcell->pold;
}
fprintf(stdout,"\n");

}



/*****************************************************************

			KrnFreeBuffer()

******************************************************************

*/

KrnFreeBuffer(buffer_Pt pbuffer)

{
	int i;
	cell_t *pcell;
return(0);
/* if the buffer has not been initialized, this is the first access,
  we must initialize it */
if(!pbuffer->init_buffer)
	init_buffer(pbuffer);

fprintf(stdout,
"\nKrnFreeBuffer cellsize = %d, max. delay = %d, no. of cells allocated = %d\n",
		pbuffer->cellsize, pbuffer->dmax, pbuffer->cells_alloc);
fprintf(stdout,
"delay for last read-pointer = %d, no. of cells stored = %d\n",
		pbuffer->dlast_rd, pbuffer->cells_stored);
fprintf(stdout,
"last read-pointer = %d, newest write-pointer = %d\n",
		pbuffer->plast_rd, pbuffer->pnewest);

/* print all cells that have something stored in them */
fprintf(stdout,"\nStarting with the newest:\n");
pcell = pbuffer->pnewest;
for(i=0;i< pbuffer->cells_stored + pbuffer->dmax - pbuffer->dmin; ++i) {
        if(pcell->pdata)
                 free(pcell->pdata);
	pcell = pcell->pold;
}
fprintf(stdout,"\n");

}





/*
 * This recursive routine searches the topology starting from the Universe
 * and attempts to find the connection signal name corresponding
 * to the supplied buffer pointer.
 *
 * written by Sasan H. Ardalan
 * July 29, 1990
 */
 char *FindSignalNameFromBuffer(pbuffer,pgalaxy)
POINTER		pbuffer;
block_Pt 	pgalaxy;


{


block_Pt outBlk_P, inBlk_P;
int inNum;
int err;
star_Pt pstar;
int input_no;
POINTER signal_name;

/*
 * point to first internal block in pgalaxy
 */
if((inBlk_P = pgalaxy->pchild) == NULL) {
	pb_error = pgalaxy;
	return("Bad news");
}

/*
 * examine each block in turn
 */
do {
	/*
  	 *  For each block search input connections and compare
	 *  buffer pointers.
	 */
	for(inNum=0; inNum<IO_BUFFERS; inNum++) {
		if(inBlk_P->type == GTYPE) continue;
		pstar = inBlk_P->star_P;
		if(pstar->inBuffer_P[inNum] == pbuffer) {
			/*
			 * Found a match!
			 * Return the signal name.
			 */
			return(pstar->signalName[inNum]);

		}
	}
	/*
	 * if block_to is GALAXY, then search it
	 */
	if(inBlk_P->type == GTYPE) {
		signal_name=FindSignalNameFromBuffer(pbuffer,inBlk_P);
		if(strcmp(signal_name,"Not_Found") != 0 )
			return(signal_name);

	}

} while((inBlk_P = inBlk_P->pfsibling) != pgalaxy->pchild);

/*
 * If we get here, then no match was found. Bad news!
 */

return("Not_Found");
}











