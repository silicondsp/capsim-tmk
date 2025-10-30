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

transpose 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* transpose.s */
/***********************************************************************
                             transpose()
************************************************************************
This block inputs an image and transposes it.
<NAME>
transpose
</NAME>
<DESCRIPTION>
This block inputs an image and transposes it.
</DESCRIPTION>
<PROGRAMMERS>
Programmer:  	Sasan Ardalan	
Date: 		April 15, 1988
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This block inputs an image and transposes it.
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
		<TYPE>int</TYPE>
		<NAME>pointCount</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberRowsInput</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>widthOutput</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>heightOutput</NAME>
		<VALUE>0</VALUE>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int no_samples;
	int i,j;
	int	factor;

</DECLARATIONS> 

         

<PARAMETERS>
<PARAM>
	<DEF>Image Width</DEF>
	<TYPE>int</TYPE>
	<NAME>width</NAME>
	<VALUE>1</VALUE>
</PARAM>
<PARAM>
	<DEF>Image Height</DEF>
	<TYPE>int</TYPE>
	<NAME>height</NAME>
	<VALUE>1</VALUE>
</PARAM>
<PARAM>
	<DEF>Operation: 0=Transpose, 1= flip</DEF>
	<TYPE>int</TYPE>
	<NAME>operation</NAME>
	<VALUE>0</VALUE>
</PARAM>
</PARAMETERS>

    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>x</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
    

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>y</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

	mat_PP = (float**)calloc(height+1,sizeof(float*));
	for(i=0; i<height; i++) {
	  mat_PP[i]=(float*)calloc(width+1,sizeof(float));
	}
	pointCount = 0;
	numberRowsInput=0;
        widthOutput = 0;
        heightOutput = 0;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

/*
 * if the image has been inputted and is ready to be outputted, then
 * output either a row at a time or a column at a time on 
 * each visit
 */
if(numberRowsInput == height) {
	    switch(operation) {
	        case 0:
	
		   if(widthOutput >= width) { 
			/*
			 * reset and collect another matrix again
			 */
			pointCount = 0;
			numberRowsInput=0;
        		widthOutput = 0;
        		heightOutput = 0;
			break;
		   }
		   for (i=0; i<height; i++)
		   {
		   	/* 
		    	 * now, output real  samples		
		     	 */
			if(IT_OUT(0)) {
				KrnOverflow("transpose",0);
				return(99);
			}
			y(0) = mat_PP[i][widthOutput];
			
		   }
		   widthOutput++;
		   return(0);
		   break;
	        case 1:
		   if(heightOutput == height) {
			/*
			 * reset and collect another matrix again
			 */
			pointCount = 0;
			numberRowsInput=0;
        		widthOutput = 0;
        		heightOutput = 0;
			break;
		   }
	           for(j=0; j<width; j++) {
		          if(IT_OUT(0) ){
				KrnOverflow("transpose",0);
				return(99);
			  }
			  y(0) = mat_PP[height-1-heightOutput][j];
		   }
		   heightOutput++;
		   return(0);
		   break;
	     }
}
/*
 * collect the image
 */
for (no_samples = MIN_AVAIL(); no_samples > 0; --no_samples) {
	j=pointCount;
	IT_IN(0);
	mat_PP[numberRowsInput][j]=x(0);
	pointCount++;


			

	/* 
	 * Get enough points				
	 */
	if(pointCount == width ) {
		numberRowsInput++;
		pointCount =0;
		if(numberRowsInput == height) {
			return(0);
		}
	}
}
return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

	/* free up allocated space	*/
	for(i=0; i<height; i++)
		free((char*)mat_PP[i]);

]]>
</WRAPUP_CODE> 



</BLOCK> 

