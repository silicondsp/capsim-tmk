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
<BLOCK_NAME>fconv</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* fconv.s */
/***********************************************************************
                             fconv()
************************************************************************
"Linear Convolution":
This star convolves its input signal with an impulse response to
generate the output signal.
Param.	1 - (int) impl: length of impulse response in samples.
	2 - (file) impf_name: ASCII file which holds impulse response.
	3 - (int) fftexp: log2(fft length).
Convolution is performed by the fft overlap-save method (described in
Oppenheim & Schafer, Digital Signal Processing, pp. 113).
The FFT length must be greater than the impulse response length.
For efficiency, it should probably be more than twice as long.
<NAME>
fconv
</NAME>
<DESCRIPTION>
"Linear Convolution":
This star convolves its input signal with an impulse response to
generate the output signal.
Param.	1 - (int) impl: length of impulse response in samples.
	2 - (file) impf_name: ASCII file which holds impulse response.
	3 - (int) fftexp: log2(fft length).
Convolution is performed by the fft overlap-save method (described in
Oppenheim & Schafer, Digital Signal Processing, pp. 113).
The FFT length must be greater than the impulse response length.
For efficiency, it should probably be more than twice as long.
</DESCRIPTION>
<PROGRAMMERS>
Programmer: M. R. Civanlar
Date: November 16, 1986
Modified: ljfaber, Dec86, Feb87
Modified: 6/88 ljfaber  update comments, efficiency
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This star convolves its input signal with an impulse response (from file) to generate the output signal.
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 

#include <math.h>
#include <cap_fft.h>
#include <cap_fftr.h>


]]>
</INCLUDES> 

                

<STATES>
	<STATE>
		<TYPE>cap_fft_scalar*</TYPE>
		<NAME>temp</NAME>
	</STATE>
	<STATE>
		<TYPE>cap_fft_cpx*</TYPE>
		<NAME>freqBuffCx</NAME>
	</STATE>
	<STATE>
		<TYPE>cap_fft_scalar*</TYPE>
		<NAME>temp2</NAME>
	</STATE>
	<STATE>
		<TYPE>cap_fft_cpx*</TYPE>
		<NAME>iresp</NAME>
	</STATE>
	<STATE>
		<TYPE>cap_fft_scalar*</TYPE>
		<NAME>save</NAME>
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
		<NAME>pcount</NAME>
		<VALUE>impl</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>fftl</NAME>
		<VALUE><![CDATA[ 1 << fftexp    ]]></VALUE>
	</STATE>
	<STATE>
		<TYPE>double</TYPE>
		<NAME>norm</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i;
	int no_samples;
	FILE* fp;
	float val;

</DECLARATIONS> 

         

<PARAMETERS>
<PARAM>
	<DEF>impl: length of impulse response in samples:</DEF>
	<TYPE>int</TYPE>
	<NAME>impl</NAME>
	<VALUE>128</VALUE>
</PARAM>
<PARAM>
	<DEF>(file)ASCII file which holds impulse response:</DEF>
	<TYPE>file</TYPE>
	<NAME>impf_name</NAME>
	<VALUE>imp.dat</VALUE>
</PARAM>
<PARAM>
	<DEF>log2(fft length):</DEF>
	<TYPE>int</TYPE>
	<NAME>fftexp</NAME>
	<VALUE>8</VALUE>
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

	if(impl < (2.89 * log((float)fftl) + 1))
	fprintf(stderr,"fconv: direct convolution may be faster\n");
	if(impl >= fftl) {
		fprintf(stderr,"fconv: FFT length smaller than impulse response length\n");
		return(1);
	}
	if( (temp = (cap_fft_scalar*)calloc(fftl,sizeof(cap_fft_scalar))) == NULL
	 || (iresp = (cap_fft_cpx*)calloc(fftl,sizeof(cap_fft_cpx))) == NULL
	 || (freqBuffCx = (cap_fft_cpx*)calloc(fftl,sizeof(cap_fft_cpx))) == NULL 
	 || (temp2 = (cap_fft_scalar*)calloc(fftl,sizeof(cap_fft_scalar))) == NULL
	 || (save = (cap_fft_scalar*)calloc(impl,sizeof(cap_fft_scalar))) == NULL  ) {
		fprintf(stderr,"fconv: can't allocate work space\n");
		return(2);
	}
	if((fp = fopen(impf_name,"r")) == NULL) {
		fprintf(stderr,"fconv: can't open impulse response file %s\n",impf_name);
		return(3);
	}
	for(i=0; i<impl; i++) {
		if( (fscanf(fp,"%f", &val)) != 1) {
			fprintf(stderr, "fconv: impulse response file %s too short\n",
				impf_name);
			return(4);
		}
		temp[i]=val;
		//printf("reading %d %f\n",i, temp[i]);
	}
	fclose(fp);

	preverse = cap_fftr_alloc(fftl, INVERSE_FFT, NULL,NULL);
	pforward = cap_fftr_alloc(fftl, FORWARD_FFT, NULL,NULL);
	
	
	 cap_fftr(pforward, temp,iresp);
	 for(i=0; i<fftl; i++) temp[i]=0.0;
	  norm=1.0/(float)fftl;
	 
	

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

	for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) {
		IT_IN(0);
		temp[pcount++] = x(0);
		if(pcount == fftl) {
			for(i=0; i<impl; i++)
				save[i] = temp[fftl-impl+i];
				
		        cap_fftr(pforward, temp,freqBuffCx);		
				
		//	rfft(temp,fftl);
			
			
		//	cmultfft(temp, iresp, fftl);
		
		        cmultfftcap(freqBuffCx, iresp, fftl/2,1.0);
		        cap_fftri(preverse, freqBuffCx,temp);	
			
			
			
			for(i=impl; i<fftl; i++){
				if(IT_OUT(0) ) {
					KrnOverflow("fconv",0);
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

	free(temp); free(iresp); free(save); free(temp2); free(freqBuffCx);
	
        free(preverse);
        free(pforward);
	

]]>
</WRAPUP_CODE> 



</BLOCK> 

