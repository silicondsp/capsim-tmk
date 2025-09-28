 
#ifdef LICENSE

/*  Capsim (r) Text Mode Kernel (TMK) Star Library (Blocks)
    Copyright (C) 1989-2017  Silicon DSP Corporation

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

#endif
 
#ifdef SHORT_DESCRIPTION

Prints samples from an arbitrary number of input buffers to a file, which is named as a parameter.

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>


 

#define FLOAT_BUFFER 0
#define COMPLEX_BUFFER 1
#define INTEGER_BUFFER 2


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      FILE*  __fp;
      int  __numberInputBuffers;
      int  __numberOutputBuffers;
      int  __displayFlag;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define fp (state_P->__fp)
#define numberInputBuffers (state_P->__numberInputBuffers)
#define numberOutputBuffers (state_P->__numberOutputBuffers)
#define displayFlag (state_P->__displayFlag)

/*         
 *    PARAMETER DEFINES 
 */ 
#define file_name (param_P[0]->value.s)
#define control (param_P[1]->value.d)
#define bufferType (param_P[2]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

prfile 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int i,j,k;
	complex val;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Name of output file";
     char   *ptype0 = "file";
     char   *pval0 = "stdout";
     char   *pname0 = "file_name";
     char   *pdef1 = "Print output control (0/Off, 1/On)";
     char   *ptype1 = "int";
     char   *pval1 = "1";
     char   *pname1 = "control";
     char   *pdef2 = "Buffer type:0= Float,1= Complex, 2=Integer";
     char   *ptype2 = "int";
     char   *pval2 = "0";
     char   *pname2 = "bufferType";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);

      }
break;
   


/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            displayFlag=0;

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

if((numberInputBuffers = NO_INPUT_BUFFERS()) <= 0) {
	fprintf(stdout,"prfile: no input buffers\n");
	return(1);
}
if((numberOutputBuffers = NO_OUTPUT_BUFFERS()) > numberInputBuffers) {
	fprintf(stdout,"prfile: more output than input buffers\n");
	return(2);
}
if(strcmp(file_name,"stdout") == 0) {
	fp = stdout;
	displayFlag = 1;
}
else if(strcmp(file_name,"stderr") == 0) {
	fp = stderr;
	displayFlag = 1;
}
else if((fp = fopen(file_name,"w")) == NULL) {
	fprintf(stdout,"prfile: can't open output file '%s'\n",
		file_name);
	return(3);
}
switch(bufferType) {
	case COMPLEX_BUFFER: 
		for(i=0; i< numberInputBuffers; i++)
			SET_CELL_SIZE_IN(i,sizeof(complex));
		for(i=0; i< numberOutputBuffers; i++)
			SET_CELL_SIZE_OUT(0,sizeof(complex));
		break;
	case FLOAT_BUFFER: 
		for(i=0; i< numberInputBuffers; i++)
			SET_CELL_SIZE_IN(i,sizeof(float));
		for(i=0; i< numberOutputBuffers; i++)
			SET_CELL_SIZE_OUT(0,sizeof(float));
		break;
	case INTEGER_BUFFER: 
		for(i=0; i< numberInputBuffers; i++)
			SET_CELL_SIZE_IN(i,sizeof(int));
		for(i=0; i< numberOutputBuffers; i++)
			SET_CELL_SIZE_OUT(0,sizeof(int));
		break;
	default: 
		fprintf(stderr,"Bad buffer type specified in prfile \n");
		return(4);
		break;
}


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 

	
if(control) {
	if(displayFlag && MIN_AVAIL() > 0) {
		fprintf(fp,"\n");
		for(j=0; j<(numberInputBuffers-2); j++)
			fprintf(fp,"%-6s","");
		fprintf(fp,"Output From Prfile '%s'\n",block_P->name);
		for(j=0; j<numberInputBuffers; ++j)
			fprintf(fp,"%-10s  ", SNAME(j));
		fprintf(fp,"\n");
	}
	/* This mode synchronizes all input buffers */
	for(i = MIN_AVAIL(); i>0; i--) {
		for(j=0; j<numberInputBuffers; ++j) {
			IT_IN(j);
			if(j < numberOutputBuffers) {
				if(IT_OUT(j)) {
					KrnOverflow("prfile",j);
					return(99);
				}
				switch(bufferType) {
					case COMPLEX_BUFFER: 
					   OUTCX(j,0) = INCX(j,0);
					   break;
					case FLOAT_BUFFER: 
					   OUTF(j,0) = INF(j,0);
					   break;
				        case INTEGER_BUFFER: 
					   OUTI(j,0) = INI(j,0);
					   break;
				}

			}
			switch(bufferType) {
				case COMPLEX_BUFFER: 
				   val=INCX(j,0);
				   if(fp!= stdout) 
				       fprintf(fp,"%-10g %-10g ", val.re,val.im);
				   else {
				       fprintf(stderr,"%-10g %-10g ", val.re,val.im);
				       
				   }
				   break;
				case FLOAT_BUFFER: 
				    if(fp!= stdout) 
					    fprintf(fp,"%-10g  ", INF(j,0));
				   else {
				       fprintf(stderr,"%-10g  ", INF(j,0));
				       
				   }
				   break;
			        case INTEGER_BUFFER: 
				    if(fp!= stdout)
					    fprintf(fp,"%-d  ", INI(j,0));
					else {
				       fprintf(stderr,"%-d  ", INI(j,0));
				       


					}
				   break;
			}

		}
		if(fp!= stdout)
		   fprintf(fp,"\n");
		else  {
                  fprintf(stderr," \n ");
				  

		}
		    
	}
}
else {
	/* This mode empties all input buffers */
	for(j=0; j<numberInputBuffers; ++j) {
		if(j < numberOutputBuffers) {
			while(IT_IN(j)) {
				if(IT_OUT(j) ){
					KrnOverflow("prfile",j);
					return(99);
				}
				switch(bufferType) {
					case COMPLEX_BUFFER: 
					   OUTCX(j,0) = INCX(j,0);
					   break;
					case FLOAT_BUFFER: 
					   OUTF(j,0) = INF(j,0);
					   break;
				        case INTEGER_BUFFER: 
					   OUTI(j,0) = INI(j,0);
					   break;
				}

			}
		}
		else
			while(IT_IN(j));
	}
}
return(0);



break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

	if(fp != stdout && fp != stderr)
		fclose(fp);


break;
}
return(0);
}
