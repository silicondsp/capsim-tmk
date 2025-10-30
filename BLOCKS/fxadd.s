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

fxadd 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* fxadd.s */
/**********************************************************************
			fxadd()
***********************************************************************
	This block adds all of its input samples. The input is
	accepted in pairs coming from fxgain.s block. The output
	is rounded by the number of bits specified by the parameter
	roundoff_bits.
	Parameters :
	1 - (int) roudoff_bits 
	2 - (int) size : The size of input number 
	3 - (int) output_size : output register word-length
<NAME>
fxadd
</NAME>
<DESCRIPTION>
	This block adds all of its input samples. The input is
	accepted in pairs coming from fxgain.s block. The output
	is rounded by the number of bits specified by the parameter
	roundoff_bits.
	Parameters :
	1 - (int) roudoff_bits 
	2 - (int) size : The size of input number 
	3 - (int) output_size : output register word-length
</DESCRIPTION>
<PROGRAMMERS>
	Programmer : KARAOGUZ, Jeyhan
	Date       : 9/30/90
</PROGRAMMERS>	
*/

]]>
</COMMENTS> 

    
<DESC_SHORT>
This block adds all of its input samples using fixed point arithmetic. 
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberInputBuffers</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberOutputBuffers</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i, j, samples;
	int sum1, sum0, input1, input0, out1, out0, out;
	doublePrecInt inputSample;

</DECLARATIONS> 

           

<PARAMETERS>
<PARAM>
	<DEF>roundoff bits</DEF>
	<TYPE>int</TYPE>
	<NAME>roundoff_bits</NAME>
	<VALUE>8</VALUE>
</PARAM>
<PARAM>
	<DEF>Word length</DEF>
	<TYPE>int</TYPE>
	<NAME>size</NAME>
	<VALUE>32</VALUE>
</PARAM>
<PARAM>
	<DEF>outputsize</DEF>
	<TYPE>int</TYPE>
	<NAME>output_size</NAME>
	<VALUE>32</VALUE>
</PARAM>
<PARAM>
	<DEF>saturation mode</DEF>
	<TYPE>int</TYPE>
	<NAME>saturation_mode</NAME>
	<VALUE>1</VALUE>
</PARAM>
</PARAMETERS>

<INIT_CODE>
<![CDATA[ 

        if (size > 32) {
                fprintf(stderr,"fxadd:size can not be greater than 32\n");
                return(4);
                }
	if ((size & 1) == 1) {
                fprintf(stderr,"fxadd: Sorry, size can not be an odd number\n");
                return(4);
                }
	/* 
	 * store as state the number of input/output buffers 
	 */
	if ((numberInputBuffers = NO_INPUT_BUFFERS()) < 1) {
		fprintf(stderr,"fxadd: no input buffers\n");
		return(2);
	}
	for(i=0; i< numberInputBuffers; i++) 
		SET_CELL_SIZE_IN(i,sizeof(doublePrecInt));
	if ((numberOutputBuffers = NO_OUTPUT_BUFFERS()) < 1) {
		fprintf(stderr,"fxadd: no output buffers\n");
		return(3);
	}
	for(i=0; i< numberOutputBuffers; i++) 
		SET_CELL_SIZE_OUT(i,sizeof(int));

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	/* 
	 * read one sample from each input buffer and add them 
	 */

	for (samples = (MIN_AVAIL());samples > 0; --samples) {

		sum1 = 0;
		sum0 = 0;

		for (i=0; i<numberInputBuffers; ++i) { 

	                IT_IN(i);
			         inputSample = INDI(i,0);
                        input1 = inputSample.highWord;
                        input0 = inputSample.lowWord;
                        Fx_AddVar(size,saturation_mode,input1,input0,sum1,sum0,&out1,&out0); 
                        sum1 = out1;
                        sum0 = out0;
		} 

		Fx_RoundVar(size,output_size,roundoff_bits,sum1,sum0,&out);

		for (i=0; i<numberOutputBuffers; ++i) { 

			if(IT_OUT(i) ) {
				KrnOverflow("fxadd",i);
				return(99);
			}
            OUTI(i,0) = out;
		} 
	}

	return(0);	/* at least one input buffer empty */


]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

