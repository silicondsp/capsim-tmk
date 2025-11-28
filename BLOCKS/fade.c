 
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

This star models multipath fading channels for mobile radio applications.

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 

#include <math.h>


 

#define PI 3.1415926


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int  __inbufs;
      int  __fftl;
      int  __fftexp;
      float*  __fftBuffer_P;
      float*  __inputBuffer_P;
      float*  __outputBuffer_P;
      int  __inSampleCount;
      int  __samplesOutput;
      float  __wd;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define inbufs (state_P->__inbufs)
#define fftl (state_P->__fftl)
#define fftexp (state_P->__fftexp)
#define fftBuffer_P (state_P->__fftBuffer_P)
#define inputBuffer_P (state_P->__inputBuffer_P)
#define outputBuffer_P (state_P->__outputBuffer_P)
#define inSampleCount (state_P->__inSampleCount)
#define samplesOutput (state_P->__samplesOutput)
#define wd (state_P->__wd)

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define inPhase(delay) *(float  *)POUT(0,delay)
#define quadPhase(delay) *(float  *)POUT(1,delay)

/*         
 *    PARAMETER DEFINES 
 */ 
#define npts (param_P[0]->value.d)
#define type (param_P[1]->value.d)
#define fs (param_P[2]->value.f)
#define fc (param_P[3]->value.f)
#define v (param_P[4]->value.f)
#define p (param_P[5]->value.f)
#define delays ((float*)param_P[6]->value.s)
#define n_delays  (param_P[6]->array_size)
#define powers ((float*)param_P[7]->value.s)
#define n_powers  (param_P[7]->array_size)
#define numberArrivals (param_P[8]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

fade 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int numberOfSamples;
	int i,j;
	float fd, lambda;
	double er,ei;
	float arg;
	float t;
	float env;
	float tsin,tcos;
	int	samples;
	void cxfft(float *x,int *mfft);
	void cxifft(float *x,int *mfft);


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Number of points (preferably a power of 2)";
     char   *ptype0 = "int";
     char   *pval0 = "128";
     char   *pname0 = "npts";
     char   *pdef1 = "Doppler Spectrum, only Ez supported at this time.";
     char   *ptype1 = "int";
     char   *pval1 = "0";
     char   *pname1 = "type";
     char   *pdef2 = "Sampling Rate";
     char   *ptype2 = "float";
     char   *pval2 = "1.0";
     char   *pname2 = "fs";
     char   *pdef3 = "Carrier frequency";
     char   *ptype3 = "float";
     char   *pval3 = "1000e6";
     char   *pname3 = "fc";
     char   *pdef4 = "Vehicle Velocity, m/s";
     char   *ptype4 = "float";
     char   *pval4 = "0";
     char   *pname4 = "v";
     char   *pdef5 = "Power";
     char   *ptype5 = "float";
     char   *pval5 = "1.0";
     char   *pname5 = "p";
     char   *pdef6 = "Array of multipath delays microsec: number_of_paths t0 t1  ... ";
     char   *ptype6 = "array";
     char   *pval6 = "";
     char   *pname6 = "delays";
     char   *pdef7 = "Array of multipath powers: number_of_paths p0 p1  ... ";
     char   *ptype7 = "array";
     char   *pval7 = "";
     char   *pname7 = "powers";
     char   *pdef8 = "Number of Plane Waves arriving plane waves, N where N >=34";
     char   *ptype8 = "int";
     char   *pval8 = "40";
     char   *pname8 = "numberArrivals";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);
KrnModelParam(indexModel88,3 ,pdef3,ptype3,pval3,pname3);
KrnModelParam(indexModel88,4 ,pdef4,ptype4,pval4,pname4);
KrnModelParam(indexModel88,5 ,pdef5,ptype5,pval5,pname5);
KrnModelParam(indexModel88,6 ,pdef6,ptype6,pval6,pname6);
KrnModelParam(indexModel88,7 ,pdef7,ptype7,pval7,pname7);
KrnModelParam(indexModel88,8 ,pdef8,ptype8,pval8,pname8);

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
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            inSampleCount=0;
       samplesOutput=0;


         
   if(NO_OUTPUT_BUFFERS() != 2 ){
       fprintf(stdout,"%s:2 outputs expected; %d connected\n",
              STAR_NAME,NO_OUTPUT_BUFFERS());
	      return(201);
   }

   SET_CELL_SIZE_OUT(0,sizeof(float));

   SET_CELL_SIZE_OUT(1,sizeof(float));

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

	inbufs = NO_INPUT_BUFFERS();
	/*
 	 * extract the exponent in npts=2**fftexp 
         */
        fftexp = (int) (log((float)npts)/log(2.0)+0.5);
        fftl = 1 << fftexp;
        if (fftl > npts ) {
                    fftl = fftl/2;
                    fftexp -= 1;
        }
	if (n_delays == 0 )
	{
		fprintf(stderr,"fade: number of delays must be >= 1 \n");
		return(1);
	}
	if (n_delays != n_powers)
	{
		fprintf(stderr,"fade: number of delays dont match powers \n");
		return(2);
	}
	if ((fftBuffer_P = (float*)calloc(2*fftl,sizeof(float))) == NULL)
	{
		fprintf(stderr,"fade: can't allocate work space \n");
		return(3);
	}
	if ((inputBuffer_P = (float*)calloc(2*fftl,sizeof(float))) == NULL)
	{
		fprintf(stderr,"fade: can't allocate work space \n");
		return(4);
	}
	if ((outputBuffer_P = (float*)calloc(2*fftl,sizeof(float))) == NULL)
	{
		fprintf(stderr,"fade: can't allocate work space \n");
		return(5);
	}
	/*
	 * calculate maximum doppler shift
 	 */
	lambda= 3.e8/fc;
	fd= v/lambda;
	wd=2*PI*fd;
	inSampleCount=0;


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 

/*
 * Output computed complex samples in chunks of 128 samples
 * This is done after fftl number of samples have been input and processed.
 */
if(inSampleCount >= fftl) {
     if(samplesOutput >= fftl) return(0);
     for(i=0; i < 128; i++) {
	    samples=samplesOutput;
	    if(IT_OUT(0) ){
		KrnOverflow("fade",0);
		return(99);
	    }
	    if(IT_OUT(1)) {
		KrnOverflow("fade",1);
		return(99);
	    }
	    inPhase(0) = outputBuffer_P[2*samples]/fftl;
	    quadPhase(0) = outputBuffer_P[2*samples+1]/fftl;
	    samplesOutput++;
     }
     return(0);
}
/*
 * input the samples. Collect fftl number of samples before processing
 */
for (numberOfSamples = MIN_AVAIL(); numberOfSamples > 0; --numberOfSamples) {

      IT_IN(0);
      IT_IN(1);
      /*
       * store samples in inputBuffer_P
       */
      inputBuffer_P[2*inSampleCount] = INF(0,0);
      inputBuffer_P[2*inSampleCount+1] = INF(1,0);
      /*
       * keep track of the number of samples inputted up this point
       */
      inSampleCount++;
      if(inSampleCount == fftl) {
	/*
	 * fftl number of samples collected. 
	 * Compute fading channel amplitude. 
	 * Compute n_delays, the number of multipaths,  independent amplitudes.
	 * This done my chnage the phase by an offset. See Jakes(1974).
	 */
        for(j=0; j< n_delays; j++) {
	   for(samples=0; samples < inSampleCount; samples++) {
	      t=(float)samples/fs;
	      /*
	       * Compute complex mobile fading channel amplitude
	       */
	      er=0.0;
	      ei=0.0;
	      for(i=0; i<numberArrivals/2; i++) {
		 /*
		  * note the term (i+2*j)
		  * This poduces (hopefully) independent amplitues for
		  * different j's where j is the multipath number.
		  * ri(t) = er + j*ei
		  */
	         arg = wd*t*cos(2*PI*(float)i/numberArrivals) + PI*((float)(i+2*j)/numberArrivals);
	         er=er + cos(arg);
	         ei=ei + sin(arg);
	      }
	      /*
	       * powers[j] are the relative powers for each multipath
	       */	
	      er= sqrt(2.0*p*powers[j]/numberArrivals) * er;
	      ei = sqrt(2.0*p*powers[j]/numberArrivals) * ei;
	      /*
	       * form u(t)*ri(t). Store in fft buffer to be transformed
	       * into the frequency domain.
	       * note  that u(t) is stored in inputBuffer_P.
	       */
	      fftBuffer_P[2*samples] = er*inputBuffer_P[2*samples] - 
					ei*inputBuffer_P[2*samples+1]; 
	      fftBuffer_P[2*samples+1] = ei*inputBuffer_P[2*samples] + 
					er*inputBuffer_P[2*samples+1]; 
	   }
	   /*
	    * Transform into the frequency domain
	    */
	   cxfft(fftBuffer_P,&fftexp);
	      
	   /*
	    * incorporate delay by multiplying Yi(f) by
	    * exp { -j2Pi(fc +f)ti} where the ti are stored in
	    * delays[i].
	    * Also add all paths.
	    */
	   for(samples=0; samples < inSampleCount; samples++) {
	       arg = 2*PI*(fc+(float)samples*fs/(float)inSampleCount)*1.e-6*delays[j];
	       tcos=cos(arg);
	       tsin = -sin(arg);
	    
	       outputBuffer_P[2*samples] += tcos*fftBuffer_P[2*samples] -
			tsin*fftBuffer_P[2*samples+1];
	       outputBuffer_P[2*samples+1] += - (tsin*fftBuffer_P[2*samples] +
			tcos*fftBuffer_P[2*samples+1]);
	   }
	}
	/*
	 * convert to time domain
	 */
	cxifft(outputBuffer_P,&fftexp);
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
	free((char*)fftBuffer_P);
	free((char*)inputBuffer_P);
	free((char*)outputBuffer_P);


break;
}
return(0);
}
