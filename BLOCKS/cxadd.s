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

cxadd 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* cxadd.s */
/**********************************************************************
			cxadd()
***********************************************************************
Function adds all its input complex samples to yield a complex output sample;
the number of input buffers is arbitrary and determined at run time.
The number of output buffers is also arbitrary (auto-fanout).
<NAME>
cxadd
</NAME>
<DESCRIPTION>
Function adds all its input complex samples to yield a complex output sample;
the number of input buffers is arbitrary and determined at run time.
The number of output buffers is also arbitrary (auto-fanout).
</DESCRIPTION>
<PROGRAMMERS>
Programmer: D.G.Messerschmitt March 7, 1985
Modified: 1/89 ljfaber. add auto-fanout
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

    
<DESC_SHORT>
Function adds all its input complex samples to yield a complex output sample
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
	complex sampleOut,val;

</DECLARATIONS> 

   
<INIT_CODE>
<![CDATA[ 

	/* store as state the number of input/output buffers */
	if((numInBuffers = NO_INPUT_BUFFERS()) < 1) {
		fprintf(stderr,"add: no input buffers\n");
		return(2);
	}
	if((numOutBuffers = NO_OUTPUT_BUFFERS()) < 1) {
		fprintf(stderr,"add: no output buffers\n");
		return(3);
	}
	for (i=0; i<numInBuffers; i++) 
		SET_CELL_SIZE_IN(i,sizeof(complex));
	for (i=0; i<numOutBuffers; i++) 
		SET_CELL_SIZE_OUT(i,sizeof(complex));

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	/* read one sample from each input buffer and add them */
	for(samples = MIN_AVAIL(); samples >0; --samples) {

		sampleOut.re = 0;
		sampleOut.im = 0;

		for(i=0; i<numInBuffers; ++i) {
			IT_IN(i);
			val = INCX(i,0);
			sampleOut.re += val.re;
			sampleOut.im += val.im;
		}
		for(i=0; i<numOutBuffers; i++) {
			if(IT_OUT(i)) {
				KrnOverflow("cxadd",i);
				return(99);
			}
			OUTCX(i,0) = sampleOut;
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

