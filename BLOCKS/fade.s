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
<BLOCK_NAME>

fade 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* fade.s */
/***********************************************************************
                             fade()
************************************************************************
This block models multipath fading channels for mobile radio
applications.
The block accepts a complex baseband equivalent input and produces 
complex baseband equivalent samples. 
The method is based on William C. Jakes, "Microwave Mobile Communications," 
John Wiley & Sons, 1974 in particular pp. 13-65.
Multipath is modeled using the technique presented by Nader Farahati, 
"A Software Multipath Fading Channel Simulator", Technophone Limited,
July 1989. Nader Farahati is now with Scientific Generics, Cambridge
U.K. Each multipath is associated with a time delay. The time
delays are incorporated by transforming the problem into the frequency
domain.
This block first reads all samples, u(t), at its input. It then multiplies the
complex input samples by the complex fading channel amplitude with
doppler shift for path i,
ri(t),  and transforms them into the frequency domain, Yi(f). 
The various delays are
incorporated by multiplying the frequency domain data, Yi(f), by
exp{-2PIj(fc+f)ti} where fc is the carrier frequency, f is the
frequency, and ti is the time delay of the ith multipath.
The various multipaths with independent fading channel amplitudes are
added in the frequency domain and transformed back into the time domain.
The block then outputs the complex data as two channels ( in-phase and
quad-phase) in 128 sample chunks. This helps in limiting the size of
buffers. 
Note that other doppler spectrums and Rician distributions will be
supported later. The block can easily be changed.
<NAME>
fade
</NAME>
<DESCRIPTION>
This block models multipath fading channels for mobile radio
applications.
The block accepts a complex baseband equivalent input and produces 
complex baseband equivalent samples. 
The method is based on William C. Jakes, "Microwave Mobile Communications," 
John Wiley & Sons, 1974 in particular pp. 13-65.
Multipath is modeled using the technique presented by Nader Farahati, 
"A Software Multipath Fading Channel Simulator", Technophone Limited,
July 1989. Nader Farahati is now with Scientific Generics, Cambridge
U.K. Each multipath is associated with a time delay. The time
delays are incorporated by transforming the problem into the frequency
domain.
This block first reads all samples, u(t), at its input. It then multiplies the
complex input samples by the complex fading channel amplitude with
doppler shift for path i,
ri(t),  and transforms them into the frequency domain, Yi(f). 
The various delays are
incorporated by multiplying the frequency domain data, Yi(f), by
exp{-2PIj(fc+f)ti} where fc is the carrier frequency, f is the
frequency, and ti is the time delay of the ith multipath.
The various multipaths with independent fading channel amplitudes are
added in the frequency domain and transformed back into the time domain.
The block then outputs the complex data as two channels ( in-phase and
quad-phase) in 128 sample chunks. This helps in limiting the size of
buffers. 
Note that other doppler spectrums and Rician distributions will be
supported later. The block can easily be changed.
</DESCRIPTION>
<PROGRAMMERS>
Programmer: 	Sasan Ardalan	
Date: 		Dec. 27, 1990
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This block models multipath fading channels for mobile radio applications.
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 

#include <math.h>

]]>
</INCLUDES> 

<DEFINES> 

#define PI 3.1415926

</DEFINES> 

           

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>inbufs</NAME>
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
		<TYPE>float*</TYPE>
		<NAME>fftBuffer_P</NAME>
	</STATE>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>inputBuffer_P</NAME>
	</STATE>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>outputBuffer_P</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>inSampleCount</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>samplesOutput</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>wd</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int numberOfSamples;
	int i,j;
	float fd, lambda;
	double er,ei;
	float arg;
	float t;
	float env;
	float tsin,tcos;
	int	samples;

</DECLARATIONS> 

                     

<PARAMETERS>
<PARAM>
	<DEF>Number of points (preferably a power of 2)</DEF>
	<TYPE>int</TYPE>
	<NAME>npts</NAME>
	<VALUE>128</VALUE>
</PARAM>
<PARAM>
	<DEF>Doppler Spectrum, only Ez supported at this time.</DEF>
	<TYPE>int</TYPE>
	<NAME>type</NAME>
	<VALUE>0</VALUE>
</PARAM>
<PARAM>
	<DEF>Sampling Rate</DEF>
	<TYPE>float</TYPE>
	<NAME>fs</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Carrier frequency</DEF>
	<TYPE>float</TYPE>
	<NAME>fc</NAME>
	<VALUE>1000e6</VALUE>
</PARAM>
<PARAM>
	<DEF>Vehicle Velocity, m/s</DEF>
	<TYPE>float</TYPE>
	<NAME>v</NAME>
	<VALUE> 0</VALUE>
</PARAM>
<PARAM>
	<DEF>Power</DEF>
	<TYPE>float</TYPE>
	<NAME>p</NAME>
	<VALUE> 1.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Array of multipath delays microsec: number_of_paths t0 t1  ... </DEF>
	<TYPE>array</TYPE>
	<NAME>delays</NAME>
	<VALUE></VALUE>
</PARAM>
<PARAM>
	<DEF>Array of multipath powers: number_of_paths p0 p1  ... </DEF>
	<TYPE>array</TYPE>
	<NAME>powers</NAME>
	<VALUE></VALUE>
</PARAM>
<PARAM>
	<DEF><![CDATA[Number of Plane Waves arriving plane waves, N where N >=34]]></DEF>
	<TYPE>int</TYPE>
	<NAME>numberArrivals</NAME>
	<VALUE>40</VALUE>
</PARAM>
</PARAMETERS>

     

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>inPhase</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>quadPhase</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

	inbufs = NO_INPUT_BUFFERS();
	/*
 	 * extract the exponent in npts=2**fftexp 
         */
        fftexp = (int) (log((float)npts)/log(2.0)+0.5);
        fftl = 1 << fftexp;
        if (fftl > npts ) {
                    fftl = fftl/2;
                    fftexp -= 1;
        }
	if (n_delays == 0 )
	{
		fprintf(stderr,"fade: number of delays must be >= 1 \n");
		return(1);
	}
	if (n_delays != n_powers)
	{
		fprintf(stderr,"fade: number of delays dont match powers \n");
		return(2);
	}
	if ((fftBuffer_P = (float*)calloc(2*fftl,sizeof(float))) == NULL)
	{
		fprintf(stderr,"fade: can't allocate work space \n");
		return(3);
	}
	if ((inputBuffer_P = (float*)calloc(2*fftl,sizeof(float))) == NULL)
	{
		fprintf(stderr,"fade: can't allocate work space \n");
		return(4);
	}
	if ((outputBuffer_P = (float*)calloc(2*fftl,sizeof(float))) == NULL)
	{
		fprintf(stderr,"fade: can't allocate work space \n");
		return(5);
	}
	/*
	 * calculate maximum doppler shift
 	 */
	lambda= 3.e8/fc;
	fd= v/lambda;
	wd=2*PI*fd;
	inSampleCount=0;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

/*
 * Output computed complex samples in chunks of 128 samples
 * This is done after fftl number of samples have been input and processed.
 */
if(inSampleCount >= fftl) {
     if(samplesOutput >= fftl) return(0);
     for(i=0; i < 128; i++) {
	    samples=samplesOutput;
	    if(IT_OUT(0) ){
		KrnOverflow("fade",0);
		return(99);
	    }
	    if(IT_OUT(1)) {
		KrnOverflow("fade",1);
		return(99);
	    }
	    inPhase(0) = outputBuffer_P[2*samples]/fftl;
	    quadPhase(0) = outputBuffer_P[2*samples+1]/fftl;
	    samplesOutput++;
     }
     return(0);
}
/*
 * input the samples. Collect fftl number of samples before processing
 */
for (numberOfSamples = MIN_AVAIL(); numberOfSamples > 0; --numberOfSamples) {

      IT_IN(0);
      IT_IN(1);
      /*
       * store samples in inputBuffer_P
       */
      inputBuffer_P[2*inSampleCount] = INF(0,0);
      inputBuffer_P[2*inSampleCount+1] = INF(1,0);
      /*
       * keep track of the number of samples inputted up this point
       */
      inSampleCount++;
      if(inSampleCount == fftl) {
	/*
	 * fftl number of samples collected. 
	 * Compute fading channel amplitude. 
	 * Compute n_delays, the number of multipaths,  independent amplitudes.
	 * This done my chnage the phase by an offset. See Jakes(1974).
	 */
        for(j=0; j< n_delays; j++) {
	   for(samples=0; samples < inSampleCount; samples++) {
	      t=(float)samples/fs;
	      /*
	       * Compute complex mobile fading channel amplitude
	       */
	      er=0.0;
	      ei=0.0;
	      for(i=0; i<numberArrivals/2; i++) {
		 /*
		  * note the term (i+2*j)
		  * This poduces (hopefully) independent amplitues for
		  * different j's where j is the multipath number.
		  * ri(t) = er + j*ei
		  */
	         arg = wd*t*cos(2*PI*(float)i/numberArrivals) + PI*((float)(i+2*j)/numberArrivals);
	         er=er + cos(arg);
	         ei=ei + sin(arg);
	      }
	      /*
	       * powers[j] are the relative powers for each multipath
	       */	
	      er= sqrt(2.0*p*powers[j]/numberArrivals) * er;
	      ei = sqrt(2.0*p*powers[j]/numberArrivals) * ei;
	      /*
	       * form u(t)*ri(t). Store in fft buffer to be transformed
	       * into the frequency domain.
	       * note  that u(t) is stored in inputBuffer_P.
	       */
	      fftBuffer_P[2*samples] = er*inputBuffer_P[2*samples] - 
					ei*inputBuffer_P[2*samples+1]; 
	      fftBuffer_P[2*samples+1] = ei*inputBuffer_P[2*samples] + 
					er*inputBuffer_P[2*samples+1]; 
	   }
	   /*
	    * Transform into the frequency domain
	    */
	   cxfft(fftBuffer_P,&fftexp);
	      
	   /*
	    * incorporate delay by multiplying Yi(f) by
	    * exp { -j2Pi(fc +f)ti} where the ti are stored in
	    * delays[i].
	    * Also add all paths.
	    */
	   for(samples=0; samples < inSampleCount; samples++) {
	       arg = 2*PI*(fc+(float)samples*fs/(float)inSampleCount)*1.e-6*delays[j];
	       tcos=cos(arg);
	       tsin = -sin(arg);
	    
	       outputBuffer_P[2*samples] += tcos*fftBuffer_P[2*samples] -
			tsin*fftBuffer_P[2*samples+1];
	       outputBuffer_P[2*samples+1] += - (tsin*fftBuffer_P[2*samples] +
			tcos*fftBuffer_P[2*samples+1]);
	   }
	}
	/*
	 * convert to time domain
	 */
	cxifft(outputBuffer_P,&fftexp);
      }
}
return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

	/* 
	 * free up allocated space	
	 */
	free((char*)fftBuffer_P);
	free((char*)inputBuffer_P);
	free((char*)outputBuffer_P);

]]>
</WRAPUP_CODE> 



</BLOCK> 

