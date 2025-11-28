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

atod 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* atod.s */
/**************************************************************
				atod()
***************************************************************
	Inputs:		x, the signal  to be quantized 
	Outputs:	buffer 0: the quantized signal
			buffer 1 (optional): the quantization error 
	Parameters:	
			The number of bits (e.g. 13 bits)
			The Maximum input range (e.g. +- 5 volts)
****************************************************************
<NAME>
atod
</NAME>
<DESCRIPTION>
This star simulates a uniform analog to digital converter.
	Outputs:	buffer 0: the quantized signal
			buffer 1 (optional): the quantization error 
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
This star simulates a uniform analog to digital converter.
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>levels</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberOutputBuffers</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int no_samples;
	int i;
	float sample,sin,sout;

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
 
<INIT_CODE>
<![CDATA[ 

	levels = 1;
	levels <<= bits-1;
	numberOutputBuffers = NO_OUTPUT_BUFFERS();
	if(numberOutputBuffers == 0) {
		fprintf(stderr,"atod: no output buffers connected \n");
		return(1);
	}

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

 
	/* note the minimum number of samples on the input 	*/
	/* buffers and iterate that many times 			*/
 
	for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) 
 
	{
		IT_IN(0);	
		sample = x(0);
		sin = sample;
		sample = sample/maxLevel;
		if (sample > 1.0 ) sample = 1.0;
		if (sample < -1.0 ) sample = -1.0; 
		sample += 1.0;
		sample = (int) (sample*(levels) +0.5);
		sout =  sample - (float)(levels);  
		if(IT_OUT(0)) {
			KrnOverflow("atod",0);
			return(99);
		}
		OUTF(0,0) = sout;
		/*
	 	 * if buffer 1 connected, output the A/D error
		 */
		if( numberOutputBuffers == 2 ) { 
			if(IT_OUT(1)) {
				KrnOverflow("atod",1);
				return(99);
			}
			OUTF(1,0) = sout/(float)levels-sin;
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

