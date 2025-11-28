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

firfil 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* firfil.s */
/***********************************************************************
                             firfil()
************************************************************************
This star designs FIR low pass, high pass, band pass, and band stop 
filters using the windowing method.
The star stores the specs of the FIR filter in the file tmp.spec.
The star stores the FIR filter taps in the file tmp.tap.
Date:  October 19, 1989 
Programmer: Sasan H. Ardalan. 
<NAME>
firfil
</NAME>
<DESCRIPTION>
This star designs FIR low pass, highj pass, band pass, and band stop 
filters using the windowing method.
The star stores the specs of the FIR filter in the file tmp.spec.
The star stores the FIR filter taps in the file tmp.tap.
</DESCRIPTION>
<PROGRAMMERS>
Date:  October 19, 1989 
Programmer: Sasan H. Ardalan. 
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This star designs FIR low pass, high pass, band pass, and band stop  filters using the windowing method.
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 

#include <math.h>
#include <stdio.h>
#include "dsp.h"

]]>
</INCLUDES> 

<DEFINES> 



</DEFINES> 

     

<STATES>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>x_P</NAME>
	</STATE>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>h_P</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>N</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

   	int i;
   	int j;
	int status;
	int numberTaps;
	float tmp1,tmp2;
        float sum;
	int	no_samples;
	FILE *imp_F;

</DECLARATIONS> 

                       

<PARAMETERS>
<PARAM>
	<DEF>Filter Type:1=LowPass,2=HighPass,3=BandPass,4=BandStop</DEF>
	<TYPE>int</TYPE>
	<NAME>filterType</NAME>
	<VALUE>1</VALUE>
</PARAM>
<PARAM>
	<DEF>Window Type:1=Rect,2=Tri,3=Hamm,4=GenHamm,5=Hann,6=Kaiser,7=Cheb,8=Parz</DEF>
	<TYPE>int</TYPE>
	<NAME>windType</NAME>
	<VALUE>3</VALUE>
</PARAM>
<PARAM>
	<DEF>Number of Taps</DEF>
	<TYPE>int</TYPE>
	<NAME>ntap</NAME>
	<VALUE>128</VALUE>
</PARAM>
<PARAM>
	<DEF>Cut Off Freq. (LowPass/HighPass Only)</DEF>
	<TYPE>float</TYPE>
	<NAME>fc</NAME>
	<VALUE>0.25</VALUE>
</PARAM>
<PARAM>
	<DEF><![CDATA[Lower cutoff freq. 0<=fl<=0.5]]></DEF>
	<TYPE>float</TYPE>
	<NAME>fl</NAME>
	<VALUE>0.25</VALUE>
</PARAM>
<PARAM>
	<DEF><![CDATA[Upper cutoff freq. 0<=fh<=0.5]]></DEF>
	<TYPE>float</TYPE>
	<NAME>fh</NAME>
	<VALUE>0.4</VALUE>
</PARAM>
<PARAM>
	<DEF><![CDATA[Alpha parameter for generalized Hamming window <=1.0]]></DEF>
	<TYPE>float</TYPE>
	<NAME>alpha</NAME>
	<VALUE>0.5</VALUE>
</PARAM>
<PARAM>
	<DEF>Ripple, dB for Chebyshev Window</DEF>
	<TYPE>float</TYPE>
	<NAME>dbripple</NAME>
	<VALUE>0.5</VALUE>
</PARAM>
<PARAM>
	<DEF>Transition Width Chebyshev Window</DEF>
	<TYPE>float</TYPE>
	<NAME>twidth</NAME>
	<VALUE>0.1</VALUE>
</PARAM>
<PARAM>
	<DEF>Attenuation for Kaiser Window</DEF>
	<TYPE>float</TYPE>
	<NAME>att</NAME>
	<VALUE>30.0</VALUE>
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

	status=FIRDesign(fc,fl,fh,alpha,dbripple,twidth,att,
				ntap,windType,filterType,"tmp");
	if(status) {
		fprintf(stderr,"firfil: Error in FIR design.\n");
		return(4);
	}
	/*
	 * open file containing impulse response samples. Check 
	 * to see if it exists.
	 *
	 */
        if( (imp_F = fopen("tmp.tap","r")) == NULL) {
		fprintf(stderr,"firfil:tmp.tap file could not be opened.\n");
		return(4);
	}
	fscanf(imp_F,"%d",&numberTaps);
	/*
	 * Allocate memory and return pointers for tapped delay line x_P and
	 * array containing impulse response samples, h_P.
	 *
	 */
	if( (x_P = (float*)calloc(numberTaps,sizeof(float))) == NULL ||
	    (h_P = (float*)calloc(numberTaps,sizeof(float))) == NULL ) {
	   	fprintf(stderr,"firfil: can't allocate work space\n");
		return(4);
	}
	/*
	 * Read in the impulse response samples into the array
	 * and initialize the tapped delay line to zero.
	 *
	 */
	for (i=0; i<numberTaps; i++) {
		x_P[i]= 0.0;
		fscanf(imp_F,"%f",&h_P[i]);
	}
	N=numberTaps;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 




	for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) {
		IT_IN(0);
		/*
		 * Shift input sample into tapped delay line
		 */
		tmp2=x(0);
		for(i=0; i<N; i++) {
			tmp1=x_P[i];
			x_P[i]=tmp2;
			tmp2=tmp1;
		}
		/*
		 * Compute inner product 
		 */
                sum = 0.0;
		for (i=0; i<N; i++) { 
		     sum += x_P[i]*h_P[i];
		}
		if(IT_OUT(0)) {
			KrnOverflow("firfil",0);
			return(99);
		}
		/*
	  	 * set output buffer to response result
		 */
		y(0) = sum;
	}

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

	free(x_P); free(h_P); 

]]>
</WRAPUP_CODE> 



</BLOCK> 

