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
<BLOCK_NAME>autoxcorr</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* autoxcorr.s */
/***********************************************************************
                             autoxcorr()
************************************************************************
If one input then compute autocorrelation.
If two inputs then compute crosscorrelation.
************************************************************************
Programmer: 	Sasan H. Ardalan	
Date: 		January 4, 1991
<NAME>
autoxcorr
</NAME>
<DESCRIPTION>
If one input then compute autocorrelation.
If two inputs then compute crosscorrelation.
</DESCRIPTION>
<PROGRAMMERS>
Programmer: 	Sasan H. Ardalan	
Date: 		January 4, 1991
</PROGRAMMERS>
*/

]]>
</COMMENTS> 


<DESC_SHORT>
If one input then compute autocorrelation. If two inputs then compute crosscorrelation.
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
		<TYPE>int</TYPE>
		<NAME>fftLength</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>fftexp</NAME>
	</STATE>
	<STATE>
		<TYPE>cap_fft_scalar*</TYPE>
		<NAME>fftBuffer</NAME>
	</STATE>
	<STATE>
		<TYPE>cap_fft_scalar*</TYPE>
		<NAME>fftBuffer2</NAME>
	</STATE>
	<STATE>
		<TYPE>cap_fft_scalar*</TYPE>
		<NAME>temp</NAME>
	</STATE>
	<STATE>
		<TYPE>cap_fft_cpx*</TYPE>
		<NAME>freqBuff</NAME>
	</STATE>
	<STATE>
		<TYPE>cap_fft_cpx*</TYPE>
		<NAME>freqBuff2</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>sampleCount</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberOfInputBuffers</NAME>
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

	int no_samples;
	int i,j;
	float	tmpReal;
	float	temp2;

</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF>Number of samples</DEF>
	<TYPE>int</TYPE>
	<NAME>npts</NAME>
	<VALUE>128</VALUE>
</PARAM>
</PARAMETERS>

    

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>y</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

/*
 * compute the power of 2 number of fft points
 */
fftexp = (int) (log((float)npts)/log(2.0)+0.5);
fftLength = 1 << fftexp;
if (fftLength > npts ) {
        fftLength = fftLength/2;
        fftexp -= 1;
}
if((numberOfInputBuffers = NO_INPUT_BUFFERS()) > 2) {
     fprintf(stderr,"autoxcorr: no input buffers\n");
     return(3);
}
if (fftLength < 8) {
	fprintf(stderr,"autocorr: fft length is too short \n");
	return(1);
}
if ((fftBuffer = (cap_fft_scalar*)calloc(fftLength,sizeof(cap_fft_scalar))) == NULL) {
	fprintf(stderr,"autoxcorr: can't allocate work space \n");
	return(2);
}
if ((freqBuff = (cap_fft_cpx*)calloc(fftLength,sizeof(cap_fft_cpx))) == NULL) {
	fprintf(stderr,"autoxcorr: can't allocate work space \n");
	return(3);
}
if(numberOfInputBuffers == 2) {  
	if ((fftBuffer2 = (cap_fft_scalar*)calloc(fftLength,sizeof(cap_fft_scalar))) == NULL) {
	   fprintf(stderr,"autoxcorr: can't allocate work space \n");
	   return(4);
	}
	if ((freqBuff2 = (cap_fft_cpx*)calloc(fftLength,sizeof(cap_fft_cpx))) == NULL) {
	fprintf(stderr,"autoxcorr: can't allocate work space \n");
	return(5);
	}
}
if ((temp = (cap_fft_scalar*)calloc(fftLength,sizeof(cap_fft_scalar))) == NULL) {
	fprintf(stderr,"autoxcorr: can't allocate work space \n");
	return(6);
}

norm=1.0/(float)fftLength;
norm=norm*norm*2.;


	preverse = cap_fftr_alloc(fftLength, INVERSE_FFT, NULL,NULL);
	pforward = cap_fftr_alloc(fftLength, FORWARD_FFT, NULL,NULL);

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

for (no_samples = MIN_AVAIL(); no_samples > 0; --no_samples) {

		/* 
		 * read in input value	
		 */
		if(numberOfInputBuffers == 1) { 
			IT_IN(0);
			fftBuffer[sampleCount] = INF(0,0);
		}
		else {
			IT_IN(0);
			fftBuffer[sampleCount] = INF(0,0);
			IT_IN(1);
			fftBuffer2[sampleCount] = INF(1,0);
		}
		sampleCount++;

		/* 
		 * Get enough points				
		 */
		if(sampleCount >= fftLength)
		{
			/* 
			 * perform fft calculation		
			 */
			 
		cap_fftr(pforward, fftBuffer,freqBuff);	 
			 
		//	rfft(fftBuffer,fftLength);
		
		

		if(numberOfInputBuffers == 1) { 
			    /*
			     * compute X(k)X*(k)
			     */
 
			    cmultfftcap(freqBuff, freqBuff, fftLength, 1.0);

			} else {
			
		        
		             cap_fftr(pforward, fftBuffer2,freqBuff2);
		        
		//		     rfft(fftBuffer2,fftLength);

				
			
			
			    /*
			     * compute X(k)Y*(k)
			     */
			     
			    cmultfftcap(freqBuff, freqBuff2, fftLength, 1.0);
			     

			}
			
			cap_fftri(preverse, freqBuff, fftBuffer);

			// rfti(fftBuffer,fftLength);
			
			/* 
			 * now, output samples			
			 */
            for (i=0; i<fftLength; i++)
			{
				if(IT_OUT(0)) {
					KrnOverflow("autoxcorr",0);
					return(99);
				}
				y(0) = fftBuffer[i]*norm;
			}


			sampleCount = 0;
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
	free((char*)fftBuffer);
	free((char*)freqBuff);
        if(numberOfInputBuffers == 2) {  
		free((char*)fftBuffer2);
		free((char*)freqBuff2);
        }
    
        free(preverse);
        free(pforward);


]]>
</WRAPUP_CODE> 



</BLOCK> 

