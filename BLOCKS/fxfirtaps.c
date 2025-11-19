 
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

This block implements an  FIR based on taps stored in a file in fixed point arithmetic

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 

#include <math.h>
#include <stdio.h>


 




/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int*  __x_P;
      double*  __h_P;
      int  __N;
      int  __fxfactor;
      int*  __fxfactor1_P;
      int*  __fxfactor0_P;
      int*  __fxfactLessFlag_P;
      int*  __less_flag2_P;
      int  __maxv;
      int*  __overflow;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define x_P (state_P->__x_P)
#define h_P (state_P->__h_P)
#define N (state_P->__N)
#define fxfactor (state_P->__fxfactor)
#define fxfactor1_P (state_P->__fxfactor1_P)
#define fxfactor0_P (state_P->__fxfactor0_P)
#define fxfactLessFlag_P (state_P->__fxfactLessFlag_P)
#define less_flag2_P (state_P->__less_flag2_P)
#define maxv (state_P->__maxv)
#define overflow (state_P->__overflow)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define x(DELAY) (*((int  *)PIN(0,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define y(delay) *(int  *)POUT(0,delay)
#define error(delay) *(float  *)POUT(1,delay)

/*         
 *    PARAMETER DEFINES 
 */ 
#define fileName (param_P[0]->value.s)
#define qbits (param_P[1]->value.d)
#define size (param_P[2]->value.d)
#define roundoff_bits (param_P[3]->value.d)
#define accumSizeRound (param_P[4]->value.d)
#define saturation_mode (param_P[5]->value.d)
#define errorControl (param_P[6]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

fxfirtaps 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

   	int i;
   	int j;
	int val;
	int status;
	int numberTaps;
	int tmp1,tmp2;
        float sum;
	int	no_samples;
	FILE *imp_F;
	doublePrecInt	accumulate;
        int sum1, sum0;
	int out;
	double factor;
	int input1,input0;
	int less_flag2;
	int out1,out0;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "File with Taps (first line # of taps)";
     char   *ptype0 = "file";
     char   *pval0 = "tmp.tap";
     char   *pname0 = "fileName";
     char   *pdef1 = "Number of bits to represent fraction";
     char   *ptype1 = "int";
     char   *pval1 = "8";
     char   *pname1 = "qbits";
     char   *pdef2 = "Word length";
     char   *ptype2 = "int";
     char   *pval2 = "32";
     char   *pname2 = "size";
     char   *pdef3 = "Accumulator Roundoff bits";
     char   *ptype3 = "int";
     char   *pval3 = "8";
     char   *pname3 = "roundoff_bits";
     char   *pdef4 = "Accumulator Word length";
     char   *ptype4 = "int";
     char   *pval4 = "32";
     char   *pname4 = "accumSizeRound";
     char   *pdef5 = "saturation mode";
     char   *ptype5 = "int";
     char   *pval5 = "1";
     char   *pname5 = "saturation_mode";
     char   *pdef6 = "Error Out (1=error 0=floating point response)";
     char   *ptype6 = "int";
     char   *pval6 = "1";
     char   *pname6 = "errorControl";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);
KrnModelParam(indexModel88,3 ,pdef3,ptype3,pval3,pname3);
KrnModelParam(indexModel88,4 ,pdef4,ptype4,pval4,pname4);
KrnModelParam(indexModel88,5 ,pdef5,ptype5,pval5,pname5);
KrnModelParam(indexModel88,6 ,pdef6,ptype6,pval6,pname6);

      }
break;
   


/*         
 *    OUTPUT BUFFER SYSTEM  INITS 
 */ 
 case OUTPUT_BUFFER_INIT: 
 {
 int indexOC = block_P->model_index;
     char   *ptypeOut0 = "int";
     char   *pnameOut0 = "y";
     char   *ptypeOut1 = "float";
     char   *pnameOut1 = "error";
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
     


         
   if(NO_OUTPUT_BUFFERS() != 2 ){
       fprintf(stdout,"%s:2 outputs expected; %d connected\n",
              STAR_NAME,NO_OUTPUT_BUFFERS());
	      return(201);
   }

   SET_CELL_SIZE_OUT(0,sizeof(int));

   SET_CELL_SIZE_OUT(1,sizeof(float));

         
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

 


	/*
	 * open file containing impulse response samples. Check 
	 * to see if it exists.
	 *
	 */
        if( (imp_F = fopen(fileName,"r")) == NULL) {
		fprintf(stderr,"firtaps: file could not be opened.\n");
		return(4);
	}
	fscanf(imp_F,"%d",&numberTaps);
	/*
	 * Allocate memory and return pointers for tapped delay line x_P and
	 * array containing impulse response samples, h_P.
	 *
	 */
	if( (x_P = (int*)calloc(numberTaps,sizeof(int))) == NULL ||
	    (h_P = (double*)calloc(numberTaps,sizeof(double))) == NULL ) {
	   	fprintf(stderr,"fxfirtaps: can't allocate work space\n");
		return(4);
	}
	if( (fxfactor0_P = (int*)calloc(numberTaps,sizeof(int))) == NULL ||
	    (fxfactor1_P = (int*)calloc(numberTaps,sizeof(int))) == NULL ||
	    (fxfactLessFlag_P = (int*)calloc(numberTaps,sizeof(int))) == NULL) {
	   	fprintf(stderr,"fxfirtaps: can't allocate work space\n");
		return(5);
	}
	
	/*
	 * Read in the impulse response samples into the array
	 * and initialize the tapped delay line to zero.
	 *
	 */
	for (i=0; i<numberTaps; i++) {
		x_P[i]= 0.0;
		fscanf(imp_F,"%lf",&h_P[i]);
	}
	N=numberTaps;
	fclose(imp_F);
	
	if (size > 32) {
		fprintf(stderr,"fxfirtaps: size can not be greater than 32\n");	
                return(6);
		}
	if ((size & 1) == 1) {
		fprintf(stderr,"fxfirtaps: Sorry, size can not be an odd number\n");	
                return(7);
		}
		
	/*
	 * store fixed point tap coefficients (part1,part2,lessFlag)
	 */
        if (qbits > 30) {
	/* 
	 * Because 1<<31 becomes a negative number in this machine 
	 */
		fprintf(stderr,"fxfirtaps:At most 30 bits are allowed for fraction\n"); 
	        return(7);
       }
	/* 
	 * Calculate the maximum number to be represented by size bits 
	 */
        maxv=1;
        maxv <<= (size-1); 
	maxv -= 1;
	val=1; 
	val <<= qbits;	
        for (i=0; i<numberTaps; i++) {
              factor=h_P[i];	
              if (factor>0.0)
		   fxfactor = (int)(factor * val + 0.5);
              else
		   fxfactor = (int)(factor * val - 0.5);
              if (fxfactor > maxv || (-fxfactor) > maxv) {
        	    fprintf(stderr,"fxfirtaps: gain can not be represented by size bits\n");
        	    return(8);
              }
              Fx_Part(size,fxfactor,&fxfactor1_P[i],&fxfactor0_P[i],&fxfactLessFlag_P[i]);
	}


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 




	for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) {
		IT_IN(0);
		/*
		 * Shift input sample into tapped delay line
		 */
		tmp2=x(0);
		for(i=0; i<N; i++) {
			tmp1=x_P[i];
			x_P[i]=tmp2;
			tmp2=tmp1;
		}
		/*
		 * Compute double precision inner product 
		 */
                sum = 0.0;
		for (i=0; i<N; i++) { 
		     sum += ((double)x_P[i])*h_P[i];
		}
		
		sum1 = 0;
		sum0 = 0;

		for (i=0; i<N; i++) { 
                          Fx_Part(size,x_P[i],&input1,&input0,&less_flag2);
        
                          Fx_MultVar(fxfactLessFlag_P[i],less_flag2,size,fxfactor1_P[i],fxfactor0_P[i],
                                    input1,input0,&out1,&out0);

		
                          Fx_AddVar(size,saturation_mode,out1,out0,sum1,sum0,&sum1,&sum0); 
                         
				    
				    
		}
                Fx_RoundVar(size,accumSizeRound,roundoff_bits,sum1,sum0,&out);

		if(IT_OUT(0)) {
			KrnOverflow("fxfirfil",0);
			return(99);
		}
		/*
	  	 * set output buffer to response result
		 */
		y(0) = out;
		
		
		if(IT_OUT(1)) {
			KrnOverflow("fxfirfil",1);
			return(99);
		}
		/*
	  	 * set output buffer to response result
		 */
		error(0) = sum-(double)out*((double)errorControl);
	}


break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

	free(x_P); free(h_P); 
	free(fxfactor0_P);
	free(fxfactor1_P);
	free(fxfactLessFlag_P);


break;
}
return(0);
}
