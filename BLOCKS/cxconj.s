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

cxconj 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* cxconj.s */
/**********************************************************************
                            cxconj()
***********************************************************************
Function has a single complex input buffer, and outputs 
the conjugate of each complex input sample to
an arbitrary number of complex output buffers.
<NAME>
cxconj
</NAME>
<DESCRIPTION>
Function has a single complex input buffer, and outputs 
the conjugate of each complex input sample to
an arbitrary number of complex output buffers.
</DESCRIPTION>
<PROGRAMMERS>
Sasan Ardalan
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

   
<DESC_SHORT>
Function has a single complex input buffer, and outputs the conjugate of each complex input sample to an arbitrary number of complex output buffers.
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numOutBuffers</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int numberOfSamples;
	int i;
	complex val;

</DECLARATIONS> 

   
    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>complex</TYPE>
		<NAME>x</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

	/* note and store the number of output buffers */
	if((numOutBuffers = NO_OUTPUT_BUFFERS() ) <= 0) {
		fprintf(stderr,"node: no output buffers\n");
		return(1); /* no output buffers */
	}
	SET_CELL_SIZE_IN(0,sizeof(complex));
	for (i=0; i<numOutBuffers; i++)
		SET_CELL_SIZE_OUT(i,sizeof(complex));

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	for(numberOfSamples=MIN_AVAIL();numberOfSamples >0; --numberOfSamples) {
		IT_IN(0);
		for(i=0;i<numOutBuffers;++i) {
			if(IT_OUT(i)) {
				KrnOverflow("cxconj",i); 
				return(99);
			}
			val=x(0);
			val.im = - val.im;
			OUTCX(i,0) = val;
		}
	}

    	return(0);  /* input buffer empty */


]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

