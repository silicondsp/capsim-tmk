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

imgcxtrl 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* imgcxtrl.s */
/***********************************************************************
                             imgcxtrl()
************************************************************************
This star inputs a complex image height*(2*width) and creates a new
real image height*width  of only the real part
<NAME>
imgcxtrl
</NAME>
<DESCRIPTION>
This star inputs a complex image height*(2*width) and creates a new real image height*width  of only the real part
</DESCRIPTION>
<PROGRAMMERS>
Programmer:  	Sasan Ardalan	
Date: 		September 9, 1993
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This star inputs a complex image height*(2*width) and creates a new real image height*width  of only the real part
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 

#include <math.h>
#include  <dsp.h> 

]]>
</INCLUDES> 

     

<STATES>
	<STATE>
		<TYPE>float**</TYPE>
		<NAME>mat_PP</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>pwidth</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>pheight</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	image_t	img;
	int no_samples;
	int i,j,k;
	int	factor;
	float	temp;
	float	y,x;
	dsp_floatMatrix_Pt	real_P;

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
		<NAME>xx</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
    

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>image_t</TYPE>
		<NAME>yy</NAME>
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
	img=xx(0);
	pheight=img.height;
	pwidth=img.width;
	mat_PP=img.image_PP;

	real_P=Dsp_AllocateMatrix(pwidth/2,pheight);
   	for(k=0; k<real_P->height; k++) {
             for(j=0; j<real_P->width; j++) {
		x=mat_PP[k][2*j];
		y=mat_PP[k][2*j+1];
		real_P->matrix_PP[k][j]=x;
	     }
        }
	if(freeImageFlag) {
                        for(i=0; i<img.height; i++)
                                free(img.image_PP[i]);
                        free(img.image_PP);
        }


	/*
	 * Package it up for output
	 */
	img.width=real_P->width;
	img.height=real_P->height;
	img.image_PP=real_P->matrix_PP;
	if(IT_OUT(0)) {
			KrnOverflow("imgcxtrl",0);
			return(99);
	}
	yy(0) = img;
		
			
}
return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

