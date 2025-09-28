 
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

This star implements a simple LMS adaptive filter.

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
      float*  __x_P;
      float*  __w_P;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define x_P (state_P->__x_P)
#define w_P (state_P->__w_P)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define x(DELAY) (*((float  *)PIN(0,DELAY)))
#define z(DELAY) (*((float  *)PIN(1,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define y(delay) *(float  *)POUT(0,delay)

/*         
 *    PARAMETER DEFINES 
 */ 
#define N (param_P[0]->value.d)
#define mu (param_P[1]->value.f)
#define outputFlag (param_P[2]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

lms 

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
	float tmp1,tmp2;
        float dhat;
        float temp;
        float error;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Filter order";
     char   *ptype0 = "int";
     char   *pval0 = "10";
     char   *pname0 = "N";
     char   *pdef1 = "LMS gain constant";
     char   *ptype1 = "float";
     char   *pval1 = "0.1";
     char   *pname1 = "mu";
     char   *pdef2 = "Flag: 0=estimate, 1=error";
     char   *ptype2 = "int";
     char   *pval2 = "0";
     char   *pname2 = "outputFlag";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);

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
     char   *ptypeIn1 = "float";
     char   *pnameIn1 = "z";
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

 

	/*
	 * Allocate memory and return pointers for tapped delay line x_P and
	 * array containing impulse response samples, h_P.
	 *
	 */
	if( (x_P = (float*)calloc(N,sizeof(float))) == NULL ||
	    (w_P = (float*)calloc(N,sizeof(float))) == NULL ) {
	   	fprintf(stderr,"lms: can't allocate work space\n");
		return(4);
	}
	/*
	 * initialize the tapped delay line and weights to zero.
	 *
	 */
	for (i=0; i<N; i++) {
		x_P[i]= 0.0;
		w_P[i] = 0.0;
	}


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 



        for(j = MIN_AVAIL(); j>0; j--) {
		/*
		 * Shift input sample into tapped delay line
		 */
		IT_IN(0);
		tmp2=x(0);
		for(i=0; i<N; i++) {
			tmp1=x_P[i];
			x_P[i]=tmp2;
			tmp2=tmp1;
		}
		/*
		 * Compute inner product 
		 */
                dhat = 0.0;
		for (i=0; i<N; i++) { 
		     dhat += x_P[i]*w_P[i];
		}
		/*
	  	 * set output buffer to response result
		 */
                IT_IN(1);
                error = z(0) - dhat;
                for (i=0;i<N;i++)  w_P[i]+= mu*x_P[i]*error;
		if(IT_OUT(0)) {
			KrnOverflow("lms",0);
			return(99);
		}
		if(!outputFlag) y(0) = dhat;
		else
			y(0) = error;
	}
	return(0);
              


break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

	free(x_P); free(w_P); 


break;
}
return(0);
}
