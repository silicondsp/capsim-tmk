 
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

Function adds all its input complex samples to yield a complex output sample

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
      int  __numInBuffers;
      int  __numOutBuffers;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define numInBuffers (state_P->__numInBuffers)
#define numOutBuffers (state_P->__numOutBuffers)
/*-------------- BLOCK CODE ---------------*/
 int  

cxadd 

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
	complex sampleOut,val;


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
	if((numInBuffers = NO_INPUT_BUFFERS()) < 1) {
		fprintf(stderr,"add: no input buffers\n");
		return(2);
	}
	if((numOutBuffers = NO_OUTPUT_BUFFERS()) < 1) {
		fprintf(stderr,"add: no output buffers\n");
		return(3);
	}
	for (i=0; i<numInBuffers; i++) 
		SET_CELL_SIZE_IN(i,sizeof(complex));
	for (i=0; i<numOutBuffers; i++) 
		SET_CELL_SIZE_OUT(i,sizeof(complex));


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


	/* read one sample from each input buffer and add them */
	for(samples = MIN_AVAIL(); samples >0; --samples) {

		sampleOut.re = 0;
		sampleOut.im = 0;

		for(i=0; i<numInBuffers; ++i) {
			IT_IN(i);
			val = INCX(i,0);
			sampleOut.re += val.re;
			sampleOut.im += val.im;
		}
		for(i=0; i<numOutBuffers; i++) {
			if(IT_OUT(i)) {
				KrnOverflow("cxadd",i);
				return(99);
			}
			OUTCX(i,0) = sampleOut;
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
