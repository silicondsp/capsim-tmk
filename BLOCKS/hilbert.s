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
<BLOCK_NAME>hilbert</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* hilbert.s */
/***********************************************************************
                             hilbert()
************************************************************************
"Discrete Hilbert Transform":
Reference:
A.V. Oppenheim amd R. W. Schafer,"Digital Signal
Processing",pp 360-363,Prentice-Hall,1974 
A Blackman window is used in the design.
It then uses the overlap save method for fast convolution to model the
hilbert transform impulse response.
The parameters are as follows:
Param.	1 - (int) implexp: log2 [ length of impulse response in samples].
Note: The larger the length, the better the approximation. However, the
simulation efficiency suffers considerably.
Convolution is performed by the fft overlap-save method (described in
Oppenheim & Schafer, Digital Signal Processing, pp. 113).
The FFT length must be greater than the impulse response length.
For efficiency, it should probably be more than twice as long.
<NAME>
hilbert
</NAME>
<DESCRIPTION>
"Discrete Hilbert Transform":
Reference:
A.V. Oppenheim amd R. W. Schafer,"Digital Signal
Processing",pp 360-363,Prentice-Hall,1974 
A Blackman window is used in the design.
It then uses the overlap save method for fast convolution to model the
hilbert transform impulse response.
The parameters are as follows:
Param.	1 - (int) implexp: log2 [ length of impulse response in samples].
Note: The larger the length, the better the approximation. However, the
simulation efficiency suffers considerably.
Convolution is performed by the fft overlap-save method (described in
Oppenheim & Schafer, Digital Signal Processing, pp. 113).
The FFT length must be greater than the impulse response length.
For efficiency, it should probably be more than twice as long.
</DESCRIPTION>
<PROGRAMMERS>
Programmer: Sasan H. Ardalan, Overlap-save method by M. R. Civanlar
Date: July 26, 1990
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
Discrete Hilbert Transform
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
#define TWO_OVER_PI 0.63661977

</DEFINES> 

            

<STATES>
	<STATE>
		<TYPE>cap_fft_scalar*</TYPE>
		<NAME>temp</NAME>
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
		<TYPE>cap_fft_cpx*</TYPE>
		<NAME>freqBuffCx</NAME>
	</STATE>
	<STATE>
		<TYPE>cap_fft_scalar*</TYPE>
		<NAME>save</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>pcount</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>fftl</NAME>
		<VALUE><![CDATA[ 1 << fftexp    ]]></VALUE>
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
		<TYPE>double</TYPE>
		<NAME>norm</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i,k;
	float	anarg,imp_del,tmp,argval,window;
	int no_samples;
	char impResponseFile[200];
	int	impFlag;
	FILE* fp;

</DECLARATIONS> 

         

<PARAMETERS>
<PARAM>
	<DEF>length of Hilbert transform impulse response</DEF>
	<TYPE>int</TYPE>
	<NAME>impl</NAME>
	<VALUE>17</VALUE>
</PARAM>
<PARAM>
	<DEF><![CDATA[bandwidth (0 < BW <= 0.5)]]></DEF>
	<TYPE>float</TYPE>
	<NAME>fbw</NAME>
	<VALUE>0.5</VALUE>
</PARAM>
<PARAM>
	<DEF>log2(fft length)</DEF>
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

pcount = impl;
/*
 * allocate necessary storage
 */
if( (temp = (cap_fft_scalar*)calloc(fftl,sizeof(cap_fft_scalar))) == NULL
	 || (temp2 = (cap_fft_scalar*)calloc(fftl,sizeof(cap_fft_scalar))) == NULL
	 || (iresp = (cap_fft_cpx*)calloc(fftl,sizeof(cap_fft_cpx))) == NULL
	 || (freqBuffCx = (cap_fft_cpx*)calloc(fftl,sizeof(cap_fft_cpx))) == NULL
	 || (save = (cap_fft_scalar*)calloc(impl,sizeof(cap_fft_scalar))) == NULL  ) {
	fprintf(stderr,"hilbert: can't allocate work space\n"); 
	return(2);
}
imp_del=(float)impl/2.0-0.5;
for( i=0; i< impl; i++) {
	anarg=(float)i-imp_del;
	if(anarg != 0.0)
	{
		tmp = sin( fbw * PI * anarg);
		argval = 2*PI*(float)i/(float)(impl-1);
		/*
		 * Blackman window
		 */
		window= 0.42 -0.5*cos(argval) + 0.08*cos(2*argval);
		temp[i] = TWO_OVER_PI*tmp*tmp/anarg*window; 
	}
	else
		temp[i] = 0.0;
}

	preverse = cap_fftr_alloc(fftl, INVERSE_FFT, NULL,NULL);
	pforward = cap_fftr_alloc(fftl, FORWARD_FFT, NULL,NULL);
	
	
	
	cap_fftr(pforward, temp,iresp);
        norm=1.0/(float)fftl;
	
	
	
	

    // rfft(iresp, fftl);

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
				
				
				
	//		rfft(temp,fftl);
	        cmultfftcap(freqBuffCx, iresp, fftl/2,1.0);
	
	//		cmultfft(temp, iresp, fftl);
	        cap_fftri(preverse, freqBuffCx,temp);
	//		rfti(temp,fftl);
			for(i=impl; i<fftl; i++){
				if(IT_OUT(0)) {
					KrnOverflow("hilbert",0);
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

