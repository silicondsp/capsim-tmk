 
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
    Las Vegas, Nevada
*/

#endif
 
#ifdef SHORT_DESCRIPTION

This routine produces the spectrogram of the input buffer.

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 

#include "dsp.h"


 

#define FLOAT_BUFFER 0
#define INTEGER_BUFFER 1
#define RECTANGULAR_WINDOW 0
#define HAMMING_WINDOW 1
 
#define BLOCK_SIZE 512


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
       int   __numberInputBuffers;
       int   __numberOutputBuffers;
       float*   __xpts;
       float*   __xTime_P;
       float*   __ypts;
       float*   __spect_P;
       int   __count;
       int   __totalCount;
       int   __blockOff;
       int   __bufi;
       float   __dx;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define  numberInputBuffers  (state_P->__numberInputBuffers)
#define  numberOutputBuffers  (state_P->__numberOutputBuffers)
#define  xpts  (state_P->__xpts)
#define  xTime_P  (state_P->__xTime_P)
#define  ypts  (state_P->__ypts)
#define  spect_P  (state_P->__spect_P)
#define  count  (state_P->__count)
#define  totalCount  (state_P->__totalCount)
#define  blockOff  (state_P->__blockOff)
#define  bufi  (state_P->__bufi)
#define  dx  (state_P->__dx)

/*         
 *    PARAMETER DEFINES 
 */ 
#define npts (param_P[0]->value.d)
#define skip (param_P[1]->value.d)
#define windowLength (param_P[2]->value.d)
#define overlap (param_P[3]->value.d)
#define zeropad (param_P[4]->value.d)
#define threshold (param_P[5]->value.f)
#define samplingRate (param_P[6]->value.f)
#define windowType (param_P[7]->value.d)
#define dBFlag (param_P[8]->value.d)
#define surfaceFlag (param_P[9]->value.d)
#define imageFlag (param_P[10]->value.d)
#define spectTitle (param_P[11]->value.s)
#define colorMapFile (param_P[12]->value.s)
#define fileFlag (param_P[13]->value.d)
#define timeFlag (param_P[14]->value.d)
#define control (param_P[15]->value.d)
#define bufferType (param_P[16]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  
spectrogramtxt
(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

       
	int samples;
	int numberPoints;
    	int i,j,ii;
	float tmp;
	complex val;
	int numberOfPoints;
	float wind;
	char title1[80];
	char fname[80];
        char curveSubTitle[80];
	float* mag_P;
	float* phase_P;
	FILE *time_F;
	FILE *freq_F;
	
	dsp_floatMatrix_Pt image_P;
	doubleVector_Pt vec_P;
	
	
	



switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = " Number of points ";
     char   *ptype0 = "int";
     char   *pval0 = "128";
     char   *pname0 = "npts";
     char   *pdef1 = " Number of points to skip ";
     char   *ptype1 = "int";
     char   *pval1 = "0";
     char   *pname1 = "skip";
     char   *pdef2 = " Window size (samples) ";
     char   *ptype2 = "int";
     char   *pval2 = "128";
     char   *pname2 = "windowLength";
     char   *pdef3 = " Overlap (samples) ";
     char   *ptype3 = "int";
     char   *pval3 = "0";
     char   *pname3 = "overlap";
     char   *pdef4 = " Zero padding (samples) ";
     char   *ptype4 = "int";
     char   *pval4 = "0";
     char   *pname4 = "zeropad";
     char   *pdef5 = " Threshold (DB) ";
     char   *ptype5 = "float";
     char   *pval5 = "40";
     char   *pname5 = "threshold";
     char   *pdef6 = " Sampling Rate (KHz) ";
     char   *ptype6 = "float";
     char   *pval6 = "8";
     char   *pname6 = "samplingRate";
     char   *pdef7 = " Window:0= Rec.,1=Hamming ";
     char   *ptype7 = "int";
     char   *pval7 = "1";
     char   *pname7 = "windowType";
     char   *pdef8 = " Linear = 0, dB = 1 ";
     char   *ptype8 = "int";
     char   *pval8 = "1";
     char   *pname8 = "dBFlag";
     char   *pdef9 = " Surface Plot: 1=True 0=False ";
     char   *ptype9 = "int";
     char   *pval9 = "0";
     char   *pname9 = "surfaceFlag";
     char   *pdef10 = " Image: 1=True 0=False ";
     char   *ptype10 = "int";
     char   *pval10 = "1";
     char   *pname10 = "imageFlag";
     char   *pdef11 = " Plot title ";
     char   *ptype11 = "file";
     char   *pval11 = "Spectrogram";
     char   *pname11 = "spectTitle";
     char   *pdef12 = " Color Map File ";
     char   *ptype12 = "file";
     char   *pval12 = "ther.map";
     char   *pname12 = "colorMapFile";
     char   *pdef13 = " File Flag: 1=True 0=False ";
     char   *ptype13 = "int";
     char   *pval13 = "1";
     char   *pname13 = "fileFlag";
     char   *pdef14 = " Time Domain On/Off (1/0) ";
     char   *ptype14 = "int";
     char   *pval14 = "1";
     char   *pname14 = "timeFlag";
     char   *pdef15 = " Control: 1=On, 0=Off ";
     char   *ptype15 = "int";
     char   *pval15 = "1";
     char   *pname15 = "control";
     char   *pdef16 = " Buffer type:0= Float,1=Integer ";
     char   *ptype16 = "int";
     char   *pval16 = "0";
     char   *pname16 = "bufferType";
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
KrnModelParam(indexModel88,16 ,pdef16,ptype16,pval16,pname16);

      }
break;
   


/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
             count = 0 ;
        totalCount = 0 ;
        blockOff = 0 ;
        bufi = 0 ;

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

/* store as state the number of input/output buffers */
if((numberInputBuffers = NO_INPUT_BUFFERS()) <= 0) {
	fprintf(stderr,"spectrogramtxt: no inputs connected\n");
	return(1);
}
if(numberInputBuffers > 1) {
	fprintf(stderr,"spectrogramtxt: only one  input allowed \n");
	return(2);
}
if((numberOutputBuffers = NO_OUTPUT_BUFFERS()) > numberInputBuffers) {
	fprintf(stderr,"spectrogramtxt: too many outputs connected\n");
	return(3);
}
if(samplingRate)
	dx=1.0/samplingRate;
else
	dx=1.0;
if (control) {
	/*                                                      
	 * allocate arrays                                      
	 */                                                     
	xpts = (float* )calloc(BLOCK_SIZE,sizeof(float));           
	ypts = (float* )calloc(BLOCK_SIZE,sizeof(float));           
	if(xpts==NULL  || ypts ==NULL) {
		fprintf(stderr,"Spectrogramtxt could not allocate space\n");
		return(4);
	}
}
count = 0;
totalCount = 0;
switch(bufferType) {
	case FLOAT_BUFFER: 
		SET_CELL_SIZE_IN(0,sizeof(float));
		if(numberOutputBuffers == 1)
			SET_CELL_SIZE_OUT(0,sizeof(float));
		break;
	case INTEGER_BUFFER: 
		SET_CELL_SIZE_IN(0,sizeof(int));
		if(numberOutputBuffers == 1)
			SET_CELL_SIZE_OUT(0,sizeof(int));
		break;
	default: 
		fprintf(stderr,"Bad buffer type specified in spectrogramtxt \n");
		return(5);
		break;
}


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


for(samples = MIN_AVAIL(); samples > 0; --samples) {

  for(i=0; i<numberInputBuffers; ++i) {
   		IT_IN(i);
		if(numberOutputBuffers > i) {
			if(IT_OUT(i)) {
				KrnOverflow("spectrogram",i);
				return(99);
			}

			switch(bufferType) {
				case INTEGER_BUFFER:
	 				OUTI(i,0) = INI(i,0);
					break;
				case FLOAT_BUFFER:
	 				OUTF(i,0) = INF(i,0);
					break;
			}

		}
  }
  if(++totalCount > skip && control ) {
		count=blockOff + bufi;
		bufi++;
		if (bufi == BLOCK_SIZE) {
			blockOff += BLOCK_SIZE;
			xpts = (float *)realloc((char *) xpts, 
				sizeof(float) * (blockOff + BLOCK_SIZE));
			ypts = (float *)realloc((char *) ypts, 
				sizeof(float) * (blockOff + BLOCK_SIZE));
			bufi=0;
		}
		if(xpts == NULL || ypts==NULL) {
			fprintf(stderr,"spectrogram: could not allocate space\n");
			return(6);
		}

		switch(bufferType) {
			case INTEGER_BUFFER:
          	     		ypts[count] = INI(0,0);
				break;
			case FLOAT_BUFFER:
          	     		ypts[count] = INF(0,0);
				break;
		}
		xpts[count]=count*dx;

		
  }

} 

return(0);



break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

if(control == 0) return(0);
if((totalCount - skip) > 0 ) {
//printf("Spectrogram  0000\n");
   /*
    * callup the plot routine 
    */
   
	/*
	 * if in graphic mode callup iip
	 */
	 xpts = (float *) realloc((char *) xpts, sizeof(float) *
				 (blockOff + bufi));
	 ypts = (float *) realloc((char *) ypts, sizeof(float) *
				 (blockOff + bufi));
	if(xpts == NULL || ypts==NULL) {
		fprintf(stderr,"spectrogram: could not allocate space\n");
		return(6);
	}
	
//	sprintf(title1,"%s_%s.img",spectTitle,SNAME(0));
   sprintf(title1,"%s.img",spectTitle );
	numberOfPoints=(blockOff + bufi);
	
	printf("Spectrogram Title=%s Number of Points=%d \n",title1,numberOfPoints);
	
	
	 
	vec_P= Dsp_AllocateVector( numberOfPoints);
	for(i=0; i< numberOfPoints; i++) {
	       vec_P->vector_P[i]=ypts[i];
	}
//	printf("Spectrogram  222\n");
				
	image_P=Dsp_Spectrogram(vec_P,windowLength,overlap,zeropad,samplingRate,
	         windowType,threshold,surfaceFlag,imageFlag,dBFlag,fileFlag,title1);
	         
//	 printf("Spectrogram  3333\n");        			
	sprintf(title1,"%s.tif",spectTitle );
	
//	printf("Spectrogram  44444\n");
				
	fprintf(stderr,"spectrogramtxt to produce %d x  %d TIFF image file\n",image_P->width,image_P->height);
	
	printf("Spectrogram  Creating TIFF File:%s\n",title1);
	
	if(IIP_WriteMatrixTIFFText(image_P->matrix_PP,image_P->width,image_P->height,title1,colorMapFile)) {
                fprintf(stderr,"spectrogramtxt: can't write TIFF image\n");
                return(4);
    }			
    printf("Spectrogram  Done Writing TIFF File\n");
				
	
    
}


break;
}
return(0);
}
