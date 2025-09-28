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

lms 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* lms.s */
/***********************************************************************
                             lms()
************************************************************************
This star implements a simple LMS adaptive filter.
Param:	
	1 - (int) N  filter order.
	2 - (float) LMS gain constant.
	3- (int) Flag to output either estimate or error
<NAME>
lms
</NAME>
<DESCRIPTION>
This star implements a simple LMS adaptive filter.
Param:	
	1 - (int) N  filter order.
	2 - (float) LMS gain constant.
	3- (int) Flag to output either estimate or error
</DESCRIPTION>
<PROGRAMMERS>
Date:  September 23, 1988 
Programmer: Adali, Tulay 
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This star implements a simple LMS adaptive filter.
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 

#include <math.h>
#include <stdio.h>

]]>
</INCLUDES> 

    

<STATES>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>x_P</NAME>
	</STATE>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>w_P</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

   	int i;
   	int j;
	float tmp1,tmp2;
        float dhat;
        float temp;
        float error;

</DECLARATIONS> 

         

<PARAMETERS>
<PARAM>
	<DEF>Filter order</DEF>
	<TYPE>int</TYPE>
	<NAME>N</NAME>
	<VALUE>10 </VALUE>
</PARAM>
<PARAM>
	<DEF>LMS gain constant</DEF>
	<TYPE>float</TYPE>
	<NAME>mu</NAME>
	<VALUE>0.1</VALUE>
</PARAM>
<PARAM>
	<DEF>Flag: 0=estimate, 1=error</DEF>
	<TYPE>int</TYPE>
	<NAME>outputFlag</NAME>
	<VALUE>0</VALUE>
</PARAM>
</PARAMETERS>

     

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>x</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>z</NAME>
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
	    (w_P = (float*)calloc(N,sizeof(float))) == NULL ) {
	   	fprintf(stderr,"lms: can't allocate work space\n");
		return(4);
	}
	/*
	 * initialize the tapped delay line and weights to zero.
	 *
	 */
	for (i=0; i<N; i++) {
		x_P[i]= 0.0;
		w_P[i] = 0.0;
	}

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 



        for(j = MIN_AVAIL(); j>0; j--) {
		/*
		 * Shift input sample into tapped delay line
		 */
		IT_IN(0);
		tmp2=x(0);
		for(i=0; i<N; i++) {
			tmp1=x_P[i];
			x_P[i]=tmp2;
			tmp2=tmp1;
		}
		/*
		 * Compute inner product 
		 */
                dhat = 0.0;
		for (i=0; i<N; i++) { 
		     dhat += x_P[i]*w_P[i];
		}
		/*
	  	 * set output buffer to response result
		 */
                IT_IN(1);
                error = z(0) - dhat;
                for (i=0;i<N;i++)  w_P[i]+= mu*x_P[i]*error;
		if(IT_OUT(0)) {
			KrnOverflow("lms",0);
			return(99);
		}
		if(!outputFlag) y(0) = dhat;
		else
			y(0) = error;
	}
	return(0);
              

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

	free(x_P); free(w_P); 

]]>
</WRAPUP_CODE> 



</BLOCK> 

