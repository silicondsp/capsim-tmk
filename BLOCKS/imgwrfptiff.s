<BLOCK>
<LICENSE>
/*  Capsim (r) Text Mode Kernel (TMK) Block Library (Blocks)
    Copyright (C) 1989-2017  Silicon DSP  Corporation 

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
    Silicon DSP Corporation
     
*/
</LICENSE>
<BLOCK_NAME>
imgwrfptiff
</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/**********************************************************************
			imgwrfptiff()
***********************************************************************
Writes an input image to a TIFF file as 8 bit samples. Also store the current
colormap.
If multiple images are received, they overwrite the previous one.
This block can later be modified so that multiple images are stored in a single
TIFF file (with multiple directories). Or stored in multiple TIFF files
with the file name changing in some manner.
Auto fan out is supported.
Programmer:  Sasan Ardalan 
Date:	October 14, 1993
*/
]]>
</COMMENTS> 

<DESC_SHORT>
Writes an input image to a TIFF file as floating point  samples. Also store the current colormap.
</DESC_SHORT>

<INCLUDES>
<![CDATA[ 
#include <string.h>
]]>
</INCLUDES> 


<DECLARATIONS> 

	int i,j,k,ii;
	unsigned short pixel;
	float	fpixel;
    int IIP_WriteMatrixFloatingPointTIFFText(float**	matrix_PP,unsigned int	width,unsigned int	height, char*, char*	);

</DECLARATIONS> 




<STATES>
	<STATE>
		<TYPE> int </TYPE>
		<NAME> fp </NAME>
	</STATE>
	<STATE>
		<TYPE> int </TYPE>
		<NAME> ibufs </NAME>
	</STATE>
	<STATE>
		<TYPE> int </TYPE>
		<NAME> obufs </NAME>
	</STATE>
	<STATE>
		<TYPE> char* </TYPE>
		<NAME> buff </NAME>
	</STATE>
	<STATE>
		<TYPE> image_t </TYPE>
		<NAME> img </NAME>
	</STATE>
	<STATE>
		<TYPE> int </TYPE>
		<NAME> pwidth </NAME>
	</STATE>
	<STATE>
		<TYPE> int </TYPE>
		<NAME> pheight </NAME>
	</STATE>
	<STATE>
		<TYPE> float** </TYPE>
		<NAME> mat_PP </NAME>
	</STATE>
	<STATE>
		<TYPE> char * </TYPE>
		<NAME> theFileName </NAME>
	</STATE>
</STATES>



<PARAMETERS>
	<PARAM>
		<DEF> Name of output file </DEF>
		<TYPE> file </TYPE>
		<NAME> fileName </NAME>
		<VALUE> output.tif </VALUE>
	</PARAM>
	<PARAM>
		<DEF> Color Map File </DEF>
		<TYPE> file </TYPE>
		<NAME> colorMapFile </NAME>
		<VALUE> ther.map </VALUE>
	</PARAM>	
	
	
	
</PARAMETERS>



<INPUT_BUFFERS>
	<BUFFER>
		<TYPE> image_t </TYPE>
		<NAME> x </NAME>
	</BUFFER>
</INPUT_BUFFERS>

<INIT_CODE>
<![CDATA[ 

	if((ibufs = NO_INPUT_BUFFERS()) != 1) {
		fprintf(stdout,"imgwrtiff: no input buffer\n");
		return(1);
	}
	if((obufs = NO_OUTPUT_BUFFERS()) > ibufs) {
		fprintf(stdout,"imgwrfptiff: more output than input buffers\n");
		return(2);
	}
	for(j=0; j<obufs; j++)
                SET_CELL_SIZE_OUT(j,sizeof(image_t));
	for(i=0; i<ibufs; i++)
        	SET_CELL_SIZE_IN(i,sizeof(image_t));
	for(i=0; i<obufs; i++)
        	SET_CELL_SIZE_OUT(i,sizeof(image_t));

        theFileName= (char*) calloc(256, sizeof(char));

        strcpy(theFileName,fileName);

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

        /* This mode synchronizes all input buffers */
for(ii = MIN_AVAIL(); ii>0; ii--) {
        IT_IN(0);
	img=x(0);
	pheight=img.height;
	pwidth=img.width;
	mat_PP=img.image_PP;
	fprintf(stderr,"imgwrtiff to produce %d x  %d image file\n",pwidth,pheight);
	if(IIP_WriteMatrixFloatingPointTIFFText(mat_PP,pwidth,pheight,theFileName,colorMapFile)) {
                fprintf(stderr,"imgwrfptiff: can't write TIFF image\n");
                return(4);
        }

	if(obufs==1) {
                if(IT_OUT(0)) {
			KrnOverflow("imgwrfptiff",0);
			return(99);
		}
                OUTIMAGE(0,0) = img;
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

