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

roundi 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* roundi.s */
/**********************************************************************
                          roundi()
***********************************************************************
	This block multiplies the incoming data stream by the
	parameter "Gain factor" in fixed-point arithmetic.The
	block is capable of doing extended precision arithmetic
	upto 64 bits result which is to be rounded to at least   
	32 bits after the fxadd.s block.
	Parameters :
	1 - (float) factor : FIR tap coefficient   
	2 - (int)   qbits  : Number of bits to represent the 
			     fraction
	3 - (int)   size   : Total word length including the 
			     integer part and the sign bit
	Buffers:
		input buffer 0: integer samples
		output buffers: Auto fanout type doublePrecInt
<NAME>
roundi
</NAME>
<DESCRIPTION>
This block multiplies the incoming data stream by the
	parameter "Gain factor" in fixed-point arithmetic.The
	block is capable of doing extended precision arithmetic
	upto 64 bits result which is to be rounded to at least   
	32 bits after the fxadd.s block.
	Parameters :
	1 - (float) factor : FIR tap coefficient   
	2 - (int)   qbits  : Number of bits to represent the 
			     fraction
	3 - (int)   size   : Total word length including the 
			     integer part and the sign bit
	Buffers:
		input buffer 0: integer samples
		output buffers: Auto fanout type doublePrecInt
</DESCRIPTION>
<PROGRAMMERS>
	Programmer : KARAOGUZ, Jeyhan
	Date       : 9/26/90  
</PROGRAMMERS>	
*/

]]>
</COMMENTS> 

   
<DESC_SHORT>
This block multiplies the incoming data stream by the parameter "Gain factor" in fixed-point arithmetic.Theblock is capable of doing extended precision arithmetic upto 64 bits result which is to be rounded to at least 32 bits after the fxadd.s block.
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberOutputBuffers</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i, samples, val;
        float input;
        int out1, out0;
	int	sampleOut;

</DECLARATIONS> 

   
    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>x</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

	if ((numberOutputBuffers = NO_OUTPUT_BUFFERS()) <= 0) {
		fprintf(stdout,"roundi: no output buffers\n");
		return(2);
		}
	for(i=0; i<numberOutputBuffers; i++) 
		SET_CELL_SIZE_OUT(i,sizeof(int));

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


for(samples = MIN_AVAIL(); samples >0; --samples) {

	IT_IN(0);
        input = x(0);

	
        for (i=0; i<numberOutputBuffers; i++) {
		if(IT_OUT(i)) {
			KrnOverflow("fxgain",i);
			return(99);
		}
		if(input <0) sampleOut=(int)(input -0.5);
                else
                          sampleOut=(int)(input+0.5);
                OUTI(i,0) = sampleOut;

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

