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

offset 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*
	offset.s:	DC offset block	
	parameters:	offset value
	inputs:		in, the signal to be offset
	outputs:	out, the offset signal
			written by Ray Kassel
			August 21, 1990
<NAME>
offset
</NAME>
<DESCRIPTION>
offset.s:	DC offset block	
	parameters:	offset value
	inputs:		in, the signal to be offset
	outputs:	out, the offset signal
</DESCRIPTION>
<PROGRAMMERS>
			written by Ray Kassel
			August 21, 1990
</PROGRAMMERS>
 */

]]>
</COMMENTS> 

<DESC_SHORT>
DC offset block	
</DESC_SHORT>


<DECLARATIONS> 


</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF>DC offset value</DEF>
	<TYPE>float</TYPE>
	<NAME>voff</NAME>
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
			KrnOverflow("offset",0);
			return(99);
		}
		y(0) = x(0) + voff;
	}

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

