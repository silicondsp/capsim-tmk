 
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

This block simulates an Ethernet cable.

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>


 

#define DC_INIT 0.0


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int  __first;
      int  __term;
      float  __dc;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define first (state_P->__first)
#define term (state_P->__term)
#define dc (state_P->__dc)

/*         
 *    PARAMETER DEFINES 
 */ 
#define samplesDelay (param_P[0]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

ethline 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int	i;
	int	numberSamples;
	int	numberInputBuffers;
	int	numberOutputBuffers;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "The delay of the line in samples";
     char   *ptype0 = "int";
     char   *pval0 = "0";
     char   *pname0 = "samplesDelay";
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

 

	if (!((samplesDelay >= 0) && (samplesDelay < 100))) {
		fprintf(stderr,"line: parameter out of range");
		return(1);
	}
	numberInputBuffers=NO_INPUT_BUFFERS();
	numberOutputBuffers=NO_OUTPUT_BUFFERS();
	if(numberInputBuffers <1 ) {
		fprintf(stderr,"line: Too few inputs");
		return(2);
	}
	if(numberInputBuffers  > 2 ) {
		fprintf(stderr,"line: Too many  inputs");
		return(3);
	}
	if(numberOutputBuffers   < 1 ) {
		fprintf(stderr,"line: Too few outputs");
		return(4);
	}
	if(numberOutputBuffers   > 2 ) {
		fprintf(stderr,"line: Too many outputs");
		return(5);
	}
	if(numberOutputBuffers    != numberInputBuffers ) {
		fprintf(stderr,"line: mismatched inputs and outputs ");
		return(6);
	}
	if(numberInputBuffers == 1)
		term=1;
	else
		term=0;
fprintf(stderr,"Term = %d \n",term);
	first=1;
	dc = DC_INIT;


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 

if(first) {
	first=0;
	i=0;
	while ( i< samplesDelay) {
		if(term) {
			if(IT_OUT(0)) {
				KrnOverflow("ethline",0);
				return(99);
			}
			OUTF(0,0) = 0.0;
		} else {
			if(IT_OUT(0)) {
				KrnOverflow("ethline",0);
				return(99);
			}
			if(IT_OUT(1)) {
				KrnOverflow("ethline",1);
				return(99);
			}
			OUTF(0,0)=0.0;
			OUTF(1,0) = 0.0;
		}
		++i;
	}
}

for(numberSamples = MIN_AVAIL(); numberSamples > 0; -- numberSamples) {
	if(term) {
		IT_IN(0);
		if(IT_OUT(0)) {
				KrnOverflow("ethline",0);
				return(99);
		}
		OUTF(0,0) =dc;
	}
	else {
		IT_IN(0);
		IT_IN(1);
		if(IT_OUT(0)) {
				KrnOverflow("ethline",0);
				return(99);
		}
		if(IT_OUT(1)) {
				KrnOverflow("ethline",1);
				return(99);
		}

		OUTF(0,0)= INF(1,0);
		OUTF(1,0)= INF(0,0);
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
