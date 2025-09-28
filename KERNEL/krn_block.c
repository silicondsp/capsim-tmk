

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


/* block.c */
/**********************************************************************

		Block Module Manipulation Routines

**********************************************************************
*/
#include "capsim.h"

/**********************************************************************

		External Function Declarations

***********************************************************************
*/
extern void ErrorAlloc();
extern int InitOne();
extern int graphics_mode;


/*********************************************************************

		Global Declarations

**********************************************************************
*/
extern int model_count;


/**********************************************************************

		CreateUniverse()

***********************************************************************

Function initializes the data structure by establishing the root node
of the tree, which corresponds to the UNIVERSE block
*/

block_Pt CreateUniverse()

{
	block_Pt pgalaxy;

/* allocate storage for UNIVERSE block */
pgalaxy = (block_Pt) calloc(1,sizeof(block_t));
if(!pgalaxy) ErrorAlloc("Kernel Universe block");

/* since UNIVERSE block is the root, there is no parent */
pgalaxy->pparent = NULL;

/* the UNIVERSE block has no siblings */
pgalaxy->pfsibling = pgalaxy;
pgalaxy->pbsibling = pgalaxy;

/* the child pointer is temporarily set to NULL, but will be reset
 when internal structure of the UNIVERSE is established */
pgalaxy->pchild = NULL;

/* initialize the remaining descriptors */
pgalaxy->type = UTYPE;
pgalaxy->model_index = model_count;
strcpy(pgalaxy->name, "UNIVERSE");

/*
 * allocate information data structure
 */
pgalaxy->info_P = (info_Pt) calloc ( 1,sizeof( info_t) ) ;

return(pgalaxy);

}


/*********************************************************************

			CreateBlock()

**********************************************************************
This routine is called to create a block instance of the specified
star or galaxy, and link it into the current galaxy.
*/

block_Pt CreateBlock(pgalaxy)
	block_Pt pgalaxy;  /* parent galaxy */
{
	block_Pt pblock;
	int i;

/* allocate storage for the block */
pblock = (block_Pt) calloc(1,sizeof(block_t));
if(!pblock) ErrorAlloc("Block allocation");
pblock->pparent = pgalaxy;
pblock->pchild = NULL;

if(pgalaxy->pchild == NULL) {
	/* first block in galaxy list */
	pgalaxy->pchild = pblock;
	pblock->pfsibling = pblock;
	pblock->pbsibling = pblock;
}
else {
	/* add block to final position in circular list */
	pblock->pfsibling = pgalaxy->pchild;
	pblock->pbsibling = pgalaxy->pchild->pbsibling;
	pgalaxy->pchild->pbsibling->pfsibling = pblock;
	pgalaxy->pchild->pbsibling = pblock;
}

/* clear io connection arrays */
for(i=0; i<IO_BUFFERS; i++) {
	pblock->inputs[i] = NULL;
	pblock->outputs[i] = NULL;
}

/* clear io connection picture arrays */
for(i=0; i<IO_BUFFERS; i++) {
//	pblock->inConn_AP[i] = NULL;
//	pblock->outConn_AP[i] = NULL;
	pblock->signalName[i]=NULL;
}
pblock->blkType=KRN_BLOCK_TYPE_REGULAR;
pblock->info_P=NULL;
pblock->selectFlag=FALSE;

#ifdef GRAPHICS
pblock->drawFlag=FALSE;
pblock->blkPic_P=NULL;
#endif

pblock->change_flag=FALSE;


#ifdef GRAPHICS
pblock->popup=NULL;
#endif


return(pblock);

}


/**********************************************************************

			FindBlock()

***********************************************************************
Looks for a block with a particular name in a given GALAXY.
It returns a pointer to the block, or NULL if block has not been created
*/

block_Pt FindBlock(pgalaxy,block_name)

	block_Pt pgalaxy; /* GALAXY in which to search for block */
	char block_name[];	/* name of the block */
{
	block_Pt pblock;

/* move pointer to first block in the GALAXY */
if((pblock = pgalaxy->pchild) == NULL)
	return(NULL);

do {
	if(strcmp(block_name,pblock->name) == 0)
		return(pblock);

} while((pblock = pblock->pfsibling) != pgalaxy->pchild);

/* ran out of blocks, name not found, so return NULL */
return(NULL);

}


/**********************************************************************

			MoveBlock()

***********************************************************************
Moves a block from one position in the linked list to another.
*/

MoveBlock(pfirst,psecond)

	block_Pt psecond;	/* block to be moved */
	block_Pt pfirst;	/* block to move psecond in front of */
{

/* first remove psecond from list */
psecond->pbsibling->pfsibling = psecond->pfsibling;
psecond->pfsibling->pbsibling = psecond->pbsibling;

/* insert psecond in front of pfirst */
psecond->pfsibling = pfirst;
psecond->pbsibling = pfirst->pbsibling;
pfirst->pbsibling->pfsibling = psecond;
pfirst->pbsibling = psecond;

/* fix galaxy child pointer if necessary */
if(pfirst->pparent->pchild == pfirst)
	pfirst->pparent->pchild = psecond;

return(0);

}


/**********************************************************************

			RemoveBlock()

***********************************************************************
Removes the specified block from the current galaxy, and de-allocates.
*/

void RemoveBlock(pblock)
	block_Pt pblock;
{
	int i;
	int ionum;
	block_Pt temp_block;

if(pblock == NULL) return;

/* remove any children of this block */
RemoveChildren(pblock);

/* disconnect the block */
for(i=0; i < IO_BUFFERS; i++) {
	if((temp_block = pblock->inputs[i]) == NULL)
		continue;
	if(temp_block != pblock->pparent) {
		ionum = pblock->output_no[i];
		temp_block->outputs[ionum] = NULL;
	}
	free(pblock->signalName[i]);
}
for(i=0; i < IO_BUFFERS; i++) {
	if((temp_block = pblock->outputs[i]) == NULL)
		continue;
	if(temp_block != pblock->pparent) {
		ionum = pblock->input_no[i];
		temp_block->inputs[ionum] = NULL;
		free(temp_block->signalName[ionum]);
	}
}
/* remove parameter storage */
for(i=0; i<MAX_PARAM; i++)
	KrnFreeParam(&pblock->param_AP[i]);

/* deal with any associated star structures and buffers */
if(pblock->star_P != NULL) {
	/* free any input buffers connected to this block */
	InitOne(pblock);
	free(pblock->star_P);
}

/* now remove block from the tree of blocks */
pblock->pbsibling->pfsibling = pblock->pfsibling;
pblock->pfsibling->pbsibling = pblock->pbsibling;

if(pblock == pblock->pparent->pchild) {
	if(pblock == pblock->pfsibling)
		/* final block left in galaxy */
		pblock->pparent->pchild = NULL;
	else
		pblock->pparent->pchild = pblock->pfsibling;
}

free(pblock);

}


/*******************************************************************

			RemoveChildren()

********************************************************************
Removes all children blocks of a galaxy.
*/

RemoveChildren(pblock)
	block_Pt pblock;
{

while(pblock->pchild != NULL)
	RemoveBlock(pblock->pchild);

}


/***************************************************************

		DeleteBlock()

****************************************************************
Remove a block, but repair any connections "through" the block.
Only connections with matching i/o numbers are repaired,
else they are removed.  Implied self-connections or direct
input-output connections are not made.
The "incoming" signal name is written to the "output" block.
*/

DeleteBlock(blk_P)
	block_Pt blk_P;
{
	int i;
	int outNum, inNum;
	int inTermFlag, outTermFlag;
	block_Pt outBlk_P,inBlk_P;

for(i=0; i < IO_BUFFERS; i++) {
	outTermFlag = inTermFlag = 0;
	/* repair any connections with matching i/o numbers */
	if((outBlk_P = blk_P->inputs[i]) != NULL) {
		blk_P->inputs[i] = NULL;
		outNum = blk_P->output_no[i];
		if(outBlk_P == blk_P->pparent)
			inTermFlag = 1;
		if((inBlk_P = blk_P->outputs[i]) != NULL) {
			blk_P->outputs[i] = NULL;
			inNum = blk_P->input_no[i];
			if(inBlk_P == blk_P->pparent)
				outTermFlag = 1;
			if(!inTermFlag) {
				outBlk_P->outputs[outNum] = inBlk_P;
				outBlk_P->input_no[outNum] = inNum;
				if(outBlk_P == inBlk_P)
					outBlk_P->outputs[outNum] = NULL;
			}
			if(!outTermFlag) {
				inBlk_P->inputs[inNum] = outBlk_P;
				inBlk_P->output_no[inNum] = outNum;
				inBlk_P->signalName[inNum] = blk_P->signalName[i];
				blk_P->signalName[i] = NULL;
				if(outBlk_P == inBlk_P)
					inBlk_P->inputs[inNum] = NULL;
			}
		}
		else if(!inTermFlag)
			outBlk_P->outputs[outNum] = NULL;

		if(blk_P->signalName[i] != NULL)
			free(blk_P->signalName[i]);
	}
	else if((inBlk_P = blk_P->outputs[i]) != NULL) {
		blk_P->outputs[i] = NULL;
		inNum = blk_P->input_no[i];
		if(inBlk_P != blk_P->pparent) {
			inBlk_P->inputs[inNum] = NULL;
		}
	}
}
RemoveBlock(blk_P);

return(0);
}


/*******************************************************************

			ApproveChanges()

********************************************************************
This function seeks user approval if there were unresolved changes
made within the input galaxy or below.  A 1 is returned if action
is approved by user, a 0 else.
*/
ApproveChanges(pgalaxy, print_flag)
	block_Pt pgalaxy;
	int print_flag;
{
	char response[NAME_LENGTH];

if(!print_flag)
	return(1);

if(!CheckChanges(pgalaxy,0))
	return(1);
#ifndef EMBEDDED_ECOS
if(graphics_mode==0) {
prinfo(stdout," Warning: Changes noted in galaxy\n");
CheckChanges(pgalaxy,1);
prinfo(stdout,"\n Do you want to proceed (y/n) ?  ");
fgets(response,NAME_LENGTH-1,stdin);
if(response[0] == 'y' || response[0] == 'Y')
	return(1);
}
#else
        return(1);
#endif

return(0);
}


/*******************************************************************

			CheckChanges()

********************************************************************
This function checks for the change flag for all blocks in a
galaxy.  It optionally prints the name of a galaxy with changes.
It returns a 0 if no changes found, a 1 else.
*/
CheckChanges(pgalaxy, print_flag)
	block_Pt pgalaxy;
	int print_flag;
{
	block_Pt pblock;
	int galaxy_change_flag = 0;
	char string[MAX_LINE];

if((pblock = pgalaxy->pchild) == NULL)
	return(0);

do {
	if(pblock->change_flag) {
		if(!print_flag)
			return(1);
		galaxy_change_flag = 1;
	}
	if(CheckChanges(pblock, print_flag))
		if(!print_flag)
			return(1);

} while((pblock = pblock->pfsibling) != pgalaxy->pchild);

if(galaxy_change_flag) {
	sprintf(string,"\t\t%s\n", NameTree(pgalaxy));
#ifdef EMBEDDED_ECOS
	prinfo(1, string);
#else
        prinfo(stdout, string);
#endif
	return(1);
}
return(0);

}


/*******************************************************************

			ClearChanges()

********************************************************************
This function clears the change flag for all blocks in a
galaxy.  It optionally propagates through subgalaxies.
*/
ClearChanges(pgalaxy, propagate_flag)
	block_Pt pgalaxy;
	int propagate_flag;
{
	block_Pt pblock;

if((pblock = pgalaxy->pchild) == NULL)
	return(0);

do {
	pblock->change_flag = 0;
	if(propagate_flag)
		ClearChanges(pblock, 1);

} while((pblock = pblock->pfsibling) != pgalaxy->pchild);

return(0);

}

/**********************************************************************

			BlockRename()

***********************************************************************
Looks for a block with a particular name in a given GALAXY.
It then changes the current block's name if no conflict.
It returns a 1 if a conflict exists otherwise it returns a zero
*/

int BlockRename(pgalaxy,blk_P,block_name)

	block_Pt pgalaxy; /* GALAXY in which to search for block */
	block_Pt blk_P;
	char block_name[];	/* name of the block */
{
	block_Pt pblock;

/* move pointer to first block in the GALAXY */
if((pblock = pgalaxy->pchild) == NULL)
	return((int)NULL);

do {
	if(strcmp(block_name,pblock->name) == 0)
		return(1);

} while((pblock = pblock->pfsibling) != pgalaxy->pchild);

/*
 * ran out of blocks, name not found, so return NULL
 * first rename block
 */
strcpy(blk_P->name,block_name);
return((int)NULL);

}

