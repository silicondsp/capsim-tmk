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

trig 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* trig.s */
/******************************************************************
			trig() 
*******************************************************************
Parameter 1: (int) number samples to output; default => all
		2: (int) index first sample; default => start from first
		3: (float) gain; default => unity gain
		4: (float) dc offset; default => no offset
		5: (int) operation: 0=sin,1=cos,2=tan,3=arctan,4=arcsin
<NAME>
trig
</NAME>
<DESCRIPTION>
Perform trig operation on input buffers
Parameter 1: (int) number samples to output; default => all
		2: (int) index first sample; default => start from first
		3: (float) gain; default => unity gain
		4: (float) dc offset; default => no offset
		5: (int) operation: 0=sin,1=cos,2=tan,3=arctan,4=arcsin
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
Perform trig operation on input buffers
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 

#include <math.h>

]]>
</INCLUDES> 

<DECLARATIONS> 

	int i,j;
	float xval;
	float tmp;

</DECLARATIONS> 

         

<PARAMETERS>
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
	<DEF>Operation:0=sin,1=cos,2=tan,3=arctan,4=arcsin</DEF>
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
				if(IT_OUT(0)) {
					KrnOverflow("trig",0);
					return(99);
				}
				tmp = gain * xval + offset;
				switch ( operation) {
				  case 0:
					xmod(0) = sin(tmp);
					break;
				  case 1:
					xmod(0) = cos(tmp);
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
	return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

