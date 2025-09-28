 
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

This star performs Nyquist pulse shaping for a baseband transmitter.

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


 

#define PI 3.1415926
#define IMPBAUD 12	/* # baud widths of impulse response to save */


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      cap_fft_cpx*  __nyqfresp;
      cap_fft_scalar*  __temp;
      cap_fft_scalar*  __temp2;
      cap_fft_scalar*  __save;
      cap_fft_cpx*  __freqBuffCx;
      cap_fftr_cfg  __preverse;
      cap_fftr_cfg  __pforward;
      int  __fftl;
      int  __impl;
      int  __pcount;
      double  __norm;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define nyqfresp (state_P->__nyqfresp)
#define temp (state_P->__temp)
#define temp2 (state_P->__temp2)
#define save (state_P->__save)
#define freqBuffCx (state_P->__freqBuffCx)
#define preverse (state_P->__preverse)
#define pforward (state_P->__pforward)
#define fftl (state_P->__fftl)
#define impl (state_P->__impl)
#define pcount (state_P->__pcount)
#define norm (state_P->__norm)

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
#define smplbd (param_P[0]->value.d)
#define expfft (param_P[1]->value.d)
#define beta (param_P[2]->value.f)
/*-------------- BLOCK CODE ---------------*/
filtnyq(run_state,block_P)

	int run_state;
	block_Pt block_P;
{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

   	int i;
   	int j;
	float freq;			/* fractional norm. frequency */
	float val;			/* temporary */
	int	no_samples;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "samples per baud interval.";
     char   *ptype0 = "int";
     char   *pval0 = "8";
     char   *pname0 = "smplbd";
     char   *pdef1 = "expfft: 2^expfft=fft length to use.";
     char   *ptype1 = "int";
     char   *pval1 = "8";
     char   *pname1 = "expfft";
     char   *pdef2 = "beta: filter rolloff factor, 0<beta<=.5 ";
     char   *ptype2 = "float";
     char   *pval2 = ".5";
     char   *pname2 = "beta";
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
KrnModelConnectionInput(indexIC,0 ,pnameIn0,ptypeIn0);
}
 break;

/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            fftl= 1 << expfft    ;
       impl=IMPBAUD * smplbd;
       pcount=impl;



         
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

 

	if(smplbd < 2) {
	   	fprintf(stderr,"filtnyq: do not use if smplbd < 2\n");
		return(1);
	}
	if(fftl <= impl) {
	   	fprintf(stderr,"filtnyq: fft length too short\n");
		return(2);
	}
	if(beta <= 0. || beta > .5) {
	   	fprintf(stderr,"filtnyq: beta param out of range\n");
		return(3);
	}
	if( (nyqfresp = (cap_fft_cpx*)calloc(fftl,sizeof(cap_fft_cpx))) == NULL ||
	    (temp = (cap_fft_scalar*)calloc(fftl,sizeof(cap_fft_scalar))) == NULL ||
	    (temp2 = (cap_fft_scalar*)calloc(fftl,sizeof(cap_fft_scalar))) == NULL ||
	    (freqBuffCx = (cap_fft_cpx*)calloc(fftl,sizeof(cap_fft_cpx))) == NULL ||
	    (save = (cap_fft_scalar*)calloc(impl,sizeof(cap_fft_scalar))) == NULL ) {
	   	fprintf(stderr,"filtnyq: can't allocate work space\n");
		return(4);
	}

	preverse = cap_fftr_alloc(fftl, INVERSE_FFT, NULL,NULL);
	pforward = cap_fftr_alloc(fftl, FORWARD_FFT, NULL,NULL);

	/* Compute nyquist frequency response */
	/* store in `folded, real fft' form */
	/* note: frequency is normalized to unity at baud rate */
	for(i=0; i<fftl/2; i++) {
		freq = i * ((float) smplbd / fftl);
		temp[2*i+1] = 0.; /*imaginary part*/
		if(freq <= .5 - beta) temp[2*i] = smplbd;
		else if(freq >= .5 + beta) temp[2*i] = 0.;
		else {	/* frequency in rolloff region */
			val =  cos(PI * (freq -.5 + beta)/(4.* beta));
			temp[2*i] = smplbd * val*val ;
		}
	}

	for(i=0; i<fftl/2; i++) {
	      freqBuffCx[i].r=temp[2*i];
             freqBuffCx[i].i=temp[2*i+1];

       }
//	for(i=0; i<fftl/2; i++) 
 //            printf("%d %f %f\n",i, temp2[i],temp2[fftl-i]);
	/* Construct realizable, truncated impulse response */
	/* (add delay by getting samples from end of imp. resp.) */
        cap_fftri(preverse, freqBuffCx, temp);
        // rfti(temp,fftl);
	for(i=0; i<fftl; i++) {
		if(i < impl)
			temp2[i] = temp[(i + fftl - impl/2)%fftl];
		else
			temp2[i] = 0;
	}
	/* Back to frequency response form */
        cap_fftr(pforward, temp2,nyqfresp);
        // rfft(nyqfresp,fftl);
	for(i=0; i<fftl; i++)
		temp[i] = 0.;
        norm=1.0/(float)fftl;
	//norm=norm*norm;
	for(i=0; i<fftl; i++) {
		nyqfresp[i].r = nyqfresp[i].r*norm;;
		nyqfresp[i].i = nyqfresp[i].i*norm;;
        }



break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


	for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) {
		IT_IN(0);
		temp[pcount++] = x(0);
		if(pcount == fftl){
			for(i=0; i<impl; i++)
				save[i] = temp[fftl - impl + i];
                        
                        cap_fftr(pforward, temp,freqBuffCx);
        		//rfft(temp,fftl);

			cmultfftcap(freqBuffCx, nyqfresp, fftl/2,1.0);

                        cap_fftri(preverse, freqBuffCx,temp);
        		//rfti(temp,fftl);
			for(i=impl; i<fftl; i++) {
				if(IT_OUT(0)) {
					KrnOverflow("filtnyq",0);
					return(99);
				}
				y(0) = temp[i]*norm;
			}
			pcount = impl;
			for(i=0; i<impl; i++)
				temp[i] = save[i];
		}
	}


break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

#if 1
	free(temp); 
	free(nyqfresp); 
	free(save); 
	free(temp2);
        free(preverse);
        free(pforward);
	free(freqBuffCx);
#endif


break;
}
return(0);
}
