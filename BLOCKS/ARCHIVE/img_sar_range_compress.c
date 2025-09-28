 
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

Compress SAR image in range

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


 

#define  PI  3.1415926535898
#define C 300000000.0


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      float  __phase;
      float  __t;
      float  __dt;
      float  __dtaz;
      float  __tp;
      int  __done;
      int  __maxRangeIndex;
      int  __k;
      float  __lamda;
      float  __t0;
      int  __obufs;
      float**  __mat_PP;
      float**  __matCompressed_PP;
      cap_fft_cpx*  __ref_P;
      cap_fft_cpx*  __range_P;
      cap_fft_cpx*  __refFFT_P;
      cap_fft_cpx*  __rangeFFT_P;
      cap_fft_cfg  __cfg;
      cap_fft_cfg  __cfgi;
      int  __rangeFFTLength;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define phase (state_P->__phase)
#define t (state_P->__t)
#define dt (state_P->__dt)
#define dtaz (state_P->__dtaz)
#define tp (state_P->__tp)
#define done (state_P->__done)
#define maxRangeIndex (state_P->__maxRangeIndex)
#define k (state_P->__k)
#define lamda (state_P->__lamda)
#define t0 (state_P->__t0)
#define obufs (state_P->__obufs)
#define mat_PP (state_P->__mat_PP)
#define matCompressed_PP (state_P->__matCompressed_PP)
#define ref_P (state_P->__ref_P)
#define range_P (state_P->__range_P)
#define refFFT_P (state_P->__refFFT_P)
#define rangeFFT_P (state_P->__rangeFFT_P)
#define cfg (state_P->__cfg)
#define cfgi (state_P->__cfgi)
#define rangeFFTLength (state_P->__rangeFFTLength)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define x(DELAY) (*((image_t  *)PIN(0,DELAY)))

/*         
 *    PARAMETER DEFINES 
 */ 
#define fc (param_P[0]->value.f)
#define Kr (param_P[1]->value.f)
#define tau (param_P[2]->value.f)
#define Br (param_P[3]->value.f)
#define fIF (param_P[4]->value.f)
#define prf (param_P[5]->value.f)
#define fs (param_P[6]->value.f)
#define fDc (param_P[7]->value.f)
#define Kaz (param_P[8]->value.f)
#define v (param_P[9]->value.f)
#define total (param_P[10]->value.f)
#define tazs (param_P[11]->value.f)
#define tc (param_P[12]->value.f)
#define rp (param_P[13]->value.f)
#define tpi (param_P[14]->value.d)
#define control (param_P[15]->value.d)
/*-------------- BLOCK CODE ---------------*/
img_sar_range_compress(run_state,block_P)

	int run_state;
	block_Pt block_P;
{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int no_samples;
	int i,j;
	float taz;
	float range;
	float arg;
	float a,b,c;
	float rx;
	image_t		img;
	int width,height;
	int order,pts;
	cap_fft_cpx x,y;
	float fmax,fmin;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Carrier Frequency, MHz";
     char   *ptype0 = "float";
     char   *pval0 = "1275";
     char   *pname0 = "fc";
     char   *pdef1 = "Pulse Chirp Rate, MHz/microsecond";
     char   *ptype1 = "float";
     char   *pval1 = "0.5621";
     char   *pname1 = "Kr";
     char   *pdef2 = "Pulse Duration Microseconds";
     char   *ptype2 = "float";
     char   *pval2 = "33.8";
     char   *pname2 = "tau";
     char   *pdef3 = "Pulse Bandwidth, MHz";
     char   *ptype3 = "float";
     char   *pval3 = "19.0";
     char   *pname3 = "Br";
     char   *pdef4 = "Center Frequency (IF) MHz";
     char   *ptype4 = "float";
     char   *pval4 = "11.38";
     char   *pname4 = "fIF";
     char   *pdef5 = "Pulse Repition Rate, Hz";
     char   *ptype5 = "float";
     char   *pval5 = "1645.0";
     char   *pname5 = "prf";
     char   *pdef6 = "Sampling Rate, MHz";
     char   *ptype6 = "float";
     char   *pval6 = "45.03";
     char   *pname6 = "fs";
     char   *pdef7 = "Doppler Frequency, Hz";
     char   *ptype7 = "float";
     char   *pval7 = "1150.0";
     char   *pname7 = "fDc";
     char   *pdef8 = "Doppler Rate of Change , Hz";
     char   *ptype8 = "float";
     char   *pval8 = "501.27";
     char   *pname8 = "Kaz";
     char   *pdef9 = "Platform Velocity, Km/s";
     char   *ptype9 = "float";
     char   *pval9 = "7.0";
     char   *pname9 = "v";
     char   *pdef10 = "Integration Time, s";
     char   *ptype10 = "float";
     char   *pval10 = "2.0";
     char   *pname10 = "total";
     char   *pdef11 = "Azimuth Sample Time";
     char   *ptype11 = "float";
     char   *pval11 = "0.0";
     char   *pname11 = "tazs";
     char   *pdef12 = "tc seconds";
     char   *ptype12 = "float";
     char   *pval12 = "1.0";
     char   *pname12 = "tc";
     char   *pdef13 = "Reference Point Range rp, kM";
     char   *ptype13 = "float";
     char   *pval13 = "840.0";
     char   *pname13 = "rp";
     char   *pdef14 = "Reference Point Azimuth tp in index units";
     char   *ptype14 = "int";
     char   *pval14 = "1000";
     char   *pname14 = "tpi";
     char   *pdef15 = "Output Control 0:real compressed, 1: complex compressed";
     char   *ptype15 = "int";
     char   *pval15 = "0";
     char   *pname15 = "control";
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
KrnModelParam(indexModel88,10 ,pdef10,ptype10,pval10,pname10);
KrnModelParam(indexModel88,11 ,pdef11,ptype11,pval11,pname11);
KrnModelParam(indexModel88,12 ,pdef12,ptype12,pval12,pname12);
KrnModelParam(indexModel88,13 ,pdef13,ptype13,pval13,pname13);
KrnModelParam(indexModel88,14 ,pdef14,ptype14,pval14,pname14);
KrnModelParam(indexModel88,15 ,pdef15,ptype15,pval15,pname15);

      }
break;
   


/*         
 *    INPUT BUFFER SYSTEM  INITS 
 */ 
 case INPUT_BUFFER_INIT:
 {
 int indexIC = block_P->model_index;
     char   *ptypeIn0 = "image_t";
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
            phase=0.;
       t=0.;
       done=0;


         
   if(NO_INPUT_BUFFERS() != 1 ){
       fprintf(stdout,"%s:1 inputs expected; %d connected\n",
              STAR_NAME,NO_INPUT_BUFFERS());
	      return(200);
   }

   SET_CELL_SIZE_IN(0,sizeof(image_t));

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

	if( (obufs = NO_OUTPUT_BUFFERS()) < 1 ) {
		fprintf(stderr,"img_sar_range_compress: no output buffers\n");
		CsInfo("img_sar_create: no output buffers");
		return(2);
	}
    dt=(1.0/fs)*0.000001;
	t0=2.0*rp*1000.0/C;
    maxRangeIndex=(int)tau*0.000001/dt;
	dtaz=(1.0/prf);
    tp=tpi*(1.0/prf);
    done=0;
    t=0;
    k=0;
    lamda=C/(fc*1000000.0);

      /*
         * round width to next power of 2
         */
        order = (int) (log((float)maxRangeIndex)/log(2.0)+0.5);
        pts = 1 << order;
        if (pts < maxRangeIndex ) {
                pts = pts*2;
                order += 1;
        }
        rangeFFTLength=pts;

 	fprintf(stderr,"img_sar_range_compress: maxRangeIndex=%d rangeFFTLength=%d \n",maxRangeIndex, rangeFFTLength); 




        cfg=cap_fft_alloc(rangeFFTLength,0,NULL,NULL);
        cfgi=cap_fft_alloc(rangeFFTLength,1,NULL,NULL);
    for(j=0; j<obufs; j++) 
		     SET_CELL_SIZE_OUT(j,sizeof(image_t));


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


for (no_samples = MIN_AVAIL(); no_samples > 0; --no_samples) {
	IT_IN(0);
	img=x(0);
	height=img.height;
	width=img.width;
	/*
	 * round width to next power of 2
	 */
	order = (int) (log((float)width)/log(2.0)+0.5);
	pts = 1 << order;
	if (pts < width ) {
        	pts = pts*2;
        	order += 1;
	}
        if(rangeFFTLength < pts) {
           fprintf(stderr,"Problem with dimensions. Overriding \n");
           pts=rangeFFTLength;
        } else {
	     rangeFFTLength=pts;
        }
	fprintf(stderr,"img_sar_range_compress: width=%d height=%d FFTWidth=%d\n",width,height,rangeFFTLength); 

	ref_P=(cap_fft_cpx *)calloc(rangeFFTLength,sizeof(cap_fft_cpx));
	range_P=(cap_fft_cpx *)calloc(rangeFFTLength,sizeof(cap_fft_cpx));
	refFFT_P=(cap_fft_cpx *)calloc(rangeFFTLength,sizeof(cap_fft_cpx));
	rangeFFT_P=(cap_fft_cpx *)calloc(rangeFFTLength,sizeof(cap_fft_cpx));

	if(ref_P == NULL || range_P== NULL || rangeFFT_P== NULL || refFFT_P== NULL) {
		fprintf(stderr,"img_sar_range_compress: could not allocate space \n");
		CsInfo("img_sar_range_compress: could not allocate space");
		return(7);
	}

	mat_PP = (float**)calloc(height,sizeof(float*));
	if(mat_PP == NULL) {
		fprintf(stderr,"img_sar_range_compress: could not allocate space \n");
		CsInfo("img_sar_range_compress: could not allocate space");
		return(5);
	}
    for(i=0; i<height; i++) {
          mat_PP[i]=(float*)calloc(rangeFFTLength,sizeof(float));
	  if(mat_PP[i] == NULL) {
		fprintf(stderr,"img_sar_range_compress: could not allocate space \n");
		CsInfo("img_sar_range_compress: could not allocate space");
		return(6);
	  }
	}

	/*
	 * generate reference
	 */
//    for(j=0; j<maxRangeIndex; j++) {
    for(j=0; j<width; j++) {
        
#if 000
		c=(fIF*t);
		b=(0.5*Kr*t*t);
		rx=cos(2*PI*(c+b));

#endif
//        range=rp+(v*v*0.5/rp)*(tc+tp-taz)*(tc+tp-tazs);
#if 000
        t=dt*j+t0;
        range=rp;
		a=t-2.0*(range*1000.0/C);
		b=a*a;
		b=PI*Kr*b*1.0e12;
		c=2*PI*(fIF*t*1000000.0-(2.0*range*1000.0/lamda));
		rx=cos(c+b);
#endif
        t=dt*j;
		c=(fIF*t*1000000.0);
		b=(0.5*Kr*t*t*1e12);
		rx=cos(2*PI*(c+b));



		ref_P[j].r=rx;
		ref_P[j].i=0.0;

    }
	/*
	 * Compute FFT of Reference
	 */
  
        cap_fft(cfg,ref_P, refFFT_P);
	/*
	 * conjugate the reference
	 */
	for(i=0; i<rangeFFTLength; i++)
	      refFFT_P[i].i = - refFFT_P[i].i;

	fmin=1e22;
	fmax= -1e22;


    /*
	 * go through each row of the input matrix
	 */
	for(i=0; i<height; i++) {
               fprintf(stderr,"Processing Range for:%d\n",i);
        /*
		 * Copy range row into FFT buffer
		 */
		for(j=0; j<width; j++) {
		   range_P[j].r=img.image_PP[i][j];
           range_P[j].i=0.0;
		}
		for(j=width; j<rangeFFTLength; j++) {
		   range_P[j].r=0.0;
           range_P[j].i=0.0;
		}
#if 1111
		/*
		 * compute FFT
		 */
       cap_fft(cfg,range_P, rangeFFT_P);
#if 1111
       /*
	    * Multiply Range and Reference
		*/
       for(j=0; j<rangeFFTLength; j++) {
	     x=rangeFFT_P[j];
		 rangeFFT_P[j].r = x.r*refFFT_P[j].r-x.i*refFFT_P[j].i;
         rangeFFT_P[j].i = x.r*refFFT_P[j].i+x.i*refFFT_P[j].r;


	   }
#endif
	   /*
	    * Compute Inverse FFT or Matched Filter Response
		*/
 
//	   fprintf(stderr,"img_sar_range_compress: rangeFFTLength=%d \n",rangeFFTLength); 

	   if(control) {
	      /*
		   * use half length to generate complex compressed range rows
	       */

              cfgi=cap_fft_alloc(rangeFFTLength/2,1,NULL,NULL);
	      cap_fft(cfgi,rangeFFT_P, range_P);


	   }
	   else { 
              cfgi=cap_fft_alloc(rangeFFTLength,1,NULL,NULL);
	      cap_fft(cfgi,rangeFFT_P, range_P);
           }

#endif
#if 000
for( j=0; j<rangeFFTLength; j++) {
range_P[j].re=ref_P[j].re;
range_P[j].im=ref_P[j].im;
}
#endif
       if(control == 0 ) {

	     /*
	      * Copy into output matrix and prescale to 0--255
		  */
         for(j=0; j<rangeFFTLength; j++) {
		    a=range_P[j].r;
			if(fmax < a) fmax=a;
			if(fmin >a ) fmin=a;
	        mat_PP[i][j]=a;
	     }	
      }	else {
	     /*
		  * store real and imaginary in consecutive locations in matrix row
		  */
	  
         for(j=0; j<rangeFFTLength/2; j++) {
		    
	        mat_PP[i][2*j]=range_P[j].r;
			mat_PP[i][2*j+1]=range_P[j].i;	

		    a=range_P[j].r;
			if(fmax < a) fmax=a;
			if(fmin >a ) fmin=a;

		 }  
	  
	  }	   
	}
	fprintf(stderr,"img_sar_range_compress: fmin=%f fmax=%f \n",fmin,fmax); 

    for(j=0; j<obufs; j++) {
			  if(IT_OUT(j)){
	
				  KrnOverflow("img_sar_range_compress",j);
				  return(99);
			   }
			   img.image_PP = mat_PP;
			   img.width = rangeFFTLength;
			   img.height = height;
			   OUTIMAGE(j,0) = img;
    }
}

return(0);



break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

if(range_P) free(range_P);
if(rangeFFT_P) free(rangeFFT_P);
if(refFFT_P) free(refFFT_P);
if(ref_P) free(ref_P);


break;
}
return(0);
}
