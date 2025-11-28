 
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

This star designs and implements a cascade form IIR digital filter.

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 

#include "dsp.h"


 

#define LOW_PASS 1
#define HIGH_PASS 2
#define BAND_PASS 3
#define BAND_STOP 4


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      float  __ycas[20];
      float  __xs[3];
      float  __ys[3];
      float  __pc1[35];
      float  __pc2[35];
      float  __zc1[35];
      float  __zc2[35];
      float  __fsamp;
      float  __wnorm;
      int  __ns;
      int  __n;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define ycas (state_P->__ycas)
#define xs (state_P->__xs)
#define ys (state_P->__ys)
#define pc1 (state_P->__pc1)
#define pc2 (state_P->__pc2)
#define zc1 (state_P->__zc1)
#define zc2 (state_P->__zc2)
#define fsamp (state_P->__fsamp)
#define wnorm (state_P->__wnorm)
#define ns (state_P->__ns)
#define n (state_P->__n)

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
#define desType (param_P[0]->value.d)
#define filterType (param_P[1]->value.d)
#define fs (param_P[2]->value.f)
#define pbdb (param_P[3]->value.f)
#define sbdb (param_P[4]->value.f)
#define fpb (param_P[5]->value.f)
#define fsb (param_P[6]->value.f)
#define fpl (param_P[7]->value.f)
#define fpu (param_P[8]->value.f)
#define fsl (param_P[9]->value.f)
#define fsu (param_P[10]->value.f)
#define filterName (param_P[11]->value.s)
/*-------------- BLOCK CODE ---------------*/
 int  

iirfil 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

   	int i,j,jj,jt;
	int status;
	int	no_samples;
	char fname[100];
        FILE *ird_F;
        int IIRCas(char* name11);
        void PzConv(char* name);


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "1=Butterworth,2=Chebyshev,3=Elliptic";
     char   *ptype0 = "int";
     char   *pval0 = "3";
     char   *pname0 = "desType";
     char   *pdef1 = "1=LowPass,2=HighPass,3=BandPass,4=BandStop";
     char   *ptype1 = "int";
     char   *pval1 = "1";
     char   *pname1 = "filterType";
     char   *pdef2 = "Sampling Frequency, Hz";
     char   *ptype2 = "float";
     char   *pval2 = "32000.0";
     char   *pname2 = "fs";
     char   *pdef3 = "Enter Passband Ripple in dB's";
     char   *ptype3 = "float";
     char   *pval3 = "0.1";
     char   *pname3 = "pbdb";
     char   *pdef4 = "Enter Stopband Attenuation in dB's";
     char   *ptype4 = "float";
     char   *pval4 = "35.0";
     char   *pname4 = "sbdb";
     char   *pdef5 = "Passband Freq. Hz/LowPass/HighPass Only";
     char   *ptype5 = "float";
     char   *pval5 = "3400.0";
     char   *pname5 = "fpb";
     char   *pdef6 = "Stopband Freq. Hz/LowPass/HighPass Only";
     char   *ptype6 = "float";
     char   *pval6 = "4400.0";
     char   *pname6 = "fsb";
     char   *pdef7 = "Lower Passband Freq. Hz/BandPass/BandStop Only";
     char   *ptype7 = "float";
     char   *pval7 = "220.0";
     char   *pname7 = "fpl";
     char   *pdef8 = "Upper Passband Freq. Hz/BandPass/BandStop Only";
     char   *ptype8 = "float";
     char   *pval8 = "3400.0";
     char   *pname8 = "fpu";
     char   *pdef9 = "Lower Stopband Freq. Hz/BandPass/BandStop Only";
     char   *ptype9 = "float";
     char   *pval9 = "10.0";
     char   *pname9 = "fsl";
     char   *pdef10 = "Upper Stopband Freq. Hz/BandPass/BandStop Only";
     char   *ptype10 = "float";
     char   *pval10 = "4400.0";
     char   *pname10 = "fsu";
     char   *pdef11 = "Filter Name";
     char   *ptype11 = "file";
     char   *pval11 = "tmp";
     char   *pname11 = "filterName";
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

 

	switch(filterType) {
	    case LOW_PASS:
		if(fpb >= fsb) {
		   fprintf(stderr,"iirfil:Low pass stop band frequency lower \
			\n than or equal to pass band. \n");
		   return(4);
		}
	 	break;
	    case HIGH_PASS:
		if(fpb <= fsb) {
		   fprintf(stderr,"iirfil:High pass stop band frequency \
			\n heigher than or equal to pass band. \n");
		   return(4);
		}
	 	break;
	    case BAND_PASS:
		if((fpl >= fpu) || (fpl <=fsl) || (fpu >= fsu) || (fsl >=fsu)){
		   fprintf(stderr,"iirfil: Band pass filter spec error.  \n");
		   return(4);
		}
		break;
	    case BAND_STOP:
		if((fpl >= fpu) || (fpl >=fsl) || (fpu <= fsu) || (fsl >=fsu)) {
		   fprintf(stderr,"iirfil: Band pass filter spec error.  \n");
		   return(4);
		}
		break;
	}
	/*
	 * Design the IIR filter.
	 * Put poles and Zeroes in file tmp.pz .
	 */
	status =IIRDesign(filterName,fs,fpb,fsb,fpl,fpu,fsl,fsu,
					pbdb,sbdb,filterType,desType);
	if (status) {
		fprintf(stderr,"Design Error in IIRDesign. \n");
		return(4);
	}
	/*
	 * Generate cascade coefficients from file tmp.pz
	 * Store in filterName.cas 
  	 */
	status=IIRCas(filterName);
	if (status) {
		fprintf(stderr,"Design Error in iircas cascade calc. \n");
		return(4);
	}
	/*
  	 * produce compact version of filterName.pz file
	 * store it in filterName.pz, i.e. overwrite filterName.pz
	 */
	PzConv(filterName);
	/*
	 * open file containing filter coefficients. Check 
	 * to see if it exists.
	 *
	 */
	strcpy(fname,filterName);
	strcat(fname,".cas");
        if( (ird_F = fopen(fname,"r")) == NULL) {
		fprintf(stderr,"iirfil: File tmp.cas could not be opened  \n");
		return(4);
	}
	/*
	 * Read in the filter coefficients and filter parameters.
	 *
	 */
         fscanf(ird_F,"%d",&ns);
      	 for (i=0; i<ns; i++) 
             {
              fscanf(ird_F,"%f",&zc1[i]); 
              fscanf(ird_F,"%f",&zc2[i]); 
	     }
      	 for (i=0; i<ns; i++) 
             {
              fscanf(ird_F,"%f",&pc1[i]); 
              fscanf(ird_F,"%f",&pc2[i]); 
	     }
         fscanf(ird_F,"%f",&fsamp);  
         fscanf(ird_F,"%f",&wnorm); 
         for (i=0; i<3; i++)
             {
              xs[i] = 0.0; 
              ys[i] = 0.0; 
             }
         for (i=0; i<20; i++){ ycas[i]=0.0;}   
              n = 0;


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


	for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) {
               IT_IN(0);
               for (j=0; j< ns; j++){
                    if (j==0){
                              xs[1]=0.0;
                              xs[2]=0.0;
                              xs[0]=x(0);
                              if (n>0) xs[1]=x(1);
                              if (n>1) xs[2]=x(2);
                             }
                    if (j>0) { 
                             for (jj=0; jj<3; jj++)
                                           xs[jj] = ys[jj];
                    }

               jt = j*3;
               for (jj=0; jj<2; jj++)  
                     ys[jj+1] = ycas[jt+jj];

               ys[0]=xs[0]+(zc1[j]*xs[1])+(zc2[j]*xs[2])-(pc1[j]*ys[1])-(pc2[j]*ys[2]);

               for (jj=0; jj<2; jj++)   
                    ycas[jt+jj] = ys[jj];
               }

               if(IT_OUT(0)) {
			KrnOverflow("iirfil",0);
			return(99);
		}
               y(0) = ys[0]/wnorm;
               n = n+1;
              }

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
