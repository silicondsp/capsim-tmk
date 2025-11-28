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

threshold 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*
	threshold.s:	Compares input with threshold and
			outputs a 0 if less, and 1 if greater
			or equal
			Output occurs on positive edge of
			control input
	parameters:	thh, threshold
	inputs:		x, signal to threshold
			in_control, control signal
	outputs:	y, the threshold decision
	description:	This star compares the input with a 
			threshold and outputs a 1 if the input
			is less than the threshold, or 0 if
			the input is greater than or
			equal to the threshold.
			Output occurs on positive edge of
			control input.
<NAME>
threshold
</NAME>
<DESCRIPTION>
threshold.s:	Compares input with threshold and
			outputs a 0 if less, and 1 if greater
			or equal
			Output occurs on positive edge of
			control input
	parameters:	thh, threshold
	inputs:		x, signal to threshold
			in_control, control signal
	outputs:	y, the threshold decision
	description:	This star compares the input with a 
			threshold and outputs a 1 if the input
			is less than the threshold, or 0 if
			the input is greater than or
			equal to the threshold.
			Output occurs on positive edge of
			control input.
</DESCRIPTION>
<PROGRAMMERS>
</PROGRAMMERS>
 */

]]>
</COMMENTS> 

<DESC_SHORT>
Compares input with threshold and outputs a 0 if less, and 1 if greater or equal Output occurs on positive edge of control input
</DESC_SHORT>


<DECLARATIONS> 

	int samples;

</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF>Threshold</DEF>
	<TYPE>float</TYPE>
	<NAME>thh</NAME>
	<VALUE>0.0</VALUE>
</PARAM>
</PARAMETERS>

       

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>x</NAME>
		<DELAY><TYPE>max</TYPE><VALUE_MAX>2</VALUE_MAX></DELAY>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>in_control</NAME>
		<DELAY><TYPE>max</TYPE><VALUE_MAX>2</VALUE_MAX></DELAY>
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


]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

	for(samples = MIN_AVAIL();samples > 0; --samples)
	{
		IT_IN(0);
		IT_IN(1);

		if(IT_OUT(0)) {
			KrnOverflow("threshold",0);
			return(99);
		}

		if(in_control(0) == 1.0 && in_control(1) == 0.0)
		{
			if(x(0) < thh)
			{
				y(0) = 1.0;
			}
			else
			{
				y(0) = 0.0;
			} 
		}
		else
		{
			y(0) = 0.0;
		}
	}
	return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

