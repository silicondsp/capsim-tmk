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

rdimage 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*************************************************************
			rdimage()
***************************************************************
Programmer: Sasan Ardalan
Date: November 4, 1990 
<NAME>
rdimage
</NAME>
<DESCRIPTION>
Read an image from a file.
</DESCRIPTION>
<PROGRAMMERS>
Programmer: Sasan Ardalan
Date: November 4, 1990 
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

       
<DESC_SHORT>
Read an image from a file.
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 
#include <string.h>
]]>
</INCLUDES> 

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>obufs</NAME>
	</STATE>
	<STATE>
		<TYPE>FILE*</TYPE>
		<NAME>fp</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>width</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>height</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberRowsRead</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i,j;
	float x;

</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF>File that contains image</DEF>
	<TYPE>file</TYPE>
	<NAME>file_name</NAME>
	<VALUE>stdin</VALUE>
</PARAM>
</PARAMETERS>

<INIT_CODE>
<![CDATA[ 

	if(strcmp(file_name,"stdin") == 0)
		fp = stdin;
	else if((fp = fopen(file_name,"r")) == NULL) {
		fprintf(stderr,"rdimage: cannot open file\n");
		return(1); /* file cannot be opened */
	}
	if( (obufs = NO_OUTPUT_BUFFERS()) < 1 ) {
		fprintf(stderr,"rdimage: no output buffers\n");
		return(2);
	}
	fscanf(fp,"%d %d",&width,&height);
	fprintf(stderr,"Image width= %d, height = %d \n",width,height);
	numberRowsRead =0;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


   	if(numberRowsRead >= height) return(0); 
	/* 
	 * output a row 
	 */
	for(i=0; i < width; ++i) {

		/* Read input lines until EOF */
		if(fscanf(fp,"%f",&x) == EOF)
			break;

		/* input sample available: 
		 *
		 * increment time on output buffer(s) 
		 * and output a sample 
		 */
		for(j=0; j<obufs; j++) {
			if(IT_OUT(j)) {
				KrnOverflow("rdimage",j);
				return(99);
			}
			OUTF(j,0) = x;
		}
	}
	numberRowsRead++;
	

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

        if (fp != stdout)
             fclose(fp);
        return(0);

]]>
</WRAPUP_CODE> 



</BLOCK> 

