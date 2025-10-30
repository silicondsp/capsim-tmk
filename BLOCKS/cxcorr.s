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

cxcorr 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* cxcorr.s */
/***********************************************************************
                             cxcorr()
************************************************************************
This block correlates the input samples with the sequence given in a file.
Param:	1 - (file) File with the sequence to correlate
	2 - (int) N  number of samples in the sequence.
<NAME>
cxcorr
</NAME>
<DESCRIPTION>
This block correlates the input samples with the sequence given in a file.
Param:	1 - (file) File with the sequence to correlate
	2 - (int) N  number of samples in the sequence.
</DESCRIPTION>
<PROGRAMMERS>
Date:  September 23, 1988 
Programmer: Adali Tulay
Modified: August 27, 2001 for complex correlation, Sasan Ardalan
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This block correlates the input samples with the sequence given in a file.
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
		<TYPE>complex*</TYPE>
		<NAME>x_P</NAME>
	</STATE>
	<STATE>
		<TYPE>complex*</TYPE>
		<NAME>h_P</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>Ndiv2</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

   	int i;
   	int j;
	complex tmp1,tmp2;
        complex  sum;
        complex tmp;
	FILE *fopen();
	FILE *imp_F;

</DECLARATIONS> 

       

<PARAMETERS>
<PARAM>
	<DEF>File name containing sequence to correlate</DEF>
	<TYPE>file</TYPE>
	<NAME>filename</NAME>
	<VALUE></VALUE>
</PARAM>
<PARAM>
	<DEF>Number of samples in sequence</DEF>
	<TYPE>int</TYPE>
	<NAME>N</NAME>
	<VALUE></VALUE>
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

        Ndiv2=N/2;
	/*
	 * Allocate memory and return pointers for tapped delay line x_P and
	 * array containing impulse response samples, h_P.
	 *
	 */
	if( (x_P = (complex*)calloc(N,sizeof(complex))) == NULL ||
	    (h_P = (complex*)calloc(N,sizeof(complex))) == NULL ) {
	   	fprintf(stderr,"cxcorr: can't allocate work space\n");
		return(4);
	}
	/*
	 * open file containing impulse response samples. Check
	 * to see if it exists.
	 *
	 */
        if( (imp_F = fopen(filename,"r")) == NULL) {
		fprintf(stderr,"cxcorr could not be opened file was %s \n",
				filename);
		return(4);
	}
	/*
	 * Read in the impulse response samples into the array
	 * and initialize the tapped delay line to zero.
	 *
	 */
	for (i=0; i<N; i++) {
		x_P[i].re= 0.0;   x_P[i].im= 0.0;
		fscanf(imp_F,"%f %f",&h_P[i].re, &h_P[i].im);
	}
        /*
         * Time reverse
         */
        for(i=0; i<Ndiv2; i++) {
            tmp=h_P[i];
            h_P[i]=h_P[N-i-1];
            h_P[N-i-1]=tmp;
        }
		SET_CELL_SIZE_IN(0,sizeof(complex));
		SET_CELL_SIZE_OUT(0,sizeof(complex));

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
                sum.re = 0.0; sum.im=0.0;
		for (i=0; i<N; i++) {

                     sum.re += x_P[i].re*h_P[i].re+x_P[i].im*h_P[i].im;
                     sum.im += x_P[i].im*h_P[i].re-x_P[i].re*h_P[i].im;
#if 0
                     sum.re += x_P[i].re*h_P[i].re;
                     sum.im += x_P[i].im*h_P[i].im;
#endif

		}
		if(IT_OUT(0)) {
			KrnOverflow("cxcorr",0);
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

