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

cxsum 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* cxsum.s */
/**********************************************************************
			cxsum()
***********************************************************************
This star is an extension of "cxadd".  It creates a Weighted Sum of
all input channels and sends it to the output buffer(s).
(This is convenient for negating inputs, for example.)
Parameter one is an array for input channel weights.
The number of input buffers is determined at run time, 10 maximum.
The number of output buffers is determined at run time (auto-fanout).
<NAME>
cxsum
</NAME>
<DESCRIPTION>
This star is an extension of "cxadd".  It creates a Weighted Sum of
all input channels and sends it to the output buffer(s).
(This is convenient for negating inputs, for example.)
Parameter one is an array for input channel weights.
The number of input buffers is determined at run time, 10 maximum.
The number of output buffers is determined at run time (auto-fanout).
</DESCRIPTION>
<PROGRAMMERS>
Programmer: L.J. Faber
Date: April 20, 1988.
Modified by Sasan Ardalan for complex inputs/outputs
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

    
<DESC_SHORT>
This star is an extension of "cxadd".  It creates a Weighted Sum of all input channels and sends it to the output buffer(s).
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
	complex sum;
	complex tmp;

</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF>Array of weights: number_of_weights w0 w1 w2 ... </DEF>
	<TYPE>array</TYPE>
	<NAME>weights</NAME>
	<VALUE></VALUE>
</PARAM>
</PARAMETERS>

<INIT_CODE>
<![CDATA[ 

	if((numInBuffers = NO_INPUT_BUFFERS()) < 1
		|| (numOutBuffers = NO_OUTPUT_BUFFERS()) < 1) {
		fprintf(stderr,"cxsum: i/o buffers connect problem\n");
		return(1);
	}
	if(numInBuffers != n_weights) {
		fprintf(stderr,"cxsum: parameters disagree with inputs\n");
		return(2);
	}
        for (i=0; i<numInBuffers; i++)
                SET_CELL_SIZE_IN(i,sizeof(complex));
        for (i=0; i<numOutBuffers; i++)
                SET_CELL_SIZE_OUT(i,sizeof(complex));

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	for(i=0; i<MIN_AVAIL(); i++) {
		sum.re = 0;
		sum.im = 0;
		for(j=0; j<numInBuffers; j++) {
			IT_IN(j);
			tmp=INCX(j,0);
			tmp.re = weights[j]*tmp.re;
			tmp.im = weights[j]*tmp.im;
			sum.re += tmp.re;
			sum.im += tmp.im;
		}
		for(j=0; j<numOutBuffers; j++) {
			if(IT_OUT(j)) {
				KrnOverflow("cxsum",j);
				return(99);
			}
			OUTCX(j,0) = sum;
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

