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

toggle 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* toggle.s */
/**********************************************************************
			toggle()
***********************************************************************
This star selects one of two input data channels to output.
It always begins with channel 0.  After a delay, it switches to ch.1.
Parameter 1 selects the number of samples of ch.0 to output before
switching to ch.1.
Note: Both input buffers are incremented (it_in) at each time,
whether their sample is chosen for output or not.
The output supports auto-fanout (automatic "forking").
<NAME>
toggle
</NAME>
<DESCRIPTION>
This star selects one of two input data channels to output.
It always begins with channel 0.  After a delay, it switches to ch.1.
Parameter 1 selects the number of samples of ch.0 to output before
switching to ch.1.
Note: Both input buffers are incremented (it_in) at each time,
whether their sample is chosen for output or not.
The output supports auto-fanout (automatic "forking").
</DESCRIPTION>
<PROGRAMMERS>
Programmer: L.J. Faber
Date: April, 1988.
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

     
<DESC_SHORT>
This star selects one of two input data channels to output.
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
	<STATE>
		<TYPE>int</TYPE>
		<NAME>timer</NAME>
		<VALUE>switch_time</VALUE>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i,j;

</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF>Time in samples to switch to channel 1 from 0</DEF>
	<TYPE>int</TYPE>
	<NAME>switch_time</NAME>
	<VALUE>0</VALUE>
</PARAM>
</PARAMETERS>

<INIT_CODE>
<![CDATA[ 

	if((inbufs = NO_INPUT_BUFFERS()) != 2
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
		if(timer > 0) {
			--timer;
			for(j=0; j<outbufs; j++) {
				if(IT_OUT(j)) {
					KrnOverflow("toggle",j);
					return(99);
				}
				OUTF(j,0) = INF(0,0);
			}
		}
		else {
			for(j=0; j<outbufs; j++) {
				if(IT_OUT(j) ) {
					KrnOverflow("toggle",j);
					return(99);
				}
				OUTF(j,0) = INF(1,0);
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

