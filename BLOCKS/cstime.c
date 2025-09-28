 
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

Function outputs the "time" to all connected output buffers.

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
      float  __time_elapse;
      int  __no_obuf;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define time_elapse (state_P->__time_elapse)
#define no_obuf (state_P->__no_obuf)

/*         
 *    PARAMETER DEFINES 
 */ 
#define time_scale (param_P[0]->value.f)
#define time_stop (param_P[1]->value.f)
/*-------------- BLOCK CODE ---------------*/
 int  

cstime 

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
     char   *pdef0 = "Time between samples";
     char   *ptype0 = "float";
     char   *pval0 = "1.0";
     char   *pname0 = "time_scale";
     char   *pdef1 = "Time before stopping";
     char   *ptype1 = "float";
     char   *pval1 = "-1.0";
     char   *pname1 = "time_stop";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);

      }
break;
   


/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            time_elapse=0.0;

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

	if((no_obuf = NO_OUTPUT_BUFFERS() ) <= 0) {
		fprintf(stderr,"time: no output buffers\n");
		return(1); /* no output buffers */
	}


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


	/* put out a maximum of NUMBER_SAMPLES_PER_VISIT samples */
	for(i=0; i < NUMBER_SAMPLES_PER_VISIT; ++i) {

		/* dont continue if time has exceeded time_stop  */
		if(time_stop >= 0.0 && time_elapse >= time_stop) return(0);
		for(j=0; j<no_obuf; j++) {
			if(IT_OUT(j)) {
				KrnOverflow("time",j);
				return(99);
			}
			OUTF(j,0) = time_elapse;
		}
		time_elapse += time_scale;
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
