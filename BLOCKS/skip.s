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

skip 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/***************************************************************************
		skip.s
****************************************************************************
This star eats the first N values,  useful for skipping transient periods
-Parameter one: the number of samples to skip
<NAME>
skip
</NAME>
<DESCRIPTION>
This star devours the first N values,  useful for skipping transient periods
</DESCRIPTION>
<PROGRAMMERS>
Programmer:	John T. Stonick
Date:		January 1988
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

   
<DESC_SHORT>
This star devours the first N values,  useful for skipping transient periods
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>no_samples</NAME>
		<VALUE>0</VALUE>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i;
	float x;

</DECLARATIONS> 

    

<PARAMETERS>
<PARAM>
	<DEF></DEF>
	<TYPE>int</TYPE>
	<NAME>no_skip</NAME>
	<VALUE>100</VALUE>
</PARAM>
</PARAMETERS>

    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>xin</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
    

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>xout</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 


]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	while(AVAIL(0))
	{
	for(i=0;i<AVAIL(0);i++)
		{
		IT_IN(0);
		if(no_samples++ >= no_skip)
		{
			if(IT_OUT(0)) {
				KrnOverflow("skip",0);
				return(99);
			}
			x=xin(0);
			xout(0) = x;
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

