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

divider2 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*
	divider.s:	divides input asynchronously  
			by specified parameter
	parameters:	divide_by, value to divide by	
	inputs:		in_data, data to be divided
	outputs:	out_data, divided data
<NAME>
divider2
</NAME>
<DESCRIPTION>
	divider.s:	divides input asynchronously  
			by specified parameter
	parameters:	divide_by, value to divide by	
	inputs:		in_data, data to be divided
	outputs:	out_data, divided data
</DESCRIPTION>
<PROGRAMMERS>
December 4, 1990
</PROGRAMMERS>
 */

]]>
</COMMENTS> 

    
<DESC_SHORT>
Divides input asynchronously by specified parameter
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>count_val</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>temp_out</NAME>
		<VALUE>0</VALUE>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int samples;

</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF>value to divide by</DEF>
	<TYPE>int</TYPE>
	<NAME>divide_by</NAME>
	<VALUE>2</VALUE>
</PARAM>
</PARAMETERS>

     

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>in_data</NAME>
		<DELAY><TYPE>max</TYPE><VALUE_MAX>1</VALUE_MAX></DELAY>
	</BUFFER>
</INPUT_BUFFERS>
 
    

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>out_data</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 


]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	for(samples = MIN_AVAIL(); samples>0; --samples)
	{
		IT_IN(0);
		if(in_data(0) == 0.0 && in_data(1) > 0.5)
		{
			++count_val;
		}
		if(in_data(0) > 0.5 && in_data(1) == 0.0)
		{
			++count_val;
		}
		if(count_val == divide_by)
		{
			temp_out = ~temp_out & 1;
			count_val = 0;
		}
		if(IT_OUT(0)) {
			KrnOverflow("divider2",0);
			return(99);
		}
		out_data(0) = temp_out;
	}
	return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

