 
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

Create SAR image from parameters.

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 

#include <math.h>


 

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
      int  __maxAzimuthIndex;
      int  __maxRangeIndex;
      int  __k;
      float  __lamda;
      float  __t0;
      int  __obufs;
      float**  __mat_PP;
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
#define maxAzimuthIndex (state_P->__maxAzimuthIndex)
#define maxRangeIndex (state_P->__maxRangeIndex)
#define k (state_P->__k)
#define lamda (state_P->__lamda)
#define t0 (state_P->__t0)
#define obufs (state_P->__obufs)
#define mat_PP (state_P->__mat_PP)

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
#define rpRef (param_P[13]->value.f)
#define rp (param_P[14]->value.f)
#define tpi (param_P[15]->value.d)
/*-------------- BLOCK CODE ---------------*/


img_sar_create 

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
 

	int no_samples;
	int i,j;
	float taz;
	float range;
	float arg;
	float a,b,c;
	float rx;
	image_t		img;


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
     char   *pname13 = "rpRef";
     char   *pdef14 = "Point Range rp, kM";
     char   *ptype14 = "float";
     char   *pval14 = "840.0";
     char   *pname14 = "rp";
     char   *pdef15 = "Point Azimuth tp in index units";
     char   *ptype15 = "int";
     char   *pval15 = "1000";
     char   *pname15 = "tpi";
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
		fprintf(stderr,"img_sar_create: no output buffers\n");
		CsInfo("img_sar_create: no output buffers");
		return(2);
	}
    dt=1.0/(fs*1000000.0);
    maxRangeIndex=(int)tau*0.000001/dt;
	dtaz=(1.0/prf);
    tp=tpi*(1.0/prf);
    done=0;
    maxAzimuthIndex=(int)(total*prf);
    t=0;
    k=0;
    lamda=C/(fc*1000000.0);
	t0=2.0*rpRef*1000.0/C;
 	fprintf(stderr,"img_sar_create: width=%d height=%d\n",maxRangeIndex,maxAzimuthIndex); 
	mat_PP = (float**)calloc(maxAzimuthIndex,sizeof(float*));
	if(mat_PP == NULL) {
		fprintf(stderr,"img_sar_create: could not allocate space \n");
		CsInfo("img_sar_create: could not allocate space");
		return(5);
	}
    for(i=0; i<maxAzimuthIndex; i++) {
          mat_PP[i]=(float*)calloc(maxRangeIndex,sizeof(float));
	  if(mat_PP[i] == NULL) {
		fprintf(stderr,"img_sar_create: could not allocate space \n");
		CsInfo("img_sar_create: could not allocate space");
		return(6);
	  }
	}
    for(j=0; j<obufs; j++) 
		     SET_CELL_SIZE_OUT(j,sizeof(image_t));


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


if(done)return(0);

for(i=0; i<maxAzimuthIndex; i++) {
     taz=i*dtaz;
     for(j=0; j<maxRangeIndex; j++) {
        t=dt*j+t0;
        
        
 //       taz=(1.0/prf)*i;
 //       taz=tazs;
        range=rp+(v*v*0.5/rp)*(tc+tp-taz)*(tc+tp-taz);
		a=t-2.0*(range*1000.0/C);
		b=a*a;
		b=PI*Kr*b*1.0e12;
		c=2*PI*(fIF*t*1000000.0-(2.0*range*1000.0/lamda));
		rx=cos(c+b);
		mat_PP[i][j]=rx;


//		fprintf(stderr,"%d %f\n",k,range); 


   }
}
for(j=0; j<obufs; j++) {
			  if(IT_OUT(j)){
	
				  KrnOverflow("img_sar_create",j);
				  return(99);
			   }
			   img.image_PP = mat_PP;
			   img.width = maxRangeIndex;
			   img.height = maxAzimuthIndex;
			   OUTIMAGE(j,0) = img;
}

done=1;

return(0);



break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 



break;
}
return(0);
}
