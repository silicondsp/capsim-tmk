 
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

Spectrum probe (plots both frequency and time domain). Float/Int/Complex input buffers.

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>


 

#define BLOCK_SIZE 1024
#define STATIC 0
#define DYNAMIC 1
#define PI 3.1415926
#define FLOAT_BUFFER 0
#define COMPLEX_BUFFER 1
#define INTEGER_BUFFER 2
#define RECTANGULAR_WINDOW 0
#define HAMMING_WINDOW 1
#define HANNING_WINDOW 2
#define BLACKMAN_WINDOW 3


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int  __numberInputBuffers;
      int  __numberOutputBuffers;
      float*  __xfreq_P;
      float*  __xTime_P;
      float*  __ypts_P;
      float*  __spect_P;
      int  __count;
      int  __totalCount;
      int  __blockOff;
      int  __bufi;
      int  __fftl;
      int  __fftexp;
      int  __plottedFlag;
      int  __displayed;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define numberInputBuffers (state_P->__numberInputBuffers)
#define numberOutputBuffers (state_P->__numberOutputBuffers)
#define xfreq_P (state_P->__xfreq_P)
#define xTime_P (state_P->__xTime_P)
#define ypts_P (state_P->__ypts_P)
#define spect_P (state_P->__spect_P)
#define count (state_P->__count)
#define totalCount (state_P->__totalCount)
#define blockOff (state_P->__blockOff)
#define bufi (state_P->__bufi)
#define fftl (state_P->__fftl)
#define fftexp (state_P->__fftexp)
#define plottedFlag (state_P->__plottedFlag)
#define displayed (state_P->__displayed)

/*         
 *    PARAMETER DEFINES 
 */ 
#define npts (param_P[0]->value.d)
#define skip (param_P[1]->value.d)
#define title (param_P[2]->value.s)
#define dbFlag (param_P[3]->value.d)
#define windFlag (param_P[4]->value.d)
#define plotStyleParam (param_P[5]->value.d)
#define timeFlag (param_P[6]->value.d)
#define sampFreq (param_P[7]->value.f)
#define control (param_P[8]->value.d)
#define bufferType (param_P[9]->value.d)
#define mode (param_P[10]->value.d)
/*-------------- BLOCK CODE ---------------*/
spectrumtxt(run_state,block_P)

	int run_state;
	block_Pt block_P;
{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int	points;
	int samples;
	int numberPoints;
    	int i,j,ii;
	float tmp;
	complex val;
	float wind;
	char title1[80];
	char fname[80];
        char curveSubTitle[80];
	float* mag_P;
	float* phase_P;
	FILE *time_F;
	FILE *freq_F;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Number of points ( dynamic window size )";
     char   *ptype0 = "int";
     char   *pval0 = "128";
     char   *pname0 = "npts";
     char   *pdef1 = "Number of points to skip";
     char   *ptype1 = "int";
     char   *pval1 = "0";
     char   *pname1 = "skip";
     char   *pdef2 = "Plot title";
     char   *ptype2 = "file";
     char   *pval2 = "Spectrum";
     char   *pname2 = "title";
     char   *pdef3 = "Linear = 0, dB = 1";
     char   *ptype3 = "int";
     char   *pval3 = "0";
     char   *pname3 = "dbFlag";
     char   *pdef4 = "Window:0= Rec.,1=Hamm,2=Hann,3=Blackman";
     char   *ptype4 = "int";
     char   *pval4 = "0";
     char   *pname4 = "windFlag";
     char   *pdef5 = "Plot Style: 1=Line,2=Points,5=Bar Chart";
     char   *ptype5 = "int";
     char   *pval5 = "1";
     char   *pname5 = "plotStyleParam";
     char   *pdef6 = "Time Domain On/Off (1/0)";
     char   *ptype6 = "int";
     char   *pval6 = "1";
     char   *pname6 = "timeFlag";
     char   *pdef7 = "Sampling Rate (Bin Number if zero,Normalized if Negative";
     char   *ptype7 = "float";
     char   *pval7 = "0";
     char   *pname7 = "sampFreq";
     char   *pdef8 = "Control: 1=On, 0=Off";
     char   *ptype8 = "int";
     char   *pval8 = "1";
     char   *pname8 = "control";
     char   *pdef9 = "Buffer type:0= Float,1= Complex, 2=Integer";
     char   *ptype9 = "int";
     char   *pval9 = "0";
     char   *pname9 = "bufferType";
     char   *pdef10 = "0=Static,1=Dynamic";
     char   *ptype10 = "int";
     char   *pval10 = "0";
     char   *pname10 = "mode";
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

      }
break;
   


/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            count=0;
       totalCount=0;
       blockOff=0;
       bufi=0;
       displayed=FALSE;

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

/* store as state the number of input/output buffers */
if((numberInputBuffers = NO_INPUT_BUFFERS()) <= 0) {
	fprintf(stderr,"spectrum: no inputs connected\n");
	return(1);
}
if(numberInputBuffers > 1) {
	fprintf(stderr,"spectrum: only one  input allowed \n");
	return(2);
}
if((numberOutputBuffers = NO_OUTPUT_BUFFERS()) > numberInputBuffers) {
	fprintf(stderr,"spectrum: too many outputs connected\n");
	return(3);
}
/*
 * Find closest power of two number 
 */
fftexp = (int) (log((float)npts)/log(2.0)+0.5);
fftl = 1 << fftexp;
if (fftl > npts ) {
	fftl = fftl/2;
	fftexp -= 1;
}
if (control && mode == DYNAMIC) {
	/*                                                      
	 * allocate arrays                                      
	 */                                                     
	xfreq_P = (float* )calloc(npts,sizeof(float));           
	xTime_P = (float* )calloc(npts,sizeof(float));           
	if( bufferType == COMPLEX_BUFFER)
		ypts_P = (float* )calloc(2*npts,sizeof(float));           
	else
		ypts_P = (float* )calloc(npts,sizeof(float));           
	spect_P = (float* )calloc(2*fftl,sizeof(float));           
	if(xfreq_P == NULL || xTime_P ==NULL || ypts_P==NULL) {
		fprintf(stderr,"spectrum: could not allocate space\n");
		return(5);
	}
} else if(control && mode == STATIC) {
	/*                                                      
	 * allocate arrays                                      
	 */                                                     
	xfreq_P = (float* )calloc(BLOCK_SIZE,sizeof(float));           
	xTime_P = (float* )calloc(BLOCK_SIZE,sizeof(float));           
	if( bufferType == COMPLEX_BUFFER)
		ypts_P = (float* )calloc(2*BLOCK_SIZE,sizeof(float));           
	else
		ypts_P = (float* )calloc(BLOCK_SIZE,sizeof(float));           
	if(xfreq_P == NULL || xTime_P ==NULL || ypts_P==NULL) {
		fprintf(stderr,"spectrum: could not allocate space\n");
		return(5);
	}
}
count = 0;
totalCount = 0;
switch(bufferType) {
	case COMPLEX_BUFFER: 
		SET_CELL_SIZE_IN(0,sizeof(complex));
		if(numberOutputBuffers == 1)
			SET_CELL_SIZE_OUT(0,sizeof(complex));
		break;
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
		fprintf(stderr,"Bad buffer type specified in spectrum \n");
		return(4);
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
				KrnOverflow("spectrum",i);
				return(99);
			}

			switch(bufferType) {
				case COMPLEX_BUFFER:
	 				OUTCX(i,0) = INCX(i,0);
					break;
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
		if(mode == STATIC)
			count=blockOff + bufi;

		bufi++;

		if (bufi == BLOCK_SIZE && mode==STATIC) {
			blockOff += BLOCK_SIZE;
			xfreq_P = (float *)realloc((char *) xfreq_P, 
				sizeof(float) * (blockOff + BLOCK_SIZE));
			xTime_P = (float *)realloc((char *) xTime_P, 
				sizeof(float) * (blockOff + BLOCK_SIZE));
			if(bufferType == COMPLEX_BUFFER) 
			    ypts_P = (float *)realloc((char *) ypts_P, 
				sizeof(float) * 2*(blockOff + BLOCK_SIZE));
			else
			    ypts_P = (float *)realloc((char *) ypts_P, 
				sizeof(float) * (blockOff + BLOCK_SIZE));
				
			bufi=0;
			if(xfreq_P == NULL || ypts_P==NULL || xTime_P==NULL) {
				fprintf(stderr,"spectrum: could not allocate space\n");
				return(6);
			}
		}

		switch(bufferType) {
			case COMPLEX_BUFFER:
				val=INCX(0,0);
          	     		ypts_P[2*count] = val.re; 
          	     		ypts_P[2*count+1] = val.im; 
				break;
			case INTEGER_BUFFER:
          	     		ypts_P[count] = INI(0,0);
				break;
			case FLOAT_BUFFER:
          	     		ypts_P[count] = INF(0,0);
				break;
		}

		if(mode == DYNAMIC)
			count++;
		
  }

} 

return(0);



break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

if(control == 0) return(0);
if((totalCount - skip) > 0 && mode ==STATIC) {
	/*
	 * compute the power of 2 number of fft points
	 */
	fftexp = (int) (log((float)count)/log(2.0)+0.5);
	fftl = 1 << fftexp;
	if (fftl > count ) {
		    fftl = fftl/2;
		    fftexp -= 1;
	}
	spect_P = (float* )calloc(2*fftl,sizeof(float));           
	xfreq_P = (float *) realloc((char *) xfreq_P, sizeof(float) *
				 (blockOff + bufi));
	xTime_P = (float *) realloc((char *) xTime_P, sizeof(float) *
				 (blockOff + bufi));
	if(bufferType == COMPLEX_BUFFER) 
		ypts_P = (float *) realloc((char *) ypts_P, sizeof(float) *
				 2*(blockOff + bufi));
	else
		ypts_P = (float *) realloc((char *) ypts_P, sizeof(float) *
				 (blockOff + bufi));
	if(xfreq_P == NULL || ypts_P==NULL || xTime_P == NULL) {
		fprintf(stderr,"spectrum: could not allocate space\n");
		return(8);
	}
for(i=0; i<fftl; i++) {
    switch(windFlag) { 
	case HAMMING_WINDOW:
		/*
		 * Hamming Window
		 */
	        wind= 0.54-0.46*cos(2.*PI*i/(fftl-1));
		break;
	case HANNING_WINDOW:
		/*
		 * Hanning Window
		 */
        	wind= 0.5*(1-cos(2.*PI*i/(fftl-1)));
		break;
	case BLACKMAN_WINDOW:
                /*
                 * Blackman Window
                 */
                wind= 0.42-0.50*cos(2.*PI*i/(fftl-1))
                          +0.08*cos(4.*PI*i/(fftl-1));
	default:	      
	        wind= 1.0;
		break;
     }
	      if(bufferType == COMPLEX_BUFFER) {
	      		spect_P[2*i]=ypts_P[2*i]*wind;
	      		spect_P[2*i+1] = ypts_P[2*i+1]*wind;
	      } else {
	      		spect_P[2*i]=ypts_P[i]*wind;
	      		spect_P[2*i+1] = 0.0;
	      }
	}
	cxfft(spect_P,&fftexp);
	if(bufferType == COMPLEX_BUFFER) {
		mag_P = (float* )calloc(fftl,sizeof(float));           
		phase_P = (float* )calloc(fftl,sizeof(float));           
		if(mag_P == NULL || phase_P ==NULL ) {
			fprintf(stderr,"spectrum: could not allocate space\n");
			return(6);
		}
	}
	for(i=0; i<fftl; i++) {
	    if(bufferType == COMPLEX_BUFFER) {
		mag_P[i]=sqrt(spect_P[2*i]*spect_P[2*i] +
				spect_P[2*i+1]*spect_P[2*i+1]);		
		if(spect_P[2*i] == 0.0)
                                        phase_P[i]= PI/2 *(spect_P[2*i+1] > 0 ? 1:-1);
                                else
                                        phase_P[i]= atan2((double)spect_P[2*i+1],(double)spect_P[2*i]);
	    } else {
		spect_P[i]=sqrt(spect_P[2*i]*spect_P[2*i] +
				spect_P[2*i+1]*spect_P[2*i+1]);		
	        if(dbFlag) {
			tmp = spect_P[i];
			if(tmp)
			spect_P[i] = 10*log10(tmp*tmp);
			else spect_P[i] = -200.0;
		 }
	    }
	     if(sampFreq>0) 
		xfreq_P[i] = i*sampFreq/fftl;
	     else if(sampFreq == 0)
		xfreq_P[i] = i;
	     else
		xfreq_P[i] = (float)i/(float)fftl;
	     if(sampFreq>0) 
		xTime_P[i] = i/sampFreq;
	     else if(sampFreq == 0)
		xTime_P[i] = (float)i;
	     else
		xTime_P[i] = (float)i;
}
{
	/*
	 * text mode, write results to file
	 */
#if 1
	strcpy(fname,title);
	strcat(fname,".tim");
	time_F = fopen(fname,"w");
        fprintf(stderr,"spectrum created file: %s \n",fname);
	strcpy(fname,title);
	strcat(fname,".fre");
	if(bufferType == COMPLEX_BUFFER) {
		fprintf(time_F,"#complex time domain \n");
		for(i=0; i<count; i++) 
			fprintf(time_F,"%e %e\n",ypts_P[2*i],ypts_P[2*i+1]);
	} else {
		for(i=0; i<count; i++) 
			fprintf(time_F,"%e %e\n",xTime_P[i],ypts_P[i]);
	}
	freq_F = fopen(fname,"w");
        fprintf(stderr,"spectrum created file: %s \n",fname);
	if(bufferType == COMPLEX_BUFFER) {
	       	fprintf(freq_F,"#Complex Frequency Response\n");
		for(i=0; i<fftl; i++) 
	        	fprintf(freq_F,"%e %e\n",spect_P[2*i],spect_P[2*i+1]);
	} else {
		for(i=0; i<fftl/2; i++) 
	        	fprintf(freq_F,"%e %e\n",xfreq_P[i],spect_P[i]);
	}
	fclose(time_F);
	fclose(freq_F);
	free(xfreq_P); 
	free(ypts_P); 
	free(xTime_P);
	free(spect_P);
#endif
}
}


break;
}
return(0);
}
