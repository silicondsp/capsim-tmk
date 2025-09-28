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

spiceprb 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/**********************************************************************
			spiceprb()
***********************************************************************
<NAME>
spiceprb
</NAME>
<DESCRIPTION>
Spice probe. Used in spice circuit simulation.
</DESCRIPTION>
<PROGRAMMERS>
Programmer:  S. Ardalan
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

     
<DESC_SHORT>
Spice probe. Used in spice circuit simulation.
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberInputBuffers</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberOutputBuffers</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>displayFlag</NAME>
		<VALUE>0</VALUE>
	</STATE>
</STATES>
 
<DECLARATIONS> 


</DECLARATIONS> 

   
<INIT_CODE>
<![CDATA[ 

if((numberInputBuffers = NO_INPUT_BUFFERS()) <= 0) {
	fprintf(stdout,"spiceprb: no input buffers\n");
	return(1);
}
if((numberOutputBuffers = NO_OUTPUT_BUFFERS()) > numberInputBuffers) {
	fprintf(stdout,"spiceprb: more output than input buffers\n");
	return(2);
}

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

	

return(0);


]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

