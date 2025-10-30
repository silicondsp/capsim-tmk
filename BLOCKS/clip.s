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

clip 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/***************************************************************************
		clip.s
****************************************************************************
This block eats values that are outside a range that is specified by the 
first parameter
-Parameter one: the cutoff value
<NAME>
clip
</NAME>
<DESCRIPTION>
This block eats values that are outside a range that is specified by the 
first parameter
</DESCRIPTION>
<PROGRAMMERS>
Programmer:	John T. Stonick
Date:		January 1988
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This block eats values that are outside a range that is specified by the first parameter
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 

#include <math.h>

]]>
</INCLUDES> 

   

<STATES>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>cutoff2</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i;
	float d;

</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF>Clip value</DEF>
	<TYPE>float</TYPE>
	<NAME>cutoff</NAME>
	<VALUE>100000.0</VALUE>
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

	cutoff2 = cutoff * cutoff;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	while(AVAIL(0))
	{
	for(i=0;i<AVAIL(0);i++)
		{
		IT_IN(0);
		d=in(0);
		if(d*d <= cutoff2)
		{
			if(IT_OUT(0)) {
				KrnOverflow("clip",0);
				return(99);
			}
			out(0) = d;
		}
		}
	}

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

