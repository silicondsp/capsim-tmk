
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
/* run.c */
/**********************************************************************

		Simulation Schedule and Run Routines

***********************************************************************

This file contains the routines necessary for reordering the blocks
for efficient execution;
and the routines necessary to run a BLOSIM simulation.
*/
#include <string.h>
#include <stdio.h>
#include "capsim.h"

/**********************************************************************

		External Function Declarations

***********************************************************************
*/

/* buffer.c */
extern int BufferActive();



int FreeBuffer(buffer_Pt pbuf);
int InitAll(block_Pt pgalaxy);
int Schedule(block_Pt pgalaxy);
int MultiRun(int status,block_Pt pgalaxy);
int Ready0(block_Pt pb_unsched,block_Pt pblock);
int Ready1(block_Pt pb_unsched,block_Pt pblock);
int SingleRun(int status,block_Pt pgalaxy);


/* block.c */
//extern int MoveBlock();

/* connect.c */
//extern int ConnectAllStars();

/**********************************************************************

			Global declaration

***********************************************************************
*/

extern block_Pt pg_current;
extern block_Pt pb_current;
extern block_Pt pb_error;


/**********************************************************************
 *
 * KrnSetupRun
 *
 **********************************************************************
*/

int KrnSetupRun(galaxy_PP)
block_Pt *galaxy_PP;
{
block_Pt pgalaxy, pblock;
int err = 0;
int i;

pgalaxy = pg_current;

/* auto move to top level */
if(pgalaxy->blkType != KRN_BLOCK_TYPE_SPICE)
   while(pgalaxy->type != UTYPE)
	pgalaxy = pgalaxy->pparent;
pblock = pgalaxy->pchild;

/* check for empty universe */
if(pblock == NULL) {
//SHA FIXED 08182001
	pb_error=NULL;
	return(err = 41);
}

/* check all universe blocks for input/output connections */
do {
	for(i=0; i< IO_BUFFERS; i++) {
		if(pblock->inputs[i] == NULL)
			break;
		if((pblock->inputs[i] == pgalaxy) && (pgalaxy->blkType !=
KRN_BLOCK_TYPE_SPICE))
			return(err = 42);
	}
	for(i=0; i< IO_BUFFERS; i++) {
		if(pblock->outputs[i] == NULL)
			break;
		if((pblock->outputs[i] == pgalaxy) && (pgalaxy->blkType !=
KRN_BLOCK_TYPE_SPICE))
			return(err = 42);
	}

} while((pblock = pblock->pfsibling) != pgalaxy->pchild);

*galaxy_PP=pgalaxy;
#define MEM_FREE
#ifdef MEM_FREE
//SHA Free up buffer memory
//fprintf(stderr,"BufferMemorySegs=%d\n",KRN_LIST_SIZE(krn_bufferMemory));
//fprintf(stderr,"BufferPointerMemorySegs=%d\n",KRN_LIST_SIZE(krn_bufferPointerMemory));
KrnListDestroy(krn_bufferMemory);
KrnListDestroy(krn_bufferPointerMemory);

KrnListInit(krn_bufferMemory,KrnDestroy);
KrnListInit(krn_bufferPointerMemory,KrnDestroyBuffer);
#endif

/* we're ready to run */
if(err = InitAll(pgalaxy))
	return(err);
if(err = ConnectAllStars(pgalaxy))
	return(err);
if(err = Schedule(pgalaxy))
	return(err);
return(err);
}

/************************************************************
 * KrnRunPhases: Run all phases
 ************************************************************
 */
int KrnRunPhases(galaxy_P)
block_Pt galaxy_P;
{
int err;
/* run all phases */
if(err = SingleRun(SYSTEM_INIT, galaxy_P))
	return(err);
if(err =  SingleRun(USER_INIT, galaxy_P))
	return(err);
do {
	if((err = MultiRun(MAIN_CODE, galaxy_P)) > 1)
		return(err);
} while(err != 0);

if(err = SingleRun(WRAPUP, galaxy_P))
	return(err);
/*
 * all is well
 */
return(err);

}


/**********************************************************************

			LineRun()

***********************************************************************
This is the simulation run command.
*/

int LineRun(void)
{
block_Pt pgalaxy, pblock;
block_Pt galaxy_P;
int err = 0;
int i;

err=KrnSetupRun(&galaxy_P);
if(err) return(err);
err=KrnRunPhases(galaxy_P);
return(err);

}


/**********************************************************************

			Schedule()

***********************************************************************

Arranges the order of blocks in the galaxy list.  This is the order of
execution when running.  The first block to execute is the galaxy child,
the next is its forward sibling, etc.  Blocks are moved as necessary to
satisfy certain scheduling rules.  Conflicts will occur if there are
feedback loops in a galaxy, separate loops, etc.
Any GALAXY blocks cause a recursive call to schedule();
thus, scheduling is done independently within each GALAXY.

There are three successive rule levels for scheduling a block:
	level = 0: the block must have no unscheduled blocks as inputs;
			thus, blocks with no inputs (source blocks) or
			only galaxy inputs, will be first in the list.
			This level is sufficient to schedule normal
			feedforward topologies completely.
	level = 1: the block must have at least one scheduled block or
			a galaxy input as an input; thus in a feedback
			loop, the "primary" star will be first.
	level = 2: the next block in the list is scheduled.  This level
			occurs if a topology has no source blocks
			and no inputs (usually in universe topology).
The level is reset to zero whenever a block is successfully scheduled.
If no blocks can be scheduled at a particular level, it is increased.

*/

int Schedule(block_Pt pgalaxy)

	  /* pointer to the GALAXY to be scheduled  */
{
	block_Pt pblock;
	block_Pt pb_unsched;	/* first unscheduled block in galaxy */
	int completed;		/* set to one if all blocks scheduled */
	int deadlocked;		/* set to one if GALAXY is deadlocked */
	int level = 0;		/* 0,1,2  schedule forcing level */

if((pb_unsched = pgalaxy->pchild) == NULL)
	return(0);

do {
	completed = 1;
	deadlocked = 1;

	pblock = pb_unsched;
	/* cycle thru all unscheduled blocks in the GALAXY */
	do {
		/* determine if block is ready to schedule */
		if( (level == 0 && Ready0(pb_unsched,pblock))
		 || (level == 1 && Ready1(pb_unsched,pblock))
		 || (level >= 2) ) {

			/* schedule block by moving it just in front
			  of pb_unsched in linked list */
			if(pblock != pb_unsched)
				MoveBlock(pb_unsched,pblock);
			else	/* moving not necessary */
				pb_unsched = pblock->pfsibling;

			/* if GALAXY, call Schedule() recursively */
			if(pblock->type == GTYPE && pblock->blkType != KRN_BLOCK_TYPE_SPICE)
				Schedule(pblock);

			/* schedule level not deadlocked */
			deadlocked = 0;
			/* reset scheduling level */
			level = 0;
		}
		else	/* block not scheduled this pass */
			completed = 0;

	} while((pblock = pblock->pfsibling) != pgalaxy->pchild);

	if(!completed && deadlocked)
		/* raise scheduling level for next pass */
		level += 1;

} while(!completed);

return(0);
}

/**********************************************************************

			Ready0()

***********************************************************************

Returns a one if all block's input have been scheduled,
or the block has no inputs.  Otherwise returns a zero.
*/

int Ready0(block_Pt pb_unsched,block_Pt pblock)

	 	/* first unscheduled GALAXY block */
	 	/* candidate block */
{
	block_Pt pblock_from;  /* pointer to block connected to input */
	block_Pt ptemp;
	int in_no;

/* check each input to the block in turn */
for(in_no=0; in_no<IO_BUFFERS; in_no++) {

	if((pblock_from = pblock->inputs[in_no]) == NULL)
		break;

	/* check all siblings after first unscheduled block */
	/* make sure they are not an input to pblock */
	ptemp = pb_unsched;
	do {
		if(pblock_from == ptemp)
			/* this block has an unscheduled input */
			return(0);

	} while((ptemp = ptemp->pfsibling) != pblock->pparent->pchild);
}

/* any input blocks are scheduled */
return(1);

}


/**********************************************************************

			Ready1()

***********************************************************************

Returns a one if at least one input block has been scheduled, or is a
galaxy input.  Otherwise returns a zero.
*/

int Ready1(block_Pt pb_unsched,block_Pt pblock)

	 /* first block in GALAXY not scheduled */
	 	/* block pointer */
{
	block_Pt pblock_from;  /* pointer to block connected to input */
	block_Pt ptemp;
	int in_no;

/* check each input to the block in turn */
for(in_no=0; in_no<IO_BUFFERS; in_no++) {

	if((pblock_from = pblock->inputs[in_no]) == NULL)
		break;

	/* see if the input is a galaxy input */
	if(pblock_from == pblock->pparent)
		/* success */
		return(1);

	/* check if any scheduled block is the input */
	ptemp = pblock->pparent->pchild;
	while(ptemp != pb_unsched) {
		if(pblock_from == ptemp)
			/* success */
			return(1);
		ptemp = ptemp->pfsibling;
	}
}

/* this block does not have any scheduled inputs */
return(0);

}


/**********************************************************************

			SingleRun()

***********************************************************************

Executes the blocks in a GALAXY the order determined by schedule()

When it encounters a GALAXY, it calls itself recursively to
run the blocks within that GALAXY

Each block is executed precisely once
*/

int SingleRun(int status,block_Pt pgalaxy)

	  /* GALAXY to be executed */
	 	/* status code to pass to the star code */
{
	block_Pt pblock;
	int star_return;

pblock = pgalaxy->pchild;

/* cycle through all the blocks in the GALAXY */
do {
	if (pblock->type == GTYPE ) {
		if(pblock->blkType != KRN_BLOCK_TYPE_SPICE) {
		    /* block is a GALAXY: call single_run() recursively */
		    star_return = SingleRun(status,pblock);
		    if(star_return != 0)
			return(star_return);
		}
	}
	else  {

		/* execute the STAR block */
		/* save block pointer for any error message */
		pb_error = pblock;

		/* now call the STAR function */
	 	star_return =
	 	//	(*(pblock->function))(status,pblock);
	 	 	(*(pblock->function))(status,(char *)pblock);



		/* error if STAR returns non-zero */
		if(star_return != 0)
			return(1000 + star_return);
	}

} while((pblock = pblock->pfsibling) != pgalaxy->pchild);

return(0);

}


/**********************************************************************

			MultiRun()

***********************************************************************

Executes the blocks in a GALAXY the order of the linked list; this order
is determined by schedule().  Blocks are visited sequentially, until
all deadlock.  If a GALAXY block is encountered, the blocks within that
GALAXY are run until they deadlock.  To control buffer lengths, source
STAR blocks (those with no inputs) are only executed once per visit of
their host galaxy.

The deadlock criterion for a GALAXY visit is if, in a sequence through
all blocks in the GALAXY, no star successfully accesses a data buffer,
or, some star returns an error.  Unsuccessful buffer access means
that no data samples are input or output (active buffer).

A zero is returned if the GALAXY was not active, a one if active.
If a called star function returns an error, the function returns
(1000 + error value).
*/

int MultiRun(int status,block_Pt pgalaxy)

	 	/* GALAXY which is to be executed */
	 	/* status to pass to the user star code */
{
	block_Pt pblock;
	star_Pt star_P;
	int star_return;
	int run_return;
	int active_block;	/* any block active this pass? */
	int active_galaxy = 0;	/* any activity this galaxy visit? */
	int first_pass = 1;	/* first time through galaxy blocks? */

/* pass through all blocks as long as one or more blocks is active */
do {
	pblock = pgalaxy->pchild;
	active_block = 0;
	/* cycle through all the blocks in the GALAXY */
	do {
		/* if block is a GALAXY; call multi_run() recursively */
		if(pblock->type == GTYPE) {
			run_return =MultiRun(status,pblock);
			if(run_return > 1)
				return(run_return); /* star error */
			if(run_return == 1)
				active_block = 1;
		}
		else { /* block is STAR */
			/* skip any source star after first pass */
			if(!first_pass && pblock->inputs[0] == NULL)
				continue;

			star_P = pblock->star_P;
			 star_return =
			 	(*(pblock->function))(status,(char *)pblock);
			 // 	(*(pblock->function))(status,pblock);



			/* save block pointer for any error message */
			pb_error = pblock;
			if(star_return != 0)
				return(1000 + star_return);

			/* check for activity in buffers */
			if(BufferActive())
				active_block = 1;
		}

	} while((pblock = pblock->pfsibling) != pgalaxy->pchild);

	first_pass = 0;
	if(active_block)
		active_galaxy = 1;

} while(active_block);

return(active_galaxy);

}

/***********************************************************************

			InitAll()

************************************************************************

This routine clears the state variables for all star blocks.
Any stars in a galaxy which use arg parameters
retrieve their values from the galaxy parameters.
Any connected data buffers are freed.
*/

int InitAll(block_Pt pgalaxy)


{
	block_Pt pblock;
	int err;

if((pblock = pgalaxy->pchild) == NULL) {
	pb_error = pgalaxy;
	return(40);
}
do {
	/* clear all data structures */
	if(pblock->type == GTYPE)
		InitAll(pblock);
	else {
//fprintf(stderr,"DEBUG InitOne \n");
		InitOne(pblock);
        }

} while((pblock = pblock->pfsibling) != pgalaxy->pchild);

return(0);
}

/***********************************************************************

			InitOne()

************************************************************************
This function initializes one (star-type) block.
It also frees any input buffers associated with it.

Written: 7/88 ljfaber
Modified: 10/88 ljfaber.  only input buffers are freed.
*/

int InitOne(block_Pt pblock)

{
	int i;

if(pblock->star_P->state_P != NULL) {
	free(pblock->star_P->state_P);
	pblock->star_P->state_P = NULL;
}

for(i=0; i<IO_BUFFERS; i++) {
	if(pblock->star_P->inBuffer_P[i] != NULL) {
		FreeBuffer((buffer_Pt)pblock->star_P->inBuffer_P[i]);
		pblock->star_P->inBuffer_P[i] = NULL;
	}

	if(pblock->star_P->outBuffer_P[i] != NULL)
		pblock->star_P->outBuffer_P[i] = NULL;
}

pblock->star_P->numberInBuffers = 0;
pblock->star_P->numberOutBuffers = 0;

return(0);
}
