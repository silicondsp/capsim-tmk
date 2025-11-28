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

mux 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* mux.s */
/**********************************************************************
			mux()
***********************************************************************
This star actively selects one input data channel to send to its output.
Input channel 0 is always the control port;  its input stream of
numbers selects which input data channel to route to the output.
The number N of input data channels is arbitrary (>= 1).
In the event that the control port sample does not correspond to an
attached input buffer number (i.e. 1-N), a zero sample is output.
Since the control buffer is (float), rounding is used to generate an
integer buffer number.
Note: ALL input buffers are incremented (it_in) at each time,
whether their sample is chosen for output or not.
The output supports auto-fanout (automatic "forking").
There are no parameters.
<NAME>
mux
</NAME>
<DESCRIPTION>
This star actively selects one input data channel to send to its output.
Input channel 0 is always the control port;  its input stream of
numbers selects which input data channel to route to the output.
The number N of input data channels is arbitrary (>= 1).
In the event that the control port sample does not correspond to an
attached input buffer number (i.e. 1-N), a zero sample is output.
Since the control buffer is (float), rounding is used to generate an
integer buffer number.
Note: ALL input buffers are incremented (it_in) at each time,
whether their sample is chosen for output or not.
The output supports auto-fanout (automatic "forking").
There are no parameters.
</DESCRIPTION>
<PROGRAMMERS>
Programmer: L.J. Faber
Date: April, 1988.
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

    
<DESC_SHORT>
This star actively selects one input data channel to send to its output.
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
	int buffer_id;

</DECLARATIONS> 

   
<INIT_CODE>
<![CDATA[ 

	if((inbufs = NO_INPUT_BUFFERS()) < 2
		|| (outbufs = NO_OUTPUT_BUFFERS()) < 1) {
		fprintf(stderr,"mux: i/o buffers connect problem\n");
		return(1);
	}

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	for(i=0; i<MIN_AVAIL(); i++) {
		for(j=0; j<inbufs; j++)
			IT_IN(j);
		buffer_id = (int)(INF(0,0) + .5);
		if(buffer_id > 0 && buffer_id < inbufs) {
			for(j=0; j<outbufs; j++) {
				if(IT_OUT(j)){
					KrnOverflow("mux",j);
					return(99);
				}
				OUTF(j,0) = INF(buffer_id,0);
			}
		}
		else {
			for(j=0; j<outbufs; j++) {
				if(IT_OUT(j)) {
					KrnOverflow("mux",j);
					return(99);
				}
				OUTF(j,0) = 0;
			}
		}
	}

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

