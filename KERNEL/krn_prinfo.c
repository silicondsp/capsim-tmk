

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




/* krn_prinfo.c */
/*********************************************************************

			Output Print Routines

**********************************************************************

*/
#include <stdio.h>
#include <string.h>
#include "capsim.h"

/*********************************************************************

			Global declarations

**********************************************************************
*/



extern int line_mode;
extern int model_count;
extern int graphics_mode;
extern block_Pt pb_error;
extern block_Pt pb_current;
extern block_Pt pg_current;

extern char*GetMsg(int);

/*
 * this array is used to make arguments contiguous in  stored file
 * or in printing to terminal
 */
int	krn_argAssoc_A[MAX_PARAM];

int CsMessageAddLine(char *buffer);

/***********************************************************************

			prinfo()

************************************************************************

This routine prints one string exactly as received.
A file pointer must be provided.
*/

#ifdef EMBEDDED_ECOS

prinfo(int fp, char *string)
{
                if(fp == NULL) {
#ifdef GRAPHICS
                        CsInfoText(string);
#endif
                }
                else
			{
			printf("%s", string);
			}
}

#else



void prinfo(FILE *fp, char *string)


{
		if(fp == NULL) {
			printf("%s", string);
		}
		else
			{
			fprintf(fp,"%s", string);
			}
}
#endif


/**********************************************************************
/**********************************************************************

			PrInfoBlockCurrent()

***********************************************************************

Prints out current block prompt.
*/

void PrInfoBlockCurrent()
{
	//char *NameTree();
	char string[MAX_LINE];

sprintf(string," Current Block:  %s", NameTree(pb_current));

if(pb_current == NULL) {
	strcat(string,"\n");
#ifdef EMBEDDED_ECOS
	prinfo(1,string);
#else
	prinfo(stdout,string);
#endif
	return;
}

#ifdef EMBEDDED_ECOS
prinfo(1,string);
#else
prinfo(stdout,string);
#endif
if(pb_current->type == GTYPE)
	sprintf(string, "  (galaxy: %s.t)\n",
			model[pb_current->model_index].name);
else
	sprintf(string, "  (star: %s)\n",
			model[pb_current->model_index].name);
#ifdef EMBEDDED_ECOS
prinfo(1,string);
#else
prinfo(stdout,string);
#endif

}


/*********************************************************************

			NameTree()

***********************************************************************
This function constructs a block name with fully expanded hierarchy.
*/

char *NameTree(block_Pt blk_P)

{
	static char tree_string[MAX_LINE];
	char string[MAX_LINE];

strcpy(tree_string,"");

if(blk_P == NULL) {
	if(pg_current->type != UTYPE)
		sprintf(tree_string, "%s/", NameTree(pg_current));

	strcat(tree_string,"NULL");
}
else {  /* normal block */
	sprintf(tree_string,"%s", blk_P->name);

	if(blk_P->type != UTYPE) {

		while((blk_P = blk_P->pparent)->type != UTYPE) {
			sprintf(string,"%s/%s",
				blk_P->name, tree_string);
			strcpy(tree_string, string);
		}
	}
}

return(tree_string);

}


/**********************************************************************

			PrInfoAll()

***********************************************************************

Function prints out information about a galaxy.
*/

void PrInfoAll(FILE *fp, block_Pt pgalaxy)
#ifdef EMBEDDED_ECOS
int fp;
#else

#endif

{
int displayFlag = 0;
char string[MAX_LINE];
block_Pt blk_P;
//char *NameTree();
modelEntry_t modelTableEntry;	/* model table entry */
char strBuf[1024];

if(pgalaxy == NULL)
	return;
blk_P = pgalaxy->pchild;
if(blk_P == NULL)
	return;

modelTableEntry = model[pgalaxy->model_index];
#ifndef EMBEDDED_ECOS
if(fp == stdout || fp == stderr)
	displayFlag = 1;
#else
        displayFlag=1;
#endif

if(displayFlag) {
	sprintf(string,
"*******************************************************\
\n\tparent galaxy  %s  (%s.t)\n\n",
	NameTree(pgalaxy), modelTableEntry.name);
}
else
	sprintf(string,"\n# topology file:  %s.t\n\n",
			modelTableEntry.name);
prinfo(fp,string);
#if 1
/*
 * print information
 */
if ( pgalaxy->info_P) {
prinfo(fp,"#--------------------------------------------------- \n");
sprintf(strBuf,"# Title: %s \n",pg_current->info_P->title);
prinfo(fp,strBuf);
sprintf(strBuf,"# Author: %s \n",pg_current->info_P->author);
prinfo(fp,strBuf);
sprintf(strBuf,"# Date: %s \n",pg_current->info_P->date);
prinfo(fp,strBuf);
sprintf(strBuf,"# Description: %s \n",pg_current->info_P->descrip);
prinfo(fp,strBuf);
prinfo(fp,"#--------------------------------------------------- \n");

prinfo(fp,"\n");

sprintf(strBuf,"inform title %s\n",pg_current->info_P->title);
prinfo(fp,strBuf);
sprintf(strBuf,"inform author %s\n",pg_current->info_P->author);
prinfo(fp,strBuf);
sprintf(strBuf,"inform date %s\n",pg_current->info_P->date);
prinfo(fp,strBuf);
sprintf(strBuf,"inform descrip %s\n",pg_current->info_P->descrip);
prinfo(fp,strBuf);

prinfo(fp,"\n");
}
#endif
/*
 * make arguments contiguous
 */

PrInfoArgs(fp,pgalaxy);

do {
	PrInfoParams(fp, blk_P->param_AP);

	modelTableEntry = model[blk_P->model_index];
	if(modelTableEntry.mtype == LIBRARY) {
		sprintf(string,"block %s %s",
			blk_P->name, modelTableEntry.name);
	}
	else if(modelTableEntry.mtype == GALAXY)
		sprintf(string,"hblock %s %s.t",
			blk_P->name, modelTableEntry.name);

	else  /* custom star */
		sprintf(string,"block %s %s.o",
			blk_P->name, modelTableEntry.name);
#if 000
        if(displayFlag && graphics_mode && blk_P->blkPic_P == NULL)
                strcat(string," (PROBE)");
#endif

	if(displayFlag && blk_P->change_flag == 1)
		strcat(string," (*)");

	prinfo(fp,string);
	prinfo(fp,"\n\n");

} while((blk_P = blk_P->pfsibling) != pgalaxy->pchild);

PrInfoConnections(fp,pgalaxy);


if(displayFlag) {
	sprintf(string,
"*******************************************************\n");
	prinfo(fp,string);
}

}


/**********************************************************************

			prinfo_block()

***********************************************************************
Function prints out information about a given block.
*/

void PrInfoBlock(FILE *fp, block_Pt pb)
#ifdef EMBEDDED_ECOS
	int fp;
#else

#endif
	  /* block whose name is to be printed */
{
	int  i,j,k;
	char string[MAX_LINE];
	char string2[2*MAX_LINE];
	char *def;
	char *signame;
	param_Pt pptr;
	int np;			/* number of parameters */
	int con_flag;		/* any i/o connections? */
	modelEntry_t modelTableEntry;	/* model table entry */

if(pb == NULL) {
	PrInfoBlockCurrent();
	return;
}
else {
	sprintf(string,"Parent:  %s\n", pb->pparent->name);
	prinfo(fp,string);
	sprintf(string,"Name:  %s  (%s)\n", pb->name, NameTree(pb));
	prinfo(fp,string);
}

if(pb->type == GTYPE)
	prinfo(fp,"Type:  GALAXY\n");
else
	prinfo(fp,"Type:  STAR\n");

modelTableEntry = model[pb->model_index];
if(modelTableEntry.mtype == GALAXY)
	sprintf(string,"File:  %s.t\n", modelTableEntry.name);

else if(modelTableEntry.mtype == LIBRARY)
	sprintf(string, "File:  %s.s (library)\n", modelTableEntry.name);

else  /* custom star */
	sprintf(string,"File:  %s.s (custom)\n", modelTableEntry.name);

prinfo(fp,string);

if(pb->change_flag)
	prinfo(fp,"Status:  Modified\n");

prinfo(fp,"Parameters:\n");
if ((np = KrnParamCount(pb->param_AP)) == 0)
	prinfo(fp," (none)\n");
else {
	for(i=0; i<np; pptr++, i++) {
		pptr = pb->param_AP[i];
		def = pptr->def;
		if(pptr->arg >= 0) {
			sprintf(string, " %d: %s  (arg) %d\n",
				i,def,pptr->arg);
			prinfo(fp,string);
		}
		switch (pptr->type) {
		  case PARAM_DEFAULT:
			sprintf(string, " %d: %s  (default)\n",i,def);
			prinfo(fp,string);
			break;
		  case PARAM_INT:
			sprintf(string, " %d: %s  (int) %d\n",
				i,def, pptr->value.d);
			prinfo(fp,string);
			break;
		  case PARAM_FLOAT:
			sprintf(string, " %d: %s  (float) %18.14g\n",
				i,def,pptr->value.f);
			prinfo(fp,string);
			break;
		  case PARAM_FUNCTION:
			sprintf(string, " %d: %s  (function) %s\n",
				i,def,pptr->value.s);
			prinfo(fp,string);
			break;
		  case PARAM_FILE:
			sprintf(string, " %d: %s  (file) %s\n",
				i, def, pptr->value.s);
			prinfo(fp,string);
			break;
		  case PARAM_STRING:
			sprintf(string, " %d: %s  (string) \"%s\"\n",
				i, def, pptr->value.s);
			prinfo(fp,string);
			break;

		  case PARAM_ARRAY:
			sprintf(string," %d: %s  (array) %d\n  ",
				i,def,pptr->array_size);
			for(j=0; j<pptr->array_size; j++) {
				sprintf(string2, "  %g",
				*(((float *)pptr->value.s)+j) );
				strcat(string, string2);
			}
			strcat(string, "\n");
			prinfo(fp,string);
			break;
		}
	}
} /* ends parameter printing */

prinfo(fp,"Inputs:\n");

con_flag = 0;
for(i=0; i < IO_BUFFERS; i++) {
	if (pb->inputs[i] == NULL)
		continue;
	else if(pb->inputs[i] == pb->pparent) {
		j = pb->output_no[i];
		sprintf(string, " %d:  input %d\t%s\n",
			i, j, pb->signalName[i]);
	}
	else {
		sprintf(string, " %d:  %s (%s) %d  \t%s\n",
			i, pb->inputs[i]->name,
			model[pb->inputs[i]->model_index].name,
			pb->output_no[i], pb->signalName[i]);
	}
	con_flag++;
	prinfo(fp,string);
}
if(!con_flag)
	prinfo(fp," (none)\n");


prinfo(fp,"Outputs:\n");
con_flag = 0;
for(i=0; i < IO_BUFFERS; i++) {

	if(pb->outputs[i] == NULL)
		continue;
	else if(pb->outputs[i] == pb->pparent) {
		j = pb->input_no[i];
		if(pb->pparent->outputs[j] != NULL) {
			k = pb->pparent->input_no[j];
			signame = pb->pparent->outputs[j]->signalName[k];
			sprintf(string, " %d:  output %d  \t%s\n",
				i, j, signame);
		}
		else
			sprintf(string, " %d:  output %d\n", i,j);
	}
	else {
		j = pb->input_no[i];
		sprintf(string, " %d:  %s (%s) %d  \t%s\n",
			i, pb->outputs[i]->name,
			model[pb->outputs[i]->model_index].name,
			j, pb->outputs[i]->signalName[j]);
	}
	con_flag++;
	prinfo(fp,string);
}
if(!con_flag)
	prinfo(fp," (none)\n");

prinfo(fp,"\n");
return;

}


/***********************************************************************

			PrInfoConnections()

************************************************************************
This routine prints all the connections for the specified galaxy,
exactly as they would appear in a topology file.
An exception occurs when the file pointer is stdout:
i/o signal names are gathered from the parent galaxy, if available.
*/

void PrInfoConnections(FILE *fp, block_Pt  pgalaxy)
#ifdef EMBEDDED_ECOS
	int fp;
#else
	///FILE *fp;
#endif
///	block_Pt pgalaxy;
{
	block_Pt blk_P, inBlk_P;
	int i, inNum;
	char string[MAX_LINE];
	char bufferStr[10*MAX_LINE];
	char *sigName;
	int displayFlag = 0;
        char* outputType;
        char* outputName;
        char* inputType;
        char* inputName;
        static char *nullC="NULL";

if(pgalaxy == NULL)
	return;
if((blk_P = pgalaxy->pchild) == NULL)
	return;

#ifdef EMBEDDED_ECOS
	displayFlag = 1;
#else
if(fp == stdout || fp == stderr)
	displayFlag = 1;
#endif

/* For all blocks in current galaxy... */
do {

/* Print any block input terminals */
for(i=0; i<IO_BUFFERS; i++) {
	if(blk_P->inputs[i] == pgalaxy) {
		sigName = blk_P->signalName[i];
		inNum = blk_P->output_no[i];
		if(strdex(sigName,':') > 0)
			sigName = "";
		if(!displayFlag)
			sigName = "";

		sprintf(string,"connect input %d %s %d   \t%s\n",
				inNum, blk_P->name, i, sigName);
		prinfo(fp,string);
	}
}

/* print all block outputs */
for(i=0; i<IO_BUFFERS; i++) {
	if((inBlk_P = blk_P->outputs[i]) == NULL)
		continue;

	inNum = blk_P->input_no[i];
	if(inBlk_P != pgalaxy) {
		sigName = inBlk_P->signalName[inNum];
		if(strdex(sigName,':') > 0)
			sigName = "";
		sprintf(string, "connect %s %d %s %d  \t%s",
			blk_P->name,i,inBlk_P->name,inNum,sigName);
        strcpy(bufferStr,"\n");

        inputType=nullC;
        inputName=nullC;
        outputType=nullC;
        outputName=nullC;

        if(model[blk_P->model_index].outputBuffers_AP[i]) {
               outputType=model[blk_P->model_index].outputBuffers_AP[i]->type;
               outputName=model[blk_P->model_index].outputBuffers_AP[i]->name;
        }
        if(model[inBlk_P->model_index].inputBuffers_AP[inNum]) {
              //  fprintf(stderr,"CHECK2 inNum=%d %s \n", inNum, string);
               inputType=model[inBlk_P->model_index].inputBuffers_AP[inNum]->type;
               inputName=model[inBlk_P->model_index].inputBuffers_AP[inNum]->name;
               if(inputType == NULL) {
                       inputType=nullC;
               }
               if(inputName == NULL) {
                      inputName=nullC;
               }
               if(outputType == NULL) {
                          outputType=nullC;
               }
               if(outputName == NULL) {
                       outputName=nullC;
               }
               sprintf(bufferStr,"{%s:%s:%s,%s:%s:%s}\n",blk_P->name,outputName,outputType,
                          inBlk_P->name,inputName,inputType);

        } else {
              //fprintf(stderr,"CHECK inNum=%d %s \n", inNum, string);

        }

	} else {
                 strcpy(bufferStr,"\n");
		         sprintf(string, "connect %s %d output %d  \t%s",
			     blk_P->name,i,inNum, "");
	}
    strcat(string,bufferStr);
	prinfo(fp,string);
}

} while((blk_P = blk_P->pfsibling) != pgalaxy->pchild);

prinfo(fp,"\n");

return;
}


/***********************************************************************

			PrInfoParams()

************************************************************************
Print all the parameters from the specified parameter array.
*/

void PrInfoParams(FILE *fp, param_Pt param_AP[])
#ifdef EMBEDDED_ECOS
	int fp;
#else
//	FILE *fp;
#endif
//	param_Pt param_AP[];
{
	char string[MAX_LINE];
	char string2[2*MAX_LINE+20];	/* for array values */
	param_Pt pptr;
	int i,j;
	int np;
	char *pdef;
	char *pname;
	int displayFlag = 0;

#ifdef EMBEDDED_ECOS
	displayFlag = 1;
#else
if(fp == stdout || fp == stderr)
	displayFlag = 1;
#endif

np = KrnParamCount(param_AP);
for(j=0; j<np; j++) {
	pptr = param_AP[j];

	switch (pptr->type) {
	  case PARAM_DEFAULT:
		sprintf(string, "param default");
		break;
	  case PARAM_INT:
		if(pptr->exprFlag)
			sprintf(string, "param int %s", pptr->express);
		else
			sprintf(string, "param int %d", pptr->value.d);
		break;
	  case PARAM_FLOAT:
		if(pptr->exprFlag)
			sprintf(string, "param float %s", pptr->express);
		else
			sprintf(string, "param float %22.18g", pptr->value.f);
		break;
	  case PARAM_FUNCTION:
		sprintf(string, "param function %s", pptr->value.s);
		break;
	  case PARAM_FILE:
		sprintf(string, "param file %s", pptr->value.s);
		break;
	  case PARAM_STRING:
		sprintf(string, "param string \"%s\"", pptr->value.s);
		break;
	  case PARAM_ARRAY:
		sprintf(string, "param array %d", pptr->array_size);
		for(i=0; i<pptr->array_size; i++) {
			sprintf(string2, "  %g",
				*((float *)(pptr->value.s)+i) );
			strcat(string, string2);
		}
		if(displayFlag)
			strcat(string,"\n\t");
		break;
	  default:
		sprintf(string,"???");

	} /* ends switch */

	if(pptr->arg >= 0) {
		if(!displayFlag)
			sprintf(string, "param arg %d",
				krn_argAssoc_A[pptr->arg]);
		else {
			sprintf(string2,"(arg %d) %s",
				pptr->arg, string);
			strcpy(string,string2);
		}
	}

	//if(displayFlag && (pdef = pptr->def) != NULL && *pdef != '\0')
        if(1 && (pdef = pptr->def) != NULL && *pdef != '\0') {
                pname=pptr->name;
                sprintf(string2,"    %s   \"%s\"\n", pname,pdef);
        }
        else
                sprintf(string2,"\n");

        strcat(string,string2);


	prinfo(fp,string);
}

return;

} /* ends prinfo_params */


/**********************************************************************

			PrInfoArgs()

***********************************************************************

Print all the arguments for the specified galaxy.
*/

void PrInfoArgs(FILE *fp, block_Pt pgalaxy)
#ifdef EMBEDDED_ECOS
	int fp;
#else
//	FILE *fp;
#endif
//	block_Pt pgalaxy;
{
	modelEntry_t *gmodel;
	param_Pt pp;
	int i, j,np;
	int type;
	char string[MAX_LINE];
	char string2[MAX_LINE];
	int displayFlag = 0;

#ifdef EMBEDDED_ECOS
	displayFlag = 1;
#else
if(fp == stdout || fp == stdin)
	displayFlag = 1;
#endif


gmodel = &model[pgalaxy->model_index];
if((np = KrnParamCount(gmodel->param_AP)) == 0) {
	prinfo(fp,"arg -1 (none)\n\n");
	return;
}

for(i=0; i<MAX_PARAM; i++)
	krn_argAssoc_A[i]=0;
j= -1;
for(i=0; i<MAX_PARAM; i++) {
	pp = gmodel->param_AP[i];
	if (pp == NULL) {
		continue;
	}
	else
		j++;
	krn_argAssoc_A[i]=j;
	type = pp->type;
	sprintf(string,"arg %d ", j);
	if(type == PARAM_INT) {
		sprintf(string2,"int %d ", pp->value.d);
		if(displayFlag && pgalaxy->param_AP[i] != NULL) {
			strcat(string,string2);
			sprintf(string2,"(%d)  ",
				pgalaxy->param_AP[i]->value.d);
		}
	}
	else if(type == PARAM_FLOAT) {
		sprintf(string2,"float %g ", pp->value.f);
		if(displayFlag && pgalaxy->param_AP[i] != NULL) {
			strcat(string,string2);
			sprintf(string2,"(%f)  ",
				pgalaxy->param_AP[i]->value.f);
		}
	}
	else if(type == PARAM_FILE) {
		sprintf(string2,"file %s ", pp->value.s);
		if(displayFlag && pgalaxy->param_AP[i] != NULL) {
			strcat(string,string2);
			sprintf(string2,"(%s)  ",
				pgalaxy->param_AP[i]->value.s);
		}

	}	else if(type == PARAM_STRING) {
		sprintf(string2,"string \"%s\" ", pp->value.s);
		if(displayFlag && pgalaxy->param_AP[i] != NULL) {
			strcat(string,string2);
			sprintf(string2,"(%s)  ",
				pgalaxy->param_AP[i]->value.s);
		}
	}
	else
		sprintf(string2,"???  ");

	strcat(string,string2);

	if(pp->def != NULL && *(pp->def) != '\0') {
		sprintf(string2,"\"%s\"", pp->def);
		strcat(string,string2);
	}
	strcat(string,"\n");
	prinfo(fp,string);
}
prinfo(fp,"\n");

return;
}


/**********************************************************************

			PrInfoList()

***********************************************************************
Print all the model table names of a specified type.
*/

void PrInfoList(FILE *fp, int mtype)
#ifdef EMBEDDED_ECOS
	int fp;
#else
//	FILE *fp;
#endif
//	int mtype;
{
	char string[MAX_LINE];
	char stype[NAME_LENGTH];
	int i;
	int count = 0;

if(mtype == LIBRARY)
	strcpy(stype,"LIBRARY Star");
else if(mtype == CUSTOM)
	strcpy(stype,"CUSTOM Star");
else if(mtype == GALAXY)
	strcpy(stype,"GALAXY");

for(i=0; i<model_count; i++) {
	if(model[i].mtype == mtype) {
		count++;
		sprintf(string, "%-12s  ", model[i].name);
		if(count%5 == 0)
			strcat(string,"\n");

		prinfo(fp,string);
	}
}

if(count%5 == 0)
	prinfo(fp,"\n");
else
	prinfo(fp,"\n\n");

sprintf(string," Ratio of %s type: %d/%d\n\n",
		stype,count,model_count);
prinfo(fp,string);

return;

}


/**********************************************************************

			ErrorPrint()

***********************************************************************
Print an error message, from the message array (by error code #),
and from supplied string.
If code == 0, suppress canned message from array.
Note that pb_error is referenced for some error messages.
*/

void ErrorPrint(char *line, int code)

	/* char *line 	 custom error message */
	/* int code 	  index into error array */
{
	char string[MAX_LINE];
	char buffer[MAX_LINE];
	char *t;
	//char *get_msg();


if(code >= 1000) {
	/* star error */
	sprintf(string,GetMsg(1000),NameTree(pb_error));
	code -= 1000;
}
else
	/* command error */
	sprintf(string, GetMsg(code), NameTree(pb_error));

/* remove any linefeed */
if(*line && *(t = line+strlen(line)-1) == '\n')
	*t = '\0';

if(code > 0)
	/* from the error array */
	sprintf(buffer," (Error %d) %s\n", code, string);
	if(line_mode)
#ifdef EMBEDDED_ECOS
	   printf("%s",buffer);
#else

	   fprintf(stdout,"%s",buffer);
#endif
	else
	   CsMessageAddLine(buffer);

if(*line)
	/* custom error message */
	sprintf(buffer," %s\n", line);
	if(line_mode)
#ifdef EMBEDDED_ECOS
	   printf("%s",buffer);
#else
	   fprintf(stdout,"%s",buffer);
#endif
	else {
	   CsMessageAddLine(buffer);
	   fprintf(stderr,"%s",buffer);
        }

sprintf(buffer,"\n", line);
if(line_mode)
#ifdef EMBEDDED_ECOS
   printf("%s",buffer);
#else
   fprintf(stdout,"%s",buffer);
#endif
else
   CsMessageAddLine(buffer);

}


/***********************************************************************

			error_string

************************************************************************

This array holds all the messages associated with an error.
*/

typedef struct {
	int number;
	char *msg;
		}  ERR_MSG;

ERR_MSG	error_string[] =

{
{0,	""},	/* This slot reserved for custom messages */
{1,	"capsim: serious error (see program manager)"},
{2,	"unrecognized command"},
{3,	"undefined history command"},
{4,	"already at top level"},
{5,	"current block is a star"},
{9,	"no name match"},
{11,	"unknown display option"},
{14,	"man: cannot find the file"},
{16,	"all alias storage full"},
{17,	"no alias string given"},
{19,	"can't find given alias"},
{20,	"improper path arguments"},
{22,	"all path storage full"},
{26,	"error in load file"},
{27,	"load file not found"},
{28,	"can not store an empty galaxy"},
{29,	"can't open storage file"},
/* insert */
{30,	"improper insert format"},
{31,	"cannot find named block"},
{32,	"current block is out of i/o slots"},
{33,	"cannot connect current block to itself"},
/* run */
{40,	"universe is empty"},
{41,	"hblock %s is empty"},
{42,	"top level contains input/output terminals"},
{43,	"outputs of %s are not contiguous"},
{44,	"inputs of %s are not contiguous"},
{45,	"external but no internal output connection in %s"},
{46,	"external but no internal input connection in %s"},
/* connect */
{50,	"improper connect format"},
{51,	"can't find source block"},
{52,	"can't find destination block"},
{53,	"can't connect input directly to output"},
{54,	"input number out of range"},
{55,	"output number out of range"},
{56,	"source is already connected"},
{57,	"destination is already connected"},
/* disconnect */
{60,	"improper disconnect format"},
{61,	"can't find source block"},
{62,	"can't find destination block"},
{63,	"specified blocks are not connected"},
{64,	"input or output number out of range"},
/* name */
{65,	"improper name format"},
{66,	"block not found"},
{67,	"input not connected"},
{68,	"can not name inputs or outputs--go to higher level"},
/* param */
{70,	"parameter stack is full"},
{71,	"unknown parameter type"},
{72,	"can't read parameter"},
{73,	"function param string must end in \".c\""},
{74,	"array size out of bounds"},
{75,	"arg index out of range"},
{77,	"an argument must be predefined with an 'arg' command"},
/* arg */
{81,	"improper arg format"},
{82,	"must define arguments in ascending order"},
{83,	"must delete arguments in descending order"},
{84,	"can not read value"},
{85,	"only types allowed are 'int', 'float', or 'file'"},
/* chp (change parameters) */
{90,	"current block is NULL"},
{91,	"this star has no parameters"},
{92,	"this galaxy has no parameters"},
{93,	"improper chp format"},
/* star create */
{100,	"improper command format"},
{101,	"instance name already exists"},
{102,	"trouble reading star %s parameter model...stargaze?"},
{103,	"names 'input' and 'output' are reserved"},
{104,	"block type is unknown"},
{106,	"improper parameter type for %s"},
{107,	"improper arg type for %s"},
{108,	"parameter value out of range for %s"},
/* galaxy */
{110,	"improper command format"},
{111,	"instance name already in use"},
{112,	"use 'arg' commands in topology file"},
{113,	"names 'input' and 'output' are reserved"},
{114,	"hblock type is unknown"},
{116,	"improper parameter type for %s"},
{117,	"improper arg type for %s"},
{118,	"parameter value out of range for %s"},
/* replace */
{120,	"improper replace format"},
{121,	"instance name already in use"},
{122,	"can't read star %s parameter model...stargaze?"},
{123,	"names 'input' and 'output' are reserved"},
{124,	"new model is not defined"},
/* custom star */
{160,	"model table is full"},
{162,	"bad suffix on star file name"},
{163,	"block file name has illegal suffix"},
{164,	"error while stargazing star file"},
{165,	"error while compiling star file"},
{166,	"can't find stargaze file"},
{167,	"problem with current working directory"},
{168,	"can't find or make \".c\" file"},
{169,	"can't find or make \".o\" file"},
{170,	"can't open star file for reading"},
{171,	"can't read header on star file"},
{172,	"block file is not an object file"},
{173,	"block file has uninitialized data (use state vars)"},
{174,	"can't allocate space for star object code"},
{175,	"unable to link to star_file (possible bad name)"},
{176,	"link file error"},
{177,	"can't read linked star object code"},
/* rename block */
{190,	"Block name already in use"},
/* buffer management */
{800,	"block %s: inconsistent cellsize"},
{801,	"block %s: negative delay"},
{802,	"block %s: specified delay exceeds defined maximum"},
{803,	"block %s: specified delay less than defined minimum"},
{805,	"block %s: buffer too large"},

/* star code errors */
{1000,	"block '%s' returned non-zero error code"},

{9999,	"undefined error (see program manager!)"}

};


/***********************************************************************

			GetMsg()

***********************************************************************

This routine searches for the appropriate message corresponding to the
given error code.  If it can't find one, it return message number 9999.
*/

char *GetMsg(code)
	int code;
{
	int i = 0;

while (1) {
	if (error_string[i].number == code)
		return(error_string[i].msg);
	if (error_string[i].number > code) {
		/* couldn't find it! */
		return(GetMsg(9999));
	}
	i++;
}

}

/****************************************************************

			ErrorAlloc()

*******************************************************************
Function prints error message and exits in response to failure
to allocate memory
*/

void ErrorAlloc(char *string)


{
	printf("capsim: OS unable to allocate more memory\nFrom:%s\n",string);
	exit(10);
}


#ifndef GRAPHICS
int CsMessageAddLine(char *buffer)

{
return(0);
}
#endif


/***********************************************************************

			StoreMarkedConnections()

************************************************************************
This routine prints all marked  connections for the specified galaxy,
exactly as they would appear in a topology file.
An exception occurs when the file pointer is stdout:
i/o signal names are gathered from the parent galaxy, if available.

Author: Sasan H. Ardalan
Date: June 16, 1991
*/
#ifdef GRAPHICS

static int StoreMarkedConnections(fp, pgalaxy)
#ifdef EMBEDDED_ECOS
int fp;
#else
FILE *fp;
#endif
block_Pt pgalaxy;
{
#if 11111
#ifdef GRAPHICS
connPic_Pt      connPic_P;
#endif

block_Pt blk_P, inBlk_P;
int i, inNum;
int             inTermCount=0;
int             outTermCount=0;
char string[MAX_LINE];
char *sigName;
int displayFlag = 0;

if(pgalaxy == NULL)
	return;
if((blk_P = pgalaxy->pchild) == NULL)
	return;

#ifdef EMBEDDED_ECOS
	displayFlag = 1;
#else
if(fp == stdout || fp == stderr)
	displayFlag = 1;
#endif

/* For all blocks in current galaxy... */
do {

   /*
    * Print any block input terminals
    */
   for(i=0; i<IO_BUFFERS; i++) {
	if(blk_P->inputs[i] == NULL)
                        continue;

       if((connPic_P = blk_P->inConn_AP[i]) == NULL) {
                        CsInfo("Store marked connections: Get rid of probe");
                        return(1);

        }
        if(connPic_P->termType == -1 || connPic_P->auxFlag ==
                                        BBOX_CONN_INPUT_TERMINAL) {
#if 000
                sigName = blk_P->sig_name[i];
                inNum = blk_P->output_no[i];
                if(strdex(sigName,':') > 0)
                        sigName = "";
                if(!displayFlag)
                        sigName = "";
#endif
                sigName="";
                if(connPic_P->auxFlag == BBOX_CONN_INPUT_TERMINAL) {
                        sprintf(string,"connect input %d %s %d   \t%s\n",
                                inTermCount, blk_P->name, i, sigName);
                       inTermCount++;

                }
                else {
                        sprintf(string,"connect input %d %s %d   \t%s\n",
                                inNum, blk_P->name, i, sigName);

                }
                prinfo(fp,string);
        }
   }

   /*
    * print all block outputs
    */
   for(i=0; i<IO_BUFFERS; i++) {
	if(blk_P->outputs[i] == NULL)
                        continue;
        if((connPic_P = blk_P->outConn_AP[i]) == NULL) {
                        CsInfo("Store marked connections: Get rid of probe");
                        return(1);
        }


	if((inBlk_P = blk_P->outputs[i]) == NULL)
		continue;

	inNum = blk_P->input_no[i];
        if(connPic_P->auxFlag == BBOX_CONN_IN) {
#if 000
                sigName = inBlk_P->sig_name[inNum];
                if(strdex(sigName,':') > 0)
                        sigName = "";
                sigName="";
                sprintf(string, "connect %s %d %s %d  \t%s\n",
                        blk_P->name,i,inBlk_P->name,inNum,sigName);
                prinfo(fp,string);
        }
        else if (connPic_P->auxFlag == BBOX_CONN_OUTPUT_TERMINAL) {
                sprintf(string, "connect %s %d output %d  \t%s\n",
                        blk_P->name,i,outTermCount, "");
                outTermCount++;
                prinfo(fp,string);
             }
   }
#endif

} while((blk_P = blk_P->pfsibling) != pgalaxy->pchild);

prinfo(fp,"\n");
#endif
return(0);
}


#endif


/**********************************************************************

			KrnCreateGalaxy()

***********************************************************************

Function stores a new galaxy selected by a bounding box and marked.
Each block and connection to be stored must be marked.
This routine only works for graphic mode.
Author: Sasan H. Ardalan
Date: June 16, 1991
*/
#ifdef EMBEDDED_ECOS
 void KrnCreateGalaxy(int fp,block_Pt galaxy_P,char *name)
#else

 void KrnCreateGalaxy(FILE *fp,block_Pt galaxy_P,char *name)
#endif

{
int displayFlag = 0;
char string[MAX_LINE];
block_Pt blk_P;
//char *NameTree();
char	strBuf[100];
modelEntry_t modelTableEntry;	/* model table entry */

if(galaxy_P == NULL)
	return;
blk_P = galaxy_P->pchild;
if(blk_P == NULL)
	return;

modelTableEntry = model[galaxy_P->model_index];
#ifdef EMBEDDED_ECOS
	displayFlag = 1;
#else
if(fp == stdout || fp == stderr)
	displayFlag = 1;

#endif

if(displayFlag) {
	sprintf(string,
"*******************************************************\
\n\tparent galaxy  %s  (%s.t)\n\n",
	NameTree(galaxy_P), name);
}
else
	sprintf(string,"\n# topology file:  %s.t\n\n", name);
prinfo(fp,string);

/*
 * print information
 */
if ( galaxy_P->info_P) {
prinfo(fp,"#--------------------------------------------------- \n");
sprintf(strBuf,"# Title: %s \n",pg_current->info_P->title);
prinfo(fp,strBuf);
sprintf(strBuf,"# Author: %s \n",pg_current->info_P->author);
prinfo(fp,strBuf);
sprintf(strBuf,"# Date: %s \n",pg_current->info_P->date);
prinfo(fp,strBuf);
sprintf(strBuf,"# Description: %s \n",pg_current->info_P->descrip);
prinfo(fp,strBuf);
prinfo(fp,"#--------------------------------------------------- \n");

prinfo(fp,"\n");

sprintf(strBuf,"inform title \"%s\" \n",pg_current->info_P->title);
prinfo(fp,strBuf);
sprintf(strBuf,"inform author \"%s\" \n",pg_current->info_P->author);
prinfo(fp,strBuf);
sprintf(strBuf,"inform date \"%s\" \n",pg_current->info_P->date);
prinfo(fp,strBuf);
sprintf(strBuf,"inform descrip \"%s\" \n",pg_current->info_P->descrip);
prinfo(fp,strBuf);

prinfo(fp,"\n");
}

PrInfoArgs(fp,galaxy_P);

do {
	if(blk_P->selectFlag == FALSE)
			continue;
	PrInfoParams(fp, blk_P->param_AP);

	modelTableEntry = model[blk_P->model_index];
	if(modelTableEntry.mtype == LIBRARY) {
		sprintf(string,"block %s %s",
			blk_P->name, modelTableEntry.name);
	}
	else if(modelTableEntry.mtype == GALAXY)
		sprintf(string,"hblock %s %s.t",
			blk_P->name, modelTableEntry.name);

	else  /* custom star */
		sprintf(string,"block %s %s.o",
			blk_P->name, modelTableEntry.name);

	if(displayFlag && graphics_mode )
		strcat(string," (PROBE)");
	if(displayFlag && blk_P->change_flag == 1)
		strcat(string," (*)");

	prinfo(fp,string);
	prinfo(fp,"\n\n");

} while((blk_P = blk_P->pfsibling) != galaxy_P->pchild );

#ifdef GRAPHICS
if(StoreMarkedConnections(fp,galaxy_P)) return;
#endif

if(displayFlag) {
	sprintf(string,
"*******************************************************\n");
	prinfo(fp,string);
}
KrnCreateModel(name);
return;
}


	void KrnOverflow(char *star,int	 buffer)

{
char strBuf[200];
sprintf(strBuf,"Star: %s had a buffer overflow on output buffer:%d\n",
		star,buffer);
if(!graphics_mode)
   printf("%s",strBuf);
else
   CsMessageAddLine(strBuf);
return;
}




