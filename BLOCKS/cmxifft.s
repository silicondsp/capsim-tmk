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
<BLOCK_NAME>cmxifft</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* cmxifft.s */
/***********************************************************************
                             cmxifft()
************************************************************************
	Inputs:		x complex
	Outputs:	y, the fft of the signal complex
	Parameters:	int inpts  the fft length
************************************************************************
This star produces the inverse fft of the input signal.  The points are output
as complex numbers.  The number of points input is npts and the number
of points generated is npts;
Programmer: 	Prayson Pate
Date: 		April 15, 1988
Modified:	April 18, 1988
Modified:	Sasan Ardalan to use cxfft() routine, use complex buffers.
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This star produces the inverse fft of the input signal.  The points are output
as complex numbers.
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 

#include <cap_fft.h>

]]>
</INCLUDES> 

         

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
		<TYPE>float</TYPE>
		<NAME>norm</NAME>
	</STATE>
	<STATE>
		<TYPE>cap_fft_cpx*</TYPE>
		<NAME>cxinBuff</NAME>
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
		<TYPE>int</TYPE>
		<NAME>pointCount</NAME>
		<VALUE>0</VALUE>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int no_samples;
	complex calc;
	int i,j;

</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF>Size of FFT</DEF>
	<TYPE>int</TYPE>
	<NAME>npts</NAME>
	<VALUE>128 </VALUE>
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

fftl=npts;
norm=1.0/(float)fftl;

if (fftl < 2)
{
		fprintf(stderr,"cmxifft: fft length is too short \n");
		return(1);
}
cfg=cap_fft_alloc(fftl,1,NULL,NULL);
if ((cxinBuff = (cap_fft_cpx*)calloc(fftl,sizeof(cap_fft_cpx))) == NULL)
{
	fprintf(stderr,"cmxifft: can't allocate work space \n");
	return(2);
}
if ((cxoutBuff = (cap_fft_cpx*)calloc(fftl,sizeof(cap_fft_cpx))) == NULL)
{
	fprintf(stderr,"cmxifft: can't allocate work space \n");
	return(3);
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
		cxinBuff[j].r=x(0).re;
		cxinBuff[j].i=x(0).im;
		pointCount++;

			

		/* 
		 * Get enough points				
		 */
		if(pointCount >= fftl )
		{
			/* 
			 * perform fft calculation		
			 */
                        cap_fft(cfg, cxinBuff, cxoutBuff);

			
			/* 
			 * now, output complex pairs		
			 */
			for (i=0; i<fftl; i++)
			{
				if(IT_OUT(0)) {
					KrnOverflow("cmxifft",0);
					return(99);
				}
				calc.re = cxoutBuff[i].r*norm;
				calc.im = cxoutBuff[i].i*norm;
				y(0) = calc;
			}


			pointCount = 0;
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
	free((char*)cxinBuff);
	free((char*)cxoutBuff);

]]>
</WRAPUP_CODE> 



</BLOCK> 

