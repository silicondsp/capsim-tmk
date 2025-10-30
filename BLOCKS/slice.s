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

slice 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*********************************************************************
                slice()
**********************************************************************
This block simulates a decision element for a data receiver.
It compares the incoming signal to a set of thresholds, which are
COMPUTED from the user-specified set of output levels.
Thresholds are always exactly HALF way between specified output levels.
Output levels are specified via a topology file parameter array.
Parameter arrays are float, so there are no restrictions on specified
output values.  Only 10 levels are allowed, and must be listed in
ascending magnitude order.
	Examples-- binary decision (threshold = 0.0)
			param array 2 -1.0 1.0
		   quaternary decision (thresholds -2/0/2)
			param array 4 -3.  -1.  1.  3.
The number of output channels is determined at run-time (auto-fanout).
<NAME>
slice
</NAME>
<DESCRIPTION>
This block simulates a decision element for a data receiver.
It compares the incoming signal to a set of thresholds, which are
COMPUTED from the user-specified set of output levels.
Thresholds are always exactly HALF way between specified output levels.
Output levels are specified via a topology file parameter array.
Parameter arrays are float, so there are no restrictions on specified
output values.  Only 10 levels are allowed, and must be listed in
ascending magnitude order.
	Examples-- binary decision (threshold = 0.0)
			param array 2 -1.0 1.0
		   quaternary decision (thresholds -2/0/2)
			param array 4 -3.  -1.  1.  3.
The number of output channels is determined at run-time (auto-fanout).
</DESCRIPTION>
<PROGRAMMERS>
Programmer:  L.J. Faber
Date: April, 1988
Modified:
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

    
<DESC_SHORT>
This block simulates a decision element for a data receiver.
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>obufs</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>thresh[10]</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i,j;
	int	no_samples;

</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF>Array of decision levels: # of levels, levels</DEF>
	<TYPE>array</TYPE>
	<NAME>level</NAME>
	<VALUE></VALUE>
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

	if((obufs = NO_OUTPUT_BUFFERS()) < 1) {
		fprintf(stderr,"slicer: no output buffers\n");
		return(2);
	}
	if(n_level < 2) {
		fprintf(stderr,"slicer: improper parameters\n");
		return(1);
	}
	for(i=0; i<n_level-1; i++) {
		if(level[i] >= level[i+1]) {
			fprintf(stderr,
	"slicer: level parameters must be in ascending order!\n");
		return(3);
		}
		thresh[i] = (level[i] + level[i+1])/2.;
	}

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) {
		IT_IN(0);
		for(i=0; i<n_level-1; i++) {
			if(x(0) < thresh[i]) break;	
		}
		for(j=0; j<obufs; j++) {
			if(IT_OUT(j)) {
				KrnOverflow("slice",j);
				return(99);
			}
			OUTF(j,0) = level[i];
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

