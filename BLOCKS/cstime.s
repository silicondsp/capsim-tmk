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

cstime 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* cstime.s */
/**********************************************************************
			cstime()
***********************************************************************
Function outputs the "time" to all connected output buffers.
The time between samples and the time before stopping are both
input parameters:
	The time between samples defaults to 1.0 ("second")
	The time before stopping defaults to infinity
Using the stopping criterion is a convenient way of controlling
the length of the simulation to a certain time interval specified
in seconds.
<NAME>
cstime
</NAME>
<DESCRIPTION>
Function outputs the "time" to all connected output buffers.
The time between samples and the time before stopping are both
input parameters:
	The time between samples defaults to 1.0 ("second")
	The time before stopping defaults to infinity
Using the stopping criterion is a convenient way of controlling
the length of the simulation to a certain time interval specified
in seconds.
</DESCRIPTION>
<PROGRAMMERS>
Programmer: D.G.Messerschmitt
Date: June 26, 1982
Modification for V2.0: Jan. 10, 1985
Mod: ljfaber 12/87 add 'auto fanout'
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

    
<DESC_SHORT>
Function outputs the "time" to all connected output buffers.
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>time_elapse</NAME>
		<VALUE>0.0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>no_obuf</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i,j;

</DECLARATIONS> 

       

<PARAMETERS>
<PARAM>
	<DEF>Time between samples</DEF>
	<TYPE>float</TYPE>
	<NAME>time_scale</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Time before stopping</DEF>
	<TYPE>float</TYPE>
	<NAME>time_stop</NAME>
	<VALUE>-1.0</VALUE>
</PARAM>
</PARAMETERS>

<INIT_CODE>
<![CDATA[ 

	if((no_obuf = NO_OUTPUT_BUFFERS() ) <= 0) {
		fprintf(stderr,"time: no output buffers\n");
		return(1); /* no output buffers */
	}

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	/* put out a maximum of NUMBER_SAMPLES_PER_VISIT samples */
	for(i=0; i < NUMBER_SAMPLES_PER_VISIT; ++i) {

		/* dont continue if time has exceeded time_stop  */
		if(time_stop >= 0.0 && time_elapse >= time_stop) return(0);
		for(j=0; j<no_obuf; j++) {
			if(IT_OUT(j)) {
				KrnOverflow("time",j);
				return(99);
			}
			OUTF(j,0) = time_elapse;
		}
		time_elapse += time_scale;
	}
	return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

