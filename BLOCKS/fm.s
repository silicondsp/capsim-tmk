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

fm 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/************************************************************************
 *									*
 *	fm.s:		frequency modulator				*
 *									*
 *	parameters:	fs, sampling frequency				*
 *			fo, center frequency				*
 * 			A, amplitude					*
 *									*
 *	inputs:		in, the signal to be modulated			*
 *									*
 *	outputs:	A*sin(2.*PI*fo*t+phase)				*
 *									*
 *	description:	This star produces samples of the output	*
 *			every 1/fs seconds.  The phase of an FM 	*
 *			signal is the integral of the input.  This	*
 *			is accomplished digitally as :			*
 *			phase=phase+in.					*
 *									*
 *									*
 *						*
 *									*
<NAME>
fm
</NAME>
<DESCRIPTION>
 *									*
 *	description:	This star produces samples of the output	*
 *			every 1/fs seconds.  The phase of an FM 	*
 *			signal is the integral of the input.  This	*
 *			is accomplished digitally as :			*
 *			phase=phase+in.					*
 *									*
 *
 *	parameters:	fs, sampling frequency				*
 *			fo, center frequency				*
 * 			A, amplitude					*
 *									*
 *	inputs:		in, the signal to be modulated			*
 *									*
 *	outputs:	A*sin(2.*PI*fo*t+phase)				*
</DESCRIPTION>
<PROGRAMMERS>
 John T. Stonick
</PROGRAMMERS> 
 ************************************************************************/

]]>
</COMMENTS> 

<DESC_SHORT>
This star produces samples of the output every 1/fs seconds.  The phase of an FM  signal is the integral of the input.  This is accomplished digitally as :	phase=phase+in		
</DESC_SHORT>

<INCLUDES>
<![CDATA[ 

#include <math.h>

]]>
</INCLUDES> 

<DEFINES> 

#define  PI  3.1415926

</DEFINES> 

    

<STATES>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>phase</NAME>
		<VALUE>0.</VALUE>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>t</NAME>
		<VALUE>0.</VALUE>
	</STATE>
</STATES>
 
<DECLARATIONS> 


</DECLARATIONS> 

         

<PARAMETERS>
<PARAM>
	<DEF>Sampling rate</DEF>
	<TYPE>float</TYPE>
	<NAME>fs</NAME>
	<VALUE></VALUE>
</PARAM>
<PARAM>
	<DEF>Center frequency</DEF>
	<TYPE>float</TYPE>
	<NAME>fo</NAME>
	<VALUE></VALUE>
</PARAM>
<PARAM>
	<DEF>Amplitude</DEF>
	<TYPE>float</TYPE>
	<NAME>A</NAME>
	<VALUE></VALUE>
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
		if(IT_OUT(0) ) {
			KrnOverflow("fm",0);
			return(99);
		}
		phase=phase+in(0);
		t=t+1/fs;
		out(0)=A*(float)sin((double)(2.*PI*fo*t+phase));
	}

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

