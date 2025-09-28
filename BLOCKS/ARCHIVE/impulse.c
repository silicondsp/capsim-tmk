 
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

This star sends out a unit sample, then a number of zero samples.

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
      int  __samples_out;
      int  __no_obuf;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define samples_out (state_P->__samples_out)
#define no_obuf (state_P->__no_obuf)

/*         
 *    PARAMETER DEFINES 
 */ 
#define length (param_P[0]->value.d)
/*-------------- BLOCK CODE ---------------*/


impulse 

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


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Enter number of samples";
     char   *ptype0 = "int";
     char   *pval0 = "128";
     char   *pname0 = "length";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);

      }
break;
   


/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            samples_out=0;

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

	if((no_obuf = NO_OUTPUT_BUFFERS() ) <= 0) {
		fprintf(stderr,"impulse: no outputs connected\n");
		return(1);
	}


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


	for (i=0; i<NUMBER_SAMPLES_PER_VISIT; i++) {
     
		if (samples_out++ >= length) return(0);

		for(j=0; j<no_obuf; j++) {
			if(IT_OUT(j)) {
				KrnOverflow("impulse",0);
				return(99);
			}

			if(samples_out > 1) OUTF(j,0) = 0.;
			else 	OUTF(j,0) = 1.;
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
