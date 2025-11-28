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

impulse 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* impulse.s */
/**********************************************************************
                          impulse()
************************************************************************
This star sends out a unit sample, then a number of zero samples. The 
only parameter, which defaults to NUMBER_SAMPLES_PER_VISIT, sets the total samples
to send out.
<NAME>
impulse
</NAME>
<DESCRIPTION>
This star sends out a unit sample, then a number of zero samples. The 
only parameter, which defaults to NUMBER_SAMPLES_PER_VISIT, sets the total samples
to send out.
</DESCRIPTION>
<PROGRAMMERS>
Mod: ljfaber 12/87 add 'auto fanout'
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

    
<DESC_SHORT>
This star sends out a unit sample, then a number of zero samples.
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>samples_out</NAME>
		<VALUE>0</VALUE>
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
	<DEF>Enter number of samples</DEF>
	<TYPE>int</TYPE>
	<NAME>length</NAME>
	<VALUE>128</VALUE>
</PARAM>
</PARAMETERS>

<INIT_CODE>
<![CDATA[ 

	if((no_obuf = NO_OUTPUT_BUFFERS() ) <= 0) {
		fprintf(stderr,"impulse: no outputs connected\n");
		return(1);
	}

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	for (i=0; i<NUMBER_SAMPLES_PER_VISIT; i++) {
     
		if (samples_out++ >= length) return(0);

		for(j=0; j<no_obuf; j++) {
			if(IT_OUT(j)) {
				KrnOverflow("impulse",0);
				return(99);
			}

			if(samples_out > 1) OUTF(j,0) = 0.;
			else 	OUTF(j,0) = 1.;
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

