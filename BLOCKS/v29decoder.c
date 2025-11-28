 
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

This star inputs inPhase and quadPhase of the CCITT v.29 coordinates and decodes the input into binary data.

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
      int  __intVal0;
      int  __intVal1;
      int  __bit;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define intVal0 (state_P->__intVal0)
#define intVal1 (state_P->__intVal1)
#define bit (state_P->__bit)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define inPhase(DELAY) (*((float  *)PIN(0,DELAY)))
#define quadPhase(DELAY) (*((float  *)PIN(1,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define data(delay) *(float  *)POUT(0,delay)
/*-------------- BLOCK CODE ---------------*/
 int  

v29decoder 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int	n,i;
	float   tmp1, tmp0;


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
     char   *pnameOut0 = "data";
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
     char   *pnameIn0 = "inPhase";
     char   *ptypeIn1 = "float";
     char   *pnameIn1 = "quadPhase";
KrnModelConnectionInput(indexIC,0 ,pnameIn0,ptypeIn0);
KrnModelConnectionInput(indexIC,1 ,pnameIn1,ptypeIn1);
}
 break;

/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
     


         
   if(NO_OUTPUT_BUFFERS() != 1 ){
       fprintf(stdout,"%s:1 outputs expected; %d connected\n",
              STAR_NAME,NO_OUTPUT_BUFFERS());
	      return(201);
   }

   SET_CELL_SIZE_OUT(0,sizeof(float));

         
   if(NO_INPUT_BUFFERS() != 2 ){
       fprintf(stdout,"%s:2 inputs expected; %d connected\n",
              STAR_NAME,NO_INPUT_BUFFERS());
	      return(200);
   }

   SET_CELL_SIZE_IN(0,sizeof(float));

   SET_CELL_SIZE_IN(1,sizeof(float));

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 



break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 

	while(MIN_AVAIL()) {
		
		IT_IN(0);
		tmp0 = inPhase(0);
		IT_IN(1);
		tmp1 = quadPhase(0);
/*
 * Calculating the integer value of the inputs
 */
		if(tmp0 < 0.00001)
			intVal0 = (int)(tmp0 - 0.5);
		else
			intVal0 = (int)(tmp0 + 0.5);
			
		if(tmp1 < 0.00001)
			intVal1 = (int)(tmp1 - 0.5);
		else
			intVal1 = (int)(tmp1 + 0.5);
/*
 * Mapping the coordinates into the decimal value of the decoded inputs
 */
		if(intVal0 == 1 && intVal1 == 1)
			n = 0;
		else if(intVal0 == 3 && intVal1 == 0)
			n = 8;
		else if(intVal0 == 0 && intVal1 == 3)
			n = 4;
		else if(intVal0 == -1 && intVal1 == 1)
			n = 12;
		else if(intVal0 == 0 && intVal1 == -3)
			n = 2;
		else if(intVal0 == 1 && intVal1 == -1)
			n = 10;
		else if(intVal0 == -1 && intVal1 == -1)
			n = 6;
		else if(intVal0 == -3 && intVal1 == 0)
			n = 14;
		else if(intVal0 == 3 && intVal1 == 3)
			n = 1;
		else if(intVal0 == 5 && intVal1 == 0)
			n = 9;
		else if(intVal0 == 0 && intVal1 == 5)
			n = 5;
		else if(intVal0 == -3 && intVal1 == 3)
			n = 13;
		else if(intVal0 == 0 && intVal1 == -5)
			n = 3;
		else if(intVal0 == 3 && intVal1 == -3)
			n = 11;
		else if(intVal0 == -3 && intVal1 == -3)
			n = 7;
		else if(intVal0 == -5 && intVal1 == 0)
			n = 15;
/*
 * Calculating the binary representation of the decimal value
 */
		for(i=0; i<4; i++){
			if(n % 2)
				bit = 1;
			else
				bit = 0;
			n = n >> 1;
  			if(IT_OUT(0) ) {
				KrnOverflow("v29decoder",0);
				return(99);
			}
			data(0) = bit;	
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
