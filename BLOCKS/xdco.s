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

xdco 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/************************************************************************
 *                                                                      *
 *	xdco.s	:	digitally controlled oscillator 		*
 *									*
 *	parameters:	fs, sampling frequency				*
 *			fo, center frequency				*
 *			A, amplitude					*
 *									*
 *	inputs:		lambda, phase update term			*
 *									*
 *	outputs:	A*cos(2*PI*fo*t+theta)				*
 *			A*sin(2*PI*fo*t+theta)				*
 *									*
 *	description:	This star produces samples of the outputs	*
 *			every 1/fs seconds.  The dco behaves just	*
 *			like an FM modulator.  The phase is updated	*
 *			as theta=theta+lambda (integrates the input)	*
 *									*
 *									*
 *			written by John T. Stonick			*
 *									*
<NAME>
xdco
</NAME>
<DESCRIPTION>
digitally controlled oscillator 		*
 *									*
 *	parameters:	fs, sampling frequency				*
 *			fo, center frequency				*
 *			A, amplitude					*
 *									*
 *	inputs:		lambda, phase update term			*
 *									*
 *	outputs:	A*cos(2*PI*fo*t+theta)				*
 *			A*sin(2*PI*fo*t+theta)				*
 *									*
 *	description:	This star produces samples of the outputs	*
 *			every 1/fs seconds.  The dco behaves just	*
 *			like an FM modulator.  The phase is updated	*
 *			as theta=theta+lambda (integrates the input)	*
</DESCRIPTION>
<PROGRAMMERS>
written by John T. Stonick
</PROGRAMMERS>
 ************************************************************************/

]]>
</COMMENTS> 

<DESC_SHORT>
This star produces samples of the outputs every 1/fs seconds.  The dco behaves just	like an FM modulator.  The phase is updated	as theta=theta+lambda (integrates the input)	*
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


</DECLARATIONS> 

         

<PARAMETERS>
<PARAM>
	<DEF>Sampling Rate</DEF>
	<TYPE>float</TYPE>
	<NAME>fs</NAME>
	<VALUE>1.</VALUE>
</PARAM>
<PARAM>
	<DEF>Center Frequency</DEF>
	<TYPE>float</TYPE>
	<NAME>fo</NAME>
	<VALUE>1.</VALUE>
</PARAM>
<PARAM>
	<DEF>Amplitude</DEF>
	<TYPE>float</TYPE>
	<NAME>A</NAME>
	<VALUE>1.</VALUE>
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
		<NAME>cout</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>sout</NAME>
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
			KrnOverflow("xdco",0);
			return(99);
		}
		if(IT_OUT(1)) {
			KrnOverflow("xdco",1);
			return(99);
		}
		theta=theta+lambda(0);
		cout(0)=A*(float)cos((double)(2.*PI*fo*t+theta));
		sout(0)=A*(float)sin((double)(2.*PI*fo*t+theta));
		t=t+1/fs;
	}

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

