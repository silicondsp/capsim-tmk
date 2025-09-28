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

imgnonlinfil 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* imgnonlinfilter.s */
/***********************************************************************
                             imgnonlinfilter()
************************************************************************
Input an image and perform nonlinear filtering on  it.
<NAME>
imgnonlinfilter
</NAME>
<DESCRIPTION>
Input an image and perform nonlinear filtering on  it.
</DESCRIPTION>
<PROGRAMMERS>
Programmer:  	Sasan Ardalan	
Date: 		September 10, 1993
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
Input an image and perform nonlinear filtering on  it.
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 

#include <math.h>
#include  <dsp.h> 

]]>
</INCLUDES> 

   

<STATES>
	<STATE>
		<TYPE>image_t</TYPE>
		<NAME>img</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int no_samples;
	int i,j,k;
	dsp_floatMatrix_Pt	filtered_P;
	dsp_floatMatrix_t	matrix;

</DECLARATIONS> 

         

<PARAMETERS>
<PARAM>
	<DEF>Nonliner Filter Type:2=min,3=median,4=max</DEF>
	<TYPE>int</TYPE>
	<NAME>type</NAME>
	<VALUE>3</VALUE>
</PARAM>
<PARAM>
	<DEF>Order</DEF>
	<TYPE>int</TYPE>
	<NAME>order</NAME>
	<VALUE>3</VALUE>
</PARAM>
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
	/*
	 * input an image
	 */
	IT_IN(0);
	img=x(0);

	matrix.height=img.height;
	matrix.width=img.width;
	matrix.matrix_PP=img.image_PP;

	filtered_P=Dsp_NonlinearFilter(&matrix,type,order);
	if(filtered_P==NULL) {
		fprintf(stderr,"imgnonlinfilter: could not  filter. \n");
		return(1);
	}


        /*
         * Send image out
	 */

        if(freeImageFlag) {
              for(i=0; i<img.height; i++)
                         free(img.image_PP[i]);
              free(img.image_PP);
        }

	img.width=filtered_P->width;
	img.height=filtered_P->height;
    	img.image_PP=filtered_P->matrix_PP;

	if(IT_OUT(0)) {
				KrnOverflow("imgnonlinfilter",0);
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

