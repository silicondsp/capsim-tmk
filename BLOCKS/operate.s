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

operate 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* operate.s */
/******************************************************************
			operate() 
*******************************************************************
Parameter 1: (int) number samples to output; default => all
		2: (int) index first sample; default => blockt from first
		3: (float) gain; default => unity gain
		4: (float) dc offset; default => no offset
		5: (int) operation: 0=none,1=abs,2=square,3=sqrt,4=dB
<NAME>
operate
</NAME>
<DESCRIPTION>
Parameter 1: (int) number samples to output; default => all
		2: (int) index first sample; default => blockt from first
		3: (float) gain; default => unity gain
		4: (float) dc offset; default => no offset
		5: (int) operation: 0=none,1=abs,2=square,3=sqrt,4=dB
</DESCRIPTION>
<PROGRAMMERS>
Programmer: 	Sasan Ardalan	
Date:	 	Dec. 29, 1990	
Modified:
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
Perform operations on input buffer.
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 

#include <math.h>

]]>
</INCLUDES> 

    

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>count</NAME>
		<VALUE>N</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>wait</NAME>
		<VALUE>first</VALUE>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i,j;
	float xval;
	float tmp;

</DECLARATIONS> 

             

<PARAMETERS>
<PARAM>
	<DEF>Number of samples to output</DEF>
	<TYPE>int</TYPE>
	<NAME>N</NAME>
	<VALUE>30000</VALUE>
</PARAM>
<PARAM>
	<DEF>First sample to blockt from</DEF>
	<TYPE>int</TYPE>
	<NAME>first</NAME>
	<VALUE>0</VALUE>
</PARAM>
<PARAM>
	<DEF>Gain</DEF>
	<TYPE>float</TYPE>
	<NAME>gain</NAME>
	<VALUE>1.</VALUE>
</PARAM>
<PARAM>
	<DEF>DC Offset</DEF>
	<TYPE>float</TYPE>
	<NAME>offset</NAME>
	<VALUE>0.</VALUE>
</PARAM>
<PARAM>
	<DEF>Operation:0=none,1=abs,2=square,3=sqrt,4=dB</DEF>
	<TYPE>int</TYPE>
	<NAME>operation</NAME>
	<VALUE>0</VALUE>
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
		<NAME>xmod</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 


]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	for(i=MIN_AVAIL();i>0; --i) {
		IT_IN(0);
		xval = x(0);
		if(wait-- <= 0 ) {
			if(count-- > 0) {
				if(IT_OUT(0)) {
					KrnOverflow("operate",0);
					return(99);
				}
				tmp = gain * xval + offset;
				switch ( operation) {
				  case 0:
					xmod(0) = tmp;
					break;
				  case 1:
					xmod(0) = fabs(tmp);
					break;
				  case 2:
					xmod(0) = tmp*tmp;
					break;
				  case 3:
					xmod(0) = sqrt(tmp);
					break;
				  case 4:
					if(tmp)
					   xmod(0) = 10*log10(tmp*tmp);
					else 
					   xmod(0)= -200.0;
					break;
				}
			}
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

