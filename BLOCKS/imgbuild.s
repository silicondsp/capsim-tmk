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

imgbuild 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* imgbuild.s */
/***********************************************************************
                             imgbuild()
************************************************************************
This star inputs a sequence of images  and creates  a larger image
with the inputted images forming subimages from left to right top
to bottom. 
When the height (specified as a parameter) is exceeded the inputted
images wrap around.
After the sub images are all gathered, the image is output.
<NAME>
imgbuild
</NAME>
<DESCRIPTION>
This star inputs a sequence of images  and creates  a larger image
with the inputted images forming subimages from left to right top
to bottom. 
When the height (specified as a parameter) is exceeded the inputted
images wrap around.
After the sub images are all gathered, the image is output.
</DESCRIPTION>
<PROGRAMMERS>
Programmer:  	Sasan Ardalan	
Date: 		August 15, 1993
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This star inputs a sequence of images  and creates  a larger image with the inputted images forming subimages from left to right top to bottom. 
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
		<NAME>widthOffset</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>heightOffset</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>createImageFlag</NAME>
		<VALUE>1</VALUE>
	</STATE>
	<STATE>
		<TYPE>dsp_floatMatrix_Pt</TYPE>
		<NAME>matrix_P</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>done</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>ibufs</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int no_samples;
	int i,j,k;
	float	temp;
	dsp_floatMatrix_t	matrix;
	dsp_floatMatrix_Pt	subMatrix_P;
	int	pwidth;
	int	pheight;
	float**		mat_PP;
	image_t	img;
	//dsp_floatMatrix_Pt Dsp_SubMatrix();

</DECLARATIONS> 

         

<PARAMETERS>
<PARAM>
	<DEF>Image width</DEF>
	<TYPE>int</TYPE>
	<NAME>imageWidth</NAME>
	<VALUE>128</VALUE>
</PARAM>
<PARAM>
	<DEF>Image height</DEF>
	<TYPE>int</TYPE>
	<NAME>imageHeight</NAME>
	<VALUE>128</VALUE>
</PARAM>
<PARAM>
	<DEF>Levels (for inverse)</DEF>
	<TYPE>int</TYPE>
	<NAME>levels</NAME>
	<VALUE>256</VALUE>
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

/*
 * get number of input buffers
 */
if((ibufs = NO_INPUT_BUFFERS()) <= 0) {
        fprintf(stderr,"imgbuild: no inputs connected\n");
        return(2);
}
SET_CELL_SIZE_OUT(0,sizeof(image_t));
for(i=0; i<ibufs; i++)
        SET_CELL_SIZE_IN(i,sizeof(image_t));

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


/*
 * collect the images
 */
for (no_samples = MIN_AVAIL(); no_samples > 0; --no_samples) {
	/*
 	 * Create the image if necessary
	 */
	if(createImageFlag) {
		matrix_P= Dsp_AllocateMatrix(imageWidth,imageHeight);
		if(matrix_P == NULL) {
			fprintf(stderr,"imgbuild: allocation failure\n");
			return(4);
		}
		createImageFlag=0;
		done=0;
		heightOffset=0;
		widthOffset=0;

	}
	/*
	 * get images
	 */
	IT_IN(0);
	img=INIMAGE(0,0);
	pheight=img.height;
	pwidth=img.width;
	mat_PP=img.image_PP;


	/*
	 * copy inputted image into image
	 */
	for(k=heightOffset; k<pheight+heightOffset; k++) {
              for(j=widthOffset; j<pwidth+widthOffset; j++) {
                 if(k < matrix_P->height && j < matrix_P->width ) {
		    temp= mat_PP[k-heightOffset][j-widthOffset];
		    matrix_P->matrix_PP[k][j] += temp;
		 }
              }
	}

	/*
	 * move along image
	 */
	widthOffset += pwidth;
	if(widthOffset >= matrix_P->width) {
			heightOffset += pheight;
			widthOffset =0;
    	}

        if(heightOffset >= matrix_P->height) {
            fprintf(stderr,"Create a new image heightOffset=%d\n",heightOffset);
			/*
			 * We have filled the image with sub images
			 * we can now create a new image
			 * and continue to fill it
			 */
			widthOffset=0;
			heightOffset=0;
	     		createImageFlag=1;
			done=1;
	}
	if(done) {
	     /*
	      * filled image of sub images 
	      * now output
	      */
	
          fprintf(stderr,"Output new image heightOffset=%d\n",heightOffset);

          if(IT_OUT(0) ){
		    KrnOverflow("imgbuild",0);
		    return(99);
	      }

	      img.image_PP=matrix_P->matrix_PP;
	      img.width=matrix_P->width;
	      img.height=matrix_P->height;

	      y(0) = img;

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

