 
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

This block correlates the input samples with the sequence given in a file.

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


 

#define PI 3.1415926


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      complex*  __x_P;
      complex*  __h_P;
      int  __Ndiv2;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define x_P (state_P->__x_P)
#define h_P (state_P->__h_P)
#define Ndiv2 (state_P->__Ndiv2)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define x(DELAY) (*((complex  *)PIN(0,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define y(delay) *(complex  *)POUT(0,delay)

/*         
 *    PARAMETER DEFINES 
 */ 
#define filename (param_P[0]->value.s)
#define N (param_P[1]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

cxcorr 

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
	complex tmp1,tmp2;
        complex  sum;
        complex tmp;
	FILE *fopen();
	FILE *imp_F;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "File name containing sequence to correlate";
     char   *ptype0 = "file";
     char   *pval0 = "";
     char   *pname0 = "filename";
     char   *pdef1 = "Number of samples in sequence";
     char   *ptype1 = "int";
     char   *pval1 = "";
     char   *pname1 = "N";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);

      }
break;
   


/*         
 *    OUTPUT BUFFER SYSTEM  INITS 
 */ 
 case OUTPUT_BUFFER_INIT: 
 {
 int indexOC = block_P->model_index;
     char   *ptypeOut0 = "complex";
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
     char   *ptypeIn0 = "complex";
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

   SET_CELL_SIZE_OUT(0,sizeof(complex));

         
   if(NO_INPUT_BUFFERS() != 1 ){
       fprintf(stdout,"%s:1 inputs expected; %d connected\n",
              STAR_NAME,NO_INPUT_BUFFERS());
	      return(200);
   }

   SET_CELL_SIZE_IN(0,sizeof(complex));

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

        Ndiv2=N/2;
	/*
	 * Allocate memory and return pointers for tapped delay line x_P and
	 * array containing impulse response samples, h_P.
	 *
	 */
	if( (x_P = (complex*)calloc(N,sizeof(complex))) == NULL ||
	    (h_P = (complex*)calloc(N,sizeof(complex))) == NULL ) {
	   	fprintf(stderr,"cxcorr: can't allocate work space\n");
		return(4);
	}
	/*
	 * open file containing impulse response samples. Check
	 * to see if it exists.
	 *
	 */
        if( (imp_F = fopen(filename,"r")) == NULL) {
		fprintf(stderr,"cxcorr could not be opened file was %s \n",
				filename);
		return(4);
	}
	/*
	 * Read in the impulse response samples into the array
	 * and initialize the tapped delay line to zero.
	 *
	 */
	for (i=0; i<N; i++) {
		x_P[i].re= 0.0;   x_P[i].im= 0.0;
		fscanf(imp_F,"%f %f",&h_P[i].re, &h_P[i].im);
	}
        /*
         * Time reverse
         */
        for(i=0; i<Ndiv2; i++) {
            tmp=h_P[i];
            h_P[i]=h_P[N-i-1];
            h_P[N-i-1]=tmp;
        }
		SET_CELL_SIZE_IN(0,sizeof(complex));
		SET_CELL_SIZE_OUT(0,sizeof(complex));


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 




	while(IT_IN(0)){
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
                sum.re = 0.0; sum.im=0.0;
		for (i=0; i<N; i++) {

                     sum.re += x_P[i].re*h_P[i].re+x_P[i].im*h_P[i].im;
                     sum.im += x_P[i].im*h_P[i].re-x_P[i].re*h_P[i].im;
#if 0
                     sum.re += x_P[i].re*h_P[i].re;
                     sum.im += x_P[i].im*h_P[i].im;
#endif

		}
		if(IT_OUT(0)) {
			KrnOverflow("cxcorr",0);
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
