 
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

This block selects one of two input data channels to output.

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
      int  __inbufs;
      int  __outbufs;
      int  __timer;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define inbufs (state_P->__inbufs)
#define outbufs (state_P->__outbufs)
#define timer (state_P->__timer)

/*         
 *    PARAMETER DEFINES 
 */ 
#define switch_time (param_P[0]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

toggle 

(int run_state,block_Pt block_P)

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
     char   *pdef0 = "Time in samples to switch to channel 1 from 0";
     char   *ptype0 = "int";
     char   *pval0 = "0";
     char   *pname0 = "switch_time";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);

      }
break;
   


/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            timer=switch_time;

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

	if((inbufs = NO_INPUT_BUFFERS()) != 2
		|| (outbufs = NO_OUTPUT_BUFFERS()) < 1) {
		fprintf(stderr,"mux: i/o buffers connect problem\n");
		return(1);
	}


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


	for(i=0; i<MIN_AVAIL(); i++) {
		for(j=0; j<inbufs; j++)
			IT_IN(j);
		if(timer > 0) {
			--timer;
			for(j=0; j<outbufs; j++) {
				if(IT_OUT(j)) {
					KrnOverflow("toggle",j);
					return(99);
				}
				OUTF(j,0) = INF(0,0);
			}
		}
		else {
			for(j=0; j<outbufs; j++) {
				if(IT_OUT(j) ) {
					KrnOverflow("toggle",j);
					return(99);
				}
				OUTF(j,0) = INF(1,0);
			}
		}
	}


break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 



break;
}
return(0);
}
