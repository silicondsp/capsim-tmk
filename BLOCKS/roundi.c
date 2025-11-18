 
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

This block multiplies the incoming data stream by the parameter "Gain factor" in fixed-point arithmetic.Theblock is capable of doing extended precision arithmetic upto 64 bits result which is to be rounded to at least 32 bits after the fxadd.s block.

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
      int  __numberOutputBuffers;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define numberOutputBuffers (state_P->__numberOutputBuffers)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define x(DELAY) (*((float  *)PIN(0,DELAY)))
/*-------------- BLOCK CODE ---------------*/
 int  

roundi 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int i, samples, val;
        float input;
        int out1, out0;
	int	sampleOut;


switch (run_state) {


 /********* PARAMETER INITIALIZATION CODE ************/
case PARAM_INIT:

        {
        int indexModel88 = block_P->model_index;

        KrnModelParam(indexModel88,-1,"","","","");
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

 

	if ((numberOutputBuffers = NO_OUTPUT_BUFFERS()) <= 0) {
		fprintf(stdout,"roundi: no output buffers\n");
		return(2);
		}
	for(i=0; i<numberOutputBuffers; i++) 
		SET_CELL_SIZE_OUT(i,sizeof(int));


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


for(samples = MIN_AVAIL(); samples >0; --samples) {

	IT_IN(0);
        input = x(0);

	
        for (i=0; i<numberOutputBuffers; i++) {
		if(IT_OUT(i)) {
			KrnOverflow("fxgain",i);
			return(99);
		}
		if(input <0) sampleOut=(int)(input -0.5);
                else
                          sampleOut=(int)(input+0.5);
                OUTI(i,0) = sampleOut;

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
