 
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

Generates azimuth reference for SAR image processing

#endif
 
#ifdef PROGRAMMERS

Sasan Ardalan 1990

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 

#include <math.h>
#include <cap_fft.h>


 

#define  PI  3.1415926535898
#define C 299792458.00



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
      int  __maxAzimuthIndex;
      int  __k;
      float  __lamda;
      float  __t0;
      int  __obufs;
      cap_fft_cpx*  __ref_P;
      cap_fft_cpx*  __azimuth_P;
      cap_fft_cpx*  __refFFT_P;
      cap_fft_cpx*  __azimuthFFT_P;
      int  __rangeFFTLength;
      int  __azimuthFFTLength;
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
#define maxAzimuthIndex (state_P->__maxAzimuthIndex)
#define k (state_P->__k)
#define lamda (state_P->__lamda)
#define t0 (state_P->__t0)
#define obufs (state_P->__obufs)
#define ref_P (state_P->__ref_P)
#define azimuth_P (state_P->__azimuth_P)
#define refFFT_P (state_P->__refFFT_P)
#define azimuthFFT_P (state_P->__azimuthFFT_P)
#define rangeFFTLength (state_P->__rangeFFTLength)
#define azimuthFFTLength (state_P->__azimuthFFTLength)

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
#define frac (param_P[15]->value.f)
/*-------------- BLOCK CODE ---------------*/
 int  sar_azimuth_ref(int run_state,block_Pt block_P)

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
     char   *pdef15 = "T center (0.5 halfway)";
     char   *ptype15 = "float";
     char   *pval15 = "0.5";
     char   *pname15 = "frac";
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
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            phase=0.;
       t=0.;
       done=0;

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

	if( (obufs = NO_OUTPUT_BUFFERS()) < 1 ) {
		fprintf(stderr,"sar_azimuth_ref: no output buffers\n");
		CsInfo("sar_azimuth_ref: no output buffers");
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
    maxAzimuthIndex=(int)(total*prf);
	/*
	 * round maxAzimuthIndex to next power of 2
	 * Note we are dealing with Azimuth
	 * Also maxAzimuthIndex is already a power of 2 (should be)
	 */
	order = (int) (log((float)maxAzimuthIndex)/log(2.0)+0.5);
	pts = 1 << order;
	if (pts < maxAzimuthIndex ) {
        	pts = pts*2;
        	order += 1;
	}
    azimuthFFTLength=pts;
    for(j=0; j<obufs; j++) 
		     SET_CELL_SIZE_OUT(j,sizeof(float));


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 



if(done) return(0);

fprintf(stderr,"sar_azimuth_ref:  maxAzimuthIndex=%d azimuthFFTLength=%d\n",maxAzimuthIndex,azimuthFFTLength); 

	

	  ref_P=(cap_fft_cpx *)calloc(azimuthFFTLength,sizeof(cap_fft_cpx));
	  azimuth_P=(cap_fft_cpx *)calloc(azimuthFFTLength,sizeof(cap_fft_cpx));
	  refFFT_P=(cap_fft_cpx *)calloc(azimuthFFTLength,sizeof(cap_fft_cpx));
	  azimuthFFT_P=(cap_fft_cpx *)calloc(azimuthFFTLength,sizeof(cap_fft_cpx));

	  if(ref_P == NULL || azimuth_P== NULL || azimuthFFT_P== NULL || refFFT_P== NULL) {
		  fprintf(stderr,"sar_azimuth_ref: could not allocate space \n");
		  CsInfo("sar_azimuth_ref: could not allocate space");
		  return(7);
	  }


 	  /*
	   * generate azimuth reference  impulse response
	   */
      for(j=0; j<maxAzimuthIndex; j++) {
        

          taz=dtaz*j-(float)maxAzimuthIndex*frac*dtaz;
          a=0.5*Kaz*taz*taz;
		  
		  b=fDc*taz;
		  c=2*PI*(b+a);

		  ref_P[j].r=cos(c);
		  ref_P[j].i=sin(c);

       }
       for(j=maxAzimuthIndex; j<azimuthFFTLength; j++) {
        
		   ref_P[j].r=0.0;
		   ref_P[j].i=0.0;

       }

	   for(i=0; i<azimuthFFTLength; i++) {
			      if(IT_OUT(0)){
	
				     KrnOverflow("img_sar_create",0);
				     return(99);
			      }
			      OUTF(0,0) = ref_P[i].r;
				  if(obufs ==2) {
                     if(IT_OUT(1)){
	
				        KrnOverflow("img_sar_create",1);
				        return(99);
			         }
			         OUTF(1,0) = ref_P[i].i;


				  }
			  
       }
	   done=1;


return(0);



break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

if(azimuth_P) free(azimuth_P);
if(azimuthFFT_P) free(azimuthFFT_P);
if(refFFT_P) free(refFFT_P);
if(ref_P) free(ref_P);


break;
}
return(0);
}
