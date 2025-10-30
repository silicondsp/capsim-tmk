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

cxreal 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* cxreal.s */
/***************************************************************
		cxreal()
****************************************************************
	Inputs:		x, the complex signal
	Outputs:	y0, the real part
	Parameters: 	None
****************************************************************
This block outputs the real part of the input
complex stream. Buffer 0 contains the real part.
<NAME>
cxreal
</NAME>
<DESCRIPTION>
This block outputs the real part of the input
complex stream. Buffer 0 contains the real part.
</DESCRIPTION>
<PROGRAMMERS>
Programmer:  	Sasan Ardalan	
Date:		March 12, 1989
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This block outputs the real part of the inputcomplex stream. 
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 

#include <math.h>

]]>
</INCLUDES> 

   

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numOutputBuffers</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int no_samples;
	float a,b;

</DECLARATIONS> 

   
    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>complex</TYPE>
		<NAME>x</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
    

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>y0</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

	numOutputBuffers = NO_OUTPUT_BUFFERS();
	SET_CELL_SIZE_IN(0,sizeof(complex));
	SET_CELL_SIZE_OUT(0,sizeof(float));

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	/* note the minimum number of samples on the 	*/
	/* input buffers and iterate that many times 	*/
	
	for(no_samples=(MIN_AVAIL() );no_samples >0; --no_samples) 

	{
		/* first get real sample	*/
		IT_IN(0);	
		a = x(0).re;

		/* now get imaginary sample	*/
		b = x(0).im;

			/*
			 * buffer available on 0 so output real part
			 */
			if(IT_OUT(0)) {
				KrnOverflow("cxreal",0);
				return(99);
			}
			y0(0) = a;

	}
	return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

