 
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

This star implements an integrator  that charges and discharges by control

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
      float  __y;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define y (state_P->__y)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define in(DELAY) (*((float  *)PIN(0,DELAY)))
#define int_hold(DELAY) (*((float  *)PIN(1,DELAY)))
#define dump(DELAY) (*((float  *)PIN(2,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define out(delay) *(float  *)POUT(0,delay)
/*-------------- BLOCK CODE ---------------*/
 int  

intcntrl 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int samples;


switch (run_state) {


 /********* PARAMETER INITIALIZATION CODE ************/
case PARAM_INIT:

        {
        int indexModel88 = block_P->model_index;

        KrnModelParam(indexModel88,-1,"","","","");
        }

break;
   
          
 
/*         
 *    OUTPUT BUFFER SYSTEM  INITS 
 */ 
 case OUTPUT_BUFFER_INIT: 
 {
 int indexOC = block_P->model_index;
     char   *ptypeOut0 = "float";
     char   *pnameOut0 = "out";
KrnModelConnectionOutput(indexOC,0 ,pnameOut0,ptypeOut0);
}
 break;

/*         
 *    INPUT BUFFER SYSTEM  INITS 
 */ 
 case INPUT_BUFFER_INIT:
 {
 int indexIC = block_P->model_index;
     char   *ptypeIn0 = "float";
     char   *pnameIn0 = "in";
     char   *ptypeIn1 = "float";
     char   *pnameIn1 = "int_hold";
     char   *ptypeIn2 = "float";
     char   *pnameIn2 = "dump";
KrnModelConnectionInput(indexIC,0 ,pnameIn0,ptypeIn0);
KrnModelConnectionInput(indexIC,1 ,pnameIn1,ptypeIn1);
KrnModelConnectionInput(indexIC,2 ,pnameIn2,ptypeIn2);
}
 break;

/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
     

  delay_max((buffer_Pt)star_P->inBuffer_P[0],2);
  delay_max((buffer_Pt)star_P->inBuffer_P[1],2);
  delay_max((buffer_Pt)star_P->inBuffer_P[2],2);

         
   if(NO_OUTPUT_BUFFERS() != 1 ){
       fprintf(stdout,"%s:1 outputs expected; %d connected\n",
              STAR_NAME,NO_OUTPUT_BUFFERS());
	      return(201);
   }

   SET_CELL_SIZE_OUT(0,sizeof(float));

         
   if(NO_INPUT_BUFFERS() != 3 ){
       fprintf(stdout,"%s:3 inputs expected; %d connected\n",
              STAR_NAME,NO_INPUT_BUFFERS());
	      return(200);
   }

   SET_CELL_SIZE_IN(0,sizeof(float));

   SET_CELL_SIZE_IN(1,sizeof(float));

   SET_CELL_SIZE_IN(2,sizeof(float));

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

	y = 0;


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 

	for(samples = MIN_AVAIL(); samples > 0; --samples)
	{
		IT_IN(0);
		IT_IN(1);
		IT_IN(2);
		if(int_hold(0) == 1.0)
		{
			y += in(0);
		}
		if(dump(0) == 1.0 && dump(1) == 0.0)
		{
			y=0;
		}
		if(IT_OUT(0)) {
			KrnOverflow("intctrl",0);
			return(99);
		}
		out(0) = y;
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
