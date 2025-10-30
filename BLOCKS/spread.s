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

spread 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*spread()*/
/**********************************************************************
                           spread()
***********************************************************************
Description:
This block inputs data  and spreads it with a sequence from a file.
The parameters are the file containing the spreading values and the number of
chips per bit.
This block expects the input data to be in the form of "1"s and "0".
<NAME>
spread
</NAME>
<DESCRIPTION>
This block inputs data  and spreads it with a sequence from a file.
The parameters are the file containing the spreading values and the number of
chips per bit.
This block expects the input data to be in the form of "1"s and "0".
</DESCRIPTION>
<PROGRAMMERS>
Programmer: Sasan Ardalan, Ali Sadri 
Date: March 20, 2002 SHA
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This block inputs data  and spreads it with a sequence from a file.
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 

#include <stdio.h>

]]>
</INCLUDES> 

    

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
        FILE *fp;

</DECLARATIONS> 

       

<PARAMETERS>
<PARAM>
	<DEF>Chips per Bit</DEF>
	<TYPE>int</TYPE>
	<NAME>chipsPerBit</NAME>
	<VALUE>8</VALUE>
</PARAM>
<PARAM>
	<DEF>File name containing spreading sequence</DEF>
	<TYPE>file</TYPE>
	<NAME>spreadSeqFileName</NAME>
	<VALUE>spread.dat</VALUE>
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

	if((template = (float*)calloc(chipsPerBit, sizeof(float))) == NULL) {
		fprintf(stderr, "spread: cannot allocate space\n");
		return(1);
	}
        fp=fopen(spreadSeqFileName,"r");
	if(fp == NULL) {
		fprintf(stderr, "spread: cannot open file: %s \n",spreadSeqFileName);
		return(2);
	}
        for(i=0; i<chipsPerBit; i++) {
             fscanf(fp,"%f",&template[i]);
             if(feof(fp)) {
		fprintf(stderr, "spread: premature end of  file: %s \n",spreadSeqFileName);
		return(3);
             }
        }
        fclose(fp);
        numberOutputBuffers = NO_OUTPUT_BUFFERS();
        if(numberOutputBuffers == 0) {
                fprintf(stderr,"spread: no output buffers connected \n");
                return(3);
        }

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


 for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) {
		IT_IN(0);
		mag = bindata(0);
                if(mag==0.0)  code_val= -1;
                else
                         code_val=1;

		for(i=0; i<chipsPerBit; i++) {
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

