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

ecount 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/**********************************************************************
                ecount()
***********************************************************************
"error counter"
This star compares two data streams for "equality".  (Since the input
streams are floating point, a guard band is used.) An output stream
is created, with 'zero' output for equality, and 'one' if there is a
difference.  (Note: the output stream is optional--if no star is
connected to the output, there is no output.)
Param. 1 selects an initial number of samples to be ignored for
the final error tally (used during training sequences); default zero.
Param 2 sets an index, after which a message is printed to stderr for
each error.  It defaults to "infinity", i.e. no error messages.
This star prints a final message to stderr giving the error rate
(errors/smpl), disregarding the initial ignored samples.
<NAME>
ecount
</NAME>
<DESCRIPTION>
"error counter"
This star compares two data streams for "equality".  (Since the input
streams are floating point, a guard band is used.) An output stream
is created, with 'zero' output for equality, and 'one' if there is a
difference.  (Note: the output stream is optional--if no star is
connected to the output, there is no output.)
Param. 1 selects an initial number of samples to be ignored for
the final error tally (used during training sequences); default zero.
Param 2 sets an index, after which a message is printed to stderr for
each error.  It defaults to "infinity", i.e. no error messages.
This star prints a final message to stderr giving the error rate
(errors/smpl), disregarding the initial ignored samples.
</DESCRIPTION>
<PROGRAMMERS>
Programmer: L.J. Faber 
Date: Dec 1987
Modified: April 1988
Modified: May 1988--Fix report print
Modified: June 1988--Fix report print
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This star compares two data streams for "equality".
</DESC_SHORT>


<DEFINES> 

#define GBAND 0.001	/* guard band for equality */

</DEFINES> 

      

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>samples</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>error_count</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>hits</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>obufs</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i,j;
	int numin;
	int err_out;

</DECLARATIONS> 

       

<PARAMETERS>
<PARAM>
	<DEF>Number of samples to ignore for final error tally</DEF>
	<TYPE>int</TYPE>
	<NAME>ignore</NAME>
	<VALUE>0</VALUE>
</PARAM>
<PARAM>
	<DEF>Index after which each error is printed to terminal</DEF>
	<TYPE>int</TYPE>
	<NAME>err_msg</NAME>
	<VALUE>30000</VALUE>
</PARAM>
</PARAMETERS>

     

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>w</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>x</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

	obufs = NO_OUTPUT_BUFFERS();

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	numin = MIN_AVAIL();
	for(i=0; i<numin; i++) {
		IT_IN(0);
		IT_IN(1);
		err_out = 0;
		if(w(0) > x(0) + GBAND || w(0) < x(0) - GBAND ) {
			hits++;
			if(samples >= ignore) {
				err_out = 1.;
				error_count++;
				if(samples >= err_msg)
	fprintf(stderr, "ecount: symbol error @%d\n",samples);

			}
			else {
				if(samples >= err_msg)
	fprintf(stderr, "ecount: symbol error @%d  (ignore)\n",samples);
			}
		}
		samples++;

		for(j=0; j<obufs; j++) {
			if(IT_OUT(j)) {
				KrnOverflow("ecount",j);
				return(99);
			}
			OUTF(j,0) = err_out;
		}
	}

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

fprintf(stderr,"ecount: hits/samples = %d/%d  (ignore %d)  BER = %d/%d = %.4g\n",
		hits, samples, samples>ignore? ignore:samples,
		error_count, samples>ignore? samples-ignore:0,
		samples>ignore? (float)error_count/(samples-ignore):0);

]]>
</WRAPUP_CODE> 



</BLOCK> 

