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

multiply 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* multiply.s */
/**********************************************************************
			multiply()
***********************************************************************
Function multiplies all its input samples to yield an output sample;
The number of input buffers is arbitrary and determined at run time.
The number of output buffers is also arbitrary (auto-fanout).
<NAME>
multiply
</NAME>
<DESCRIPTION>
Function multiplies all its input samples to yield an output sample;
The number of input buffers is arbitrary and determined at run time.
The number of output buffers is also arbitrary (auto-fanout).
</DESCRIPTION>
<PROGRAMMERS>
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

    
<DESC_SHORT>
Function multiplies all its input samples to yield an output sample
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numInBuffers</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numOutBuffers</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i,j;
	int samples;
	float calcSample;

</DECLARATIONS> 

   
<INIT_CODE>
<![CDATA[ 

	/* store as state the number of input/output buffers */
	if((numInBuffers = NO_INPUT_BUFFERS()) < 1) {
		fprintf(stderr,"multiply: no input buffers\n");
		return(2);
	}
	if((numOutBuffers = NO_OUTPUT_BUFFERS()) < 1) {
		fprintf(stderr,"multiply: no output buffers\n");
		return(3);
	}

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	/* read one sample from each input buffer and add them */
	for(samples = MIN_AVAIL(); samples >0; --samples) {

		calcSample = 1.0;

		for(i=0; i<numInBuffers; ++i) {
			IT_IN(i);
			calcSample *= INF(i,0);
		}
		for(i=0; i<numOutBuffers; i++) {
			if(IT_OUT(i)) {
				KrnOverflow("multiply",i);
				return(99);
			}
			OUTF(i,0) = calcSample;
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

