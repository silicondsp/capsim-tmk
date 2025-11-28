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

prbinimage 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/**********************************************************************
			prbINIMAGE()
***********************************************************************
<NAME>
prbinimage
</NAME>
<DESCRIPTION>
Inputs image and stores as binary to file.
</DESCRIPTION>
<PROGRAMMERS>
Programmer:  Sasan Ardalan 
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
Inputs image and stores as binary to file.
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 

#include <sys/file.h>
#include <limits.h>     /* definition of OPEN_MAX */
#include <unistd.h>
]]>
</INCLUDES> 

<DEFINES> 

#define PMODE 0644

</DEFINES> 

        

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>fp</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>ibufs</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>obufs</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>displayFlag</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberColumnsPrinted</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>char*</TYPE>
		<NAME>buff</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i,j,k;
	unsigned short pixel;
	float	fpixel;

</DECLARATIONS> 

         

<PARAMETERS>
<PARAM>
	<DEF>Name of output file</DEF>
	<TYPE>file</TYPE>
	<NAME>file_name</NAME>
	<VALUE>output.img</VALUE>
</PARAM>
<PARAM>
	<DEF>Image Width</DEF>
	<TYPE>int</TYPE>
	<NAME>width</NAME>
	<VALUE>1</VALUE>
</PARAM>
<PARAM>
	<DEF>Image Height</DEF>
	<TYPE>int</TYPE>
	<NAME>height</NAME>
	<VALUE>1</VALUE>
</PARAM>
</PARAMETERS>

<INIT_CODE>
<![CDATA[ 

	if((ibufs = NO_INPUT_BUFFERS()) <= 0) {
		fprintf(stdout,"prbinimage: no input buffers\n");
		return(1);
	}
	if((obufs = NO_OUTPUT_BUFFERS()) > ibufs) {
		fprintf(stdout,"prbinimage: more output than input buffers\n");
		return(2);
	}
	if((fp = creat(file_name,PMODE)) == -1) {
		fprintf(stdout,"prbinimage: can't create output file '%s'\n",
			file_name);
		return(3);
	}
	fprintf(stderr,"prbinimage to produce %d x  %d image file\n",width,height);
        buff = (char *) calloc(width,sizeof(char));
        if(buff == NULL) {
                fprintf(stderr,"prbinimage: can't allocate space\n");
                return(4);
        }

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

        /* This mode synchronizes all input buffers */
        for(i = MIN_AVAIL(); i>0; i--) {
                for(j=0; j<ibufs; ++j) {
                        IT_IN(j);
                        if(j < obufs) {
                                if(IT_OUT(j)) {
					KrnOverflow("prbinimage",j);
					return(99);
				}
                                OUTF(j,0) = INF(j,0);
                        }
			fpixel = INF(j,0);
			if(fpixel < 0 ) pixel = 0;
			   else if (fpixel > 255) pixel = 255;
			     else pixel = (unsigned short)fpixel;	
			buff[numberColumnsPrinted]= (char)pixel;
			numberColumnsPrinted++;
                	if(numberColumnsPrinted >= width) {
				write(fp,buff,width);
				numberColumnsPrinted = 0;
			}
                }
        }
	
	/* This mode empties all input buffers */
	for(j=0; j<ibufs; ++j) {
		if(j < obufs) {
			while(IT_IN(j)) {
				if(IT_OUT(j) ){
					KrnOverflow("prbinimage",j);
					return(99);
				}
				OUTF(j,0) = INF(j,0);
			}
		}
		else
			while(IT_IN(j));
	}
return(0);


]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

	free(buff);
	close(fp);

]]>
</WRAPUP_CODE> 



</BLOCK> 

