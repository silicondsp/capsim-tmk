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

fxgain 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* fxgain.s */
/**********************************************************************
                          fxgain()
***********************************************************************
	This star multiplies the incoming data stream by the
	parameter "Gain factor" in fixed-point arithmetic.The
	star is capable of doing extended precision arithmetic
	upto 64 bits result which is to be rounded to at least   
	32 bits after the fxadd.s star.
	Parameters :
	1 - (float) factor : FIR tap coefficient   
	2 - (int)   qbits  : Number of bits to represent the 
			     fraction
	3 - (int)   size   : Total word length including the 
			     integer part and the sign bit
	Buffers:
		input buffer 0: integer samples
		output buffers: Auto fanout type doublePrecInt
	Programmer : KARAOGUZ, Jeyhan
	Date       : 9/26/90  
<NAME>
fxgain
</NAME>
<DESCRIPTION>
This star multiplies the incoming data stream by the
	parameter "Gain factor" in fixed-point arithmetic.The
	star is capable of doing extended precision arithmetic
	upto 64 bits result which is to be rounded to at least   
	32 bits after the fxadd.s star.
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
This star multiplies the incoming data stream by the parameter "Gain factor" in fixed-point arithmetic.
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberOutputBuffers</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>fxfactor</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>fxfactor1</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>fxfactor0</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>less_flag1</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>less_flag2</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>max</NAME>
	</STATE>
	<STATE>
		<TYPE>int*</TYPE>
		<NAME>overflow</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i, samples, val;
        int input, input1, input0;
        int out1, out0;
	doublePrecInt	sampleOut;

</DECLARATIONS> 

         

<PARAMETERS>
<PARAM>
	<DEF>Gain factor</DEF>
	<TYPE>float</TYPE>
	<NAME>factor</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Number of bits to represent fraction</DEF>
	<TYPE>int</TYPE>
	<NAME>qbits</NAME>
	<VALUE>8</VALUE>
</PARAM>
<PARAM>
	<DEF>Word length</DEF>
	<TYPE>int</TYPE>
	<NAME>size</NAME>
	<VALUE>32</VALUE>
</PARAM>
</PARAMETERS>

    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>int</TYPE>
		<NAME>x</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

	if ((numberOutputBuffers = NO_OUTPUT_BUFFERS()) <= 0) {
		fprintf(stderr,"gain: no output buffers\n");
		return(2);
		}
	overflow = (int*)calloc(1,sizeof(int)); /* what is this ! */
	if (size > 32) {
		fprintf(stderr,"size can not be greater than 32\n");	
                return(4);
		}
	if ((size & 1) == 1) {
		fprintf(stderr,"Sorry, size can not be an odd number\n");	
                return(4);
		}
        if (qbits > 30) {
	/* 
	 * Because 1<<31 becomes a negative number in this machine 
	 */
		fprintf(stderr,"At most 30 bits are allowed for fraction\n"); 
	        return(4);
        	}
	/* 
	 * Calculate the maximum number to be represented by size bits 
	 */
        max=1;
        max <<= (size-1); 
	max -= 1;
	val=1; 
	val <<= qbits;
        if (factor>0.0)
		fxfactor = (int)(factor * val + 0.5);
        else
		fxfactor = (int)(factor * val - 0.5);
        if (fxfactor > max || (-fxfactor) > max) {
        	fprintf(stderr,"gain can not be represented by size bits\n");
        	return(4);
        	}
        Fx_Part(size,fxfactor,&fxfactor1,&fxfactor0,&less_flag1);
	for(i=0; i<numberOutputBuffers; i++) 
		SET_CELL_SIZE_OUT(i,sizeof(doublePrecInt));

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


for(samples = MIN_AVAIL(); samples >0; --samples) {

	IT_IN(0);
        input = x(0);

        if (input > max || (-input) > max) {
        	fprintf(stderr,"input cannot be represented by size bits\n");
       	}
       
        Fx_Part(size,input,&input1,&input0,&less_flag2);
        
        Fx_MultVar(less_flag1,less_flag2,size,fxfactor1,fxfactor0,
                                    input1,input0,&out1,&out0);
	
        for (i=0; i<numberOutputBuffers; i++) {
		   if(IT_OUT(i)) {
			   KrnOverflow("fxgain",i);
			   return(99);
		   }
		   sampleOut.lowWord=out0;
		   sampleOut.highWord=out1;
                OUTDI(i,0) = sampleOut;

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

