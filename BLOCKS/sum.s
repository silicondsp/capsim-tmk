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

<BLOCK_NAME>sum</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* sum.s */
/**********************************************************************
			sum()
***********************************************************************
This block is an extension of "add".  It creates a Weighted Sum of
all input channels and sends it to the output buffer(s).
(This is convenient for negating inputs, for example.)
Parameter one is an array for input channel weights.
The number of input buffers is determined at run time, 10 maximum.
The number of output buffers is determined at run time (auto-fanout).
<NAME>
sum
</NAME>
<DESCRIPTION>
This block is an extension of "add".  It creates a Weighted Sum of
all input channels and sends it to the output buffer(s).
(This is convenient for negating inputs, for example.)
Parameter one is an array for input channel weights.
The number of input buffers is determined at run time, 10 maximum.
The number of output buffers is determined at run time (auto-fanout).
</DESCRIPTION>
<PROGRAMMERS>
Programmer: L.J. Faber
Date: April 20, 1988.
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

    
<DESC_SHORT>
This block is an extension of "add".  It creates a Weighted Sum of all input channels and sends it to the output buffer(s).
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>inbufs</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>outbufs</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i,j;
	float sum;

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

	if((inbufs = NO_INPUT_BUFFERS()) < 1
		|| (outbufs = NO_OUTPUT_BUFFERS()) < 1) {
		fprintf(stderr,"sum: i/o buffers connect problem\n");
		return(1);
	}
	if(inbufs != n_weights) {
		fprintf(stderr,"sum: parameters disagree with inputs\n");
		return(2);
	}
        for(j=0; j<inbufs; j++) {

           printf("SUM WEIGHT[%d]=%f\n",j,weights[j]);
        }

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	for(i=0; i<MIN_AVAIL(); i++) {
		sum = 0;
		for(j=0; j<inbufs; j++) {
			IT_IN(j);
			sum += weights[j] * INF(j,0);
		}
		for(j=0; j<outbufs; j++) {
			if(IT_OUT(j)) {
				KrnOverflow("sum",j);
				return(99);
			}
			OUTF(j,0) = sum;
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

