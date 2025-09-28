<BLOCK>
<LICENSE>
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
</LICENSE>
<BLOCK_NAME>spectrumtxt</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* spectrumtxt.s */
/**********************************************************************
                                spectrumtxt()
***********************************************************************
        inputs:         (One channel)
        outputs:        (optional feed-through of input channels)
        parameters:     int npts, the number of points to plot
                        int skip, number of points to skip before first plot
                        file title,  the title of the plot
                        dB flag (0=linear 1=dB)
                        window flag (0=Rect 1= Hamming Hanning=2 Blackman=3)
*************************************************************************
This routine will produces the time domain and frequency domain spectrum 
of the input buffer.
The first parameter represents the number of points plotted from the channel.
Default is set to (int 128).
The second parameter is the number of points to skip before the first plot set
is presented.  This enables skipping of any transient period.
Default is set to (int 0).
The third parameter represents the title for the plot.
Default is set to "PLOT".
The fourth parameter is the dB flag (0 for linear, 1 for dB );
The fifth parameter is the window flag ( 0 for Rectangular 1 for hammming)
The sixth paramter determines the plotting style.
The seventh parameter is used to turn the time domain plot on and off.
The last parameter is used to plot agains bin number , frequency, or
normalized axis.
Programmer: 	Sasan Ardalan, Ramin Nobakht
Date: 		2/16/89
Modified:	L.J. Faber 1/3/89.  Add flow through; general cleanup.
modified for Hanning & Blackman window       Ali Sadri, Oct. 11, 1991.
Modified:	Sasan Ardalan, June 3, 1993 Added Dynamic Display.
*/

]]>
</COMMENTS> 

<DESC_SHORT>
Spectrum probe (plots both frequency and time domain). Float/Int/Complex input buffers.
</DESC_SHORT>


<DEFINES> 

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

</DEFINES> 

                

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberInputBuffers</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberOutputBuffers</NAME>
	</STATE>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>xfreq_P</NAME>
	</STATE>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>xTime_P</NAME>
	</STATE>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>ypts_P</NAME>
	</STATE>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>spect_P</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>count</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>totalCount</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>blockOff</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>bufi</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>fftl</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>fftexp</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>plottedFlag</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>displayed</NAME>
		<VALUE>FALSE</VALUE>
	</STATE>
	
        
		
	
</STATES>
 
<DECLARATIONS> 

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

</DECLARATIONS> 

                         

<PARAMETERS>
<PARAM>
	<DEF>Number of points ( dynamic window size )</DEF>
	<TYPE>int</TYPE>
	<NAME>npts</NAME>
	<VALUE>128 </VALUE>
</PARAM>
<PARAM>
	<DEF>Number of points to skip</DEF>
	<TYPE>int</TYPE>
	<NAME>skip</NAME>
	<VALUE>0 </VALUE>
</PARAM>
<PARAM>
	<DEF>Plot title</DEF>
	<TYPE>file</TYPE>
	<NAME>title</NAME>
	<VALUE>Spectrum</VALUE>
</PARAM>
<PARAM>
	<DEF>Linear = 0, dB = 1</DEF>
	<TYPE>int</TYPE>
	<NAME>dbFlag</NAME>
	<VALUE>0</VALUE>
</PARAM>
<PARAM>
	<DEF>Window:0= Rec.,1=Hamm,2=Hann,3=Blackman</DEF>
	<TYPE>int</TYPE>
	<NAME>windFlag</NAME>
	<VALUE>0</VALUE>
</PARAM>
<PARAM>
	<DEF>Plot Style: 1=Line,2=Points,5=Bar Chart</DEF>
	<TYPE>int</TYPE>
	<NAME>plotStyleParam</NAME>
	<VALUE>1</VALUE>
</PARAM>
<PARAM>
	<DEF>Time Domain On/Off (1/0)</DEF>
	<TYPE>int</TYPE>
	<NAME>timeFlag</NAME>
	<VALUE>1</VALUE>
</PARAM>
<PARAM>
	<DEF>Sampling Rate (Bin Number if zero,Normalized if Negative</DEF>
	<TYPE>float</TYPE>
	<NAME>sampFreq</NAME>
	<VALUE>0</VALUE>
</PARAM>
<PARAM>
	<DEF>Control: 1=On, 0=Off</DEF>
	<TYPE>int</TYPE>
	<NAME>control</NAME>
	<VALUE>1</VALUE>
</PARAM>
<PARAM>
	<DEF>Buffer type:0= Float,1= Complex, 2=Integer</DEF>
	<TYPE>int</TYPE>
	<NAME>bufferType</NAME>
	<VALUE>0</VALUE>
</PARAM>
<PARAM>
	<DEF>0=Static,1=Dynamic</DEF>
	<TYPE>int</TYPE>
	<NAME>mode</NAME>
	<VALUE>0</VALUE>
</PARAM>
</PARAMETERS>

<INIT_CODE>
<![CDATA[ 

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

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


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
		if(mode == STATIC) {
		         
			count=blockOff + bufi;
		}

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


]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

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
		for(i=0; i<fftl  ; i++) 
			fprintf(time_F,"%e %e\n",ypts_P[2*i],ypts_P[2*i+1]);
	} else {
		for(i=0; i<fftl ; i++) 
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

]]>
</WRAPUP_CODE> 



</BLOCK> 

