 
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

This star inputs data and ouputs the coordinates of the CCITT v.29 encoder constlations. 

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
      float  __array_A[4];
      int  __numberBits;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define array_A (state_P->__array_A)
#define numberBits (state_P->__numberBits)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define data(DELAY) (*((float  *)PIN(0,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define inPhase(delay) *(float  *)POUT(0,delay)
#define quadPhase(delay) *(float  *)POUT(1,delay)
/*-------------- BLOCK CODE ---------------*/
 int  

v29encoder 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int	i,k,j;
	static float a_A[16] = {1,3,0,-1,0,1,-1,-3,3,5,0,-3,0,3,-3,-5};
	static float b_A[16] = {1,0,3,1,-3,-1,-1,0,3,0,5,3,-5,-3,-3,0};


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
     char   *pnameOut0 = "inPhase";
     char   *ptypeOut1 = "float";
     char   *pnameOut1 = "quadPhase";
KrnModelConnectionOutput(indexOC,0 ,pnameOut0,ptypeOut0);
KrnModelConnectionOutput(indexOC,1 ,pnameOut1,ptypeOut1);
}
 break;

/*         
 *    INPUT BUFFER SYSTEM  INITS 
 */ 
 case INPUT_BUFFER_INIT:
 {
 int indexIC = block_P->model_index;
     char   *ptypeIn0 = "float";
     char   *pnameIn0 = "data";
KrnModelConnectionInput(indexIC,0 ,pnameIn0,ptypeIn0);
}
 break;

/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            numberBits=0;



         
   if(NO_OUTPUT_BUFFERS() != 2 ){
       fprintf(stdout,"%s:2 outputs expected; %d connected\n",
              STAR_NAME,NO_OUTPUT_BUFFERS());
	      return(201);
   }

   SET_CELL_SIZE_OUT(0,sizeof(float));

   SET_CELL_SIZE_OUT(1,sizeof(float));

         
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

 

	for(i=0; i<4; i++) 
		array_A[i]=0;
	numberBits =0;


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 

	while(IT_IN(0)) {

		for(k=0; k<3; k++){
			j=3-k;
			array_A[j] = array_A[j-1];
		}
		array_A[0] = data(0);
			
		numberBits++;
		if(numberBits == 4){	
			numberBits=0;

			array_A[1] = array_A[1]*2;
			array_A[2] = array_A[2]*4;
			array_A[3] = array_A[3]*8;
 	
			i = 0;
			for (k=0; k<4;k++)
				i += array_A[k];	

  			if(IT_OUT(0)) {
				KrnOverflow("v29encoder",0) ;
				return(99);
			}
			
  			if(IT_OUT(1) ) {
				KrnOverflow("v29encoder",0) ;
				return(99);
			}
  			inPhase(0) = a_A[i];
  			quadPhase(0) = b_A[i];
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
