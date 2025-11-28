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

pllfilt 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*
	pllfilt.s:	loop filter for PLL
	parameters:	gain#1, gain#2, gain#3 of the filter
	inputs:		in, the signal to be filtered
	outputs:	out, the filtered signal
	description:	This star implements a loop filter
			as a recursive equation:
			y(n)=2*y(n-1)-y(n-2)
			     +g1*[x(n)-2*x(n-1)+x(n-2)]	
			     +g2*[x(n)-x(n-1)]
			     +g3*x(n)
			This filter can be used as a PLL loop filter.
			written by Ray Kassel
			August 9, 1990
<NAME>
pllfilt
</NAME>
<DESCRIPTION>
	parameters:	gain#1, gain#2, gain#3 of the filter
	inputs:		in, the signal to be filtered
	outputs:	out, the filtered signal
	description:	This star implements a loop filter
			as a recursive equation:
			y(n)=2*y(n-1)-y(n-2)
			     +g1*[x(n)-2*x(n-1)+x(n-2)]	
			     +g2*[x(n)-x(n-1)]
			     +g3*x(n)
			This filter can be used as a PLL loop filter.
</DESCRIPTION>
<PROGRAMMERS>
			written by Ray Kassel
			August 9, 1990
</PROGRAMMERS>
 */

]]>
</COMMENTS> 


<DESC_SHORT>
This star implements a loop filter as a recursive equation:  y(n)=2*y(n-1)-y(n-2) +g1*[x(n)-2*x(n-1)+x(n-2)] +g2*[x(n)-x(n-1)] +g3*x(n)
</DESC_SHORT>

<DECLARATIONS> 


</DECLARATIONS> 

         

<PARAMETERS>
<PARAM>
	<DEF>Gain1</DEF>
	<TYPE>float</TYPE>
	<NAME>g1</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Gain2</DEF>
	<TYPE>float</TYPE>
	<NAME>g2</NAME>
	<VALUE>0.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Gain3</DEF>
	<TYPE>float</TYPE>
	<NAME>g3</NAME>
	<VALUE>0.0</VALUE>
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
		<DELAY><TYPE>max</TYPE><VALUE_MAX>3</VALUE_MAX></DELAY>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 


]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

	while(IT_IN(0))
	{
		if(IT_OUT(0)) {
			KrnOverflow("pllfilt",0);
			return(99);
		}
		y(0)=2*y(1)-y(2)+g1*x(0)-2*g1*x(1)+g1*x(2)+g2*x(0)-g2*x(1)+g3*x(0);
	}

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

