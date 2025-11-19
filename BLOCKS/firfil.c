 
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

This block designs FIR low pass, high pass, band pass, and band stop  filters using the windowing method.

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
#include "dsp.h"


 




/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      float*  __x_P;
      float*  __h_P;
      int  __N;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define x_P (state_P->__x_P)
#define h_P (state_P->__h_P)
#define N (state_P->__N)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define x(DELAY) (*((float  *)PIN(0,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define y(delay) *(float  *)POUT(0,delay)

/*         
 *    PARAMETER DEFINES 
 */ 
#define filterType (param_P[0]->value.d)
#define windType (param_P[1]->value.d)
#define ntap (param_P[2]->value.d)
#define fc (param_P[3]->value.f)
#define fl (param_P[4]->value.f)
#define fh (param_P[5]->value.f)
#define alpha (param_P[6]->value.f)
#define dbripple (param_P[7]->value.f)
#define twidth (param_P[8]->value.f)
#define att (param_P[9]->value.f)
/*-------------- BLOCK CODE ---------------*/
 int  

firfil 

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
	int status;
	int numberTaps;
	float tmp1,tmp2;
        float sum;
	int	no_samples;
	FILE *imp_F;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Filter Type:1=LowPass,2=HighPass,3=BandPass,4=BandStop";
     char   *ptype0 = "int";
     char   *pval0 = "1";
     char   *pname0 = "filterType";
     char   *pdef1 = "Window Type:1=Rect,2=Tri,3=Hamm,4=GenHamm,5=Hann,6=Kaiser,7=Cheb,8=Parz";
     char   *ptype1 = "int";
     char   *pval1 = "3";
     char   *pname1 = "windType";
     char   *pdef2 = "Number of Taps";
     char   *ptype2 = "int";
     char   *pval2 = "128";
     char   *pname2 = "ntap";
     char   *pdef3 = "Cut Off Freq. (LowPass/HighPass Only)";
     char   *ptype3 = "float";
     char   *pval3 = "0.25";
     char   *pname3 = "fc";
     char   *pdef4 = "Lower cutoff freq. 0<=fl<=0.5";
     char   *ptype4 = "float";
     char   *pval4 = "0.25";
     char   *pname4 = "fl";
     char   *pdef5 = "Upper cutoff freq. 0<=fh<=0.5";
     char   *ptype5 = "float";
     char   *pval5 = "0.4";
     char   *pname5 = "fh";
     char   *pdef6 = "Alpha parameter for generalized Hamming window <=1.0";
     char   *ptype6 = "float";
     char   *pval6 = "0.5";
     char   *pname6 = "alpha";
     char   *pdef7 = "Ripple, dB for Chebyshev Window";
     char   *ptype7 = "float";
     char   *pval7 = "0.5";
     char   *pname7 = "dbripple";
     char   *pdef8 = "Transition Width Chebyshev Window";
     char   *ptype8 = "float";
     char   *pval8 = "0.1";
     char   *pname8 = "twidth";
     char   *pdef9 = "Attenuation for Kaiser Window";
     char   *ptype9 = "float";
     char   *pval9 = "30.0";
     char   *pname9 = "att";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);
KrnModelParam(indexModel88,3 ,pdef3,ptype3,pval3,pname3);
KrnModelParam(indexModel88,4 ,pdef4,ptype4,pval4,pname4);
KrnModelParam(indexModel88,5 ,pdef5,ptype5,pval5,pname5);
KrnModelParam(indexModel88,6 ,pdef6,ptype6,pval6,pname6);
KrnModelParam(indexModel88,7 ,pdef7,ptype7,pval7,pname7);
KrnModelParam(indexModel88,8 ,pdef8,ptype8,pval8,pname8);
KrnModelParam(indexModel88,9 ,pdef9,ptype9,pval9,pname9);

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

   SET_CELL_SIZE_IN(0,sizeof(float));

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

	status=FIRDesign(fc,fl,fh,alpha,dbripple,twidth,att,
				ntap,windType,filterType,"tmp");
	if(status) {
		fprintf(stderr,"firfil: Error in FIR design.\n");
		return(4);
	}
	/*
	 * open file containing impulse response samples. Check 
	 * to see if it exists.
	 *
	 */
        if( (imp_F = fopen("tmp.tap","r")) == NULL) {
		fprintf(stderr,"firfil:tmp.tap file could not be opened.\n");
		return(4);
	}
	fscanf(imp_F,"%d",&numberTaps);
	/*
	 * Allocate memory and return pointers for tapped delay line x_P and
	 * array containing impulse response samples, h_P.
	 *
	 */
	if( (x_P = (float*)calloc(numberTaps,sizeof(float))) == NULL ||
	    (h_P = (float*)calloc(numberTaps,sizeof(float))) == NULL ) {
	   	fprintf(stderr,"firfil: can't allocate work space\n");
		return(4);
	}
	/*
	 * Read in the impulse response samples into the array
	 * and initialize the tapped delay line to zero.
	 *
	 */
	for (i=0; i<numberTaps; i++) {
		x_P[i]= 0.0;
		fscanf(imp_F,"%f",&h_P[i]);
	}
	N=numberTaps;


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
		 * Compute inner product 
		 */
                sum = 0.0;
		for (i=0; i<N; i++) { 
		     sum += x_P[i]*h_P[i];
		}
		if(IT_OUT(0)) {
			KrnOverflow("firfil",0);
			return(99);
		}
		/*
	  	 * set output buffer to response result
		 */
		y(0) = sum;
	}


break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

	free(x_P); free(h_P); 


break;
}
return(0);
}
