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

ds2 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/***************************************************************************
		ds2.s
****************************************************************************
This block is a self-contained second order delta sigma modulator.  Ouput 0
is the output of the circuit. Output 1 is the input to the comparator
if connected.
-Parameter one: the gain of the first integrator
-Parameter two: the gain of the second integrator
-Parameter three: the value for delta
<NAME>
ds2
</NAME>
<DESCRIPTION>
his block is a self-contained second order delta sigma modulator.  Ouput 0
is the output of the circuit. Output 1 is the input to the comparator
if connected.
-Parameter one: the gain of the first integrator
-Parameter two: the gain of the second integrator
-Parameter three: the value for delta
</DESCRIPTION>
<PROGRAMMERS>
Programmer:	John T. Stonick
Date:		February 1989
Modified: Sasan Ardalan, If a second buffer is added then the 
error prior to 1 bit quantization is output on buffer 1.
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This block is a self-contained second order delta sigma modulator.
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 

#include <math.h>

]]>
</INCLUDES> 

        

<STATES>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>y</NAME>
		<VALUE>1.0</VALUE>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>x</NAME>
		<VALUE>0.0</VALUE>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>p</NAME>
		<VALUE>0.0</VALUE>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>xold</NAME>
		<VALUE>0.0</VALUE>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>yold</NAME>
		<VALUE>0.0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberOutputBuffers</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i;

</DECLARATIONS> 

         

<PARAMETERS>
<PARAM>
	<DEF>The gain of the first integrator</DEF>
	<TYPE>float</TYPE>
	<NAME>g1</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF>The gain of the second integrator</DEF>
	<TYPE>float</TYPE>
	<NAME>g2</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Binary Quantizer Level</DEF>
	<TYPE>float</TYPE>
	<NAME>delta</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
</PARAMETERS>

    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>in</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

       /* note and store the number of output buffers */
        if((numberOutputBuffers = NO_OUTPUT_BUFFERS() ) <= 0) {
                fprintf(stderr,"ds2: no output buffers\n");
                return(1); /* no output buffers */
        }
        if(numberOutputBuffers > 2) {
                fprintf(stderr,"ds2: more than two outputs\n");
                return(2);
        }

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

while(IT_IN(0))
{

	x = xold + g1*in(0) - g1*p;

	y = yold + g2*xold - g2*p;

	p = delta;
	if(y < 0.0) p = -delta;

	
	if(numberOutputBuffers==1) {
		if(IT_OUT(0)) {
			KrnOverflow("ds2",0);
			return(99);
		}
		OUTF(0,0)=p;
	} else {
		if(IT_OUT(0)) {
			KrnOverflow("ds2",0);
			return(99);
		}
		OUTF(0,0)=p;
		if(IT_OUT(1)) {
			KrnOverflow("ds2",1);
			return(99);
		}
		OUTF(0,0)=y;

	}


	xold = x;
	yold = y;
	
}

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

