
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


/* parameter.c */
/********************************************************************

		Parameter Mainipulation Routines

*********************************************************************
*/
#include <string.h>
#include "capsim.h"

int param_type(char *stype);
void propagate_arg(block_Pt pg,int  index);
int LineCharg(char *line);
int KrnModelParam(int mt_index,int pp_index,char *def,char *stype,char *sval,char *sname);
//extern float KrnEvalParamExp();

/* an array of parameter pointers */
param_Pt  param_stack[MAX_PARAM];

/*********************************************************************

		External Function Declarations

**********************************************************************
*/
//void KrnFreeParam(param_Pt *pp);

/**********************************************************************

			Global Declarations

***********************************************************************
*/


/* main.c */
extern int line_mode, graphics_mode;
extern block_Pt pb_current;
extern block_Pt pg_current;
extern block_Pt pb_error;

/**********************************************************************

			LineParam()

***********************************************************************

Function accepts a single line in the file which defines a parameter
and adds the parameter to the paramstack
*/

int LineParam(char *line)

{
	param_Pt p1;
	int error = 0;
	int i;
	int np;
	char stype[20];
	char sval[2*MAX_LINE];
	char sval2[2*MAX_LINE];
	float *a;
	float	paramEval;
        char *t;
	int k,qstart,qend,length;

/*
 * check that there is room for another parameter
 */
if((np = KrnParamCount(param_stack)) >= MAX_PARAM)
	return(70);

if(sscanf(line,"param%s %[^\n]",stype, sval) < 1)
	return(71);

/*
 * set up space for another parameter
 */
p1 = (param_Pt) calloc(1,sizeof(param_t));
p1->arg = -1;	/* initialize, not an arg parameter */

/*
 * determine the type of parameter
 */
p1->type = param_type(stype);

p1->exprFlag=FALSE;
if(sval[0]=='=' || sval[1]=='=') {

	p1->exprFlag=TRUE;
	p1->express = (char*)calloc(strlen(sval),sizeof(char));
	strcpy(p1->express,sval);
	paramEval=KrnEvalParamExp(sval);
	switch(p1->type) {
		   case  PARAM_FLOAT:
			p1->value.f = (float)paramEval;
			break;
		   case PARAM_INT:
			p1->value.d = (int)paramEval;
			break;
		   default:
			ErrorPrint("Expression not allowed for array or file or func",0);
			error = 72;
			break;
	}

}
switch(p1->type) {


  case	PARAM_FLOAT:
	if(p1->exprFlag) break;
	if(sscanf(sval,"%f",&p1->value.f) != 1)
		error = 72;
	break;

  case	PARAM_INT:
	if(p1->exprFlag) break;
	if(sscanf(sval,"%d",&p1->value.d) != 1)
		error = 72;
	break;

  case	PARAM_FILE:
	if(p1->exprFlag) break;
	p1->value.s = (char *) calloc(1,strlen(sval)+1);
	sscanf(sval,"%s",p1->value.s);
        // fprintf(stderr,"FILE PARAM=%s\n",sval);
	break;

//+++
  case  PARAM_STRING:
	if(p1->exprFlag) break;

        /*
         * strip white space and quote from string value
         */
         // fprintf(stderr,"STRING PARAM=%s\n",sval);

        t=sval;
    qstart=0;
    qend=0;
    length=strlen(t);
    if(*t != '&') {
            k=0;
            while(*t != '"' && k <length) { k++; qstart++; t++;}
	    t=&sval[qstart+1];
	    while(*t != '"' && k <length) { k++; qend++; t++; }
	    // fprintf(stderr,"qstart=%d qend=%d \n",qstart,qend);
            for(k=0; k<qend; k++) {
	        sval2[k]=sval[qstart+1+k];
	    }
	    sval2[qend]=0;

#if 000
             while(*t == ' ' || *t == '"' || *t == '\t')  t++;
             strcpy(sval,t);
             // t = sval + strlen(sval) - 1;
	     t = sval + strlen(sval) ;
	     fprintf(stderr,"STRING PARAM2 t=%s\n",t);
             while(*t == ' ' || *t == '"' || *t == '\t')  {
	               if(*t == '"') { t--; break;}
	               t--;

             }
             *(t+1) = '\0';
#endif

        }
        p1->value.s = (char *)calloc(1,strlen(sval2)+1);
        strcpy(p1->value.s, sval2);
        // fprintf(stderr,"STRING PARAM AFTER STRIP=%s\n",sval2);

        break;

//+++

  case	PARAM_FUNCTION:
	if(p1->exprFlag) break;
	/*
   	 * confirm a .c suffix and strip it off
	 */
	if(strcmp(".c",&sval[strlen(sval)-2]) != 0) {
		error = 73;
		break;
	}
	p1->value.s = (char *) calloc(1,strlen(sval)+1);
	sscanf(sval,"%s",p1->value.s);
	break;

  case	PARAM_ARRAY:
	if(p1->exprFlag) break;

	/*
	 * read number of elements of array from line
	 */
	if(sscanf(sval,"%d",&p1->array_size) != 1
	 || p1->array_size < 0 || p1->array_size > KRN_PARAM_MAX_ARRAY_SIZE) {
		error = 74;
		break;
	}

	/*
	 * read array values (maximum KRN_PARAM_MAX_ARRAY_SIZE!)
	 */
	a = (float *)calloc(KRN_PARAM_MAX_ARRAY_SIZE,sizeof(float));
	sscanf(sval,"%*d%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f",
			a,a+1,a+2,a+3,a+4,a+5,a+6,a+7,a+8,a+9,
			a+10,a+11,a+12,a+13,a+14,a+15,a+16,a+17,a+18,
			a+19,a+20,a+21,a+22,a+23,a+24);
	p1->value.a = a;

	break;

  case	PARAM_DEFAULT:
	break;

  case	PARAM_ARG:
	if(p1->exprFlag) break;
	if(sscanf(sval,"%d",&p1->arg) != 1
	 || p1->arg < 0 || p1->arg >= MAX_PARAM) {
		error = 75;
		break;
	}
	if(model[pg_current->model_index].param_model_flag == 1
	 && model[pg_current->model_index].param_AP[p1->arg] == NULL) {
		error = 77;
		break;
	}
	break;

  default:
	error = 71;
	break;
}

if(error) {
	KrnFreeParam(&p1);
	return(error);
}

param_stack[np] = p1;
/*
 * clear next paramstack entry
 */
if(++np < MAX_PARAM)
	param_stack[np] = NULL;

return(0);

}

int LineChp(char*);
/**********************************************************************

			LineParamName()

***********************************************************************

Function accepts a single line in the file which defines a parameter
by name and changes that parametr
*/

int LineParamName(char *line)

{
	char sval[2*MAX_LINE], command[MAX_LINE];
	char sprompt[MAX_LINE];
	char paramName[MAX_LINE];
	int prompt_flag = 0;
	int i,j, nwords;
	int pnum, ptype;
	int np;		/* number of parameters */
	int argnum;
	int intval;
	float floatval;
	float *a;
	int nar;	/* number of array elements */
	param_Pt *paramBlk_AP, *paramBlkModel_AP;	/* block and block model params */
	param_Pt *paramGal_AP, *paramGalModel_AP;	/* gal and gal model params */
	float	paramEval;
	int exprFlag=0;

	/*
	 * search the parameters and find the index corresponding to the parameter name
	 */

        if(pb_current == NULL)
	          return(90);
        paramBlk_AP = pb_current->param_AP;
        if((np = KrnParamCount(paramBlk_AP)) == 0) {
	     if(pb_current->type == GTYPE) return(92);
	     return(91);
        }

        if((nwords = sscanf(line,"parambyname %s %[^\n]", paramName, sval)) != 2) {
	    return(0);
        }
 //       else if(pnum < 0 || pnum >= np)
//	     return(93);
        paramBlkModel_AP = model[pb_current->model_index].param_AP;
        for(i=0; i<np; i++) {

	    if(strcmp(paramName, paramBlk_AP[i]->name)==0) {

	           sprintf(line,"chp %d %s\n",i,sval);
		   printf("Found Parameter at index=%d executing:chp %d %s\n",i,i,sval);
		   LineChp(line);
		   return(0);
	    };
	}
	printf("Could not find parameter:%s in %s. Perhaps wrong block!\n",paramName,pb_current->name);
}

/**********************************************************************

			LineChp()

***********************************************************************
Change the parameters of the current block, possibly with prompting.
During prompting, a (return) will leave the value unchanged.
(Note: Models for galaxies are built by 'arg' commands.
Models for stars are automatically built during their creation.)
*/

int LineChp(line)
	char *line;
{
	char sval[2*MAX_LINE], command[MAX_LINE];
	char sprompt[MAX_LINE];
	int prompt_flag = 0;
	int i,j, nwords;
	int pnum, ptype;
	int np;		/* number of parameters */
	int argnum;
	int intval;
	float floatval;
	float *a;
	int nar;	/* number of array elements */
	param_Pt *paramBlk_AP, *paramBlkModel_AP;	/* block and block model params */
	param_Pt *paramGal_AP, *paramGalModel_AP;	/* gal and gal model params */
	float	paramEval;
	int exprFlag=0;

if(pb_current == NULL)
	return(90);
paramBlk_AP = pb_current->param_AP;
if((np = KrnParamCount(paramBlk_AP)) == 0) {
	if(pb_current->type == GTYPE) return(92);
	return(91);
}

if((nwords = sscanf(line,"chp%d %[^\n]", &pnum, sval)) != 2) {
	if(!line_mode)
		return(0);
	prompt_flag = 1;
}
else if(pnum < 0 || pnum >= np)
	return(93);

paramBlkModel_AP = model[pb_current->model_index].param_AP;
paramGal_AP = pg_current->param_AP;
paramGalModel_AP = model[pg_current->model_index].param_AP;

if(prompt_flag) {
#ifndef EMBEDDED_ECOS
	/* Prompt user */
	sprintf(sprompt," Enter %d new parameters:\n", np);
	prinfo(stdout,sprompt);
#endif
}
for(i=0; i<np; i++) {
	if(!prompt_flag) {
		i = pnum;
		ptype = paramBlk_AP[i]->type;
		goto evaluate_sval;
	}
	ptype = paramBlk_AP[i]->type;
	sprintf(sprompt, "%d: %s\n", i,paramBlk_AP[i]->def);
#ifdef EMBEDDED_ECOS
	prinfo(1,sprompt);
#else
        prinfo(stdout,sprompt);
#endif

        exprFlag=paramBlk_AP[i]->exprFlag;




	if(paramBlk_AP[i]->arg >= 0)
		sprintf(command,"  param arg %d ?==>  ",
				paramBlk_AP[i]->arg);
	else if(exprFlag) {
		sprintf(command,"  param int %s ?==>  ",
				paramBlk_AP[i]->express);



	} else {
	    switch(ptype) {

	      case	PARAM_INT:
		sprintf(command,"  param int %d ?==>  ",
				paramBlk_AP[i]->value.d);
		break;

	      case	PARAM_FLOAT:
		sprintf(command,"  param float %18.14g ?==>  ",
				paramBlk_AP[i]->value.f);
		break;

	      case	PARAM_FILE:
		sprintf(command,"  param file %s ?==>  ",
				paramBlk_AP[i]->value.s);
		break;

	      case	PARAM_FUNCTION:
		sprintf(command,"  param function %s ?==>  ",
				paramBlk_AP[i]->value.s);
		break;

	      case	PARAM_ARRAY:
		nar = paramBlk_AP[i]->array_size;
		sprintf(command,"  param array [%d]", nar);
		a = paramBlk_AP[i]->value.a;
		for(j=0; j<nar; j++) {
			sprintf(sval,"  %g ", a[j]);
			strcat(command, sval);
		}
		strcat(command, "\n         ?==>  ");
		break;
	      case	PARAM_STRING:
		sprintf(command,"  param string \"%s\" ?==>  ",
				paramBlk_AP[i]->value.s);
		break;
	      default:
		return(93);
	    }
	}
#ifndef EMBEDDED_ECOS
	prinfo(stdout,command);
	/* get string from stdin */
	fgets(sval,2*MAX_LINE-1,stdin);
#endif

evaluate_sval:
	if(sval[0] == '\n' || sval[0]== '\r')
		continue;
	if(sval[0] == '=') {
	        sval[strlen(sval)-1]=0;
		paramBlk_AP[i]->exprFlag=TRUE;
		paramBlk_AP[i]->express=(char*)calloc(strlen(sval),sizeof(char));
		strcpy(paramBlk_AP[i]->express,sval);
		paramEval=KrnEvalParamExp(sval);
		switch(ptype) {
		   case  PARAM_FLOAT:
			paramBlk_AP[i]->value.f = (float)paramEval;
			break;
		   case PARAM_INT:
			paramBlk_AP[i]->value.d = (int)paramEval;
			break;
		   default:
			if(!prompt_flag)
				return(93);
			ErrorPrint("Expression not allowed for array or file or func",0);
			i--;
			continue;
			break;
		}
		if(!prompt_flag)
			return(0);
		continue;
	} else
		paramBlk_AP[i]->exprFlag=FALSE;

	if(sscanf(sval,"arg%d",&argnum) == 1) {
		if(argnum == paramBlk_AP[i]->arg) {
			if(!prompt_flag)
				return(0);
			continue;
		}
		if(argnum >= MAX_PARAM) {
			if(!prompt_flag)
				return(93);
			ErrorPrint("arg index too large",0);
			i--;
			continue;
		}
		if(argnum < 0) {
			paramBlk_AP[i]->arg = -1;
			paramBlk_AP[i]->def = paramBlkModel_AP[i]->def;
			pb_current->change_flag = 1;
			if(!prompt_flag)
				return(0);
			continue;
		}
		if(paramGalModel_AP[argnum] == NULL) {
			if(!prompt_flag)
				return(93);
			ErrorPrint("that arg is not yet defined",0);
			i--;
			continue;
		}
		if(paramGalModel_AP[argnum]->type != paramBlk_AP[i]->type) {
			if(!prompt_flag)
				return(93);
			ErrorPrint("that arg is wrong type",0);
			i--;
			continue;
		}
		paramBlk_AP[i]->arg = argnum;
		pb_current->change_flag = 1;
		propagate_arg(pg_current,argnum);
		if(!prompt_flag)
			return(0);
		continue;
	}

	if(strcmp(sval,"default") == 0) {
		KrnFreeParam(&paramBlk_AP[i]);
		KrnParamCheck(&paramBlk_AP[i],&paramBlkModel_AP[i]);
	}
	else if(ptype == PARAM_FLOAT) {
		if(sscanf(sval,"%f",&floatval) != 1) {
			if(!prompt_flag)
				return(93);
			ErrorPrint("improper float format",0);
			i--;
			continue;
		}
		else
			paramBlk_AP[i]->value.f = floatval;
	}
	else if(ptype == PARAM_INT) {
		if(sscanf(sval,"%d",&intval) != 1) {
			if(!prompt_flag)
				return(93);
			ErrorPrint("improper int format",0);
			i--;
			continue;
		}
		else
			paramBlk_AP[i]->value.d = intval;
	}
	else if(ptype == PARAM_FILE || ptype == PARAM_FUNCTION) {
		free(paramBlk_AP[i]->value.s);
		paramBlk_AP[i]->value.s = (char*)calloc(1,strlen(sval)+1);
		sscanf(sval,"%s",paramBlk_AP[i]->value.s);
	} else if(ptype == PARAM_STRING) {

		free(paramBlk_AP[i]->value.s);
		paramBlk_AP[i]->value.s = (char*)calloc(1,strlen(sval)+1);
		strcpy(paramBlk_AP[i]->value.s,sval);
    }
	else if(ptype == PARAM_ARRAY) {
		if(sscanf(sval,"%d", &nar) != 1
		 || nar < 0 || nar > KRN_PARAM_MAX_ARRAY_SIZE) {
			if(!prompt_flag)
				return(93);
			ErrorPrint("array size error",0);
			i--;
			continue;
		}
		paramBlk_AP[i]->array_size = nar;
		a = (float *) calloc(KRN_PARAM_MAX_ARRAY_SIZE,sizeof(float));
		sscanf(sval,"%*d%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f",
			a,a+1,a+2,a+3,a+4,a+5,a+6,a+7,a+8,a+9,
			a+10,a+11,a+12,a+13,a+14,a+15,a+16,a+17,a+18,
			a+19,a+20,a+21,a+22,a+23,a+24);
		free(paramBlk_AP[i]->value.s);
		paramBlk_AP[i]->value.a = a;
	}
	paramBlk_AP[i]->arg = -1;
	paramBlk_AP[i]->def = paramBlkModel_AP[i]->def;
	pb_current->change_flag = 1;
	propagate_arg(pb_current,i);
	if(!prompt_flag)
		return(0);
}

return(0);

}  /* ends line_changep */


/**********************************************************************

			LineArg()

***********************************************************************
Sets up model for galaxy parameters from 'arg' commands.
The format is:   'arg' argnum argtype argval "argprompt"
The (optional) prompt must be in double quotes.
NOTE: Only argtypes allowed are: int, float, or file.
The line 'arg -1' is interpreted as 'no args for this galaxy'.
The line 'arg 2 NULL' (e.g.) means 'eliminate arg #2'.
*/

int LineArg(char *line)

{
	param_Pt pp;
	param_Pt *paramGal_AP, *paramGalModel_AP;	/* parameters: galaxy, galaxy model */
	int error = 0;
	int i, nwords;
	int argnum, argtype;
	char sargtype[NAME_LENGTH];
	char sargval[NAME_LENGTH];
	char argprompt[MAX_LINE];
	char *t;

strcpy(argprompt,"&");
nwords = sscanf(line,"arg%d%s%s%[^\n]",
		&argnum,sargtype,sargval,argprompt);
if(nwords == 0 || argnum >= MAX_PARAM)
	return(81);

paramGalModel_AP = model[pg_current->model_index].param_AP;
paramGal_AP = pg_current->param_AP;

if(argnum < 0) {
	/* No args for this galaxy */
	for(i=0; i<MAX_PARAM; i++)
		KrnFreeParam(&paramGalModel_AP[i]);
	if(line_mode || graphics_mode) {

		for(i=0; i<MAX_PARAM; i++) {
			KrnFreeParam(&paramGal_AP[i]);
			propagate_arg(pg_current,i);
		}
		pg_current->change_flag = 1;
	}
	model[pg_current->model_index].param_model_flag = 1;
	return(0);
}
if(nwords < 2)
	return(81);
if(strcmp(sargtype,"NULL") == 0) {
	/* clear largest arg */
	if(paramGalModel_AP[argnum] == NULL)
		return(0);
#if 0
	if(argnum < MAX_PARAM-1 && paramGalModel_AP[argnum+1] != NULL)
		/* check contiguity of arg deletion */
		return(83);
#endif
	KrnFreeParam(&paramGalModel_AP[argnum]);
	if(line_mode || graphics_mode) {
		KrnFreeParam(&paramGal_AP[argnum]);
		propagate_arg(pg_current,argnum);
		pg_current->change_flag = 1;
	}
	model[pg_current->model_index].param_model_flag = 1;
	return(0);
}

if(nwords < 3)
	return(81);
#if 0
if(argnum > 0 && paramGalModel_AP[argnum-1] == NULL)
	/* contiguity of arg definition check */
	return(82);
#endif

pp = (param_Pt) calloc(1,sizeof(param_t));

pp->arg = -1;	/* model parameters are NEVER arguments */
pp->type = argtype = param_type(sargtype);
if(argtype == PARAM_INT) {
	if(sscanf(sargval,"%d",&(pp->value.d)) != 1) {
		KrnFreeParam(&pp);
		return(84);
	}
}
else if(argtype == PARAM_FLOAT) {
	if(sscanf(sargval,"%f",&(pp->value.f)) != 1) {
		KrnFreeParam(&pp);
		return(84);
	}
}
else if(argtype == PARAM_FILE) {
	pp->value.s = (char *)calloc(1,strlen(sargval)+1);
	strcpy(pp->value.s, sargval);
}else if(argtype == PARAM_STRING) {

	/*
	 * strip white space and quote from string value
	 */


	t=sargval;
    if(*t != '&') {
	     while(*t == ' ' || *t == '"' || *t == '\t')  t++;
	     strcpy(sargval,t);
	     t = sargval + strlen(sargval) - 1;
	     while(*t == ' ' || *t == '"' || *t == '\t')  t--;
	     *(t+1) = '\0';

	}
	pp->value.s = (char *)calloc(1,strlen(sargval)+1);
	strcpy(pp->value.s, sargval);
}
else {
	KrnFreeParam(&pp);
	return(85);
}

/* strip white space and quote marks from prompt */
t = argprompt;
if(*t != '&') {
	while(*t == ' ' || *t == '"' || *t == '\t')  t++;
	strcpy(argprompt,t);
	t = argprompt + strlen(argprompt) - 1;
	while(*t == ' ' || *t == '"' || *t == '\t')  t--;
	*(t+1) = '\0';

	pp->def = (char *)calloc(1,strlen(argprompt)+1);
	strcpy(pp->def,argprompt);
}
else {
	pp->def = (char *)calloc(1,1);
	strcpy(pp->def,"");
}

if(paramGalModel_AP[argnum] != NULL) {
	if(strcmp(pp->def,"") == 0)
		pp->def = paramGalModel_AP[argnum]->def;
	if(paramGalModel_AP[argnum]->type != pp->type) {
		KrnFreeParam(&paramGalModel_AP[argnum]);
		KrnFreeParam(&paramGal_AP[argnum]);
		pg_current->change_flag = 1;
		propagate_arg(pg_current,argnum);
	}
	paramGalModel_AP[argnum]= pp;
/*
 * check this out
 */
	if(pg_current->type == UTYPE)
		paramGal_AP[argnum]= pp;
	model[pg_current->model_index].param_model_flag = 1;
#if 0
	if(pg_current->type == UTYPE)
		KrnFreeParam(&paramGal_AP[argnum]);
#endif
	if(line_mode || graphics_mode) {
		KrnParamCheck(&paramGal_AP[argnum], &paramGalModel_AP[argnum]);
		propagate_arg(pg_current,argnum);
	}
}
else {
/*
 * check this out too
 */
	if(pg_current->type == UTYPE)
		paramGal_AP[argnum] = pp;
	paramGalModel_AP[argnum] = pp;
	model[pg_current->model_index].param_model_flag = 1;
#if 0
	if(pg_current->type == UTYPE)
		KrnFreeParam(&paramGal_AP[argnum]);
#endif
	if(line_mode || graphics_mode) {
		pg_current->change_flag = 1;
#if 0
		KrnParamCheck(&paramGal_AP[argnum], &paramGalModel_AP[argnum]);
#endif
		propagate_arg(pg_current,argnum);
	}
}

return(0);

}

/**********************************************************************

			LineCharg()

***********************************************************************
*/

int LineCharg(char *line)

{
	param_Pt pp;
	param_Pt *paramGal_AP, *paramGalModel_AP;	/* parameters: galaxy, galaxy model */
	int error = 0;
	int i, nwords;
	int argnum, argtype;
	char sargtype[NAME_LENGTH];
	char sargval[NAME_LENGTH];
	char argprompt[MAX_LINE+2];
	char sval[2*MAX_LINE], command[MAX_LINE], sprompt[MAX_LINE];
	int pnum, ptype;
	int argType;
	int leave=0;

      int prompt_flag=0;

	char *t;

paramGalModel_AP = model[pg_current->model_index].param_AP;
paramGal_AP = pg_current->param_AP;

if((nwords = sscanf(line,"charg%d %[^\n]", &pnum, sval)) != 2) {
	if(!line_mode)
		return(0);
	prompt_flag = 1;
}
else if(0)
	return(93); //fix

if(prompt_flag) {

	/* Prompt user */
	sprintf(sprompt," Enter arg number:\n");
	prinfo(stdout,sprompt);
      scanf("%d",&argnum);






      if(argnum >= MAX_PARAM)
	     return(81); //fix


      strcpy(sargtype,"");
      strcpy(sargval,"");
      strcpy(argprompt,"");

      if(paramGalModel_AP[argnum] != NULL) {

	    pp = paramGalModel_AP[argnum];

	    argType = pp->type;




           prinfo(stdout,"Argument exists\n");



      }  else {
                   sprintf(command,"arg %d int 0 ",argnum);
                   LineArg(command);
 	             pp = paramGalModel_AP[argnum];

	             argType = pp->type;


      }

	strcpy(argprompt,pp->def);


	sprintf(sprompt," Enter arg prompt(%s):\n",argprompt);
	prinfo(stdout,sprompt);

      while (fgets(sval,2*MAX_LINE-1,stdin) != NULL) {
	   break;
      }

      while (fgets(sval,MAX_LINE-1,stdin) != NULL) {
             break;
//           if(strncmp(argprompt,"\"",1)==0) break;
      };
//++++

 	if(sval[0] == '\n' || sval[0]== '\r' || sval[0]==' ') {

	} else {
	    strcpy(argprompt,sval);
#if 1
          /*
           * strip white space and quote from string value
           */


          t=argprompt;
          if(*t != '&') {
             while(*t == ' ' || *t == '"' || *t == '\t')  t++;
             strcpy(argprompt,t);
             t = argprompt + strlen(argprompt) - 1;
             while(*t == ' ' || *t == '"' || *t == '\t' || *t=='\n' || *t=='\r')  t--;
             *(t+1) = '\0';

          }
#endif

	}






	   switch(argType) {

	       case PARAM_INT:
//	           prinfo(stdout,"Type is int\n");
		   strcpy(sargtype,"int");
	           break;
               case PARAM_FLOAT:
//	           prinfo(stdout,"Type is float\n");
		   strcpy(sargtype,"float");

	           break;

               case PARAM_FILE:
//	           prinfo(stdout,"Type is File\n");
		   strcpy(sargtype,"file");

	           break;
               case PARAM_STRING:
//	           prinfo(stdout,"Type is String\n");
		   strcpy(sargtype,"string");

	           break;



	   }

	   switch(argType) {

	     case	PARAM_INT:
		sprintf(sargval,"%d",
				pp->value.d);
		break;

	     case	PARAM_FLOAT:
		sprintf(sargval,"%g",
				pp->value.f);
		break;

	    case	PARAM_FILE:
		sprintf(sargval,"%s",
				pp->value.s);
		break;

	    case	PARAM_STRING:
		sprintf(sargval,"%s",
				pp->value.s);
		break;


            }




//	fgets(sval,2*MAX_LINE-1,stdin);
//	printf("CHECK THIS ARGS %s \n",sval);

	sprintf(sprompt," Enter type (%s):\n",sargtype);
	prinfo(stdout,sprompt);

        while (fgets(sval,2*MAX_LINE-1,stdin) != NULL) {
	   break;

        };


//	fgets(sval,2*MAX_LINE-1,stdin);



	if(sval[0] == '\n' || sval[0]== '\r' || sval[0]==' ') {

	} else {
	   sscanf(sval,"%s[^\n]",sargtype);

	}






 //       scanf("%s[^\n]",sargtype);

	sprintf(sprompt," Enter value (%s):\n",sargval);
	prinfo(stdout,sprompt);

        while (fgets(sval,2*MAX_LINE-1,stdin) != NULL) {
           break;

        };

//      printf("CHECKING VALUE sval=%s\n",sval);
 	if(sval[0] == '\n' || sval[0]== '\r' || sval[0]==' ') {

	} else {
	   sscanf(sval,"%s[^\n]",sargval);

	}

  //    scanf("%s[^\n]",sargval);






//+++++

//      scanf("%s[^\n]",argprompt);

      printf("arg %d %s %s %s \n",
		argnum,sargtype,sargval,argprompt);
      nwords=4;


}

#if 0000

strcpy(argprompt,"&");
nwords = sscanf(line,"arg%d%s%s%[^\n]",
		&argnum,sargtype,sargval,argprompt);
if(nwords == 0 || argnum >= MAX_PARAM)
	return(81);

#endif

#if 1111
paramGalModel_AP = model[pg_current->model_index].param_AP;
paramGal_AP = pg_current->param_AP;

if(argnum < 0) {
	/* No args for this galaxy */
	for(i=0; i<MAX_PARAM; i++)
		KrnFreeParam(&paramGalModel_AP[i]);
	if(line_mode || graphics_mode) {

		for(i=0; i<MAX_PARAM; i++) {
			KrnFreeParam(&paramGal_AP[i]);
			propagate_arg(pg_current,i);
		}
		pg_current->change_flag = 1;
	}
	model[pg_current->model_index].param_model_flag = 1;
	return(0);
}
#if 000
if(nwords < 2)
	return(81);
#endif

if(strcmp(sargtype,"NULL") == 0) {
	/* clear largest arg */
	if(paramGalModel_AP[argnum] == NULL)
		return(0);
#if 0
	if(argnum < MAX_PARAM-1 && paramGalModel_AP[argnum+1] != NULL)
		/* check contiguity of arg deletion */
		return(83);
#endif
	KrnFreeParam(&paramGalModel_AP[argnum]);
	if(line_mode || graphics_mode) {
		KrnFreeParam(&paramGal_AP[argnum]);
		propagate_arg(pg_current,argnum);
		pg_current->change_flag = 1;
	}
	model[pg_current->model_index].param_model_flag = 1;
	return(0);
}

if(nwords < 3)
	return(81);
#if 0
if(argnum > 0 && paramGalModel_AP[argnum-1] == NULL)
	/* contiguity of arg definition check */
	return(82);
#endif



pp = (param_Pt) calloc(1,sizeof(param_t));

pp->arg = -1;	/* model parameters are NEVER arguments */
pp->type = argtype = param_type(sargtype);
if(argtype == PARAM_INT) {
	if(sscanf(sargval,"%d",&(pp->value.d)) != 1) {
		KrnFreeParam(&pp);
		return(84);
	}
}
else if(argtype == PARAM_FLOAT) {
	if(sscanf(sargval,"%f",&(pp->value.f)) != 1) {
		KrnFreeParam(&pp);
		return(84);
	}
}
else if(argtype == PARAM_FILE) {
	pp->value.s = (char *)calloc(1,strlen(sargval)+1);
	strcpy(pp->value.s, sargval);
}else if(argtype == PARAM_STRING) {

	/*
	 * strip white space and quote from string value
	 */


	t=sargval;
    if(*t != '&') {
	     while(*t == ' ' || *t == '"' || *t == '\t')  t++;
	     strcpy(sargval,t);
	     t = sargval + strlen(sargval) - 1;
	     while(*t == ' ' || *t == '"' || *t == '\t')  t--;
	     *(t+1) = '\0';

	}
	pp->value.s = (char *)calloc(1,strlen(sargval)+1);
	strcpy(pp->value.s, sargval);
}
else {
	KrnFreeParam(&pp);
	return(85);
}

/* strip white space and quote marks from prompt */
t = argprompt;
if(*t != '&') {
	while(*t == ' ' || *t == '"' || *t == '\t')  t++;
	strcpy(argprompt,t);
	t = argprompt + strlen(argprompt) - 1;
	while(*t == ' ' || *t == '"' || *t == '\t')  t--;
	*(t+1) = '\0';

	pp->def = (char *)calloc(1,strlen(argprompt)+1);
	strcpy(pp->def,argprompt);
}
else {
	pp->def = (char *)calloc(1,1);
	strcpy(pp->def,"");
}

if(paramGalModel_AP[argnum] != NULL) {
	if(strcmp(pp->def,"") == 0)
		pp->def = paramGalModel_AP[argnum]->def;
	if(paramGalModel_AP[argnum]->type != pp->type) {
		KrnFreeParam(&paramGalModel_AP[argnum]);
		KrnFreeParam(&paramGal_AP[argnum]);
		pg_current->change_flag = 1;
		propagate_arg(pg_current,argnum);
	}
	paramGalModel_AP[argnum]= pp;
/*
 * check this out
 */
	if(pg_current->type == UTYPE)
		paramGal_AP[argnum]= pp;
	model[pg_current->model_index].param_model_flag = 1;
#if 0
	if(pg_current->type == UTYPE)
		KrnFreeParam(&paramGal_AP[argnum]);
#endif
	if(line_mode || graphics_mode) {
		KrnParamCheck(&paramGal_AP[argnum], &paramGalModel_AP[argnum]);
		propagate_arg(pg_current,argnum);
	}
}
else {
/*
 * check this out too
 */
	if(pg_current->type == UTYPE)
		paramGal_AP[argnum] = pp;
	paramGalModel_AP[argnum] = pp;
	model[pg_current->model_index].param_model_flag = 1;
#if 0
	if(pg_current->type == UTYPE)
		KrnFreeParam(&paramGal_AP[argnum]);
#endif
	if(line_mode || graphics_mode) {
		pg_current->change_flag = 1;
#if 0
		KrnParamCheck(&paramGal_AP[argnum], &paramGalModel_AP[argnum]);
#endif
		propagate_arg(pg_current,argnum);
	}
}


#endif

return(0);

}


/**********************************************************************

			KrnStoreStack()

************************************************************************

Function copies paramstack pointers into a block param array.
If the block pointer is NULL, the stack is cleared.
*/

 void KrnStoreStack(block_Pt pblock)

{
	param_Pt *paramBlk_AP, *paramBlkModel_AP;	/* block, block model param array */
	param_Pt *paramGal_AP, *paramGalModel_AP;	/* gal, gal model param array */
	int i, index;
	int arg;

if(pblock == NULL) {
	for(i=0; i<MAX_PARAM; i++) {
		if(param_stack[i] != NULL)
			KrnFreeParam(&param_stack[i]);
	}
	return;
}
index = pblock->model_index;
paramBlk_AP = pblock->param_AP;

for(i=0; i<MAX_PARAM; i++) {
	paramBlk_AP[i] = param_stack[i];
	param_stack[i] = NULL;
}

if(pblock->type != GTYPE ) {
   for(i=0; i<MAX_PARAM; i++) {
        if(paramBlk_AP[i]) {
	   if(model[index].param_AP[i]) {
                   paramBlk_AP[i]->name=(char *)calloc(100,sizeof(char));
                   strcpy(paramBlk_AP[i]->name,model[index].param_AP[i]->name);
           }
        } else {

	}
   }
}



#if 0
if(pblock->type==GTYPE || pblock->type == UTYPE)
	KrnCreateArgListFromArray(pblock);
#endif

return;

}


/*********************************************************************
 *
 *		KrnVerifyParams()
 *
 *********************************************************************
Compares block parameters array to block model parameter array.
Block values are overwritten as necessary.
 */

 int KrnVerifyParams(block_Pt pblock)

{
	param_Pt *paramBlk_AP, *paramBlkModel_AP;	/* block, block model params */
	param_Pt *paramGal_AP, *paramGalModel_AP;	/* gal, gal model params */
	int i,j;
	int npb, npbm;
	int arg,type;
	int model_create_flag = 0;

if(model[pblock->model_index].param_model_flag != 1) {
	if(pblock->type == STYPE)
		return(102);
	/*
	 * TEMPORARY:  help convert old style topologies
	 * (no arg commands) into modern style automatically.
	 * 1) always set block model_flag for galaxies
	 * 2) set model_create_flag to create parent model.
	 */
	else
 		model[pblock->model_index].param_model_flag = 1;
}
paramBlk_AP = pblock->param_AP;
paramBlkModel_AP = model[pblock->model_index].param_AP;
npb = KrnParamCount(paramBlk_AP);
npbm = KrnParamCount(paramBlkModel_AP);

if(pblock->pparent != NULL) {
	/* this is for non-universe galaxies */
	paramGal_AP = pblock->pparent->param_AP;
	paramGalModel_AP = model[pblock->pparent->model_index].param_AP;
	if(model[pblock->pparent->model_index].param_model_flag != 1)
		model_create_flag = 1;
}

/* this clears block params, and incomplete block models */
for(i=npbm; i<MAX_PARAM; i++) {
	KrnFreeParam(&paramBlk_AP[i]);
	KrnFreeParam(&paramBlkModel_AP[i]);
}

for(i=0; i<npbm; i++) {
	if(paramBlk_AP[i] == NULL)
		pblock->change_flag = 1;
	else if((arg = paramBlk_AP[i]->arg) >= 0) {
		if(model_create_flag) {
			if((type = paramBlkModel_AP[i]->type) == PARAM_INT
			 || type == PARAM_FLOAT
			 || type == PARAM_STRING
			 || type == PARAM_FILE) {
				KrnParamCheck(&paramGalModel_AP[arg],&paramBlkModel_AP[i]);
				pblock->change_flag = 1;
			}
			else {
				pb_error = pblock;
				return(117);
			}
		}
		else {
			if(paramGalModel_AP[arg] == NULL)
				return(112);
		}
		/* initial setup from galaxy model */
		KrnParamCheck(&paramBlk_AP[i],&paramGalModel_AP[arg]);
		paramBlk_AP[i]->arg = arg;
	}

	KrnParamCheck(&paramBlk_AP[i],&paramBlkModel_AP[i]);
	propagate_arg(pblock,i);
}

return(0);

}
#if 0000
/*
 * copy parameter p2 into p1
 */
void CopyParameter(p1,p2)
param_Pt p1, p2;
{
int i;

p1->arg = -1;
p1->type = p2->type;
p1->def = p2->def;
p1->name = p2->name;
p1->array_size = 0;

switch (p2->type) {

  case	PARAM_INT:
	p1->value.d = p2->value.d;
	break;

  case	PARAM_FLOAT:
	p1->value.f = p2->value.f;
	break;

  case	PARAM_FILE:
  case	PARAM_FUNCTION:
	p1->value.s = (char*)calloc(1,strlen(p2->value.s)+1);
	strcpy(p1->value.s, p2->value.s);
	break;

  case	PARAM_ARRAY:
	p1->array_size = p2->array_size;
	p1->value.a = (float *)calloc(KRN_PARAM_MAX_ARRAY_SIZE,sizeof(float));
	for(i=0; i<p2->array_size; i++)
		p1->value.a[i] = p2->value.a[i];
	break;
  case	PARAM_STRING:
	if(p1->exprFlag) break;
	p1->value.s = (char *) calloc(1,strlen(sval)+1);
    j=0;
	buff=(char*)p1->value.s;
    for(i=0; i<strlen(sval); i++) {
         c=sval[i];
		 if(c=='"') continue;
          buff[j]=c;
		  j++;

	}
	buff[j]=0;
	break;


  default:
	break;
}
if(p2->exprFlag) {
	p1->exprFlag=TRUE;
	p1->express=(char*)calloc(strlen(p2->express),sizeof(char));
	strcpy(p1->express,p2->express);
} else
	p1->exprFlag=FALSE;

return;
}
#endif

/*
 * copy parameter p2 into p1
 */
void CopyParameter(p1,p2)
param_Pt p1, p2;
{
int i;

p1->arg = -1;
p1->type = p2->type;
p1->def = p2->def;
p1->name = p2->name;
p1->array_size = 0;

switch (p2->type) {

  case	PARAM_INT:
	p1->value.d = p2->value.d;
	break;

  case	PARAM_FLOAT:
	p1->value.f = p2->value.f;
	break;

  case	PARAM_FILE:
  case	PARAM_FUNCTION:
	p1->value.s = (char*)calloc(1,strlen(p2->value.s)+1);
	strcpy(p1->value.s, p2->value.s);
	break;

  case	PARAM_STRING:
	p1->value.s = (char*)calloc(1,strlen(p2->value.s)+1);
	strcpy(p1->value.s, p2->value.s);
	break;


  case	PARAM_ARRAY:
	p1->array_size = p2->array_size;
	p1->value.a = (float *)calloc(KRN_PARAM_MAX_ARRAY_SIZE,sizeof(float));
	for(i=0; i<p2->array_size; i++)
		p1->value.a[i] = p2->value.a[i];
	break;

  default:
	break;
}
if(p2->exprFlag) {
	p1->exprFlag=TRUE;
	p1->express=(char*)calloc(strlen(p2->express),sizeof(char));
	strcpy(p1->express,p2->express);
} else
	p1->exprFlag=FALSE;

return;
}

/**********************************************************************

			KrnParamCheck()

************************************************************************

Function conditionally copies parameter #2 into parameter #1.
If param #2 is NULL, param #1 is freed (if necessary) and NULLED.
Else, if param #1 is NULL, it is allocated, and complete copy occurs.
Else, if there is type disagreement, param #1 is freed, allocated
	and complete copy occurs.
Else, if types agree, nothing happens (except definition copy).
*/

 int KrnParamCheck(param_Pt *pp1,param_Pt *pp2)


{
	param_Pt p1, p2;
	int i;

if(pp1 == NULL || pp2 == NULL) {
	ErrorPrint("KrnParamCheck argument form",1);
	exit(2);
}
#if 0
if(*pp1 == NULL &&  *pp2 == NULL) {
	return(0);
}
#endif

if(*pp2 == NULL) {
	KrnFreeParam(pp1);
	return(0);
}
p2 = *pp2;

#if 1
if((p1 = *pp1) != NULL && p1->type == p2->type) {
	/* Magnitude Checking NOT IMPLEMENTED YET */
	if(p1->def == NULL)
		p1->def = p2->def;
	if(p1->name == NULL)
		p1->name = p2->name;
	return(0);
}
#endif

KrnFreeParam(pp1);
*pp1 = (param_Pt) calloc(1,sizeof(param_t));
p1 = *pp1;
CopyParameter(p1,p2);
return(0);

}


/*********************************************************************

			KrnParamCount()

**********************************************************************
Returns the number of parameters in a parameter pointer array
*/

 int KrnParamCount(param_Pt pp[])

{
	int	i;
	int numberParams = 0;

if(pp == NULL)
	return(0);

for(i=0; i<MAX_PARAM; i++) {
	if(pp[i]) ++numberParams;
}

return(numberParams);

}


/*******************************************************************

			param_type()

********************************************************************

Function interprets a word representing a parameter type.
*/

int param_type(char *stype)


{

if(strcmp(stype,"float") == 0) return(PARAM_FLOAT);
else if(strcmp(stype,"int") == 0) return(PARAM_INT);
else if(strcmp(stype,"file") == 0) return(PARAM_FILE);
else if(strcmp(stype,"function") == 0) return(PARAM_FUNCTION);
else if(strcmp(stype,"array") == 0) return(PARAM_ARRAY);
else if(strcmp(stype,"arg") == 0) return(PARAM_ARG);
else if(strcmp(stype,"string") == 0) return(PARAM_STRING);

else if(strcmp(stype,"default") == 0) return(PARAM_DEFAULT);
else return(-2); /* error */

}


/**********************************************************************

			KrnFreeParam()

***********************************************************************

Function frees parameter storage
*/

void KrnFreeParam(param_Pt *pp)
{
	int type;

if(pp == NULL)
	return;
if(*pp == NULL)
	return;

if((type = (*pp)->type) == PARAM_FILE
 || type == PARAM_FUNCTION
  || type == PARAM_STRING
 || type == PARAM_ARRAY)
	free((*pp)->value.s);

//SHA June 24, 2002      free(*pp);
*pp = NULL;

return;
}


/**********************************************************************

			propagate_arg()

**********************************************************************
Searches the parameters of all children of the given galaxy
block for those with argument numbers matching the given index.
The galaxy parameter value and definition pointer are then copied to
the child.  This is recursive if the child is also a galaxy block.
Special case: if the indicated galaxy parameter is NULL, then any
child parameters with matching args are "turned off" (param arg = -1);
*/

void propagate_arg(block_Pt pg,int  index)

{
	block_Pt pblock;
	param_Pt *paramBlk_AP, *paramGal_AP;	/* block parameter arrays */
	param_Pt *paramBlkModel_AP, *paramGalModel_AP;	/* model parameter arrays */
	char *val1, *val2;
	int i;
	int arg_off_flag = 0;

if(pg == NULL || (pblock = pg->pchild) == NULL)
	return;
/*
 * Update the parameter array for this galaxy.
 * The parameter array is derived from the linked list of argument
 * parameters.
 *
 */
paramGal_AP = pg->param_AP;
paramGalModel_AP = model[pg->model_index].param_AP;
if(paramGal_AP[index] == NULL)
	arg_off_flag = 1;

do {
	paramBlk_AP = pblock->param_AP;
	paramBlkModel_AP = model[pblock->model_index].param_AP;
	for(i=0; i<MAX_PARAM; i++) {
		if(paramBlk_AP[i] == NULL)
			/*
			 * used to be break
			 */
			continue;


                paramBlk_AP[i]->name=paramBlkModel_AP[i]->name;

		if(paramBlk_AP[i]->arg == index) {
			if(arg_off_flag) {
				paramBlk_AP[i]->arg = -1;
				paramBlk_AP[i]->def = paramBlkModel_AP[i]->def;
				pblock->change_flag = 1;
				continue;
			}
			if(paramBlk_AP[i]->type == PARAM_INT) {
				paramBlk_AP[i]->value.d = paramGal_AP[index]->value.d;
				paramBlk_AP[i]->def = paramGalModel_AP[index]->def;
				propagate_arg(pblock,i);
				continue;
			}
			if(paramBlk_AP[i]->type == PARAM_FLOAT) {
				paramBlk_AP[i]->value.f = paramGal_AP[index]->value.f;
				paramBlk_AP[i]->def = paramGalModel_AP[index]->def;
				propagate_arg(pblock,i);
				continue;
			}
			if(paramBlk_AP[i]->type == PARAM_FILE) {
				free(paramBlk_AP[i]->value.s);
				val2 = paramGal_AP[index]->value.s;
				val1 = (char *)calloc(1,strlen(val2)+1);
				strcpy(val1,val2);
				paramBlk_AP[i]->value.s = val1;
				paramBlk_AP[i]->def = paramGalModel_AP[index]->def;
				propagate_arg(pblock,i);
				continue;
			}
			if(paramBlk_AP[i]->type == PARAM_STRING) {
				free(paramBlk_AP[i]->value.s);
				val2 = paramGal_AP[index]->value.s;
				val1 = (char *)calloc(1,strlen(val2)+1);
				strcpy(val1,val2);
				paramBlk_AP[i]->value.s = val1;
				paramBlk_AP[i]->def = paramGalModel_AP[index]->def;
				propagate_arg(pblock,i);
				continue;
			}

			pb_error = pblock;
			ErrorPrint("",117);
			return;
		}
	}
} while((pblock = pblock->pfsibling) != pg->pchild);

return;

}


/*******************************************************************
 *
 *		KrnModelParam()
 *
 ******************************************************************
 * Function is called by stars to create a model parameter entry.
 */
int KrnModelParam(int mt_index,int pp_index,char *def,char *stype,char *sval,char *sname)


{
	param_Pt *modparam = model[mt_index].param_AP;
	param_Pt pp;
	float *a;
	int i;
	float	paramValue;
	int	exprFlag=FALSE;

model[mt_index].param_model_flag = 1;



if(pp_index < 0)
	/* The 'no parameters' case */
	return(0);

//printf("KrnModelParam : %s : %s \n",sname,def);
pp = (param_Pt)calloc(1,sizeof(param_t));
pp->def = (char *)calloc(1,strlen(def)+1);
pp->name = (char *)calloc(1,strlen(sname)+1);
strcpy(pp->def,def);
strcpy(pp->name,sname);
pp->arg = -1;

pp->type = param_type(stype);
if(sval[0]=='=') {
	paramValue = KrnEvalParamExp(sval);
	exprFlag = TRUE;
}
switch(pp->type) {
  case	PARAM_FLOAT:
	if(exprFlag)
		pp->value.f = paramValue;
	else
		sscanf(sval,"%f",&pp->value.f);
	break;

  case	PARAM_INT:
	if(exprFlag)
		pp->value.d = (int)paramValue;
	else
		sscanf(sval,"%d",&pp->value.d);
	break;

  case	PARAM_FILE:
  case	PARAM_FUNCTION:
	pp->value.s = (char *)calloc(1,strlen(sval)+1);
	strcpy(pp->value.s, sval);
	break;

  case	PARAM_ARRAY:

	a = (float *)calloc(KRN_PARAM_MAX_ARRAY_SIZE, sizeof(float));
	sscanf(sval,"%d%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f",
			&pp->array_size,
			a,a+1,a+2,a+3,a+4,a+5,a+6,a+7,a+8,a+9,
			a+10,a+11,a+12,a+13,a+14,a+15,a+16,a+17,a+18,
			a+19,a+20,a+21,a+22,a+23,a+24);
	pp->value.a = a;
	break;
  case PARAM_STRING:
	pp->value.s = (char *)calloc(1,strlen(sval)+1);
	strcpy(pp->value.s, sval);
//	CsInfo("Star");CsInfo(pp->value.s);
	break;
  default:
	/* this is an error but stars are prevented from
	   generating it by stargaze; it is trapped, since
	   the param flag does not get set */
	break;
}

modparam[pp_index] = pp;


return(0);

}

