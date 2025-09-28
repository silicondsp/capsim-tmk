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

intcntrl 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*
	integrate.s:	Integrator
 	parameters:	none
	inputs:		in, signal to integrate
			int_hold, integrate or hold
				  1 to integrate
				  0 to hold
			dump,
				  positive edge to dump
	outputs:	out, Integrated signal
	description:	This star implements an integrator 
			that charges and discharges by control
<NAME>
Integrator
</NAME>
<DESCRIPTION>
	This star implements an integrator 
			that charges and discharges by control
	inputs:		in, signal to integrate
			int_hold, integrate or hold
				  1 to integrate
				  0 to hold
			dump,
				  positive edge to dump
	outputs:	out, Integrated signal
</DESCRIPTION>
<PROGRAMMERS>
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

   
<DESC_SHORT>
This star implements an integrator  that charges and discharges by control
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>y</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int samples;

</DECLARATIONS> 

   
         

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>in</NAME>
		<DELAY><TYPE>max</TYPE><VALUE_MAX>2</VALUE_MAX></DELAY>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>int_hold</NAME>
		<DELAY><TYPE>max</TYPE><VALUE_MAX>2</VALUE_MAX></DELAY>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>dump</NAME>
		<DELAY><TYPE>max</TYPE><VALUE_MAX>2</VALUE_MAX></DELAY>
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

	y = 0;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

	for(samples = MIN_AVAIL(); samples > 0; --samples)
	{
		IT_IN(0);
		IT_IN(1);
		IT_IN(2);
		if(int_hold(0) == 1.0)
		{
			y += in(0);
		}
		if(dump(0) == 1.0 && dump(1) == 0.0)
		{
			y=0;
		}
		if(IT_OUT(0)) {
			KrnOverflow("intctrl",0);
			return(99);
		}
		out(0) = y;
	}

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

