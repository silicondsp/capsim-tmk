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

cxmult 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* cxmult.s */
/***************************************************************
			cxmult() 
****************************************************************
	Inputs:		x1, the first complex signal
			x2, the second complex signal
	Outputs:	y, the complex output
	Parameters:	none
****************************************************************
This star multiplies two complex data streams.  Each complex 
sample is assumed to be composed of a real sample followed by 
an imaginary sample.  This star operates like a "butterfly," i.e.
	c1 = a + jb = x1(0) + x1(1)
	c2 = c + jd = x2(0) + x2(1)
	r = c1 * c2 = (ac-bd) + j(bc+ad) = y(0) + y(1)
<NAME>
cxmult
</NAME>
<DESCRIPTION>
This star multiplies two complex data streams.  Each complex 
sample is assumed to be composed of a real sample followed by 
an imaginary sample.  This star operates like a "butterfly," i.e.
	c1 = a + jb = x1(0) + x1(1)
	c2 = c + jd = x2(0) + x2(1)
	r = c1 * c2 = (ac-bd) + j(bc+ad) = y(0) + y(1)
</DESCRIPTION>
<PROGRAMMERS>
Programmer: 	Prayson W. Pate
Date:		April 13, 1988
Modified:	April, 1988
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This star multiplies two complex data streams. 
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
	complex calc;

</DECLARATIONS> 

   
     

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>complex</TYPE>
		<NAME>x1</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>complex</TYPE>
		<NAME>x2</NAME>
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

	SET_CELL_SIZE_IN(0,sizeof(complex));
	SET_CELL_SIZE_IN(1,sizeof(complex));
	SET_CELL_SIZE_OUT(0,sizeof(complex));

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	/* note the minimum number of samples on the 	*/
	/* input buffers and iterate that many times 	*/
	
	{
	for(no_samples=(MIN_AVAIL() );no_samples >0; --no_samples) 

		{
		/* first get real samples	*/
		IT_IN(0);	
		IT_IN(1);	
		a = x1(0).re;
		c = x2(0).re;

		/* now get imaginary samples	*/
		b = x1(0).im;
		d = x2(0).im;

		/* output complex result		*/
		if(IT_OUT(0)) {
			KrnOverflow("cxmult",0);
			return(99);
		}
		calc.re = a*c - b*d;
		calc.im = b*c + a*d;
		y(0)=calc;

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

