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

imgcalc 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* imgcalc.s */
/***********************************************************************
                             imgcalc()
************************************************************************
Perform a mathematical or logical operation on an image using another
image.
Buffers:
	Input:
		x
		y
	Output:	
		z
The image on buffer x is replaced with the result of the calculation.
x=f(x,y)
x is output on buffer z.
Image y may be offset in width and height prior to the operation.
Supported Operations:
	0: Multiply 
	1: Add
	2: Subtract
	3: Divide
	4: AND
	5: OR
	6: XOR
	7: Complement
	8: Copy
<NAME>
imgcalc
</NAME>
<DESCRIPTION>
Perform a mathematical or logical operation on an image using another
image.
Buffers:
	Input:
		x
		y
	Output:	
		z
The image on buffer x is replaced with the result of the calculation.
x=f(x,y)
x is output on buffer z.
Image y may be offset in width and height prior to the operation.
Supported Operations:
	0: Multiply 
	1: Add
	2: Subtract
	3: Divide
	4: AND
	5: OR
	6: XOR
	7: Complement
	8: Copy
</DESCRIPTION>
<PROGRAMMERS>
Programmer:  	Sasan Ardalan	
Date: 		September 10, 1993
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
Perform a mathematical or logical operation on an image using another image.
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
	<STATE>
		<TYPE>dsp_floatMatrix_Pt</TYPE>
		<NAME>filter_P</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int no_samples;
	int i,j,k;
	dsp_floatMatrix_t	matrix1;
	dsp_floatMatrix_t	matrix2;

</DECLARATIONS> 

         

<PARAMETERS>
<PARAM>
	<DEF><![CDATA[ Operation:0=x,1=-,2:*,3:/,4:&,5:|,6:xor,7:cmpl,8:copy]]></DEF>
	<TYPE>int</TYPE>
	<NAME>operation</NAME>
	<VALUE>6</VALUE>
</PARAM>
<PARAM>
	<DEF>width offset</DEF>
	<TYPE>int</TYPE>
	<NAME>widthOffset</NAME>
	<VALUE>0</VALUE>
</PARAM>
<PARAM>
	<DEF>height offset</DEF>
	<TYPE>int</TYPE>
	<NAME>heightOffset</NAME>
	<VALUE>0</VALUE>
</PARAM>
</PARAMETERS>

     

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>image_t</TYPE>
		<NAME>x</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>image_t</TYPE>
		<NAME>y</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
    

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>image_t</TYPE>
		<NAME>z</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

	SET_CELL_SIZE_IN(0,sizeof(image_t));
	SET_CELL_SIZE_IN(1,sizeof(image_t));
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

	matrix1.height=img.height;
	matrix1.width=img.width;
	matrix1.matrix_PP=img.image_PP;

	IT_IN(1);
	img=y(0);


	matrix2.height=img.height;
	matrix2.width=img.width;
	matrix2.matrix_PP=img.image_PP;

	Dsp_CalculateMatrix(&matrix1,&matrix2,
                operation,widthOffset,heightOffset,256);
        /*
         * Send image out
	 */

	img.width=matrix1.width;
	img.height=matrix1.height;
    	img.image_PP=matrix1.matrix_PP;

	if(IT_OUT(0)) {
				KrnOverflow("imgcalc",0);
				return(99);
	}
	z(0) = img;
	
			
}
return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

