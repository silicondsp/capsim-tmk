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

pri 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*pri.s*/
/*
 * This star writes the input data on the screen in hex form
<NAME>
pri
</NAME>
<DESCRIPTION>
This star writes the input data on the screen in hex form
</DESCRIPTION>
<PROGRAMMERS>
</PROGRAMMERS> 
 */

]]>
</COMMENTS> 

   
<DESC_SHORT>
This star writes the input data on the screen in hex form
</DESC_SHORT>

<INCLUDES>
<![CDATA[ 
#include <string.h>
]]>
</INCLUDES> 


<STATES>
	<STATE>
		<TYPE>FILE*</TYPE>
		<NAME>fp</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int no_samples;
	int i;

</DECLARATIONS> 

       

<PARAMETERS>
<PARAM>
	<DEF>Format: 0=Hex, 1=Decimal</DEF>
	<TYPE>int</TYPE>
	<NAME>flag</NAME>
	<VALUE>0</VALUE>
</PARAM>
<PARAM>
	<DEF>Name of output file</DEF>
	<TYPE>file</TYPE>
	<NAME>file_name</NAME>
	<VALUE>stdout</VALUE>
</PARAM>
</PARAMETERS>

    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>int</TYPE>
		<NAME>x</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

	if(strcmp(file_name,"stdout") == 0) fp=stdout;
	else {
           if((fp = fopen(file_name,"w")) == NULL) {
                fprintf(stdout,"pri: can't open output file '%s'\n",
                        file_name);
                return(3);
           }
	}

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) {
		IT_IN(0);
		switch(flag) {
		  case 0:
                      fprintf(fp,"%x\n", x(0));
		      break;
		  case 1:
                      fprintf(fp,"%d\n", x(0));
		      break;
		}
	}



]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

                fclose(fp);

]]>
</WRAPUP_CODE> 



</BLOCK> 

