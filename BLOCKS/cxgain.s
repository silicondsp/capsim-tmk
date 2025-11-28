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

cxgain 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* cxgain.s */
/**********************************************************************
                          cxgain()
***********************************************************************
This star multiplies the incoming complex data stream by the complex parameter
coefficient, and outputs the resulting complex data values.
Auto fanout is supported.
<NAME>
cxgain
</NAME>
<DESCRIPTION>
This star multiplies the incoming complex data stream by the complex parameter
coefficient, and outputs the resulting complex data values.
Auto fanout is supported.
</DESCRIPTION>
<PROGRAMMERS>
Sasan Ardalan
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

   
<DESC_SHORT>
This star multiplies the incoming complex data stream by the complex parameter coefficient, and outputs the resulting complex data values.
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numOutBuffers</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i;
	int samples;
	complex val,tmp;

</DECLARATIONS> 

       

<PARAMETERS>
<PARAM>
	<DEF>Gain factor real part</DEF>
	<TYPE>float</TYPE>
	<NAME>factorReal</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Gain factor imaginary part</DEF>
	<TYPE>float</TYPE>
	<NAME>factorImag</NAME>
	<VALUE>0.0</VALUE>
</PARAM>
</PARAMETERS>

    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>complex</TYPE>
		<NAME>x</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

	if((numOutBuffers = NO_OUTPUT_BUFFERS()) <= 0) {
		fprintf(stderr,"cxgain: no output buffers\n");
		return(2);
	}
	SET_CELL_SIZE_IN(0,sizeof(complex));
	for (i=0; i<numOutBuffers; i++)
                SET_CELL_SIZE_OUT(i,sizeof(complex));

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


for(samples = MIN_AVAIL(); samples >0; --samples) {
	IT_IN(0);
	tmp=x(0);
        val.re = tmp.re*factorReal - tmp.im*factorImag;
        val.im = tmp.im*factorReal + tmp.re*factorImag;
	for(i=0; i<numOutBuffers; i++) {
		if(IT_OUT(i)) {
			KrnOverflow("cxgain",i);
			return(99);
		}
		OUTCX(i,0) = val;
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

