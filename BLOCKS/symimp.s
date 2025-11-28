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

symimp 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*symimp()*/
/**********************************************************************
                           symimp()
***********************************************************************
Description:
This star inputs data  and stretches it with zeros.
The code output oversampling rate (samples per baud interval) is
selected by the  parameter `smplbd'. 
<NAME>
symimp
</NAME>
<DESCRIPTION>
This star inputs data  and stretches it with zeros.
The code output oversampling rate (samples per baud interval) is
selected by the  parameter `smplbd'. 
</DESCRIPTION>
<PROGRAMMERS>
Programmer:  A. S. Sadri
Date: June 4, 1990
Modified: March 20, 2002 SHA
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

   
<DESC_SHORT>
This star inputs data  and stretches it with zeros.
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberOutputBuffers</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i;
	float mag;
	float code_val;
	int no_samples;

</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF>Samples per baud</DEF>
	<TYPE>int</TYPE>
	<NAME>smplbd</NAME>
	<VALUE>8</VALUE>
</PARAM>
</PARAMETERS>

     

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>bindata</NAME>
		<DELAY><TYPE>max</TYPE><VALUE_MAX>1</VALUE_MAX></DELAY>
	</BUFFER>
</INPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

        numberOutputBuffers = NO_OUTPUT_BUFFERS();
        if(numberOutputBuffers == 0) {
                fprintf(stderr,"symimp: no output buffers connected \n");
                return(3);
        }

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


 for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) {
		IT_IN(0);
		code_val = bindata(0);

		for(i=0; i<smplbd; i++) {
			if(IT_OUT(0)) {
				KrnOverflow("symimp",0);
				return(99);
			}
			if(!i)
                           OUTF(0,0) = code_val;
                        else 
                           OUTF(0,0) = 0;
		}
	}

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

