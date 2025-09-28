 
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

Function evaluates all its input samples through an expression specified as a parameter.

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int  __ibufs;
      int  __obufs;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define ibufs (state_P->__ibufs)
#define obufs (state_P->__obufs)

/*         
 *    PARAMETER DEFINES 
 */ 
#define paramExpr (param_P[0]->value.s)
/*-------------- BLOCK CODE ---------------*/
 int  

expr 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int i,j;
	int samples;
	float sampleIn;
	char	expression[256];


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Enter expression ( buffers are in0,in1,...)";
     char   *ptype0 = "file";
     char   *pval0 = "in0*1";
     char   *pname0 = "paramExpr";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);

      }
break;
   


/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
     
break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

	/*
	 *  Store as state the number of input/output buffers 
	 */
	if((ibufs = NO_INPUT_BUFFERS()) < 1) {
		sprintf(stderr,"expr: no input buffers\n");
		return(2);
	}
	if((obufs = NO_OUTPUT_BUFFERS()) < 1) {
		sprintf(stderr,"expr: no output buffers\n");
		return(3);
	}


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


	/* 
	 * Read one sample from each input buffer  
	 */
	for(samples = MIN_AVAIL(); samples >0; --samples) {


		for(i=0; i<ibufs; ++i) {
			IT_IN(i);
			
			sampleIn = INF(i,0);
			/*
			 * Setup expression for ini=sampleIn
			 * This will be passed to the parser.
			 * The symbol table will contain the symbols
			 * in0,in1,... which are equal to the buffer
			 * samples. When we later evaluate the expression
			 * which refers to in0, in1,... they will be recognized.
			 */
			sprintf(expression,"in%d=%e\n",i,sampleIn);
			krn_bufferPtr=0;
                        krn_buffer=expression;
                        yyparse();
		}
		/*
		 * since in0,in1,... are setup, evaluate expression. 
		 * First add an end of line ( all expressions must end with
		 * an end of line character.
		 * Next set the buffer pointer to zero and the buffer to
		 * the expression and call yyparse()
		 */
		strcpy(expression,paramExpr);
		strcat(expression,"\n");
		krn_bufferPtr=0;
                krn_buffer=expression;
               	yyparse();
//        	if(krn_yyerror) {
//                	krn_yyerror=FALSE;
//                	fprintf(stderr,"expr: Error in expression\n");
//                	return(7);
//        	}


		/*
		 * the result of evaluating the expression is in 
		 * krn_eqnResult. Ship it out to the output buffers
		 */
		for(i=0; i<obufs; i++) {
			if(IT_OUT(i)) {
				fprintf(stderr,"expr: Buffer %d is full\n",i);;
				return(1);
			}
			OUTF(i,0) = krn_eqnResult;
		}
	}

	return(0);	/* at least one input buffer empty */



break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 



break;
}
return(0);
}
