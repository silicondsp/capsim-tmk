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

imgaddnoise 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* imgaddnoise.s */
/***********************************************************************
                             imgaddnoise()
************************************************************************
Input an image and add the following noise to it:
Uniform noise distributed between a(param1) and b(param2)
Gaussian noise with mean(param1) and std(param2) specified.
Spike noise generated as follows:
      a Normal distribution is generated. If its level exceeds
      param1, then its value is assigned to x.
      Next x is multiplied by param2 to obtain the spike.
      The spike value is then added to the matrix.
To generate different outcomes change the expression
<NAME>
imgaddnoise
</NAME>
<DESCRIPTION>
Input an image and add the following noise to it:
Uniform noise distributed between a(param1) and b(param2)
Gaussian noise with mean(param1) and std(param2) specified.
Spike noise generated as follows:
      a Normal distribution is generated. If its level exceeds
      param1, then its value is assigned to x.
      Next x is multiplied by param2 to obtain the spike.
      The spike value is then added to the matrix.
To generate different outcomes change the expression
</DESCRIPTION>
<PROGRAMMERS>
Programmer:  	Sasan Ardalan	
Date: 		September 10, 1993
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
Input an image and add the following noise to it: Uniform noise. Gaussian noise. Spike noise.
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
	float	norm;
	dsp_floatMatrix_t	matrix;

</DECLARATIONS> 

           

<PARAMETERS>
<PARAM>
	<DEF>Noise Type:0=none,1=uniform,2=normal,3=spike</DEF>
	<TYPE>int</TYPE>
	<NAME>type</NAME>
	<VALUE>1</VALUE>
</PARAM>
<PARAM>
	<DEF>Expression for seed generation</DEF>
	<TYPE>file</TYPE>
	<NAME>expression</NAME>
	<VALUE>any_expression</VALUE>
</PARAM>
<PARAM>
	<DEF>param1: a(uniform), mean (normal) trigger(spike)</DEF>
	<TYPE>float</TYPE>
	<NAME>param1</NAME>
	<VALUE>0.0</VALUE>
</PARAM>
<PARAM>
	<DEF>param2: b(uniform), std (normal) multiplier(spike)</DEF>
	<TYPE>float</TYPE>
	<NAME>param2</NAME>
	<VALUE>1.0</VALUE>
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

	Dsp_MatrixAddNoise(&matrix,type,expression,param1,param2); 

        /*
         * Send image out
	 */

	img.width=matrix.width;
	img.height=matrix.height;
    	img.image_PP=matrix.matrix_PP;

	if(IT_OUT(0)) {
				KrnOverflow("imgaddnoise",0);
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

