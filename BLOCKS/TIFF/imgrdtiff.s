<BLOCK>
<LICENSE>
/*  Capsim (r) Text Mode Kernel (TMK) Star Library (Blocks)
    Copyright (C) 1989-2002  XCAD Corporation 

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

    http://www.xcad.com
    XCAD Corporation
    Raleigh, North Carolina */
*/
</LICENSE>
<BLOCK_NAME>
imgrdtiff
</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*************************************************************
			imgrdtiff()
***************************************************************
Description:  Read  an 8 bit  TIFF  image.
	Auto fan-out.
Programmer: Sasan Ardalan
Date:  October 15, 1993 
*/
]]>
</COMMENTS> 
<DESC_SHORT>
Read  an 8 bit  TIFF  image.
</DESC_SHORT>

<INCLUDES>
<![CDATA[ 

#include "dsp.h"

]]>
</INCLUDES> 

<DECLARATIONS> 

	int i,j,k;
	float x;
	int  n;
	image_t	img;
	dsp_floatMatrix_Pt	tiffImage_P;
	dsp_floatMatrix_Pt	IIP_ReadTIFFMatrix();

</DECLARATIONS> 




<STATES>
	<STATE>
		<TYPE> int </TYPE>
		<NAME> obufs </NAME>
	</STATE>
	<STATE>
		<TYPE> int </TYPE>
		<NAME> haveRead </NAME>
		<VALUE> 0 </VALUE>
	</STATE>
</STATES>



<PARAMETERS>
	<PARAM>
		<DEF> File that contains  TIFF image </DEF>
		<TYPE> file </TYPE>
		<NAME> fileName </NAME>
		<VALUE> image.tif </VALUE>
	</PARAM>
</PARAMETERS>

<INIT_CODE>
<![CDATA[ 

	if( (obufs = NO_OUTPUT_BUFFERS()) < 1 ) {
		fprintf(stderr,"rdfptiff: no output buffers\n");
		return(2);
	}
        for(j=0; j<obufs; j++) 
		SET_CELL_SIZE_OUT(j,sizeof(image_t));

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

while(!haveRead) {
	
	  tiffImage_P=IIP_ReadTIFFMatrix(fileName);
	  if(tiffImage_P == NULL) {
		fprintf(stderr,"imgrdtiff: could not read image\n");
		return(3);
	  }
	  haveRead=1;

	  for(j=0; j<obufs; j++) {
		if(IT_OUT(j)){

			KrnOverflow("imgrdtiff",j);
			return(99);
		}
		img.image_PP = tiffImage_P->matrix_PP;
		img.width = tiffImage_P->width;
		img.height = tiffImage_P->height;
		OUTIMAGE(j,0) = img;
	  }
}
return(0);
	

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

        return(0);

]]>
</WRAPUP_CODE> 



</BLOCK> 

