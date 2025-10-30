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

stc 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*stc()*/
/**********************************************************************
                           stc()
***********************************************************************
Description:
This block inputs data  and stretches it with zeros.
The code output oversampling rate (samples per baud interval) is
selected by the  parameter `smplbd'. 
Programmer:  A. S. Sadri
Date: June 4, 1990
<NAME>
stc
</NAME>
<DESCRIPTION>
This block inputs data  and stretches it with zeros.
The code output oversampling rate (samples per baud interval) is
selected by the  parameter `smplbd'. 
</DESCRIPTION>
<PROGRAMMERS>
Programmer:  A. S. Sadri
Date: June 4, 1990
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

    
<DESC_SHORT>
This block inputs data  and stretches it with zeros.
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>template</NAME>
	</STATE>
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

	if((template = (float*)calloc(smplbd, sizeof(float))) == NULL) {
		fprintf(stderr, "coder: cannot allocate space\n");
		return(1);
	}
		template[0] = 1.;
        numberOutputBuffers = NO_OUTPUT_BUFFERS();
        if(numberOutputBuffers == 0) {
                fprintf(stderr,"stcode: no output buffers connected \n");
                return(3);
        }

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


 for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) {
		IT_IN(0);
		mag = bindata(0);

		code_val =  mag;
		for(i=0; i<smplbd; i++) {
			if(IT_OUT(0)) {
				KrnOverflow("stc",0);
				return(99);
			}
			OUTF(0,0) = code_val * template[i];
		}
	}

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

	free(template);

]]>
</WRAPUP_CODE> 



</BLOCK> 

