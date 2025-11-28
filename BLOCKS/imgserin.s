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

imgserin 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* imgserin.s */
/***********************************************************************
                             imgserin()
************************************************************************
This star inputs rows and creates an  image and
outputs it to the image buffer
<NAME>
imgserin
</NAME>
<DESCRIPTION>
This star inputs rows and creates an  image and
outputs it to the image buffer
</DESCRIPTION>
<PROGRAMMERS>
Programmer:  	Sasan Ardalan	
Date: 		April 15, 1988
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This star inputs rows and creates an  image and outputs it to the image buffer
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
	image_t	img;

</DECLARATIONS> 

       

<PARAMETERS>
<PARAM>
	<DEF>Image Width</DEF>
	<TYPE>int</TYPE>
	<NAME>pwidth</NAME>
	<VALUE>1</VALUE>
</PARAM>
<PARAM>
	<DEF>Image Height</DEF>
	<TYPE>int</TYPE>
	<NAME>pheight</NAME>
	<VALUE>1</VALUE>
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
		<TYPE>image_t</TYPE>
		<NAME>y</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

	mat_PP = (float**)calloc(pheight+1,sizeof(float*));
	if(mat_PP == NULL) {
		fprintf(stderr,"Could not allocate in imgserin.\n");
		return(4);
	}
	for(i=0; i<pheight; i++) {
	  mat_PP[i]=(float*)calloc(pwidth+1,sizeof(float));
		if(mat_PP[i] == NULL) {
			fprintf(stderr,"Could not allocate in imgserin.\n");
			return(5);
		}
	}
	pointCount = 0;
	numberRowsInput=0;
        widthOutput = 0;
        heightOutput = 0;
    SET_CELL_SIZE_OUT(0,sizeof(image_t));

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

/*
 * if the image has been inputted and is ready to be outputted, then
 * output either a row at a time or a column at a time on 
 * each visit
 */
if(numberRowsInput == pheight) {
	
	   {
	   	/* 
	    	 * now, output real  samples		
	     	 */
		if(IT_OUT(0)) {
			KrnOverflow("imgserin",0);
			return(99);
		}
		img.image_PP=mat_PP;
		img.width=pwidth;
		img.height=pheight;
		y(0) = img;
			
	   }
	/*
	 * reset and collect another matrix again
	 */
	pointCount = 0;
	numberRowsInput=0;
       	widthOutput = 0;
       	heightOutput = 0;
   	return(0);
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
	if(pointCount == pwidth ) {
		numberRowsInput++;
		pointCount =0;
		if(numberRowsInput == pheight) {
			return(0);
		}
	}
}
return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

	/* 
	 * free up allocated space      
	 */
#if 0
        for(i=0; i<pheight; i++)
                free((char*)mat_PP[i]);
#endif

]]>
</WRAPUP_CODE> 



</BLOCK> 

