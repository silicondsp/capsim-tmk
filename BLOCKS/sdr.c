 
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

Compute signal to distortion ratio

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 
#include <cap_fft.h>
#include <TCL/tcl.h>


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int  __ibufs;
      int  __obufs;
      float*  __xpts;
      float*  __ypts;
      float*  __spect;
      cap_fft_cpx*  __cxinBuff;
      cap_fft_cpx*  __cxoutBuff;
      cap_fft_cfg  __cfg;
      int  __count;
      int  __total_count;
      int  __fftl;
      int  __fftexp;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define ibufs (state_P->__ibufs)
#define obufs (state_P->__obufs)
#define xpts (state_P->__xpts)
#define ypts (state_P->__ypts)
#define spect (state_P->__spect)
#define cxinBuff (state_P->__cxinBuff)
#define cxoutBuff (state_P->__cxoutBuff)
#define cfg (state_P->__cfg)
#define count (state_P->__count)
#define total_count (state_P->__total_count)
#define fftl (state_P->__fftl)
#define fftexp (state_P->__fftexp)

/*         
 *    PARAMETER DEFINES 
 */ 
#define npts (param_P[0]->value.d)
#define skip (param_P[1]->value.d)
#define sdrRes (param_P[2]->value.s)
#define windFlag (param_P[3]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  sdr(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int samples;
    	int i,j;
	float tmp;
	float wind;
	char title1[80];
  	float sdr,sdrdB;
        float norm;
	char theName[100];
#ifdef TCL_SUPPORT
        Tcl_Obj *varNameObj_P;
        Tcl_Obj *objVar_P;
#endif

switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Number of points to collect";
     char   *ptype0 = "int";
     char   *pval0 = "";
     char   *pname0 = "npts";
     char   *pdef1 = "Number of points to skip";
     char   *ptype1 = "int";
     char   *pval1 = "";
     char   *pname1 = "skip";
     char   *pdef2 = "File to store SDR results";
     char   *ptype2 = "file";
     char   *pval2 = "";
     char   *pname2 = "sdrRes";
     char   *pdef3 = "Window: 0=Rect., 1=Hamming";
     char   *ptype3 = "int";
     char   *pval3 = "0";
     char   *pname3 = "windFlag";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);
KrnModelParam(indexModel88,3 ,pdef3,ptype3,pval3,pname3);

      }
break;
   


/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            count=0;
       total_count=0;

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

        /*                                                      
         * allocate arrays                                      
         */                                                     
        xpts = (float* )calloc(npts,sizeof(float));           
        ypts = (float* )calloc(npts,sizeof(float));           
	if(ibufs > 1) {
		fprintf(stderr,"plot: only one  input allowed \n");
		return(5);
	}
	/* store as state the number of input/output buffers */
	if((ibufs = NO_INPUT_BUFFERS()) <= 0) {
		fprintf(stderr,"plot: no inputs connected\n");
		return(2);
	}
	if((obufs = NO_OUTPUT_BUFFERS()) > ibufs) {
		fprintf(stderr,"plot: too many outputs connected\n");
		return(3);
	}
        /*
	 * compute the power of 2 number of fft points
	 */
	fftexp = (int) (log((float)npts)/log(2.0)+0.5);
	fftl = 1 << fftexp;
	if (fftl > npts ) {
		fftl = fftl/2;
		fftexp -= 1;
	}
        spect = (float* )calloc(2*fftl,sizeof(float));           
        cfg=cap_fft_alloc(fftl,0,NULL,NULL);
        if ((cxinBuff = (cap_fft_cpx*)calloc(fftl,sizeof(cap_fft_cpx))) == NULL)
        {
                fprintf(stderr,"cmxfft: can't allocate work space \n");
                return(6);
        }
        if ((cxoutBuff = (cap_fft_cpx*)calloc(fftl,sizeof(cap_fft_cpx))) == NULL)
        {
             fprintf(stderr,"cmxfft: can't allocate work space \n");
             return(7);
        }



break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


	for(samples = MIN_AVAIL(); samples > 0; --samples) {
		for(i=0; i<ibufs; ++i) {
	   		IT_IN(i);
			if(obufs > i) {
				if(IT_OUT(i)) {
					KrnOverflow("sdr",i);
					return(99);
				}
	 			OUTF(i,0) = INF(i,0);
			}
	        }

		if(++total_count > skip) {
			for(i=0; i<ibufs; ++i)
           			ypts[npts*i+count] = INF(i,0);

			xpts[count] = total_count - 1;

     			if(++count >= npts) {
                            norm=1.0/(float)fftl;
			    for(i=0; i<fftl; i++) {
			        if(windFlag == 1) 
				/*
				 * Hamming Window
				 */
				  wind= 0.54-0.46*cos(2.*3.1415926*i/(fftl-1));
				else 
				  wind= 1.0;
				       
				cxinBuff[i].r=ypts[i]*wind*norm;
				cxinBuff[i].i = 0.0;
				}

                                cap_fft(cfg,cxinBuff,cxoutBuff);
                                for(i=0; i< fftl; i++) {
                                       spect[2*i]=cxoutBuff[i].r*norm;
                                       spect[2*i+1]=cxoutBuff[i].i*norm;

                                }
				calsdr(spect,&sdr,fftl,sdrRes);
  				if (sdr) sdrdB = 10.*log10(sdr);
 				   else sdrdB = -200.0;
 				fprintf(stderr,"SDR = %e %e (dB) \n",sdr,sdrdB);
				count = 0;
#ifdef TCL_SUPPORT				
     if(krn_TCL_Interp) {

				sprintf(theName,"%s_var",STAR_NAME);
	                        varNameObj_P=Tcl_NewStringObj(theName, strlen(theName));
	                        objVar_P=Tcl_NewObj();
	                        Tcl_SetDoubleObj(objVar_P,sdr);
	                        Tcl_ObjSetVar2(krn_TCL_Interp,varNameObj_P,NULL,objVar_P,TCL_NAMESPACE_ONLY);
       }
#endif				
				
			}
		}
	}

	return(0);



break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 
       free((cap_fft_cpx*)cxinBuff);
        free((cap_fft_cpx*)cxoutBuff);
        free((char*)spect);
                                                                                



break;
}
return(0);
}
