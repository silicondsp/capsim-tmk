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

delay 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* delay.s */
/*********************************************************************
			delay()
**********************************************************************
Function delays its input samples by any number of samples
Parameter 1 - number of samples of delay; default => 1.
<NAME>
delay
</NAME>
<DESCRIPTION>
Function delays its input samples by any number of samples
Parameter 1 - number of samples of delay; default => 1.
</DESCRIPTION>
<PROGRAMMERS>
Modified: April, 1988 L.J.Faber: add auto-fanout.
Modified: June, 1988 L.J.Faber: add default value; kludge fix for
		feedback problems...set delay_max.
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

   
<DESC_SHORT>
Function delays its input samples by any number of samples
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>obufs</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

        int i;
	int	no_samples;

</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF>Enter number of samples to delay</DEF>
	<TYPE>int</TYPE>
	<NAME>samples_delay</NAME>
	<VALUE>1</VALUE>
</PARAM>
</PARAMETERS>

      

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>x</NAME>
		<DELAY><TYPE>max</TYPE><VALUE_MAX>samples_delay + 1</VALUE_MAX></DELAY>
		<DELAY><TYPE>min</TYPE><VALUE_MIN>samples_delay</VALUE_MIN></DELAY>
	</BUFFER>
</INPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

	if( (obufs = NO_OUTPUT_BUFFERS()) < 1 ) {
		fprintf(stderr,"delay: no output buffers\n");
		return(1);
	}

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) {
		IT_IN(0);
		for(i=0; i<obufs; i++) {
                	if(IT_OUT(i)) {
				KrnOverflow("delay",i);
				return(99);
			}
			OUTF(i,0) = x(samples_delay);
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

