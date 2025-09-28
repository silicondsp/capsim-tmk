 
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

If one input then compute autocorrelation. If two inputs then compute crosscorrelation.

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 

#include <math.h>
#include <cap_fft.h>
#include <cap_fftr.h>




/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int  __fftLength;
      int  __fftexp;
      cap_fft_scalar*  __fftBuffer;
      cap_fft_scalar*  __fftBuffer2;
      cap_fft_scalar*  __temp;
      cap_fft_cpx*  __freqBuff;
      cap_fft_cpx*  __freqBuff2;
      int  __sampleCount;
      int  __numberOfInputBuffers;
      cap_fftr_cfg  __preverse;
      cap_fftr_cfg  __pforward;
      double  __norm;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define fftLength (state_P->__fftLength)
#define fftexp (state_P->__fftexp)
#define fftBuffer (state_P->__fftBuffer)
#define fftBuffer2 (state_P->__fftBuffer2)
#define temp (state_P->__temp)
#define freqBuff (state_P->__freqBuff)
#define freqBuff2 (state_P->__freqBuff2)
#define sampleCount (state_P->__sampleCount)
#define numberOfInputBuffers (state_P->__numberOfInputBuffers)
#define preverse (state_P->__preverse)
#define pforward (state_P->__pforward)
#define norm (state_P->__norm)

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define y(delay) *(float  *)POUT(0,delay)

/*         
 *    PARAMETER DEFINES 
 */ 
#define npts (param_P[0]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  autoxcorr(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int no_samples;
	int i,j;
	float	tmpReal;
	float	temp2;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Number of samples";
     char   *ptype0 = "int";
     char   *pval0 = "128";
     char   *pname0 = "npts";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);

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
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            sampleCount=0;


         
   if(NO_OUTPUT_BUFFERS() != 1 ){
       fprintf(stdout,"%s:1 outputs expected; %d connected\n",
              STAR_NAME,NO_OUTPUT_BUFFERS());
	      return(201);
   }

   SET_CELL_SIZE_OUT(0,sizeof(float));

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

/*
 * compute the power of 2 number of fft points
 */
fftexp = (int) (log((float)npts)/log(2.0)+0.5);
fftLength = 1 << fftexp;
if (fftLength > npts ) {
        fftLength = fftLength/2;
        fftexp -= 1;
}
if((numberOfInputBuffers = NO_INPUT_BUFFERS()) > 2) {
     fprintf(stderr,"autoxcorr: no input buffers\n");
     return(3);
}
if (fftLength < 8) {
	fprintf(stderr,"autocorr: fft length is too short \n");
	return(1);
}
if ((fftBuffer = (cap_fft_scalar*)calloc(fftLength,sizeof(cap_fft_scalar))) == NULL) {
	fprintf(stderr,"autoxcorr: can't allocate work space \n");
	return(2);
}
if ((freqBuff = (cap_fft_cpx*)calloc(fftLength,sizeof(cap_fft_cpx))) == NULL) {
	fprintf(stderr,"autoxcorr: can't allocate work space \n");
	return(3);
}
if(numberOfInputBuffers == 2) {  
	if ((fftBuffer2 = (cap_fft_scalar*)calloc(fftLength,sizeof(cap_fft_scalar))) == NULL) {
	   fprintf(stderr,"autoxcorr: can't allocate work space \n");
	   return(4);
	}
	if ((freqBuff2 = (cap_fft_cpx*)calloc(fftLength,sizeof(cap_fft_cpx))) == NULL) {
	fprintf(stderr,"autoxcorr: can't allocate work space \n");
	return(5);
	}
}
if ((temp = (cap_fft_scalar*)calloc(fftLength,sizeof(cap_fft_scalar))) == NULL) {
	fprintf(stderr,"autoxcorr: can't allocate work space \n");
	return(6);
}

norm=1.0/(float)fftLength;
norm=norm*norm*2.;


	preverse = cap_fftr_alloc(fftLength, INVERSE_FFT, NULL,NULL);
	pforward = cap_fftr_alloc(fftLength, FORWARD_FFT, NULL,NULL);


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 

for (no_samples = MIN_AVAIL(); no_samples > 0; --no_samples) {

		/* 
		 * read in input value	
		 */
		if(numberOfInputBuffers == 1) { 
			IT_IN(0);
			fftBuffer[sampleCount] = INF(0,0);
		}
		else {
			IT_IN(0);
			fftBuffer[sampleCount] = INF(0,0);
			IT_IN(1);
			fftBuffer2[sampleCount] = INF(1,0);
		}
		sampleCount++;

		/* 
		 * Get enough points				
		 */
		if(sampleCount >= fftLength)
		{
			/* 
			 * perform fft calculation		
			 */
			 
		cap_fftr(pforward, fftBuffer,freqBuff);	 
			 
		//	rfft(fftBuffer,fftLength);
		
		

		if(numberOfInputBuffers == 1) { 
			    /*
			     * compute X(k)X*(k)
			     */
 
			    cmultfftcap(freqBuff, freqBuff, fftLength, 1.0);

			} else {
			
		        
		             cap_fftr(pforward, fftBuffer2,freqBuff2);
		        
		//		     rfft(fftBuffer2,fftLength);

				
			
			
			    /*
			     * compute X(k)Y*(k)
			     */
			     
			    cmultfftcap(freqBuff, freqBuff2, fftLength, 1.0);
			     

			}
			
			cap_fftri(preverse, freqBuff, fftBuffer);

			// rfti(fftBuffer,fftLength);
			
			/* 
			 * now, output samples			
			 */
            for (i=0; i<fftLength; i++)
			{
				if(IT_OUT(0)) {
					KrnOverflow("autoxcorr",0);
					return(99);
				}
				y(0) = fftBuffer[i]*norm;
			}


			sampleCount = 0;
		}
}
return(0);


break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

	/* 
	 * free up allocated space	
	 */
	free((char*)fftBuffer);
	free((char*)freqBuff);
        if(numberOfInputBuffers == 2) {  
		free((char*)fftBuffer2);
		free((char*)freqBuff2);
        }
    
        free(preverse);
        free(pforward);



break;
}
return(0);
}
