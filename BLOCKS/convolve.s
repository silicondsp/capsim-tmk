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

convolve 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* convolve.s */
/***********************************************************************
                             convolve()
************************************************************************
This block convolves the input samples with the impulse response (finite
duration, FIR ) given in a file. 
Param:	1 - (file) File with the impulse response samples
	2 - (int) N  number of samples in the impulse response.
<NAME>
convolve
</NAME>
<DESCRIPTION>
This block convolves the input samples with the impulse response (finite
duration, FIR ) given in a file. 
Param:	1 - (file) File with the impulse response samples
	2 - (int) N  number of samples in the impulse response.
</DESCRIPTION>
<PROGRAMMERS>
Date:  September 23, 1988 
Programmer: Adali Tulay 
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This block convolves the input samples with the impulse response (finite duration, FIR ) given in a file. 
</DESC_SHORT>

<INCLUDES>
<![CDATA[ 

#include <math.h>
#include <stdio.h>

]]>
</INCLUDES> 

<DEFINES> 

#define PI 3.1415926

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
</STATES>
 
<DECLARATIONS> 

   	int i;
   	int j;
	float tmp1,tmp2;
        float sum;
	FILE *fopen();
	FILE *imp_F;

</DECLARATIONS> 

       

<PARAMETERS>
<PARAM>
	<DEF>File name containing impulse response samples</DEF>
	<TYPE>file</TYPE>
	<NAME>filename</NAME>
	<VALUE></VALUE>
</PARAM>
<PARAM>
	<DEF>Order of impulse response</DEF>
	<TYPE>int</TYPE>
	<NAME>N</NAME>
	<VALUE></VALUE>
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

	/*
	 * Allocate memory and return pointers for tapped delay line x_P and
	 * array containing impulse response samples, h_P.
	 *
	 */
	if( (x_P = (float*)calloc(N,sizeof(float))) == NULL ||
	    (h_P = (float*)calloc(N,sizeof(float))) == NULL ) {
	   	fprintf(stderr,"convolve: can't allocate work space\n");
		return(4);
	}
	/*
	 * open file containing impulse response samples. Check 
	 * to see if it exists.
	 *
	 */
        if( (imp_F = fopen(filename,"r")) == NULL) {
		fprintf(stderr,"Convolve could not be opened file was %s \n",
				filename);
		return(4);
	}
	/*
	 * Read in the impulse response samples into the array
	 * and initialize the tapped delay line to zero.
	 *
	 */
	for (i=0; i<N; i++) {
		x_P[i]= 0.0;
		fscanf(imp_F,"%f",&h_P[i]);
	}

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 




	while(IT_IN(0)){
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
			KrnOverflow("convolve",0);
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

