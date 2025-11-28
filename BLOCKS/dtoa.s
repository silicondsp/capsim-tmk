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

dtoa 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* dtoa.s */
/**************************************************************
				dtoa()
***************************************************************
	Inputs:		x, the digital sample to be converted 
	Outputs:	y, the analog signal
	Parameters:	
			The number of bits (e.g. 13 bits)
			The Maximum input range (e.g. +- 5 volts)
****************************************************************
This star simulates a digital to analog converter.  
<NAME>
dtoa
</NAME>
<DESCRIPTION>
This star simulates a digital to analog converter.  
	Inputs:		x, the digital sample to be converted 
	Outputs:	y, the analog signal
	Parameters:	
			The number of bits (e.g. 13 bits)
			The Maximum input range (e.g. +- 5 volts)
</DESCRIPTION>
<PROGRAMMERS>
Programmer: 	Sasan Ardalan
Date: 		February 17, 1989
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

    
<DESC_SHORT>
This star simulates a digital to analog converter.  
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>levels</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>dist</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int no_samples;
	int i;
	float sample;

</DECLARATIONS> 

       

<PARAMETERS>
<PARAM>
	<DEF>Number of bits</DEF>
	<TYPE>int</TYPE>
	<NAME>bits</NAME>
	<VALUE>13</VALUE>
</PARAM>
<PARAM>
	<DEF>Maximum analog level</DEF>
	<TYPE>float</TYPE>
	<NAME>maxLevel</NAME>
	<VALUE>2.0</VALUE>
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

	levels = 1;
	levels <<= bits-1;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

 
	/* note the minimum number of samples on the input 	*/
	/* buffers and iterate that many times 			*/
 
	for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) 
 
		{
		if(IT_OUT(0)) {
			KrnOverflow("dtoa",0);
			return(99);	
		}
		IT_IN(0);	
		sample = x(0);
	 	sample = sample/(float)levels*maxLevel;	
		if (sample > maxLevel ) sample = maxLevel; 
		if (sample < -maxLevel ) sample = -maxLevel; 

		   y(0) = sample;  
		}
	return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

