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

invert 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* invert.s */
/**********************************************************************
                          invert()
***********************************************************************
This block logically inverts incoming data stream
Auto fanout is supported.
<NAME>
invert
</NAME>
<DESCRIPTION>
This block logically inverts incoming data stream
Auto fanout is supported.
</DESCRIPTION>
<PROGRAMMERS>
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

   
<DESC_SHORT>
This block logically inverts incoming data stream
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>obufs</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i;
	int samples;
	int k_in;
	int k_out;
	float val;

</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF>length of data in bits</DEF>
	<TYPE>int</TYPE>
	<NAME>b_length</NAME>
	<VALUE>1</VALUE>
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

	if((obufs = NO_OUTPUT_BUFFERS()) <= 0) {
		fprintf(stdout,"invert: no output buffers\n");
		return(2);
	}

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


for(samples = MIN_AVAIL(); samples >0; --samples) {
	IT_IN(0);
	k_in = x(0);
	k_out = ~k_in & ~(~0 << b_length);
	val = k_out;

	for(i=0; i<obufs; i++) {
		if(IT_OUT(i)) {
			KrnOverflow("invert",i);
			return(99);
		}
		OUTF(i,0) = val;
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

