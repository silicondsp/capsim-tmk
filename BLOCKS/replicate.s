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

replicate 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*kesh()*/
/**********************************************************************
                           kesh()
***********************************************************************
Description:
This star inputs data  and stretches it.
<NAME>
kesh
</NAME>
<DESCRIPTION>
This star inputs data  and stretches it.
</DESCRIPTION>
<PROGRAMMERS>
Programmer: Sasan Ardalan 
Date: June 4, 1992
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

   
<DESC_SHORT>
This star inputs data  and stretches it.
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberOutputBuffers</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i;
	int value;
	int no_samples;

</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF>Samples to stretch</DEF>
	<TYPE>int</TYPE>
	<NAME>strby</NAME>
	<VALUE>8</VALUE>
</PARAM>
</PARAMETERS>

     

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>indata</NAME>
		<DELAY><TYPE>max</TYPE><VALUE_MAX>1</VALUE_MAX></DELAY>
	</BUFFER>
</INPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

        numberOutputBuffers = NO_OUTPUT_BUFFERS();
        if(numberOutputBuffers == 0) {
                fprintf(stderr,"kesh: no output buffers connected \n");
                return(1);
        }

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) {
		IT_IN(0);
		value = indata(0);

		for(i=0; i<strby; i++) {
			if(IT_OUT(0)) {
				KrnOverflow("replicate",0);
				return(99);
			}
			OUTF(0,0) = value;
		}
}

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

