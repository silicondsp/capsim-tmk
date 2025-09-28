 
#ifdef LICENSE

/*  Capsim (r) Text Mode Kernel (TMK) Star Library (Blocks)
    Copyright (C) 1989-2018  Silicon DSP Corporation 

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
 */

#endif
 
#ifdef SHORT_DESCRIPTION

Block collects a sample from  all its input samples to yield an output vector with the samples.

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>





#include "buffer_types.h"




/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int  __ibufs;
      int  __obufs;
      doubleVector_t*  __theVector_P;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define ibufs (state_P->__ibufs)
#define obufs (state_P->__obufs)
#define theVector_P (state_P->__theVector_P)
/*-------------- BLOCK CODE ---------------*/
 int  

buildvec 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int i,j,k;
	int samples;
	float sample_out;
	doubleVector_t* newVector_P;


switch (run_state) {


 /********* PARAMETER INITIALIZATION CODE ************/
case PARAM_INIT:

        {
        int indexModel88 = block_P->model_index;

        KrnModelParam(indexModel88,-1,"","","","");
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
		fprintf(stderr,"add: no input buffers\n");
		return(2);
	}
	if((obufs = NO_OUTPUT_BUFFERS()) < 1) {
		fprintf(stderr,"add: no output buffers\n");
		return(3);
	}
	
	
	for(k=0; k< obufs; k++)
	     SET_CELL_SIZE_OUT(k,sizeof(doubleVector_t));
	


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


	/* read one sample from each input buffer and add them */
	for(samples = MIN_AVAIL(); samples >0; --samples) {

		sample_out = 0;
        /*
         * allocate a  new vector (Note better to setup a subroutine but we want to show all).
         */
         newVector_P= (doubleVector_t*) calloc(1, sizeof(doubleVector_t));
	     if(newVector_P==NULL) {
	           fprintf(stderr,"buildvec could not allocate space.\n");
	           return(1);
	     }
     
	     newVector_P->length=ibufs;
	     newVector_P->vector_P=(double *) calloc(ibufs, sizeof(double));
	     if(newVector_P->vector_P==NULL) {
	           fprintf(stderr,"buildvec could not allocate space.\n");
	            return(1);
	     }



		for(i=0; i<ibufs; ++i) {
			IT_IN(i);
			newVector_P->vector_P[i]=(double)INF(i,0);
			
		}
		for(i=0; i<obufs; i++) {
			if(IT_OUT(i)) {
				fprintf(stderr,"buildvec: Buffer %d is full\n",i);
				return(1);
			}
			OUTVEC(i,0) = *newVector_P;
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
