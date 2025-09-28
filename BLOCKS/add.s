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

add 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* add.s */
/**********************************************************************
			add()
***********************************************************************
<NAME>
add
</NAME>
<DESCRIPTION>
Function adds all its input samples to yield an output sample;
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
Adds multiple floating point buffers. Auto fan-in auto fan-out
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>ibufs</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>obufs</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i,j;
	int samples;
	float sample_out;

</DECLARATIONS> 

   
<INIT_CODE>
<![CDATA[ 

	/* store as state the number of input/output buffers */
	if((ibufs = NO_INPUT_BUFFERS()) < 1) {
		fprintf(stderr,"add: no input buffers\n");
		return(2);
	}
	if((obufs = NO_OUTPUT_BUFFERS()) < 1) {
		fprintf(stderr,"add: no output buffers\n");
		return(3);
	}

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	/* read one sample from each input buffer and add them */
	for(samples = MIN_AVAIL(); samples >0; --samples) {

		sample_out = 0;

		for(i=0; i<ibufs; ++i) {
			IT_IN(i);
			sample_out += INF(i,0);
		}
		for(i=0; i<obufs; i++) {
			if(IT_OUT(i)) {
				fprintf(stderr,"add: Buffer %d is full\n",i);
				return(1);
			}
			OUTF(i,0) = sample_out;
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

