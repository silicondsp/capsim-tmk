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

pump 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*
	pump.s:		charge pump and loop filter for PLL
	parameters:	g1, integrate gain of the filter
			vs, voltage step magnitude
	inputs:		up, of phase detector
			down, of phase detector
	outputs:	out, the filtered signal
	description:	This block implements a charge pump
			loop filter as a recursive equation:
			y(n)=y(n-1)
			     +g1*[x(n)-x(n-1)]	
			This filter can be used as a PLL loop filter.
<NAME>
pump
</NAME>
<DESCRIPTION>
	pump.s:		charge pump and loop filter for PLL
	parameters:	g1, integrate gain of the filter
			vs, voltage step magnitude
	inputs:		up, of phase detector
			down, of phase detector
	outputs:	out, the filtered signal
	description:	This block implements a charge pump
			loop filter as a recursive equation:
			y(n)=y(n-1)
			     +g1*[x(n)-x(n-1)]	
			This filter can be used as a PLL loop filter.
</DESCRIPTION>
<PROGRAMMERS>
</PROGRAMMERS>
 */

]]>
</COMMENTS> 

   
<DESC_SHORT>
Charge pump and loop filter for PLL
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>t_out</NAME>
		<VALUE>0.0</VALUE>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int samples;
	float t_in;
	float t_in2;

</DECLARATIONS> 

       

<PARAMETERS>
<PARAM>
	<DEF>Integrate gain</DEF>
	<TYPE>float</TYPE>
	<NAME>g1</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Voltage step</DEF>
	<TYPE>float</TYPE>
	<NAME>vs</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
</PARAMETERS>

       

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>up</NAME>
		<DELAY><TYPE>max</TYPE><VALUE_MAX>2</VALUE_MAX></DELAY>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>down</NAME>
		<DELAY><TYPE>max</TYPE><VALUE_MAX>2</VALUE_MAX></DELAY>
	</BUFFER>
</INPUT_BUFFERS>
 
     

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>y</NAME>
		<DELAY><TYPE>max</TYPE><VALUE_MAX>2</VALUE_MAX></DELAY>
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
		t_in = down(0)-up(0);
		t_in2 = down(1)-up(1);

		if(t_in == 0.0)
		{
			if(t_in2 == -1.0)
			{
				t_out += vs;
			}
			if(t_in2 == 1.0)
			{
				t_out -= vs;
			}
		}
		if(t_in == 1.0)
		{
			if(t_in2 == 0.0)
			{
				t_out += vs;
			}
			else
			{
				t_out += g1;
			}
		}
		if(t_in == -1.0)
		{
			if(t_in2 == 0.0)
			{
				t_out -= vs;
			}
			else
			{
				t_out -= g1;
			}
		}
		if(IT_OUT(0)) {
			KrnOverflow("pump",0);
			return(99);
		}
		y(0)=t_out;
	}
	return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

