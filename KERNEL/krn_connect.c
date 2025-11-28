
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



/* connect.c */
/**********************************************************************

			Connection Routines

***********************************************************************

This file contains all the routines necessary for connection
and disconnection of blocks.
It also contains the buffer (star) connection routines.
*/
#include <string.h>
#include "capsim.h"
buffer_Pt CreateBuffer();
int FindInput(block_Pt *p,int *i);
int WriteSignalName(block_Pt inBlk_P, int inNum, char *sigName);
int ConnectAllStars(block_Pt pgalaxy);
int ConnectTwoStars(block_Pt inBlk_P,int inNum);

/**********************************************************************

		External Function Declarations

***********************************************************************
*/
//extern char *NameTree();	/* prinfo.c */

extern int set_star_out();	/* star.c */
extern int set_star_in(); 	/* star.c */

extern POINTER create_buffer();	/* buffer.c */

//extern block_Pt FindBlock();	/* block.c */

/*********************************************************************

			Global declarations

**********************************************************************
*/
extern int line_mode;
extern int graphics_mode;
extern block_Pt pb_error;
extern block_Pt pb_current;
extern block_Pt pg_current;


/**********************************************************************

			LineConnect()

***********************************************************************

Function reads input line, and connects two blocks.
Auto-i/o number assignment is implemented, if a complete specification
is not provided.
*/

int LineConnect(char *line)

{
	char name_from[NAME_LENGTH];
	char name_to[NAME_LENGTH];
	int inNum, outNum, temp_no;
	char signalName[MAX_LINE];
	char st[MAX_LINE];
	int i, args;
	int imply_flag = 0;
	block_Pt outBlk_P, inBlk_P;
	block_Pt pgalaxy, ptemp;

strcpy(signalName,"");
pgalaxy = pg_current;

/* read the line */
args = sscanf(line,"connect%s%s%s%s%s",st,st,st,st,st);

if(args == 5) {
	args = sscanf(line,"connect%s%d%s%d%s",
  			name_from,&outNum,name_to,&inNum, signalName);
	if(args != 5)
		return(50);
}
else if(args == 4) {
	args = sscanf(line,"connect%s%d%s%d",
  			name_from,&outNum,name_to,&inNum);
	if(args != 4)
		return(50);
}
else if(args == 3) {
	args = sscanf(line,"connect%s%s%s",
  			name_from,name_to,signalName);
	if(args != 3)
		return(50);
	outNum = -1;
	inNum = -1;
}
else if(args == 2) {
	args = sscanf(line,"connect%s%s",
  			name_from,name_to);
	if(args != 2)
		return(50);
	outNum = -1;
	inNum = -1;
}
else
	return(50);

/* return pointers to the two blocks, NULL if block does not exist */
outBlk_P = FindBlock(pgalaxy, name_from);
inBlk_P = FindBlock(pgalaxy, name_to);

/* if blocks don't exist, are they "input" or "output" ? */
if(outBlk_P == NULL && strcmp(name_from,"input") != 0)
	return(51);
if(inBlk_P == NULL && strcmp(name_to,"output") != 0)
	return(52);

/* can not connect input directly to output of a GALAXY */
if(outBlk_P == NULL && inBlk_P == NULL)
	return(53);

/* check that input and output numbers are in range */
if(inNum >= IO_BUFFERS) {
	if(outBlk_P != NULL)
		pb_error = outBlk_P;
	return(54);
}
if(outNum >= IO_BUFFERS) {
	if(inBlk_P != NULL)
		pb_error = inBlk_P;
	return(55);
}

/* generate i/o numbers if necessary */
if(outNum < 0) {
	imply_flag = 1;
	if(outBlk_P == NULL) {
		for(i=0; i<IO_BUFFERS; i++) {
			temp_no = i;
			ptemp = pgalaxy;
			if(FindInput(&ptemp,&temp_no) != 0)
				break;
		}
	}
	else {
		for(i=0; i<IO_BUFFERS; i++) {
			if(outBlk_P->outputs[i] == NULL)
				break;
		}
	}
	if((outNum = i) == IO_BUFFERS)
		return(55);
}
if(inNum < 0) {
	imply_flag = 1;
	if(inBlk_P == NULL) {
		for(i=0; i<IO_BUFFERS; i++) {
			temp_no = i;
			ptemp = pgalaxy;
			if(FindOutput(&ptemp,&temp_no) != 0)
				break;
		}
	}
	else {
		for(i=0; i<IO_BUFFERS; i++) {
			if(inBlk_P->inputs[i] == NULL)
				break;
		}
	}
	if((inNum = i) == IO_BUFFERS)
		return(54);
}

/* now connect -- there are three cases to consider */
if(inBlk_P == NULL) {
	/* Output Port */
	if(outBlk_P->outputs[outNum] != NULL)
		return(56);
	ptemp = pgalaxy;
	temp_no = inNum;
	if(FindOutput(&ptemp,&temp_no) == 0)
		return(57);

	outBlk_P->outputs[outNum] = pgalaxy;
	outBlk_P->input_no[outNum] = inNum;
	if(line_mode || graphics_mode || imply_flag)
		outBlk_P->change_flag = 1;
}
else if(outBlk_P == NULL) {
	/* Input Port */
	if(inBlk_P->inputs[inNum] != NULL)
		return(57);
	ptemp = pgalaxy;
	temp_no = outNum;
	if(FindInput(&ptemp,&temp_no) == 0)
		return(56);

	inBlk_P->inputs[inNum] = pgalaxy;
	inBlk_P->output_no[inNum] = outNum;
	if(line_mode || graphics_mode || imply_flag)
		inBlk_P->change_flag = 1;

	/* get upstream signal name */
	if(pgalaxy->inputs[outNum] != NULL)
		strcpy(signalName,pgalaxy->signalName[outNum]);
	/* store name of connection (in inputting block only) */
	WriteSignalName(inBlk_P,inNum,signalName);
}
else {
	/* Both Normal Blocks */
	if(inBlk_P->inputs[inNum] != NULL)
		return(57);
	if(outBlk_P->outputs[outNum] != NULL)
		return(56);

	inBlk_P->inputs[inNum] = outBlk_P;
	inBlk_P->output_no[inNum] = outNum;
	outBlk_P->outputs[outNum] = inBlk_P;
	outBlk_P->input_no[outNum] = inNum;
	if(line_mode || graphics_mode || imply_flag) {
		outBlk_P->change_flag = 1;
		inBlk_P->change_flag = 1;
	}

	/* record signal name in inputting block  */
	WriteSignalName(inBlk_P,inNum,signalName);
}

return(0);

}


/*********************************************************************

			LineDisconnect()

**********************************************************************
Function reads input command to disconnect two blocks.
If specific port numbers are not given, they are interpolated:
	if the outputting block is not an 'input':
	then, the highest numbered connection from the outputting
		block to the inputting block is removed.
	else, the highest numbered connection at the inputting block
		that is an 'input' is removed.
else, the given port numbers are used if valid.
*/

int LineDisConnect(char *line)

{
	char st[NAME_LENGTH];
	char name_from[NAME_LENGTH];
	char name_to[NAME_LENGTH];
	int outNum;	/* output number of output connection */
	int inNum;	/* input number of input connection */
	int i, args;
	int imply_flag = 0;
	block_Pt outBlk_P, inBlk_P;
	block_Pt pgalaxy;

pgalaxy = pg_current;

/* read the line */
args = sscanf(line,"disconnect%s%s%s%s", st,st,st,st);

if(args == 4) {
	args = sscanf(line,"disconnect%s%d%s%d",
		name_from,&outNum,name_to,&inNum);
	if(args != 4)
		return(60);
}
else if(args == 2) {
	args = sscanf(line,"disconnect%s%s",
		name_from,name_to);
	if(args != 2)
		return(60);
	outNum = -1;
	inNum = -1;
}
else
	return(60);

/* determine if the named blocks exist */
outBlk_P = FindBlock(pgalaxy, name_from);
inBlk_P = FindBlock(pgalaxy, name_to);

/* check that blocks either exist or are input or output */
if(outBlk_P == NULL && strcmp(name_from,"input") != 0)
	return(61);
if(inBlk_P == NULL && strcmp(name_to,"output") != 0)
	return(62);

if(outBlk_P == NULL && inBlk_P == NULL)
	return(63);

if(inNum >= IO_BUFFERS || outNum >= IO_BUFFERS) {
	if(inBlk_P != NULL)
		pb_error = inBlk_P;
	else if(outBlk_P != NULL)
		pb_error = outBlk_P;
	return(64);
}

/* Generate correct io numbers as necessary */
if(outNum >= 0 && inNum >= 0) {
	if(outBlk_P == NULL) {
		if(inBlk_P->inputs[inNum] != pgalaxy
		 || inBlk_P->output_no[inNum] != outNum)
			return(63);
	}
	else if(inBlk_P == NULL) {
		if(outBlk_P->outputs[outNum] != pgalaxy
		 || outBlk_P->input_no[outNum] != inNum)
			return(63);
	}
	else {
		if(outBlk_P->outputs[outNum] != inBlk_P
		 || outBlk_P->input_no[outNum] != inNum)
			return(63);
		if(inBlk_P->inputs[inNum] != outBlk_P
		 || inBlk_P->output_no[inNum] != outNum)
			return(63);
	}
}
else if(outNum < 0 && inNum < 0) {
	imply_flag = 1;
	if(outBlk_P == NULL) {
		/* use the normal (to) block */
		for(i=IO_BUFFERS-1; i>=0; i--) {
			if(inBlk_P->inputs[i] == pgalaxy)
				break;
		}
		if((inNum = i) < 0)
			return(63);
	}
	else if(inBlk_P == NULL) {
		for(i=IO_BUFFERS-1; i>=0; i--) {
			if(outBlk_P->outputs[i] == pgalaxy)
				break;
		}
		if((outNum = i) < 0)
			return(63);
	}
	else {
		/* both normal blocks */
		for(i=IO_BUFFERS-1; i>=0; i--) {
			if(outBlk_P->outputs[i] == inBlk_P)
				break;
		}
		if((outNum = i) < 0)
			return(63);
		inNum = outBlk_P->input_no[outNum];
	}
}
else if(outNum < 0 && inNum >= 0) {
	imply_flag = 1;
	if(outBlk_P == NULL) {
		if(inBlk_P->inputs[inNum] != pgalaxy)
			return(63);
	}
	else if(inBlk_P == NULL) {
		for(i=IO_BUFFERS-1; i>=0; i--) {
			if(outBlk_P->outputs[i] == pgalaxy
			 && outBlk_P->input_no[i] == inNum)
				break;
		}
		if((outNum = i) < 0)
			return(63);
	}
	else {
		if(inBlk_P->inputs[inNum] != outBlk_P)
			return(63);
		outNum = inBlk_P->output_no[inNum];
	}
}
else if(outNum >= 0 && inNum < 0) {
	imply_flag = 1;
	if(outBlk_P == NULL) {
		for(i=IO_BUFFERS-1; i>=0; i--) {
			if(inBlk_P->inputs[i] == pgalaxy
			 && inBlk_P->output_no[i] == inNum)
				break;
		}
		if((inNum = i) < 0)
			return(63);
	}
	else if(inBlk_P == NULL) {
		if(outBlk_P->outputs[outNum] != pgalaxy)
			return(63);
	}
	else {
		if(outBlk_P->outputs[outNum] != inBlk_P)
			return(63);
		inNum = outBlk_P->input_no[outNum];
	}
}

if(inBlk_P != NULL) {
	inBlk_P->inputs[inNum] = NULL;
	if(line_mode || graphics_mode || imply_flag)
		inBlk_P->change_flag = 1;
}
if(outBlk_P != NULL) {
	outBlk_P->outputs[outNum] = NULL;
	if(line_mode || graphics_mode || imply_flag)
		outBlk_P->change_flag = 1;
}

return(0);

}


/**********************************************************************

			LineName()

***********************************************************************
Sets up a signal name for a connection.
Connections are referenced by block INPUT numbers!
It is not allowed to name galaxy outputs.
It is allowed to name galaxy inputs but they will be overwritten
by higher level galaxy signal names.
*/

int LineName(char *line)

{
	char name_to[NAME_LENGTH];
	int inNum;	/* input number of input connection */
	char sigName[MAX_LINE];
	int i, args;
	block_Pt inBlk_P;
	block_Pt pgalaxy;

pgalaxy = pg_current;

/* read the line */
args = sscanf(line,"name%s%d%s", name_to,&inNum,sigName);
if(args < 3)
	return(65);

if(strcmp(name_to,"output") == 0)
	return(68);
if((inBlk_P = FindBlock(pgalaxy, name_to)) == NULL)
	return(66);
if(inBlk_P->inputs[inNum] == NULL)
	return(67);

WriteSignalName(inBlk_P, inNum, sigName);
inBlk_P->change_flag = 1;

return(0);

}


/**********************************************************************

			LineInsert()

***********************************************************************
Inserts the current block before(-) or after(+) a specified block.
The names "input" and "output" are valid block names.
This is done by breaking and reforming the specified connection.
The command format is "insert <-,+> <specifiedBlockName> <i,o number>"
If the specified io number is connected, it is disconnected and two
new connections made at the NEXT AVAILABLE ports of the current block.
Else, a new (single) connection is formed.
The signal name is retrieved from the } block, if it is a "custom"
name (and the } block is not a terminal);
else, a default name is generated.
*/

int LineInsert(char *line)

{
	block_Pt outBlk_P, inBlk_P;
	int	outNum, inNum, connNum;
	char	blkName[NAME_LENGTH];
	char	plus[2];
	int	placeFlag = 0;	/* -1,before  +1,after */
	char	*sigName;
	int	cbInNum, cbOutNum;
	int	args;

if(pb_current == NULL)
	return(0);

/* read the line */
args = sscanf(line,"insert%1s%s%d", plus,blkName,&connNum);
if(args != 3)
	return(30);

if(plus[0] == '+')
	placeFlag = 1;
else if(plus[0] == '-')
	placeFlag = -1;
else
	return(30);

if(connNum < 0 || connNum >= IO_BUFFERS)
	return(30);

/* Find next available connection ports for current block */
for(cbInNum = 0; cbInNum < IO_BUFFERS; cbInNum++) {
	if(pb_current->inputs[cbInNum] == NULL)
		break;
}
if(placeFlag == 1 && cbInNum >= IO_BUFFERS)
	return(32);
for(cbOutNum = 0; cbOutNum < IO_BUFFERS; cbOutNum++) {
	if(pb_current->inputs[cbOutNum] == NULL)
		break;
}
if(placeFlag == -1 && cbOutNum >= IO_BUFFERS)
	return(32);

/* See if named block exists */
if((outBlk_P = FindBlock(pg_current, blkName)) != NULL) {
	if(placeFlag == -1) {
		inBlk_P = outBlk_P;
		inNum = connNum;
	}
	else
		outNum = connNum;
}
else {
	/* If I or O terminals, change reference block */
	if(strcmp(blkName,"input") == 0) {
		if(placeFlag == -1)
			return(30);
		inBlk_P = pg_current;
		inNum = connNum;
		if(FindInput(&inBlk_P,&inNum) != 0) {
			pb_current->inputs[cbInNum] = pg_current;
			pb_current->output_no[cbInNum] = connNum;
			pb_current->change_flag = 1;
			WriteSignalName(pb_current,cbInNum,"");
			return(0);
		}
		placeFlag = -1;
		if(cbOutNum >= IO_BUFFERS)
			return(32);
	}
	else if(strcmp(blkName,"output") == 0) {
		if(placeFlag == 1)
			return(30);
		outBlk_P = pg_current;
		outNum = connNum;
		if(FindOutput(&outBlk_P,&outNum) != 0) {
			pb_current->outputs[cbOutNum] = pg_current;
			pb_current->input_no[cbOutNum] = connNum;
			pb_current->change_flag = 1;
			return(0);
		}
		placeFlag = 1;
		if(cbInNum >= IO_BUFFERS)
			return(32);
	}
	else
		return(31);
}
if(outBlk_P == pb_current || inBlk_P == pb_current)
	return(33);

/* Ready to make connections */
if(placeFlag == -1) {
	/* Insert current block before inBlk */
	if((outBlk_P = inBlk_P->inputs[inNum]) != NULL) {
		if(outBlk_P == pb_current)
			return(33);
		outNum = inBlk_P->output_no[inNum];
		if(outBlk_P != pg_current) {
			outBlk_P->outputs[outNum] = pb_current;
			outBlk_P->input_no[outNum] = cbInNum;
			outBlk_P->change_flag = 1;
		}
		pb_current->inputs[cbInNum] = outBlk_P;
		pb_current->output_no[cbInNum] = outNum;
	}
	pb_current->outputs[cbOutNum] = inBlk_P;
	pb_current->input_no[cbOutNum] = inNum;
	pb_current->change_flag = 1;
	sigName = inBlk_P->signalName[inNum];
	WriteSignalName(pb_current,cbInNum,sigName);
	inBlk_P->inputs[inNum] = pb_current;
	inBlk_P->output_no[inNum] = cbOutNum;
	inBlk_P->change_flag = 1;
}
else {
	/* Insert current block after outBlk */
	if((inBlk_P = outBlk_P->outputs[outNum]) != NULL) {
		if(inBlk_P == pb_current)
			return(33);
		inNum = outBlk_P->input_no[outNum];
		if(inBlk_P != pg_current) {
			inBlk_P->inputs[inNum] = pb_current;
			inBlk_P->output_no[inNum] = cbOutNum;
			inBlk_P->change_flag = 1;
			sigName = inBlk_P->signalName[inNum];
		}
		pb_current->outputs[cbOutNum] = inBlk_P;
		pb_current->input_no[cbOutNum] = inNum;
	}
	pb_current->inputs[cbInNum] = outBlk_P;
	pb_current->output_no[cbInNum] = outNum;
	pb_current->change_flag = 1;
	WriteSignalName(pb_current,cbInNum,sigName);
	outBlk_P->outputs[outNum] = pb_current;
	outBlk_P->input_no[outNum] = cbInNum;
	outBlk_P->change_flag = 1;
}

if(pb_current->inputs[cbInNum] != NULL) {
	/* push signal name downstream */
	inBlk_P = pb_current;
	inNum = cbInNum;
	sigName = pb_current->signalName[cbInNum];
	while(inBlk_P->type == GTYPE) {
		if(FindInput(&inBlk_P,&inNum) != 0)
			break;
		strcpy(inBlk_P->signalName[inNum], sigName);
	}
}

return(0);

}


/**********************************************************************

			WriteSignalName()

***********************************************************************
Sets up the signal name for a block input connection.
If the given name is "" (empty string), a default name is created.
Function returns a non-zero value if an error occurs.
*/

int WriteSignalName(block_Pt inBlk_P, int inNum, char *sigName)


{
	block_Pt outBlk_P;
	int outNum;
	char string[MAX_LINE];

if((outBlk_P = inBlk_P->inputs[inNum]) == NULL)
	return(0);
outNum = inBlk_P->output_no[inNum];

if(inBlk_P->signalName[inNum] == NULL)
	inBlk_P->signalName[inNum] = (char *)calloc(1,SNLEN+1);

strcpy(string,sigName);
if(*sigName == '\0' && outBlk_P != inBlk_P->pparent)
	/* Create default signal name */
	sprintf(string,"%s:%d",NameTree(outBlk_P),outNum);

if(strlen(string) >= SNLEN)
	string[SNLEN-1] = '\0';
strcpy(inBlk_P->signalName[inNum], string);

/* push signal name downstream */
while(inBlk_P->type == GTYPE) {
	if(FindInput(&inBlk_P,&inNum) != 0)
		break;
	strcpy(inBlk_P->signalName[inNum], string);
}

}


/**********************************************************************

			ConnectAllStars()

***********************************************************************
Forms the connections for the STAR blocks within a GALAXY.
It is called initially for the UNIVERSE, and then calls itself
recursively whenever it encounters a GALAXY.
It searches through the hierarchy of GALAXYs to make direct STAR block
connections, for execution efficiency.
Function returns a non-zero value if an error occurs.
*/

int ConnectAllStars(block_Pt pgalaxy)


{
	block_Pt outBlk_P, inBlk_P;
	int inNum;
	int err;

/* point to first internal block in pgalaxy */
if((inBlk_P = pgalaxy->pchild) == NULL) {
	pb_error = pgalaxy;
	return(41);
}

/* examine each block in turn */
do {
	/* make sure outputs and inputs are contiguous */
	for(inNum=0; inNum < IO_BUFFERS-1; inNum++) {
		if(inBlk_P->outputs[inNum] == NULL
		  && inBlk_P->outputs[inNum+1] != NULL) {
			pb_error = inBlk_P;
			return(43);
		}
		if(inBlk_P->inputs[inNum] == NULL
		  && inBlk_P->inputs[inNum+1] != NULL) {
			pb_error = inBlk_P;
			return(44);
		}
	}
	/* any input connections to blocks in the same GALAXY ? */
	for(inNum=0; inNum<IO_BUFFERS; inNum++) {

		if((outBlk_P = inBlk_P->inputs[inNum]) == NULL)
			break;

		/* form connection, if block is in same GALAXY */
		if(outBlk_P == pgalaxy) {
			if(pgalaxy->type == UTYPE && (pgalaxy->blkType != KRN_BLOCK_TYPE_SPICE))
				return(42);
		}
		else {
			if(err = ConnectTwoStars(inBlk_P,inNum))
				return(err);
		}
	}

	/* if block_to is GALAXY, connect all internal stars */
	if(inBlk_P->type == GTYPE) {
		if(err = ConnectAllStars(inBlk_P))
			return(err);
	}

} while((inBlk_P = inBlk_P->pfsibling) != pgalaxy->pchild);

return(0);

}

/********************************************************************

			ConnectTwoStars()

*********************************************************************
Function forms a single direct connection between STAR blocks, even
if blocks are not in the same galaxy.
If one or both of the connected blocks is a GALAXY, the galaxy is
searched to find the actual STAR block(s) for connection.
*/

int ConnectTwoStars(block_Pt inBlk_P,int inNum)

	 	/* block for input connection */
	 		/* input number to be connected */
{
//	POINTER pbuffer;
    buffer_Pt pbuffer;
	block_Pt outBlk_P;	/* block for output connection */
	int outNum;		/* output number */
	int err;

/* find output block and output number */
outBlk_P = inBlk_P->inputs[inNum];
outNum = inBlk_P->output_no[inNum];

/* find direct STAR connection */
while(inBlk_P->type == GTYPE) {
	if((err = FindInput(&inBlk_P,&inNum)) != 0) {
		pb_error = inBlk_P;
		return(err);
	}
}
while(outBlk_P->type == GTYPE) {
	if((err = FindOutput(&outBlk_P,&outNum)) != 0) {
		pb_error = outBlk_P;
		return(err);
	}
}

/* create the data buffer */
pbuffer = (buffer_Pt)CreateBuffer();
KrnListInsNext(krn_bufferPointerMemory,NULL,pbuffer);

//fprintf(stderr,"Created buffer its cellsize is:%d\n",pbuffer->cellsize);


/* now connect directly between STAR blocks */
SetStarOut(outBlk_P->star_P,outNum,(POINTER)pbuffer);
SetStarIn(inBlk_P->star_P,inNum,(POINTER)pbuffer,inBlk_P->signalName[inNum]);

return(0);

}
/*********************************************************************

			FindInput()

**********************************************************************
Given a pointer to a GALAXY and an input connection number,
finds the corresponding input of an internal block.
The block pointer and the input number overwrite the arguments,
and a zero is returned.  If block is not found, non-zero is returned.
*/

int FindInput(block_Pt *p,int *i)

		/* pointer to the GALAXY pointer */
			/* pointer to the input number */
{
	block_Pt pblock;
	int inNum;

/* point to the first internal block in *p */
if((pblock = (*p)->pchild) == NULL) {
	pb_error = *p;
	return(41);
}

/* examine each internal block in turn */
do {
	/* examine each input of pblock */
	for(inNum=0; inNum<IO_BUFFERS; inNum++) {

		/* check if connected to GALAXY input */
		if(pblock->inputs[inNum] == *p
		  && pblock->output_no[inNum] == *i) {

			/* connection found */
			*p = pblock;
			*i = inNum;
			return(0);
		}
	}
} while((pblock = pblock->pfsibling) != (*p)->pchild);

/* connection not found */
return(46);

}

/*********************************************************************

			FindOutput()

**********************************************************************
Given a pointer to a GALAXY and an output connection number,
finds the corresponding output of an internal block.
Returns non-zero value if connecting block cannot be found.
*/

int FindOutput(block_Pt *p,int *o)

	 	/* pointer to the GALAXY pointer */
	 		/* pointer to the output number */
{
	block_Pt pblock;
	int outNum;

/* point to the first internal block in *p */
if((pblock = (*p)->pchild) == NULL)
	return(41);

/* examine each internal block in turn */
do {
	/* examine each output of pblock */
	for(outNum=0; outNum<IO_BUFFERS; outNum++) {

		/* check if connected to GALAXY output */
		if(pblock->outputs[outNum] == *p
		  && pblock->input_no[outNum] == *o) {

			/* connection found */
			*p = pblock;
			*o = outNum;
			return(0);
		}
	}
/* move backwards since outputting blocks usually at end */
} while((pblock = pblock->pbsibling) != (*p)->pchild);

/* connection not found */
return(45);

}

/*
 * if input and output buffers are contiguous retuen a 0
 * else return a 1
 */
 int KrnCheckContiguous()
{
block_Pt outBlk_P, inBlk_P,blk_P;
int inNum;
int outNum;
int	i;
int err;
char command[100];


blk_P=  pb_current;

/*
 * see if inputs and outputs contiguous
 */
for(i=0; i < IO_BUFFERS-1; i++) {
	if(blk_P->outputs[i] == NULL
	  && blk_P->outputs[i+1] != NULL) {
		return(1);
	}
	if(blk_P->inputs[i] == NULL
	  && blk_P->inputs[i+1] != NULL) {
		return(1);

	}
}
return(0);
}

/*
 * go through blocks buffers and make a single buffer contigous
 */

 int KrnMakeSingleContiguous()
{
block_Pt outBlk_P, inBlk_P,blk_P;
int inNum;
int outNum;
int	i;
int err;
char command[100];
#ifdef GRAPHICS
connPic_Pt      connPic_P;
#endif


blk_P=  pb_current;

/* make sure outputs and inputs are contiguous */
for(i=0; i < IO_BUFFERS-1; i++) {
	if(blk_P->outputs[i] == NULL
	  && blk_P->outputs[i+1] != NULL) {
		inBlk_P=blk_P->outputs[i+1];
		inNum=blk_P->input_no[i+1];

#ifdef GRAPHICS
                connPic_P=blk_P->outConn_AP[i+1];
                if(connPic_P) {
                        connPic_P->outNum=i;
                        blk_P->outConn_AP[i+1]=NULL;
                        blk_P->outConn_AP[i]=connPic_P;
                }
#endif
		sprintf(command,"disconnect %s %d %s %d",
			blk_P->name,i+1,inBlk_P->name,inNum);
		if(CsCallUp(command))return(1);
//fprintf(stderr,"%s \n",command);
		sprintf(command,"connect %s %d %s %d",
			blk_P->name,i,inBlk_P->name,inNum);
//fprintf(stderr,"%s \n",command);
		if(CsCallUp(command))return(1);


	}
	if(blk_P->inputs[i] == NULL
	  && blk_P->inputs[i+1] != NULL) {
		outBlk_P=blk_P->inputs[i+1];
		outNum=blk_P->output_no[i+1];
		sprintf(command,"disconnect %s %d %s %d",
			outBlk_P->name,outNum,blk_P->name,i+1);
//fprintf(stderr,"%s \n",command);
		if(CsCallUp(command))return(1);
		sprintf(command,"connect %s %d %s %d",
			outBlk_P->name,outNum,blk_P->name,i);
//fprintf(stderr,"%s \n",command);
		if(CsCallUp(command))return(1);

	}
}

return(0);
}

/*
 * make all buffers contigous
 */
 int KrnMakeContiguous(void )
{

while(KrnCheckContiguous())
	KrnMakeSingleContiguous();

return(0);
}


/*******************************************************************
 *
 *		KrnModelConnectionInput()
 *
 ******************************************************************
 * Function is called by stars to create a model input connection entry.
 */
void KrnModelConnectionInput(mt_index,connectionIndex,name,type)
	int mt_index;		/* index into model table */
	int connectionIndex;		/* connection index */
	char *name;		/* Input buffer name */
	char *type;		/* Input Buffer Type */
{
	bufferSpec_Pt *modInputBuffs = model[mt_index].inputBuffers_AP;
	bufferSpec_Pt pconn;
	float *a;
	int i;

//model[mt_index].param_model_flag = 1;

if(connectionIndex < 0)
	/* The 'no connections' case */
	return;
#ifdef DEBUG
printf("KrnModelConnectionInput  name=%s type=%s  connection=%d \n",
    name,type,connectionIndex);
#endif


pconn = (bufferSpec_Pt)calloc(1,sizeof(bufferSpec_t));
pconn->type = (char *)calloc(1,strlen(type)+1);
pconn->name = (char *)calloc(1,strlen(name)+1);
strcpy(pconn->type,type);
strcpy(pconn->name,name);


modInputBuffs[connectionIndex] = pconn;



}


/*******************************************************************
 *
 *		KrnModelConnectionOutput()
 *
 ******************************************************************
 * Function is called by stars to create a model output connection entry.
 */
void KrnModelConnectionOutput(mt_index,connectionIndex,name,type)
	int mt_index;		/* index into model table */
	int connectionIndex;		/* connection index */
	char *name;		/* Input buffer name */
	char *type;		/* Input Buffer Type */
{
	bufferSpec_Pt *modOutputBuffs = model[mt_index].outputBuffers_AP;
	bufferSpec_Pt pconn;

//model[mt_index].param_model_flag = 1;

if(connectionIndex < 0)
	/* The 'no connections' case */
	return;
#ifdef DEBUG
printf("KrnModelConnectionOutput  name=%s type=%s  connection=%d \n",
       name,type,connectionIndex);
#endif
pconn = (bufferSpec_Pt)calloc(1,sizeof(bufferSpec_t));
pconn->type = (char *)calloc(1,strlen(type)+1);
pconn->name = (char *)calloc(1,strlen(name)+1);
strcpy(pconn->type,type);
strcpy(pconn->name,name);



modOutputBuffs[connectionIndex] = pconn;


}

