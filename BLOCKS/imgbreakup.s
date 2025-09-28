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

imgbreakup 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* imgbreakup.s */
/***********************************************************************
                             imgbreakup()
************************************************************************
This star inputs an image and creates sub images.
The sub images are sequentially output.
<NAME>
imgbreakup
</NAME>
<DESCRIPTION>
This star inputs an image and creates sub images. The sub images are sequentially output.
</DESCRIPTION>
<PROGRAMMERS>
Programmer:  	Sasan Ardalan	
Date: 		August 15, 1993
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This star inputs an image and creates sub images. The sub images are sequentially output.
</DESC_SHORT>



<INCLUDES>
<![CDATA[ 

#include  <dsp.h> 

]]>
</INCLUDES> 

    

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>widthOffset</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>heightOffset</NAME>
		<VALUE>0</VALUE>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int no_samples;
	int i,j,k;
	float	temp;
	dsp_floatMatrix_t	matrix;
	dsp_floatMatrix_Pt	matrix_P;
	dsp_floatMatrix_Pt	subMatrix_P;
	int	pwidth;
	int	pheight;
	float**		mat_PP;
	image_t	img;
	dsp_floatMatrix_Pt Dsp_SubMatrix();
	int	done;

</DECLARATIONS> 

         

<PARAMETERS>
<PARAM>
	<DEF>Sub image width</DEF>
	<TYPE>int</TYPE>
	<NAME>subWidth</NAME>
	<VALUE>8</VALUE>
</PARAM>
<PARAM>
	<DEF>Sub image height</DEF>
	<TYPE>int</TYPE>
	<NAME>subHeight</NAME>
	<VALUE>8</VALUE>
</PARAM>
<PARAM>
	<DEF>Levels (for inverse)</DEF>
	<TYPE>int</TYPE>
	<NAME>levels</NAME>
	<VALUE>256</VALUE>
</PARAM>
</PARAMETERS>

    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>image_t</TYPE>
		<NAME>x</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
    

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>image_t</TYPE>
		<NAME>y</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

	SET_CELL_SIZE_IN(0,sizeof(image_t));
    SET_CELL_SIZE_OUT(0,sizeof(image_t));

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

/*
 * collect the image
 */
for (no_samples = MIN_AVAIL(); no_samples > 0; --no_samples) {
	IT_IN(0);
	img=x(0);
	pheight=img.height;
	pwidth=img.width;
	mat_PP=img.image_PP;

	widthOffset=0;
	heightOffset=0;

	/*
	 * package as a matrix structure
	 */
	matrix.matrix_PP=mat_PP;
	matrix.width=pwidth;
	matrix.height=pheight;
	done=0;
	while (!done) {
	     matrix_P=Dsp_SubMatrix(&matrix,subWidth,subHeight,
			widthOffset,heightOffset);

	     if(matrix_P == NULL) {
		fprintf(stderr,"imgbreakup: allocation failure\n");
		return(4);
	     }

             if(IT_OUT(0) ){
		    KrnOverflow("imgbreakup",0);
		    return(99);
	     }

	     img.image_PP=matrix_P->matrix_PP;
	     img.width=matrix_P->width;
	     img.height=matrix_P->height;

	     y(0) = img;
	     widthOffset += subWidth;
	     if(widthOffset >= pwidth) {
			heightOffset += subHeight;
			widthOffset =0;
	     }

	     if(heightOffset >= pheight)
			done=1;
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

