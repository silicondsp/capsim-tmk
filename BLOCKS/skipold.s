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

skipold 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* skip.s */
/*********************************************************************
			skip()
**********************************************************************
Star skips the first N data points.
Parameter: (int) Number of points to be skipped.
           default => 0
Programmer: Tulay Adali
Date: 27 Nov 1988
*/

]]>
</COMMENTS> 

<DESC_SHORT>
Star skips the first N data points.
</DESC_SHORT>
   

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>n</NAME>
		<VALUE>0</VALUE>
	</STATE>
</STATES>
 
<DECLARATIONS> 

        int i;

</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF>Number of samples to skip</DEF>
	<TYPE>int</TYPE>
	<NAME>N</NAME>
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
		<NAME>y</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

	n=0;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

	while(IT_IN(0))	{
		if( n >= N) {
			if(IT_OUT(0)) {
				KrnOverflow("skipold",0);
				return(99);
			}
			y(0) = x(0);
		}
		n++;
	}

	return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

