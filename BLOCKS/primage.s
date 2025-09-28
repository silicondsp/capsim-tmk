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

primage 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/**********************************************************************
			primage()
***********************************************************************
<NAME>
primage
</NAME>
<DESCRIPTION>
Stores image in a file.
</DESCRIPTION>
<PROGRAMMERS>
Programmer:  Sasan Ardalan 
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

       
<DESC_SHORT>
Stores image in a file.
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>FILE*</TYPE>
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
</STATES>
 
<DECLARATIONS> 

	int i,j,k;
	FILE *fopen();

</DECLARATIONS> 

         

<PARAMETERS>
<PARAM>
	<DEF>Name of output file</DEF>
	<TYPE>file</TYPE>
	<NAME>file_name</NAME>
	<VALUE>stdout</VALUE>
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
		fprintf(stdout,"primage: no input buffers\n");
		return(1);
	}
	if((obufs = NO_OUTPUT_BUFFERS()) > ibufs) {
		fprintf(stdout,"primage: more output than input buffers\n");
		return(2);
	}
	if(strcmp(file_name,"stdout") == 0) {
		fp = stdout;
		displayFlag = 1;
	}
	else if(strcmp(file_name,"stderr") == 0) {
		fp = stderr;
		displayFlag = 1;
	}
	else if((fp = fopen(file_name,"w")) == NULL) {
		fprintf(stdout,"primage: can't open output file '%s'\n",
			file_name);
		return(3);
	}
	fprintf(fp,"%d %d\n",width,height);

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

        if(displayFlag && MIN_AVAIL() > 0) {
                fprintf(fp,"\n");
                for(j=0; j<(ibufs-2); j++)
                        fprintf(fp,"%-6s","");
                fprintf(fp,"Output From Prfile '%s'\n",block_P->name);
                for(j=0; j<ibufs; ++j)
                     fprintf(fp,"%-10s  ", SNAME(j));
                fprintf(fp,"\n");
	}
        /* This mode synchronizes all input buffers */
        for(i = MIN_AVAIL(); i>0; i--) {
                for(j=0; j<ibufs; ++j) {
                        IT_IN(j);
                        if(j < obufs) {
                                if(IT_OUT(j)) {
					KrnOverflow("primage",j);
					return(99);
				}
                                OUTF(j,0) = INF(j,0);
                        }
                        fprintf(fp,"%-10g  ", INF(j,0));
			numberColumnsPrinted++;
                	if(numberColumnsPrinted >= width) {
				fprintf(fp,"\n");
				numberColumnsPrinted = 0;
			}
                }
        }
	
	/* This mode empties all input buffers */
	for(j=0; j<ibufs; ++j) {
		if(j < obufs) {
			while(IT_IN(j)) {
				if(IT_OUT(j)) {
					KrnOverflow("primage",j);
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

	if(fp != stdout && fp != stderr)
		fclose(fp);

]]>
</WRAPUP_CODE> 



</BLOCK> 

