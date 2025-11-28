 
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

This star convolves its input signal with an impulse response (from file) to generate the output signal.

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
      cap_fft_scalar*  __temp;
      cap_fft_cpx*  __freqBuffCx;
      cap_fft_scalar*  __temp2;
      cap_fft_cpx*  __iresp;
      cap_fft_scalar*  __save;
      cap_fftr_cfg  __preverse;
      cap_fftr_cfg  __pforward;
      int  __pcount;
      int  __fftl;
      double  __norm;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define temp (state_P->__temp)
#define freqBuffCx (state_P->__freqBuffCx)
#define temp2 (state_P->__temp2)
#define iresp (state_P->__iresp)
#define save (state_P->__save)
#define preverse (state_P->__preverse)
#define pforward (state_P->__pforward)
#define pcount (state_P->__pcount)
#define fftl (state_P->__fftl)
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
#define impl (param_P[0]->value.d)
#define impf_name (param_P[1]->value.s)
#define fftexp (param_P[2]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  fconv(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int i;
	int no_samples;
	FILE* fp;
	float val;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "impl: length of impulse response in samples:";
     char   *ptype0 = "int";
     char   *pval0 = "128";
     char   *pname0 = "impl";
     char   *pdef1 = "(file)ASCII file which holds impulse response:";
     char   *ptype1 = "file";
     char   *pval1 = "imp.dat";
     char   *pname1 = "impf_name";
     char   *pdef2 = "log2(fft length):";
     char   *ptype2 = "int";
     char   *pval2 = "8";
     char   *pname2 = "fftexp";
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
            pcount=impl;
       fftl= 1 << fftexp    ;



         
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

 

	if(impl < (2.89 * log((float)fftl) + 1))
	fprintf(stderr,"fconv: direct convolution may be faster\n");
	if(impl >= fftl) {
		fprintf(stderr,"fconv: FFT length smaller than impulse response length\n");
		return(1);
	}
	if( (temp = (cap_fft_scalar*)calloc(fftl,sizeof(cap_fft_scalar))) == NULL
	 || (iresp = (cap_fft_cpx*)calloc(fftl,sizeof(cap_fft_cpx))) == NULL
	 || (freqBuffCx = (cap_fft_cpx*)calloc(fftl,sizeof(cap_fft_cpx))) == NULL 
	 || (temp2 = (cap_fft_scalar*)calloc(fftl,sizeof(cap_fft_scalar))) == NULL
	 || (save = (cap_fft_scalar*)calloc(impl,sizeof(cap_fft_scalar))) == NULL  ) {
		fprintf(stderr,"fconv: can't allocate work space\n");
		return(2);
	}
	if((fp = fopen(impf_name,"r")) == NULL) {
		fprintf(stderr,"fconv: can't open impulse response file %s\n",impf_name);
		return(3);
	}
	for(i=0; i<impl; i++) {
		if( (fscanf(fp,"%f", &val)) != 1) {
			fprintf(stderr, "fconv: impulse response file %s too short\n",
				impf_name);
			return(4);
		}
		temp[i]=val;
		//printf("reading %d %f\n",i, temp[i]);
	}
	fclose(fp);

	preverse = cap_fftr_alloc(fftl, INVERSE_FFT, NULL,NULL);
	pforward = cap_fftr_alloc(fftl, FORWARD_FFT, NULL,NULL);
	
	
	 cap_fftr(pforward, temp,iresp);
	 for(i=0; i<fftl; i++) temp[i]=0.0;
	  norm=1.0/(float)fftl;
	 
	


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 

	for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) {
		IT_IN(0);
		temp[pcount++] = x(0);
		if(pcount == fftl) {
			for(i=0; i<impl; i++)
				save[i] = temp[fftl-impl+i];
				
		        cap_fftr(pforward, temp,freqBuffCx);		
				
		//	rfft(temp,fftl);
			
			
		//	cmultfft(temp, iresp, fftl);
		
		        cmultfftcap(freqBuffCx, iresp, fftl/2,1.0);
		        cap_fftri(preverse, freqBuffCx,temp);	
			
			
			
			for(i=impl; i<fftl; i++){
				if(IT_OUT(0) ) {
					KrnOverflow("fconv",0);
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

 

	free(temp); free(iresp); free(save); free(temp2); free(freqBuffCx);
	
        free(preverse);
        free(pforward);
	


break;
}
return(0);
}
