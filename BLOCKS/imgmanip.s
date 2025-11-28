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

imgmanip 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* imgmanip.s */
/***********************************************************************
                             imgmanip()
************************************************************************
This star inputs an image and transposes  or flips it.
For transposing,  a new image is generated.
All other operations overwrite the input image
<NAME>
imgmanip
</NAME>
<DESCRIPTION>
This star inputs an image and transposes  or flips it.
For transposing,  a new image is generated.
All other operations overwrite the input image
</DESCRIPTION>
<PROGRAMMERS>
Programmer:  	Sasan Ardalan	
Date: 		April 15, 1988
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This star inputs an image and transposes  or flips it.
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 

#include <math.h>
#include  <dsp.h> 

]]>
</INCLUDES> 

<DECLARATIONS> 

	int no_samples;
	int i,j,k;
	float	temp;
	dsp_floatMatrix_t	matrix;
	dsp_floatMatrix_Pt	matrix_P;
	int	pwidth;
	int	pheight;
	float**		mat_PP;
	image_t	img;
	//dsp_floatMatrix_Pt Dsp_MatrixOperate();

</DECLARATIONS> 

       

<PARAMETERS>
<PARAM>
	<DEF>Operation:0=none,1=transpose,2=flipVert,4=flipHorz,3=inverse</DEF>
	<TYPE>int</TYPE>
	<NAME>operation</NAME>
	<VALUE>0</VALUE>
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

	/*
	 * package as a matrix structure
	 */
	matrix.matrix_PP=mat_PP;
	matrix.width=pwidth;
	matrix.height=pheight;

	matrix_P=Dsp_MatrixOperate(&matrix,operation,levels);

	if(matrix_P == NULL) {
		fprintf(stderr,"imgmanip: allocation failure in transpose\n");
		return(4);
	}

        if(IT_OUT(0) ){
		KrnOverflow("imgmanip",0);
		return(99);
	}

	img.image_PP=matrix_P->matrix_PP;
	img.width=matrix_P->width;
	img.height=matrix_P->height;

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

