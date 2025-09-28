 
#ifdef LICENSE

/*  Capsim (r) Text Mode Kernel (TMK) Star Library (Blocks)
    Copyright (C) 1989-2002  XCAD Corporation 

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

    http://www.xcad.com
    XCAD Corporation
    Raleigh, North Carolina */

#endif
 
#ifdef SHORT_DESCRIPTION

This star adds all of its input samples using fixed point arithmetic. 

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
      int  __numberInputBuffers;
      int  __numberOutputBuffers;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define numberInputBuffers (state_P->__numberInputBuffers)
#define numberOutputBuffers (state_P->__numberOutputBuffers)

/*         
 *    PARAMETER DEFINES 
 */ 
#define roundoff_bits (param_P[0]->value.d)
#define size (param_P[1]->value.d)
#define output_size (param_P[2]->value.d)
#define saturation_mode (param_P[3]->value.d)
/*-------------- BLOCK CODE ---------------*/


fxadd 

(run_state,block_P)

	int run_state;
	block_Pt block_P;
{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int i, j, samples;
	int sum1, sum0, input1, input0, out1, out0, out;
	doublePrecInt inputSample;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "roundoff bits";
     char   *ptype0 = "int";
     char   *pval0 = "8";
     char   *pname0 = "roundoff_bits";
     char   *pdef1 = "Word length";
     char   *ptype1 = "int";
     char   *pval1 = "32";
     char   *pname1 = "size";
     char   *pdef2 = "outputsize";
     char   *ptype2 = "int";
     char   *pval2 = "32";
     char   *pname2 = "output_size";
     char   *pdef3 = "saturation mode";
     char   *ptype3 = "int";
     char   *pval3 = "1";
     char   *pname3 = "saturation_mode";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);
KrnModelParam(indexModel88,3 ,pdef3,ptype3,pval3,pname3);

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

 

        if (size > 32) {
                fprintf(stderr,"fxadd:size can not be greater than 32\n");
                return(4);
                }
	if ((size & 1) == 1) {
                fprintf(stderr,"fxadd: Sorry, size can not be an odd number\n");
                return(4);
                }
	/* 
	 * store as state the number of input/output buffers 
	 */
	if ((numberInputBuffers = NO_INPUT_BUFFERS()) < 1) {
		fprintf(stderr,"fxadd: no input buffers\n");
		return(2);
	}
	for(i=0; i< numberInputBuffers; i++) 
		SET_CELL_SIZE_IN(i,sizeof(doublePrecInt));
	if ((numberOutputBuffers = NO_OUTPUT_BUFFERS()) < 1) {
		fprintf(stderr,"fxadd: no output buffers\n");
		return(3);
	}
	for(i=0; i< numberOutputBuffers; i++) 
		SET_CELL_SIZE_OUT(i,sizeof(int));


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


	/* 
	 * read one sample from each input buffer and add them 
	 */

	for (samples = (MIN_AVAIL());samples > 0; --samples) {

		sum1 = 0;
		sum0 = 0;

		for (i=0; i<numberInputBuffers; ++i) { 

	                IT_IN(i);
			         inputSample = INDI(i,0);
                        input1 = inputSample.highWord;
                        input0 = inputSample.lowWord;
                        Fx_AddVar(size,saturation_mode,input1,input0,sum1,sum0,&out1,&out0); 
                        sum1 = out1;
                        sum0 = out0;
		} 

		Fx_RoundVar(size,output_size,roundoff_bits,sum1,sum0,&out);

		for (i=0; i<numberOutputBuffers; ++i) { 

			if(IT_OUT(i) ) {
				KrnOverflow("fxadd",i);
				return(99);
			}
            OUTI(i,0) = out;
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
