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

lpf 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/************************************************************************
 *									*
 *	lpf.s:		low pass filter					*
 *									*
 *	parameters:	pole, pole of the IIR filter			*
 *									*
 *	inputs:		in, the signal to be filtered			*
 *									*
 *	outputs:	out, the filtered signal			*
 *									*
 *	description:	This star implements an IIR filter as a 	*
 *			recursive equation:				*
 *			y(n)=pole*y(n-1)+(1-pole)*x(n)			*
 *			This implementation produces unity gain at DC.	*
 *									*
 *									*
 *									*
<NAME>
lpf
</NAME>
<DESCRIPTION>
 *	parameters:	pole, pole of the IIR filter			*
 *									*
 *	inputs:		in, the signal to be filtered			*
 *									*
 *	outputs:	out, the filtered signal			*
 *									*
 *	description:	This star implements an IIR filter as a 	*
 *			recursive equation:				*
 *			y(n)=pole*y(n-1)+(1-pole)*x(n)			*
 *			This implementation produces unity gain at DC.	*
 *									*
</DESCRIPTION>
<PROGRAMMERS>
John T. Stonick
</PROGRAMMERS>
 ************************************************************************/

]]>
</COMMENTS> 

<DESC_SHORT>
This star implements an IIR filter as a recursive equation:	y(n)=pole*y(n-1)+(1-pole)*x(n). This implementation produces unity gain at DC.
</DESC_SHORT>


<DECLARATIONS> 


</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF><![CDATA[Filter pole <= 1.0]]></DEF>
	<TYPE>float</TYPE>
	<NAME>pole</NAME>
	<VALUE>.9</VALUE>
</PARAM>
</PARAMETERS>

    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>in</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
     

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>out</NAME>
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
			KrnOverflow("lpf",0);
			return(99);
		}
		out(0)=pole*out(1)+(1.0-pole)*in(0);
	}

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

