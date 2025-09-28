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

imggen 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* imggen.s */
/***********************************************************************
                             imggen()
************************************************************************
Generate a rectangular image. The image contains a rectangle offset
in width and height with specified rectangle width and height.
The image may be complemented in the sense that the value will fill
all the image except the rectangle.
For now only one image is generated. However, this can be easily changed
so that a sequence is generated.
Programmer:  	Sasan Ardalan	
Date: 		September 10, 1993
<NAME>
imggen
</NAME>
<DESCRIPTION>
Generate a rectangular image. The image contains a rectangle offset
in width and height with specified rectangle width and height.
The image may be complemented in the sense that the value will fill
all the image except the rectangle.
For now only one image is generated. However, this can be easily changed
so that a sequence is generated.
</DESCRIPTION>
<PROGRAMMERS>
Programmer:  	Sasan Ardalan	
Date: 		September 10, 1993
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
Generate a rectangular image.
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 

#include <math.h>
#include  <dsp.h> 

]]>
</INCLUDES> 

   

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>generated</NAME>
		<VALUE>0</VALUE>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int no_samples;
	int i,j,k;
	dsp_floatMatrix_t	matrix;
	dsp_floatMatrix_Pt	matrix_P;
	image_t		img;

</DECLARATIONS> 

                     

<PARAMETERS>
<PARAM>
	<DEF>Pixel Value</DEF>
	<TYPE>float</TYPE>
	<NAME>pixel</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Image Width</DEF>
	<TYPE>int</TYPE>
	<NAME>pwidth</NAME>
	<VALUE>128</VALUE>
</PARAM>
<PARAM>
	<DEF>Image Height</DEF>
	<TYPE>int</TYPE>
	<NAME>pheight</NAME>
	<VALUE>128</VALUE>
</PARAM>
<PARAM>
	<DEF>Rectangle Width</DEF>
	<TYPE>int</TYPE>
	<NAME>rectWidth</NAME>
	<VALUE>128</VALUE>
</PARAM>
<PARAM>
	<DEF>Rectangle Height</DEF>
	<TYPE>int</TYPE>
	<NAME>rectHeight</NAME>
	<VALUE>128</VALUE>
</PARAM>
<PARAM>
	<DEF>Rectangle Width Offset</DEF>
	<TYPE>int</TYPE>
	<NAME>widthOffset</NAME>
	<VALUE>0</VALUE>
</PARAM>
<PARAM>
	<DEF>Rectangle Height Offset</DEF>
	<TYPE>int</TYPE>
	<NAME>heightOffset</NAME>
	<VALUE>0</VALUE>
</PARAM>
<PARAM>
	<DEF>Complex Flag</DEF>
	<TYPE>int</TYPE>
	<NAME>complexFlag</NAME>
	<VALUE>0</VALUE>
</PARAM>
<PARAM>
	<DEF>Complement Flag</DEF>
	<TYPE>int</TYPE>
	<NAME>complementFlag</NAME>
	<VALUE>0</VALUE>
</PARAM>
</PARAMETERS>

    

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>image_t</TYPE>
		<NAME>y</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

		     SET_CELL_SIZE_OUT(0,sizeof(image_t));

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


while(!generated) {
	generated=1;
	matrix_P = Dsp_GenMatrix(pwidth,pheight,rectWidth,rectHeight,
                        widthOffset,heightOffset,
                        pixel,complexFlag,complementFlag);





	if(matrix_P==NULL) {
		fprintf(stderr,"imggen: could not generate image \n");
		return(1);
	}


    /*
     * Send image out
	 */

	img.width=matrix_P->width;
	img.height=matrix_P->height;
    	img.image_PP=matrix_P->matrix_PP;

	if(IT_OUT(0)) {
				KrnOverflow("imggen",0);
				return(99);
	}
	y(0) = img;
	
}
			
return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

