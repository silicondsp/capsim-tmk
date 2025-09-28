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

cxmag 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* cxmag.s */
/***************************************************************
			cxmag() 
****************************************************************
	Inputs:		x, the complex signal
	Outputs:	y, the magnitude
	Parameters:	none
****************************************************************
This star finds the magnitude of a complex data stream.  Each complex 
sample is assumed to be composed of a real sample followed by 
an imaginary sample.
<NAME>
cxmag
</NAME>
<DESCRIPTION>
This star finds the magnitude of a complex data stream.  Each complex 
sample is assumed to be composed of a real sample followed by 
an imaginary sample.
</DESCRIPTION>
<PROGRAMMERS>
Programmer: 	Prayson W. Pate
Date:		April 18, 1988
Modified:	April, 1988
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This star finds the magnitude of a complex data stream.
</DESC_SHORT>

<INCLUDES>
<![CDATA[ 

#include <math.h>

]]>
</INCLUDES> 

<DECLARATIONS> 

	int no_samples;
	int i;
	float a,b,c,d;

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
		<NAME>y</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

	SET_CELL_SIZE_IN(0,sizeof(complex));
	SET_CELL_SIZE_OUT(0,sizeof(float));

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	/* note the minimum number of samples on the 	*/
	/* input buffers and iterate that many times 	*/
	
	{
	for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) 

		{
		/* first get real sample	*/
		IT_IN(0);	
		a = x(0).re;

		/* now get imaginary sample	*/
		b = x(0).im;

		/* find power			*/
		c = a*a + b*b;

		if(IT_OUT(0)) {
			KrnOverflow("cxmag",0);
			return(99);
		}
		y(0) = sqrt(c);

		}
	return(0);
	}

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

