 
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

This block converts a byte input vector to a digital stream.

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 

#include <math.h>
#include "bits.h"



/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int  __blockNumber;
      FILE*  __fp;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define blockNumber (state_P->__blockNumber)
#define fp (state_P->__fp)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define x(DELAY) (*((byteVector_t  *)PIN(0,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define y(delay) *(float  *)POUT(0,delay)
/*-------------- BLOCK CODE ---------------*/
 int  

vecbit 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int no_samples;
	int i,j,k,kk;
	long	templ;
	shortVector_t	vector;
	byteVector_t 	codedBlock;
	unsigned char byte;
	int	bitCount;
	int	bit;
	int	mask;
	short	*decode_P;


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
     char   *pnameOut0 = "y";
KrnModelConnectionOutput(indexOC,0 ,pnameOut0,ptypeOut0);
}
 break;

/*         
 *    INPUT BUFFER SYSTEM  INITS 
 */ 
 case INPUT_BUFFER_INIT:
 {
 int indexIC = block_P->model_index;
     char   *ptypeIn0 = "byteVector_t";
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
            blockNumber=0;



         
   if(NO_OUTPUT_BUFFERS() != 1 ){
       fprintf(stdout,"%s:1 outputs expected; %d connected\n",
              STAR_NAME,NO_OUTPUT_BUFFERS());
	      return(201);
   }

   SET_CELL_SIZE_OUT(0,sizeof(float));

         
   if(NO_INPUT_BUFFERS() != 1 ){
       fprintf(stdout,"%s:1 inputs expected; %d connected\n",
              STAR_NAME,NO_INPUT_BUFFERS());
	      return(200);
   }

   SET_CELL_SIZE_IN(0,sizeof(byteVector_t));

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

 

for (no_samples = MIN_AVAIL(); no_samples > 0; --no_samples) {
	/*
	 * collect the vector
	 */
	IT_IN(0);
	codedBlock=x(0);
	for(i=0; i<codedBlock.length; i++) {
	    byte=codedBlock.vector_P[i];
	    mask=1;
	    for(j=0; j<8; j++) {  
		bit = (byte & mask) ? 1:0;
		mask <<= 1;
        	/*
        	 * Output bits 
        	 */
           	if(IT_OUT(0) ){ KrnOverflow("vecbit",0); return(99); }
       	     	y(0) = bit;
	    }


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
