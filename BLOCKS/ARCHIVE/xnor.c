 
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

Function performs logical "xnor" of all its input samples

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
#define b_length (param_P[0]->value.d)
/*-------------- BLOCK CODE ---------------*/


xnor 

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
	int samples;
	int k_in;
	int k_out;
	float sample_out;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "length of data in bits";
     char   *ptype0 = "int";
     char   *pval0 = "1";
     char   *pname0 = "b_length";
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

 

	/* store as state the number of input/output buffers */
	if((ibufs = NO_INPUT_BUFFERS()) < 1) {
		fprintf(stderr,"xnor: no input buffers\n");
		return(2);
	}
	if((obufs = NO_OUTPUT_BUFFERS()) < 1) {
		fprintf(stderr,"xnor: no output buffers\n");
		return(3);
	}


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


	/* read one sample from each input buffer and "xnor" them */
	for(samples = MIN_AVAIL(); samples >0; --samples) {

		k_out = 0;

		for(i=0; i<ibufs; ++i) {
			IT_IN(i);
			k_in = INF(i,0);
			k_out ^= k_in;

		}
		k_out ^= ~0;
		k_out &= ~(~0 << b_length);
		sample_out = k_out;

		for(i=0; i<obufs; i++) {
			if(IT_OUT(i)) {
				KrnOverflow("xnor",i);
				return(99);
			}
			OUTF(i,0) = sample_out;
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
