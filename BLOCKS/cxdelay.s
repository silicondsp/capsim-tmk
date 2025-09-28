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

cxdelay 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* cxdelay.s */
/*********************************************************************
			cxdelay()
**********************************************************************
Function delays its complex input samples by any number of samples
Parameter 1 - number of samples of delay; default => 1.
<NAME>
cxdelay
</NAME>
<DESCRIPTION>
Function delays its complex input samples by any number of samples
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
Function delays its complex input samples by any number of samples
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numOutBuffers</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

        int i;
	int	samples;

</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF>Enter number of samples to delay</DEF>
	<TYPE>int</TYPE>
	<NAME>samplesDelay</NAME>
	<VALUE>1</VALUE>
</PARAM>
</PARAMETERS>

      

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>complex</TYPE>
		<NAME>x</NAME>
		<DELAY><TYPE>max</TYPE><VALUE_MAX>samplesDelay + 1</VALUE_MAX></DELAY>
		<DELAY><TYPE>min</TYPE><VALUE_MIN>samplesDelay</VALUE_MIN></DELAY>
	</BUFFER>
</INPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

	if( (numOutBuffers = NO_OUTPUT_BUFFERS()) < 1 ) {
		fprintf(stderr,"delay: no output buffers\n");
		return(1);
	}
	SET_CELL_SIZE_IN(0,sizeof(complex));
    for (i=0; i<numOutBuffers; i++)
                SET_CELL_SIZE_OUT(i,sizeof(complex));

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	for(samples=MIN_AVAIL();samples >0; --samples) {
		IT_IN(0);
		for(i=0; i<numOutBuffers; i++) {
                	if(IT_OUT(i)) {
				KrnOverflow("cxdelay",i);
				return(99);
			}
			OUTCX(i,0) = x(samplesDelay);
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

