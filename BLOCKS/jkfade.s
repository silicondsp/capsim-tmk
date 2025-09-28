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
<BLOCK_NAME>jkfade</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* jkfade.s */
/***********************************************************************
                             jkfade()
************************************************************************
This star models multipath fading channels for mobile radio
applications.
The star accepts a complex baseband equivalent input and produces
complex baseband equivalent samples.
The method is based on William C. Jakes, "Microwave Mobile Communications,"
John Wiley & Sons, 1974 in particular pp. 13-65.
Multipath is modeled using the technique presented by Nader Farahati,
"A Software Multipath Fading Channel Simulator", Technophone Limited,
July 1989. Nader Farahati is now with Scientific Generics, Cambridge
U.K. Each multipath is associated with a time delay. The time
delays are incorporated by transforming the problem into the frequency
domain.
This star first reads all samples, u(t), at its input. It then multiplies the
complex input samples by the complex fading channel amplitude with
doppler shift for path i,
ri(t),  and transforms them into the frequency domain, Yi(f).
The various delays are
incorporated by multiplying the frequency domain data, Yi(f), by
exp{-2PIj(fc+f)ti} where fc is the carrier frequency, f is the
frequency, and ti is the time delay of the ith multipath.
The various multipaths with independent fading channel amplitudes are
added in the frequency domain and transformed back into the time domain.
The star then outputs the complex data as two channels ( in-phase and
quad-phase) in 128 sample chunks. This helps in limiting the size of
buffers.
Note that other doppler spectrums and Rician distributions will be
supported later. The star can easily be changed.
Programmer:     Sasan Ardalan
Date:           Dec. 27, 1990
Modified:       Jeyhan Karaoguz (Time reversal and some other bugs)
Date:           June 28, 1991
*/

]]>
</COMMENTS> 
<DESC_SHORT>
This star models multipath fading channels for mobile radio applications.
</DESC_SHORT>

<INCLUDES>
<![CDATA[ 

#include <cap_fft.h>

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
		<TYPE>cap_fft_cpx*</TYPE>
		<NAME>fftBuffer_P</NAME>
	</STATE>
	<STATE>
		<TYPE>cap_fft_cpx*</TYPE>
		<NAME>inputBuffer_P</NAME>
	</STATE>
	<STATE>
		<TYPE>cap_fft_cfg</TYPE>
		<NAME>cfg</NAME>
	</STATE>
	<STATE>
		<TYPE>cap_fft_cfg</TYPE>
		<NAME>cfginv</NAME>
	</STATE>
	<STATE>
		<TYPE>cap_fft_cpx*</TYPE>
		<NAME>outputBuffer_P</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>inSampleCount</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>samplesOutput</NAME>
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
        int     samples;
        float norm;

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

     

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>inPhaseIn</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>quadPhaseIn</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
     

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
fprintf(stdout,"JKFADECAP_FFT:npts=%d fftl=%d\n",npts,fftl);
        cfg=cap_fft_alloc(fftl,0,NULL,NULL);
        cfginv=cap_fft_alloc(fftl,1,NULL,NULL);

        if (n_delays == 0 )
        {
                fprintf(stderr,"jkfade: number of delays must be >= 1 \n");
                return(1);
        }
        if (n_delays != n_powers)
        {
                fprintf(stderr,"jkfade: number of delays dont match powers \n");
                return(2);
        }
        if ((fftBuffer_P = (cap_fft_cpx*)calloc(fftl,sizeof(cap_fft_cpx))) == NULL)
        {
                fprintf(stderr,"jkfade: can't allocate work space \n");
                return(3);
        }
        if ((inputBuffer_P = (cap_fft_cpx*)calloc(fftl,sizeof(cap_fft_cpx))) == NULL)
        {
                fprintf(stderr,"jkfade: can't allocate work space \n");
                return(4);
        }
        if ((outputBuffer_P = (cap_fft_cpx*)calloc(fftl,sizeof(cap_fft_cpx))) == NULL)
        {
                fprintf(stderr,"jkfade: can't allocate work space \n");
                return(5);
        }
        /*
         * calculate maximum doppler shift
         */
        lambda= 3.e8/fc;
        fd= v/lambda;
        wd=2*PI*fd;
        inSampleCount=0;
        samplesOutput=0;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

/*
 * input the samples. Collect fftl number of samples before processing
 */
for (numberOfSamples = MIN_AVAIL(); numberOfSamples > 0; --numberOfSamples) {

      IT_IN(0);
      IT_IN(1);
      /*
       * store samples in inputBuffer_P
       */
      inputBuffer_P[inSampleCount].r = inPhaseIn(0);
      inputBuffer_P[inSampleCount].i = quadPhaseIn(0);
      /*
       * keep track of the number of samples inputted up this point
       */
      inSampleCount++;
#if 1
      if(inSampleCount == fftl) {
        /*
         * fftl number of samples collected.
         * Compute fading channel amplitude.
         * Compute n_delays, the number of multipaths,  independent amplitudes.
         * This is done by changing the phase by an offset. See Jakes(1974).
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
                 arg = wd*t*cos(2*PI*(float)i/numberArrivals) +
                                             PI*((float)(i+2*j)/numberArrivals);
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
              fftBuffer_P[samples].r = er*inputBuffer_P[samples].r -
                                        ei*inputBuffer_P[samples].i;
              fftBuffer_P[samples].i = ei*inputBuffer_P[samples].r +
                                        er*inputBuffer_P[samples].i;
           }
           /*
            * Transform into the frequency domain
            */
           cap_fft(cfg,fftBuffer_P,inputBuffer_P);
           for(i=0; i<fftl; i++)
                            fftBuffer_P[i]=inputBuffer_P[i];

           /*
            * incorporate delay by multiplying Yi(f) by
            * exp { -j2Pi(fc +f)ti} where the ti are stored in
            * delays[i].
            * Also add all paths.
            */
           for(samples=0; samples < inSampleCount; samples++) {
               arg = 2*PI*(fc+(float)samples*fs/(float)inSampleCount)*1.e-6*delays[j];
               tcos = cos(arg);
               tsin = sin(arg);

               outputBuffer_P[samples].r += (tcos*fftBuffer_P[samples].r -
                        tsin*fftBuffer_P[samples].i);
               outputBuffer_P[samples].i += (tsin*fftBuffer_P[samples].r +
                        tcos*fftBuffer_P[samples].i);
           }
        }
        /*
         * convert to time domain
         */
         cap_fft(cfginv,outputBuffer_P,inputBuffer_P);
           for(i=0; i<fftl; i++)
                            outputBuffer_P[i]=inputBuffer_P[i];
         //cxifft(outputBuffer_P,&fftexp);
         norm=1.0/(float)fftl;
         while(samplesOutput < fftl) {
                for(i=0; i < 128; i++) {
                        samples=samplesOutput;
                        IT_OUT(0);
                        IT_OUT(1);
                        inPhase(0) = outputBuffer_P[samples].r*norm;
                        quadPhase(0) = outputBuffer_P[samples].i*norm;
                        samplesOutput++;
                 }
          }
	inSampleCount=0;

      }
#endif
}
return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

        /*
         * free up allocated space
         */
        free((cap_fft_cpx*)fftBuffer_P);
        free((cap_fft_cpx*)inputBuffer_P);
        free((cap_fft_cpx*)outputBuffer_P);

]]>
</WRAPUP_CODE> 



</BLOCK> 

