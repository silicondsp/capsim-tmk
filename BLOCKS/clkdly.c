 
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

Function delays its input samples by any number of samples

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
      int  __obufs;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define obufs (state_P->__obufs)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define x(DELAY) (*((float  *)PIN(0,DELAY)))

/*         
 *    PARAMETER DEFINES 
 */ 
#define samples_delay (param_P[0]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

clkdly 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

        int i,count;
	int no_samples;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Enter number of samples to delay";
     char   *ptype0 = "int";
     char   *pval0 = "1";
     char   *pname0 = "samples_delay";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);

      }
break;
   


/*         
 *    INPUT BUFFER SYSTEM  INITS 
 */ 
 case INPUT_BUFFER_INIT:
 {
 int indexIC = block_P->model_index;
     char   *ptypeIn0 = "float";
     char   *pnameIn0 = "x";
KrnModelConnectionInput(indexIC,0 ,pnameIn0,ptypeIn0);
}
 break;

/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
     
  delay_max((buffer_Pt)star_P->inBuffer_P[0],samples_delay + 1);
  delay_min((buffer_Pt)star_P->inBuffer_P[0],samples_delay);

         
   if(NO_INPUT_BUFFERS() != 1 ){
       fprintf(stdout,"%s:1 inputs expected; %d connected\n",
              STAR_NAME,NO_INPUT_BUFFERS());
	      return(200);
   }

   SET_CELL_SIZE_IN(0,sizeof(float));

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

	if( (obufs = NO_OUTPUT_BUFFERS()) < 1 ) {
		fprintf(stderr,"clkdly: no output buffers\n");
		return(1);
	}


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


	for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) {
		IT_IN(0);
		for(i=0; i<obufs; i++) {
                	if(IT_OUT(i)) {
				KrnOverflow("clkdly",i);
				return(99);
			}
			if(count < (samples_delay - 1)) {
			   OUTF(i,0) = 1;
			   count = count + 1;
			}
			else
			   OUTF(i,0) = x(samples_delay);
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
