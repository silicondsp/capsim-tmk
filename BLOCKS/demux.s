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

demux 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/**********************************************************************
                demux()
***********************************************************************
This star provides periodic demultiplexing of an input data stream.
It is appropriate for sub-sampling (integer decimation) or creating
data streams for fractionally-spaced equalization (FSE).
For every N (integer) input samples, 1 sample is sent to each output.
The number of outputs and their phases are selectable.
Param	1 - (int) ratio input rate/output rate, N.
	2 - (array) specifies the "phase" (delay in samples relative
		to first input sample) for each output (10 Max). 
   		All phases must be non-negative.
<NAME>
demux
</NAME>
<DESCRIPTION>
This star provides periodic demultiplexing of an input data stream.
It is appropriate for sub-sampling (integer decimation) or creating
data streams for fractionally-spaced equalization (FSE).
For every N (integer) input samples, 1 sample is sent to each output.
The number of outputs and their phases are selectable.
Param	1 - (int) ratio input rate/output rate, N.
	2 - (array) specifies the "phase" (delay in samples relative
		to first input sample) for each output (10 Max). 
   		All phases must be non-negative.
</DESCRIPTION>
<PROGRAMMERS>
Programmer: L.J. Faber 
Date: April 1988
Modified:
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

    
<DESC_SHORT>
This star provides periodic demultiplexing of an input data stream.
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int*</TYPE>
		<NAME>out_time</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>obufs</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i;
	int no_samples;

</DECLARATIONS> 

       

<PARAMETERS>
<PARAM>
	<DEF>Ratio input rate/output rate,N</DEF>
	<TYPE>int</TYPE>
	<NAME>N</NAME>
	<VALUE>8</VALUE>
</PARAM>
<PARAM>
	<DEF>Array: Specifies the phase (delay in samples relative to first input sample) for each output.</DEF>
	<TYPE>array</TYPE>
	<NAME>phases</NAME>
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

	if(N < 1 ) {
		fprintf(stderr,"demux: improper parameter\n");
		return(1);
	}
	for(i=0; i<n_phases; i++) {
		if(phases[i] < 0) {
			fprintf(stderr,"demux: improper array params\n");
			return(2);
		}
	}
	if((obufs = NO_OUTPUT_BUFFERS()) != n_phases) {
		fprintf(stderr,"demux: param array != topology\n");
		return(3);
	}
	if( (out_time = (int*)calloc(obufs,sizeof(float))) == NULL ) {
		fprintf(stderr,"demux: can't allocate space\n");
		return(4);
	}
	for(i=0; i<n_phases; i++)
		out_time[i] = phases[i];

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

	for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) {
		IT_IN(0);
		for(i=0; i<n_phases; i++) {
			if(out_time[i] <= 0) {
				if(IT_OUT(i)) {
					KrnOverflow("demux",i);
					return(99);
				}
				OUTF(i,0) = INF(0,0);
				out_time[i] += N;
			}
			--out_time[i];
		}
	}

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

