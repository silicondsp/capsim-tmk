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
<BLOCK_NAME>filtnyq</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* filtnyq.s */
/***********************************************************************
                             filtnyq()
************************************************************************
This star performs Nyquist pulse shaping for a baseband transmitter.
See Carlson, Communications Systems, page 381, equation 17b.
The Nyquist criterion in the frequency domain is to have an amplitude
rolloff which is symmetric about Fb/2 (half baud frequency).
First, a frequency-domain amplitude response is created using a raised
cosine shape.  This computation is affected by:
Param:	1 - (int) smplbd: samples per baud interval. default=>8
	2 - (int) expfft: 2^expfft = fft length to use.  default=>8
	3 - (float) beta: filter rolloff factor, 0<beta<=.5  default=>.5
The amplitude response is changed to impulse response via inverse fft.
The impulse response is made causal by right shifting (filter delay),
and is time limited to "IMPBAUD" baud intervals (set by definition).
(This filter will cause a delay of IMPBAUD/2 baud intervals.)
Finally, the impulse response is transformed back to a frequency
response, which is used in subsequent linear convolution with the input,
which is implemented by the Fast Fourier Transform overlap-save method.
The fft length must be greater than the impulse response length;
for efficiency, a factor of two or more in length is desirable.
This implies that 2^expfft > smplbd * IMPBAUD.
Nyquist shaping has no meaning if smplbd = 1; this implies that
each sample would go through the filter unchanged!
<NAME>
filtnyq
</NAME>
<DESCRIPTION>
This star performs Nyquist pulse shaping for a baseband transmitter.
See Carlson, Communications Systems, page 381, equation 17b.
The Nyquist criterion in the frequency domain is to have an amplitude
rolloff which is symmetric about Fb/2 (half baud frequency).
First, a frequency-domain amplitude response is created using a raised
cosine shape.  This computation is affected by:
Param:	1 - (int) smplbd: samples per baud interval. default=>8
	2 - (int) expfft: 2^expfft = fft length to use.  default=>8
	3 - (float) beta: filter rolloff factor, 0<beta<=.5  default=>.5
The amplitude response is changed to impulse response via inverse fft.
The impulse response is made causal by right shifting (filter delay),
and is time limited to "IMPBAUD" baud intervals (set by definition).
(This filter will cause a delay of IMPBAUD/2 baud intervals.)
Finally, the impulse response is transformed back to a frequency
response, which is used in subsequent linear convolution with the input,
which is implemented by the Fast Fourier Transform overlap-save method.
The fft length must be greater than the impulse response length;
for efficiency, a factor of two or more in length is desirable.
This implies that 2^expfft > smplbd * IMPBAUD.
Nyquist shaping has no meaning if smplbd = 1; this implies that
each sample would go through the filter unchanged!
</DESCRIPTION>
<PROGRAMMERS>
Programmer: L.J. Faber
Date: Jan. 14, 1987
Modified: 6/88 ljfaber.  expand comments, fix flaws
Modified: 6/89 S. H. Ardalan.  
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This star performs Nyquist pulse shaping for a baseband transmitter.
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 

#include <math.h>
#include <cap_fft.h>
#include <cap_fftr.h>

]]>
</INCLUDES> 

<DEFINES> 

#define PI 3.1415926
#define IMPBAUD 12	/* # baud widths of impulse response to save */

</DEFINES> 

            

<STATES>
	<STATE>
		<TYPE>cap_fft_cpx*</TYPE>
		<NAME>nyqfresp</NAME>
	</STATE>
	<STATE>
		<TYPE>cap_fft_scalar*</TYPE>
		<NAME>temp</NAME>
	</STATE>
	<STATE>
		<TYPE>cap_fft_scalar*</TYPE>
		<NAME>temp2</NAME>
	</STATE>
	<STATE>
		<TYPE>cap_fft_scalar*</TYPE>
		<NAME>save</NAME>
	</STATE>
	<STATE>
		<TYPE>cap_fft_cpx*</TYPE>
		<NAME>freqBuffCx</NAME>
	</STATE>	
	
	<STATE>
		<TYPE>cap_fftr_cfg</TYPE>
		<NAME>preverse</NAME>
	</STATE>
	<STATE>
		<TYPE>cap_fftr_cfg</TYPE>
		<NAME>pforward</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>fftl</NAME>
                <VALUE><![CDATA[ 1 << expfft    ]]></VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>impl</NAME>
		<VALUE>IMPBAUD * smplbd</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>pcount</NAME>
		<VALUE>impl</VALUE>
	</STATE>
	<STATE>
		<TYPE>double</TYPE>
		<NAME>norm</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

   	int i;
   	int j;
	float freq;			/* fractional norm. frequency */
	float val;			/* temporary */
	int	no_samples;

</DECLARATIONS> 

         

<PARAMETERS>
<PARAM>
	<DEF>samples per baud interval.</DEF>
	<TYPE>int</TYPE>
	<NAME>smplbd</NAME>
	<VALUE>8</VALUE>
</PARAM>
<PARAM>
	<DEF>expfft: 2^expfft=fft length to use.</DEF>
	<TYPE>int</TYPE>
	<NAME>expfft</NAME>
	<VALUE>8</VALUE>
</PARAM>
<PARAM>
	<DEF><![CDATA[beta: filter rolloff factor, 0<beta<=.5 ]]></DEF>
	<TYPE>float</TYPE>
	<NAME>beta</NAME>
	<VALUE>.5</VALUE>
</PARAM>
</PARAMETERS>

    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>x</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
    

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>y</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

	if(smplbd < 2) {
	   	fprintf(stderr,"filtnyq: do not use if smplbd < 2\n");
		return(1);
	}
	if(fftl <= impl) {
	   	fprintf(stderr,"filtnyq: fft length too short\n");
		return(2);
	}
	if(beta <= 0. || beta > .5) {
	   	fprintf(stderr,"filtnyq: beta param out of range\n");
		return(3);
	}
	if( (nyqfresp = (cap_fft_cpx*)calloc(fftl,sizeof(cap_fft_cpx))) == NULL ||
	    (temp = (cap_fft_scalar*)calloc(fftl,sizeof(cap_fft_scalar))) == NULL ||
	    (temp2 = (cap_fft_scalar*)calloc(fftl,sizeof(cap_fft_scalar))) == NULL ||
	    (freqBuffCx = (cap_fft_cpx*)calloc(fftl,sizeof(cap_fft_cpx))) == NULL ||
	    (save = (cap_fft_scalar*)calloc(impl,sizeof(cap_fft_scalar))) == NULL ) {
	   	fprintf(stderr,"filtnyq: can't allocate work space\n");
		return(4);
	}

	preverse = cap_fftr_alloc(fftl, INVERSE_FFT, NULL,NULL);
	pforward = cap_fftr_alloc(fftl, FORWARD_FFT, NULL,NULL);

	/* Compute nyquist frequency response */
	/* store in `folded, real fft' form */
	/* note: frequency is normalized to unity at baud rate */
	for(i=0; i<fftl/2; i++) {
		freq = i * ((float) smplbd / fftl);
		temp[2*i+1] = 0.; /*imaginary part*/
		if(freq <= .5 - beta) temp[2*i] = smplbd;
		else if(freq >= .5 + beta) temp[2*i] = 0.;
		else {	/* frequency in rolloff region */
			val =  cos(PI * (freq -.5 + beta)/(4.* beta));
			temp[2*i] = smplbd * val*val ;
		}
	}

	for(i=0; i<fftl/2; i++) {
	      freqBuffCx[i].r=temp[2*i];
             freqBuffCx[i].i=temp[2*i+1];

       }
//	for(i=0; i<fftl/2; i++) 
 //            printf("%d %f %f\n",i, temp2[i],temp2[fftl-i]);
	/* Construct realizable, truncated impulse response */
	/* (add delay by getting samples from end of imp. resp.) */
        cap_fftri(preverse, freqBuffCx, temp);
        // rfti(temp,fftl);
	for(i=0; i<fftl; i++) {
		if(i < impl)
			temp2[i] = temp[(i + fftl - impl/2)%fftl];
		else
			temp2[i] = 0;
	}
	/* Back to frequency response form */
        cap_fftr(pforward, temp2,nyqfresp);
        // rfft(nyqfresp,fftl);
	for(i=0; i<fftl; i++)
		temp[i] = 0.;
        norm=1.0/(float)fftl;
	//norm=norm*norm;
	for(i=0; i<fftl; i++) {
		nyqfresp[i].r = nyqfresp[i].r*norm;;
		nyqfresp[i].i = nyqfresp[i].i*norm;;
        }


]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) {
		IT_IN(0);
		temp[pcount++] = x(0);
		if(pcount == fftl){
			for(i=0; i<impl; i++)
				save[i] = temp[fftl - impl + i];
                        
                        cap_fftr(pforward, temp,freqBuffCx);
        		//rfft(temp,fftl);

			cmultfftcap(freqBuffCx, nyqfresp, fftl/2,1.0);

                        cap_fftri(preverse, freqBuffCx,temp);
        		//rfti(temp,fftl);
			for(i=impl; i<fftl; i++) {
				if(IT_OUT(0)) {
					KrnOverflow("filtnyq",0);
					return(99);
				}
				y(0) = temp[i]*norm;
			}
			pcount = impl;
			for(i=0; i<impl; i++)
				temp[i] = save[i];
		}
	}

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

#if 1
	free(temp); 
	free(nyqfresp); 
	free(save); 
	free(temp2);
        free(preverse);
        free(pforward);
	free(freqBuffCx);
#endif

]]>
</WRAPUP_CODE> 



</BLOCK> 

