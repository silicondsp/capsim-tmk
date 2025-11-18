 
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

This block converts a bit stream to variable length vectors.

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
      UINT8  __byteval;
      int  __bitCount;
      int  __byteCount;
      UINT8*  __vect_P;
      int  __markerFlag;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define byteval (state_P->__byteval)
#define bitCount (state_P->__bitCount)
#define byteCount (state_P->__byteCount)
#define vect_P (state_P->__vect_P)
#define markerFlag (state_P->__markerFlag)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define y(DELAY) (*((float  *)PIN(0,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define x(delay) *(byteVector_t  *)POUT(0,delay)
/*-------------- BLOCK CODE ---------------*/
 int  

bitvec 

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
	byteVector_t 	codedBlock;
	int	bit;
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
     char   *ptypeOut0 = "byteVector_t";
     char   *pnameOut0 = "x";
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
     char   *pnameIn0 = "y";
KrnModelConnectionInput(indexIC,0 ,pnameIn0,ptypeIn0);
}
 break;

/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            byteval=0;
       bitCount=0;
       byteCount=0;
       markerFlag=0;



         
   if(NO_OUTPUT_BUFFERS() != 1 ){
       fprintf(stdout,"%s:1 outputs expected; %d connected\n",
              STAR_NAME,NO_OUTPUT_BUFFERS());
	      return(201);
   }

   SET_CELL_SIZE_OUT(0,sizeof(byteVector_t));

         
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

 



break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 

for (no_samples = MIN_AVAIL(); no_samples > 0; --no_samples) {
	/*
	 * collect the bits 
	 */
	IT_IN(0);
	bit=(int)(y(0)+0.001);
	byteval |= (bit << bitCount); 
	bitCount += 1;
	if(bitCount == 8) {
		if(vect_P==NULL) {
			vect_P=(unsigned char*)malloc(16*sizeof(char));
			if(vect_P == NULL) {
			   fprintf(stderr,"bitvec: could not allocate space\n");
			   return(2);
 			}
		}
		vect_P[byteCount]=byteval;
		byteCount++;
		if(!(byteCount % 16)) {
			/*
			 * time to reallocate vect_P in 16 byte chunks
			 */
			vect_P=(unsigned char*)realloc((char*)vect_P,
					sizeof(char)*(byteCount+16));
			if(vect_P == NULL) {
			   fprintf(stderr,"bitvec: could not allocate space\n");
			   return(3);
 			}

		}
		if(markerFlag) {
		   if(byteval) {
			/*
			 * found marker
			 * package vector and length and output
			 */
			codedBlock.length=byteCount;
			codedBlock.vector_P=vect_P;
           		if(IT_OUT(0) ){ KrnOverflow("bitvec",0); return(99); }
       	     		x(0) = codedBlock;
			/*
			 * set vect_P to NULL so that it will be allocated 
			 * for next segment
			 */
			vect_P=NULL;
			/*
			 * reset all others
			 */
			byteCount=0;
			markerFlag=0;
	

		   } else {
			/*
			 * 0xFF followed by a zero. Treat as regular data
			 * so reset markerFlag
			 */
			markerFlag=0;

		   }
		}
		if(byteval == 0xff) {
			markerFlag=1;
		} 
		byteval=0;
		bitCount=0;

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
