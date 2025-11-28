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

intdmp 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/************************************************************************
 *									*
 *	intdmp.s: Integrate and Dump					*
 *									*
 *	parameters:	Integration Time         			*
 *									*
 *	inputs:		in 						*
 *									*
 *	outputs:	out, Decimated by Integration Time		*
 *									*
 *	description:	This star implements a matched filter 
 *									*
 *									*
 *			written by Sasan H. Ardalan			*
 *	
<NAME>
intdmp
</NAME>
<DESCRIPTION>
This star implements a matched filter 
</DESCRIPTION>
<PROGRAMMERS>
Sasan H. Ardalan	
</PROGRAMMERS>
 ************************************************************************/

]]>
</COMMENTS> 

<DESC_SHORT>
This star implements a matched filter 
</DESC_SHORT>
    

<STATES>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>y</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numSamples</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 


</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF>Integration time (symbol time in samples)</DEF>
	<TYPE>int</TYPE>
	<NAME>dmpTime</NAME>
	<VALUE>8</VALUE>
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

	y = 0;
	numSamples=0;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

	while(IT_IN(0))
	{
		y=y+in(0);
		numSamples++;
		if(numSamples == dmpTime) {
			if(IT_OUT(0)) {
				KrnOverflow("intdmp",0);
				return(99);
			}
			out(0) = y;
			numSamples = 0;
			y=0;
		}
	}

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

