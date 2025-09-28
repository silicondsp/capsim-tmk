 
#ifdef LICENSE

/*  Capsim (r) Text Mode Kernel (TMK) Star Library (Blocks)
    Copyright (C) 1989-2002  XCAD Corporation 

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

    http://www.xcad.com
    XCAD Corporation
    Raleigh, North Carolina */

#endif
 
#ifdef SHORT_DESCRIPTION

Calculate impulse response from frequency response

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
      float*  __freqRes_A;
      float*  __impRes_A;
      int  __numSamples;
      float  __conj;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define freqRes_A (state_P->__freqRes_A)
#define impRes_A (state_P->__impRes_A)
#define numSamples (state_P->__numSamples)
#define conj (state_P->__conj)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define xfreq(DELAY) (*((float  *)PIN(0,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define ximp(delay) *(float  *)POUT(0,delay)

/*         
 *    PARAMETER DEFINES 
 */ 
#define nfft (param_P[0]->value.d)
#define conjFlag (param_P[1]->value.d)
/*-------------- BLOCK CODE ---------------*/


freqimp 

(run_state,block_P)

	int run_state;
	block_Pt block_P;
{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int 	i;
	int	j;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Number of frequency points  to input";
     char   *ptype0 = "int";
     char   *pval0 = "64";
     char   *pname0 = "nfft";
     char   *pdef1 = "Conjugatate (0=No, 1=Yes)";
     char   *ptype1 = "int";
     char   *pval1 = "0";
     char   *pname1 = "conjFlag";
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
     char   *ptypeOut0 = "float";
     char   *pnameOut0 = "ximp";
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
     char   *pnameIn0 = "xfreq";
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

 

	numSamples=0;
	/*
	 * Allocate array for frequency response 
	 */
	freqRes_A= (float *)malloc(nfft*sizeof(float));
	if(freqRes_A==NULL) {
		fprintf(stderr,"Unable to allocate space in freqimp star \n");
		return(1);
	}
	/*
	 * Allocate array for impulse response
	 */
	impRes_A= (float *)malloc(2*nfft*sizeof(float));
	if(impRes_A==NULL) {
		fprintf(stderr,"Unable to allocate space in freqimp star \n");
		return(2);
	}
	if (conjFlag) conj= -1.0;
		else conj = 1.0;


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 

for (j = MIN_AVAIL(); j > 0; --j) {
	/*
	 * Get frequency response 
	 */

	IT_IN(0);
	freqRes_A[numSamples]=xfreq(0);
	numSamples++;
	/*
	 * Check if nfft samples read in
	 */
	if(numSamples == 2*nfft) {
		for(i=0; i<nfft; i++)
		   freqRes_A[2*i+1] = conj*freqRes_A[2*i+1];	

		/*
		 * Compute impulse response
		 */

		Dsp_FreqImp(freqRes_A,nfft,impRes_A);

		/* 
 		 *  Output Impulse response
 	 	 */
		for (i=0; i<2*nfft; i++) {
			if(IT_OUT(0)) {
				KrnOverflow("freqimp",0);
				return(99);
			}
			ximp(0)=impRes_A[i];
		numSamples=0;
		}
	}
}


break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

	free(impRes_A);
	free(freqRes_A);


break;
}
return(0);
}
