 
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

This function generates a random sequence of bits, which can be used to exercise a data transmission system.

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>


 

#define OUT_SAMPLES NUMBER_SAMPLES_PER_VISIT 


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int  __shift_reg;
      int  __samples_out_total;
      double  __pace_in_total;
      int  __output_target;
      int  __no_inbuf;
      int  __obufs;
      int  __pass;
      int  __overFlowBuffer_A[25];
      float  __sample_A[25];
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define shift_reg (state_P->__shift_reg)
#define samples_out_total (state_P->__samples_out_total)
#define pace_in_total (state_P->__pace_in_total)
#define output_target (state_P->__output_target)
#define no_inbuf (state_P->__no_inbuf)
#define obufs (state_P->__obufs)
#define pass (state_P->__pass)
#define overFlowBuffer_A (state_P->__overFlowBuffer_A)
#define sample_A (state_P->__sample_A)

/*         
 *    PARAMETER DEFINES 
 */ 
#define num_of_samples (param_P[0]->value.d)
#define payloadLength (param_P[1]->value.d)
#define initialize (param_P[2]->value.d)
#define pace_rate (param_P[3]->value.f)
#define samples_first_time (param_P[4]->value.d)
/*-------------- BLOCK CODE ---------------*/


datagen 

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
 

	int i,j;
	float fbit;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "total number of samples to output";
     char   *ptype0 = "int";
     char   *pval0 = "128";
     char   *pname0 = "num_of_samples";
     char   *pdef1 = "Payload Length";
     char   *ptype1 = "int";
     char   *pval1 = "128";
     char   *pname1 = "payloadLength";
     char   *pdef2 = "Initialization for shift register";
     char   *ptype2 = "int";
     char   *pval2 = "12";
     char   *pname2 = "initialize";
     char   *pdef3 = "pace rate to determine how many samples to output";
     char   *ptype3 = "float";
     char   *pval3 = "1.0";
     char   *pname3 = "pace_rate";
     char   *pdef4 = "number of samples on the first call if paced";
     char   *ptype4 = "int";
     char   *pval4 = "128";
     char   *pname4 = "samples_first_time";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);
KrnModelParam(indexModel88,3 ,pdef3,ptype3,pval3,pname3);
KrnModelParam(indexModel88,4 ,pdef4,ptype4,pval4,pname4);

      }
break;
   


/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            samples_out_total=0;
       pace_in_total=0.0;
       output_target=NUMBER_SAMPLES_PER_VISIT;
       pass=0;

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

	if((obufs = NO_OUTPUT_BUFFERS() ) <= 0) {
		fprintf(stderr,"datagen: no output buffers\n");
		return(1); /* no output buffers */
	}
	no_inbuf = NO_INPUT_BUFFERS();
	if(no_inbuf != 1) {
		fprintf(stderr,"datagen: no input buffers\n");
		return(2); /* no output buffers */
	}
	shift_reg = initialize;


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 



	/* generate NUMBER_SAMPLES_PER_VISIT samples, then return */
	if(IT_IN(0)) {
	    for(i=0; i< payloadLength; i++) { 


		/* run the shift register sequence to obtain another bit */
		shift_reg = ((((shift_reg >> 10)&1) + ((shift_reg >> 3)&1)
			+1 ) % 2)+(shift_reg << 1);
			
		/* put out the new bit as a floating number */
		fbit = (float) (shift_reg & 1) ;
		
		samples_out_total += 1;
		for(j=0; j<obufs; j++) {
			if(IT_OUT(j)) {
				fprintf(stderr,"datagen: Serious overflow on Buffer %d \n",j);
				return(1);
			}
				
			OUTF(j,0) = fbit;
		}
		if(samples_out_total > num_of_samples) 
				return(0);
	    }
	}
	return(0);


break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 



break;
}
return(0);
}
