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

vcm 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*
 	vcm.s	:	voltage-controlled multivibrator
 	parameters:	fs, sampling frequency
 			fo, center frequency
 	inputs:		lambda, phase update term
 	output:		square wave equivalent of cos(2*PI*fo*t+theta)
 	description:	This star produces samples of the outputs
 			every 1/fs seconds with frequency of fo.
 			The phase is updated
 			as theta=theta+lambda (integrates the input)
<NAME>
vcm
</NAME>
<DESCRIPTION>
voltage-controlled multivibrator
 	parameters:	fs, sampling frequency
 			fo, center frequency
 	inputs:		lambda, phase update term
 	output:		square wave equivalent of cos(2*PI*fo*t+theta)
 	description:	This star produces samples of the outputs
 			every 1/fs seconds with frequency of fo.
 			The phase is updated
 			as theta=theta+lambda (integrates the input)
</DESCRIPTION>
<PROGRAMMERS>
</PROGRAMMERS>
 */

]]>
</COMMENTS> 

<DESC_SHORT>
Voltage-controlled multivibrator
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 

#include <math.h>

]]>
</INCLUDES> 

<DEFINES> 

#define  PI 3.141592654

</DEFINES> 

    

<STATES>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>t</NAME>
		<VALUE>0.</VALUE>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>theta</NAME>
		<VALUE>0.</VALUE>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	float temp_out;

</DECLARATIONS> 

       

<PARAMETERS>
<PARAM>
	<DEF>Sampling Rate</DEF>
	<TYPE>float</TYPE>
	<NAME>fs</NAME>
	<VALUE>32000.</VALUE>
</PARAM>
<PARAM>
	<DEF>Center Frequency</DEF>
	<TYPE>float</TYPE>
	<NAME>fo</NAME>
	<VALUE>1000.</VALUE>
</PARAM>
</PARAMETERS>

    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>lambda</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
    

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>data_out</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 


]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	if(AVAIL(0)>0)
	{
		IT_IN(0);
		if(IT_OUT(0)) {
			KrnOverflow("vcm",0);
			return(99);
		}
		theta=theta+lambda(0);
		temp_out = (float)cos((double)(2.*PI*fo*t+theta));
		if(temp_out > 0.0)
		{
			data_out(0) = 1.0;
		}
		else
		{
			data_out(0) = 0.0;
		}
		t=t+1/fs;
	}

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

