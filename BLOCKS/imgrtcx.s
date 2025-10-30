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

imgrtcx 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* imgrtcx.s */
/***********************************************************************
                             imgrtcx()
************************************************************************
This block inputs a real image widthxheight and creates a new
complex image (2*width)*height with the imaginary part set to zero
<NAME>
imgrtcx
</NAME>
<DESCRIPTION>
This block inputs a real image widthxheight and creates a new
complex image (2*width)*height with the imaginary part set to zero
</DESCRIPTION>
<PROGRAMMERS>
Programmer:  	Sasan Ardalan	
Date: 		September 9, 1993
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This block inputs a real image widthxheight and creates a new complex image (2*width)*height with the imaginary part set to zero
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 

#include <math.h>

]]>
</INCLUDES> 

       

<STATES>
	<STATE>
		<TYPE>float**</TYPE>
		<NAME>mat_PP</NAME>
	</STATE>
	<STATE>
		<TYPE>float**</TYPE>
		<NAME>matTrans_PP</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>pwidth</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>pheight</NAME>
	</STATE>
	<STATE>
		<TYPE>image_t</TYPE>
		<NAME>img</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int no_samples;
	int i,j,k;
	int	factor;
	float	temp;

</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF>1=free input image, 0= don't</DEF>
	<TYPE>int</TYPE>
	<NAME>freeImageFlag</NAME>
	<VALUE>0</VALUE>
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

		   matTrans_PP=(float**)calloc(pheight,sizeof(float*));
		   for(k=0; k<pheight; k++) {
			matTrans_PP[k]=(float*)calloc(2*pwidth,sizeof(float));
		   }
		   for(k=0; k<pheight; k++) {
	              for(j=0; j<pwidth; j++) {
			matTrans_PP[k][2*j]=mat_PP[k][j];
			matTrans_PP[k][2*j+1]=0.0;
		      }
                   }
                   if(freeImageFlag) {
                        for(i=0; i<img.height; i++)
                                free(img.image_PP[i]);
                        free(img.image_PP);
                   }

		   img.height=pheight;
		   img.width=2*pwidth;
    		   img.image_PP=matTrans_PP;
		   if(IT_OUT(0)) {
				KrnOverflow("imgrtcx",0);
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

