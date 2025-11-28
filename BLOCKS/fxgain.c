 
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

This star multiplies the incoming data stream by the parameter "Gain factor" in fixed-point arithmetic.

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
      int  __fxfactor;
      int  __fxfactor1;
      int  __fxfactor0;
      int  __less_flag1;
      int  __less_flag2;
      int  __max;
      int*  __overflow;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define numberOutputBuffers (state_P->__numberOutputBuffers)
#define fxfactor (state_P->__fxfactor)
#define fxfactor1 (state_P->__fxfactor1)
#define fxfactor0 (state_P->__fxfactor0)
#define less_flag1 (state_P->__less_flag1)
#define less_flag2 (state_P->__less_flag2)
#define max (state_P->__max)
#define overflow (state_P->__overflow)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define x(DELAY) (*((int  *)PIN(0,DELAY)))

/*         
 *    PARAMETER DEFINES 
 */ 
#define factor (param_P[0]->value.f)
#define qbits (param_P[1]->value.d)
#define size (param_P[2]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

fxgain 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int i, samples, val;
        int input, input1, input0;
        int out1, out0;
	doublePrecInt	sampleOut;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Gain factor";
     char   *ptype0 = "float";
     char   *pval0 = "1.0";
     char   *pname0 = "factor";
     char   *pdef1 = "Number of bits to represent fraction";
     char   *ptype1 = "int";
     char   *pval1 = "8";
     char   *pname1 = "qbits";
     char   *pdef2 = "Word length";
     char   *ptype2 = "int";
     char   *pval2 = "32";
     char   *pname2 = "size";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);

      }
break;
   


/*         
 *    INPUT BUFFER SYSTEM  INITS 
 */ 
 case INPUT_BUFFER_INIT:
 {
 int indexIC = block_P->model_index;
     char   *ptypeIn0 = "int";
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

   SET_CELL_SIZE_IN(0,sizeof(int));

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

	if ((numberOutputBuffers = NO_OUTPUT_BUFFERS()) <= 0) {
		fprintf(stderr,"gain: no output buffers\n");
		return(2);
		}
	overflow = (int*)calloc(1,sizeof(int)); /* what is this ! */
	if (size > 32) {
		fprintf(stderr,"size can not be greater than 32\n");	
                return(4);
		}
	if ((size & 1) == 1) {
		fprintf(stderr,"Sorry, size can not be an odd number\n");	
                return(4);
		}
        if (qbits > 30) {
	/* 
	 * Because 1<<31 becomes a negative number in this machine 
	 */
		fprintf(stderr,"At most 30 bits are allowed for fraction\n"); 
	        return(4);
        	}
	/* 
	 * Calculate the maximum number to be represented by size bits 
	 */
        max=1;
        max <<= (size-1); 
	max -= 1;
	val=1; 
	val <<= qbits;
        if (factor>0.0)
		fxfactor = (int)(factor * val + 0.5);
        else
		fxfactor = (int)(factor * val - 0.5);
        if (fxfactor > max || (-fxfactor) > max) {
        	fprintf(stderr,"gain can not be represented by size bits\n");
        	return(4);
        	}
        Fx_Part(size,fxfactor,&fxfactor1,&fxfactor0,&less_flag1);
	for(i=0; i<numberOutputBuffers; i++) 
		SET_CELL_SIZE_OUT(i,sizeof(doublePrecInt));


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


for(samples = MIN_AVAIL(); samples >0; --samples) {

	IT_IN(0);
        input = x(0);

        if (input > max || (-input) > max) {
        	fprintf(stderr,"input cannot be represented by size bits\n");
       	}
       
        Fx_Part(size,input,&input1,&input0,&less_flag2);
        
        Fx_MultVar(less_flag1,less_flag2,size,fxfactor1,fxfactor0,
                                    input1,input0,&out1,&out0);
	
        for (i=0; i<numberOutputBuffers; i++) {
		   if(IT_OUT(i)) {
			   KrnOverflow("fxgain",i);
			   return(99);
		   }
		   sampleOut.lowWord=out0;
		   sampleOut.highWord=out1;
                OUTDI(i,0) = sampleOut;

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
