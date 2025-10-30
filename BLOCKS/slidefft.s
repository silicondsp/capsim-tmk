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
<BLOCK_NAME>slidefft</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* slidefft.s */
/***********************************************************************
                             slidefft()
************************************************************************
	Inputs:		x complex
	Outputs:	y, the fft of the signal complex
	Parameters:	int inpts  	the fft length
			int M      	delay between windows 
			int windowType  window type before fft
************************************************************************
This block computes the ONE-SIDED FFT of a complex stream which is
overlapped by an amount of (fftl-M) samples for each FFT computation. 
It outputs ((int)((totalNumberofPoints - fftl)/M)+1)*fftl/2 points. The
totalNumberofPoints denotes the number of points in the complex input
data stream. 
Programmer: 	Jeyhan Karaoguz 
Date: 		June 5, 1992
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This block computes the ONE-SIDED FFT of a complex stream which is overlapped by an amount of (fftl-M) samples for each FFT computation.  It outputs ((int)((totalNumberofPoints - fftl)/M)+1)*fftl/2 points. The totalNumberofPoints denotes the number of points in the complex input 
</DESC_SHORT>

<INCLUDES>
<![CDATA[ 

#include <cap_fft.h>

]]>
</INCLUDES> 

<DEFINES> 

#define PI 3.141592654

</DEFINES> 

              

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>fftexp</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>fftl</NAME>
	</STATE>
	<STATE>
		<TYPE>cap_fft_cpx*</TYPE>
		<NAME>fftBuffer</NAME>
	</STATE>
	<STATE>
		<TYPE>complex*</TYPE>
		<NAME>dataBuffer</NAME>
	</STATE>
	<STATE>
		<TYPE>complex*</TYPE>
		<NAME>tempBuffer</NAME>
	</STATE>
	<STATE>
		<TYPE>cap_fft_cpx*</TYPE>
		<NAME>cxoutBuff</NAME>
	</STATE>
	<STATE>
		<TYPE>cap_fft_cfg</TYPE>
		<NAME>cfg</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>norm</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>pointCount</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>checkFlag</NAME>
		<VALUE>0</VALUE>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int no_samples;
	complex calc;
	int i,j;
	float w;

</DECLARATIONS> 

         

<PARAMETERS>
<PARAM>
	<DEF>Size of FFT</DEF>
	<TYPE>int</TYPE>
	<NAME>npts</NAME>
	<VALUE>128</VALUE>
</PARAM>
<PARAM>
	<DEF>Delay between Windows</DEF>
	<TYPE>int</TYPE>
	<NAME>M</NAME>
	<VALUE>10</VALUE>
</PARAM>
<PARAM>
	<DEF>Window Type: 0 = Rectangular, 1 = Hanning</DEF>
	<TYPE>int</TYPE>
	<NAME>windowType</NAME>
	<VALUE>0</VALUE>
</PARAM>
</PARAMETERS>

    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>complex</TYPE>
		<NAME>x</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
    

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>complex</TYPE>
		<NAME>y</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

/*
 * compute the power of 2 number of fft points
 */
fftexp = (int) (log((float)npts)/log(2.0)+0.5);
fftl = 1 << fftexp;
if (fftl > npts ) {
	fftl = fftl/2;
	fftexp -= 1;
}
if (fftl < 2)
{
		fprintf(stderr,"fft: fft length is too short \n");
		return(1);
}
norm=1.0/(float)fftl;
if ((fftBuffer = (cap_fft_cpx*)calloc(fftl,sizeof(cap_fft_cpx))) == NULL)
{
	fprintf(stderr,"slidefft: can't allocate work space \n");
	return(2);
}
if ((cxoutBuff = (cap_fft_cpx*)calloc(fftl,sizeof(cap_fft_cpx))) == NULL)
{
	fprintf(stderr,"slidefft: can't allocate work space \n");
	return(3);
}
cfg=cap_fft_alloc(fftl,0,NULL,NULL);

if ((dataBuffer = (complex*)calloc(fftl,sizeof(complex))) == NULL)
{
        fprintf(stderr,"fft: can't allocate work space \n");
        return(4);
}
if ((tempBuffer = (complex*)calloc(fftl,sizeof(complex))) == NULL)
{
        fprintf(stderr,"fft: can't allocate work space \n");
        return(5);
}
SET_CELL_SIZE_IN(0,sizeof(complex));
SET_CELL_SIZE_OUT(0,sizeof(complex));

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

	for (no_samples = MIN_AVAIL(); no_samples > 0; --no_samples)
	{
		/*
		 * real input buffer
		 */
		j=pointCount;
		IT_IN(0);
		dataBuffer[j]=x(0);
		pointCount++;

			
		if(checkFlag == 0)
		{
		/* 
		 * Get enough points				
		 */
			if(pointCount >= fftl)
			{
				for (i=0; i<fftl; i++)
				{
					if (windowType == 1)
					{
						w = (1.0/2.0)*(1.0-cos(2.0*PI*(float)i/((float)fftl-1.0)));
						fftBuffer[i].r = w*dataBuffer[i].re;
						fftBuffer[i].i = dataBuffer[i].im;
					}
					else
					{
                                                fftBuffer[i].r = dataBuffer[i].re;
                                                fftBuffer[i].i = dataBuffer[i].im;
					}
					 
				}
				/* 
		 		* perform fft calculation		
		 		*/
				cap_fft(cfg,fftBuffer,cxoutBuff);

		
				/* 
		 		* now, output complex pairs		
		 		*/
				for (i=0; i<fftl/2; i++)
				{
					if(IT_OUT(0)) {
						KrnOverflow("slidefft",0);
						return(99);
					}
					calc.re = cxoutBuff[i].r*norm;
					calc.im = cxoutBuff[i].i*norm;
					y(0) = calc;
				}
				for (i=0; i<fftl-M; i++)
					tempBuffer[i] = dataBuffer[i+M];
				pointCount = 0;
				checkFlag = 1;
			 }
		}
		else
		{
			if(pointCount >= M)
			{
				for (i=0; i<M; i++)
					tempBuffer[i+fftl-M]=dataBuffer[i];
				for (i=0; i<fftl; i++)
                                {
					if (windowType == 1)
                                        {
                                                w = (1.0/2.0)*(1.0-cos(2.0*PI*(float)i/((float)fftl-1.0)));
                                                fftBuffer[i].r = w*tempBuffer[i].re;
                                                fftBuffer[i].i = tempBuffer[i].im;
                                        }
					else
                                        {
                                                fftBuffer[i].r = tempBuffer[i].re;
                                                fftBuffer[i].i = tempBuffer[i].im;
                                        }
                                }
			        /*
                                * perform fft calculation
                                */
				cap_fft(cfg,fftBuffer,cxoutBuff);



                                /*
                                * now, output complex pairs
                                */
                                for (i=0; i<fftl/2; i++)
                                {
                                        if(IT_OUT(0) ) {
						KrnOverflow("slidefft",0);
						return(99);
					}
                                        calc.re = fftBuffer[i].r*norm;
                                        calc.im = fftBuffer[i].i*norm;
                                        y(0) = calc;
                                }
                                for (i=0; i<fftl-M; i++)
                                        tempBuffer[i] = tempBuffer[i+M];
				pointCount = 0;
			 }
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
	free((cap_fft_cpx*)fftBuffer);
	free((cap_fft_cpx*)cxoutBuff);
        free((char*)tempBuffer);
        free((char*)dataBuffer);

]]>
</WRAPUP_CODE> 



</BLOCK> 

