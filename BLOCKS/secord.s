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

secord 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*
	secord.s:	second order filter
	parameters:	gain#1, gain#2
			leakage factor of the filter
	inputs:		in, the signal to be filtered
	outputs:	out, the filtered signal
	description:	This block implements a second order filter
			with a leakage factor (beta)
 			as a recursive equation:
			y(n)=beta*y(n-1)+g1*[x(n)-beta*x(n-1)]+g2*x(n)
			This filter can be used as a PLL loop filter.
<NAME>
secord
</NAME>
<DESCRIPTION>
secord.s:	second order filter
	parameters:	gain#1, gain#2
			leakage factor of the filter
	inputs:		in, the signal to be filtered
	outputs:	out, the filtered signal
	description:	This block implements a second order filter
			with a leakage factor (beta)
 			as a recursive equation:
			y(n)=beta*y(n-1)+g1*[x(n)-beta*x(n-1)]+g2*x(n)
			This filter can be used as a PLL loop filter.
</DESCRIPTION>
<PROGRAMMERS>
		written by Ray Kassel
			August 8, 1990
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
Second order filter
</DESC_SHORT>


<DECLARATIONS> 


</DECLARATIONS> 

         

<PARAMETERS>
<PARAM>
	<DEF>Gain1</DEF>
	<TYPE>float</TYPE>
	<NAME>one</NAME>
	<VALUE>0.1</VALUE>
</PARAM>
<PARAM>
	<DEF>Gain2</DEF>
	<TYPE>float</TYPE>
	<NAME>two</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF><![CDATA[Beta <= 1]]></DEF>
	<TYPE>float</TYPE>
	<NAME>beta</NAME>
	<VALUE>0.9</VALUE>
</PARAM>
</PARAMETERS>

    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>x0</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
     

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>y0</NAME>
		<DELAY><TYPE>max</TYPE><VALUE_MAX>2</VALUE_MAX></DELAY>
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
			KrnOverflow("secord",0);
			return(99);
		}
		y0(0)=beta*y0(1)+one*x0(0)-beta*one*x0(1)+two*x0(0);
	}

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

