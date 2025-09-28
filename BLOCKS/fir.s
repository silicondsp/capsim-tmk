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

fir 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* fir.s */
/**********************************************************************
			fir()
***********************************************************************
This star outputs a weighted sum of delayed input data.
Parameter one is an array for filter weights, 10 maximum.
Any number of these stars can be cascaded to implement longer filters.
Connect them like this:
        	CASCADE
        _________       _________ 
data-->0|        |0>-->0|        |0>--->output
        |  fir   |      |  fir   |
        |________|1>-->1|________|
(Input and output buffers are assigned automatically.)
To implement an IIR filter with an fir in a feedback loop,
include a unit delay:
                	IIR
        ______ 
data-->0| sum |0>----------------------------------->output
        |_____|                                 |
           ^1                                   |
           |      _________        ________     |
           |----<0|        |0<---<0| delay |0<--|
                  |  fir   |       |  (1)  |
                  |________|       |_______|
<NAME>
fir
</NAME>
<DESCRIPTION>
This star outputs a weighted sum of delayed input data.
Parameter one is an array for filter weights, 10 maximum.
Any number of these stars can be cascaded to implement longer filters.
Connect them like this:
        	CASCADE
        _________       _________ 
data-->0|        |0>-->0|        |0>--->output
        |  fir   |      |  fir   |
        |________|1>-->1|________|
(Input and output buffers are assigned automatically.)
To implement an IIR filter with an fir in a feedback loop,
include a unit delay:
                	IIR
        ______ 
data-->0| sum |0>----------------------------------->output
        |_____|                                 |
           ^1                                   |
           |      _________        ________     |
           |----<0|        |0<---<0| delay |0<--|
                  |  fir   |       |  (1)  |
                  |________|       |_______|
</DESCRIPTION>
<PROGRAMMERS>
Programmer: L.J. Faber
Date: April 21, 1988.
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

    
<DESC_SHORT>
This star outputs a weighted sum of delayed input data.
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
	<DEF>Array of weights</DEF>
	<TYPE>array</TYPE>
	<NAME>weights</NAME>
	<VALUE></VALUE>
</PARAM>
</PARAMETERS>

<INIT_CODE>
<![CDATA[ 

	if((inbufs = NO_INPUT_BUFFERS()) < 1 || inbufs > 2) {
		fprintf(stderr,"fir: wrong number input buffers\n");
		return(2);
	}
	if((outbufs = NO_OUTPUT_BUFFERS()) < 1 || outbufs > 2) {
		fprintf(stderr,"fir: wrong number output buffers\n");
		return(3);
	}
	/* setup input buffer memory */
	SET_DMAX_IN(0, n_weights );

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	for(i=0; i<MIN_AVAIL(); i++) {
		IT_IN(0);
		sum = 0;
		for(j=0; j<n_weights; j++)
			sum += weights[j] * INF(0,j);
		if(inbufs == 2) {
			IT_IN(1);
			sum += INF(1,0);
		}

		if(outbufs == 1) {
			if(IT_OUT(0)) {
				KrnOverflow("fir",0);
				return(99);
			}
			OUTF(0,0) = sum;
		}
		else {	/* outbufs == 2 */
			if(IT_OUT(0)) {
				KrnOverflow("fir",0);
				return(99);
			}
			if(IT_OUT(1)) {
				KrnOverflow("fir",1);
				return(99);
			}
			OUTF(0,0) = INF(0,n_weights);
			OUTF(1,0) = sum;
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

