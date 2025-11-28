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

imgserout 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* imgserout.s */
/***********************************************************************
                             imgserout()
************************************************************************
This star inputs an image and outputs it a row at a time. 
<NAME>
imgserout
</NAME>
<DESCRIPTION>
This star inputs an image and outputs it a row at a time. 
</DESCRIPTION>
<PROGRAMMERS>
Programmer:  	Sasan Ardalan	
Date: 		April 15, 1988
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This star inputs an image and outputs it a row at a time. 
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
	<STATE>
		<TYPE>int</TYPE>
		<NAME>imageInFlag</NAME>
		<VALUE>FALSE</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>pheight</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>pwidth</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int no_samples;
	int i,j;
	int	factor;
	image_t	img;

</DECLARATIONS> 

   
    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>image_t</TYPE>
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

	pointCount = 0;
	numberRowsInput=0;
        widthOutput = 0;
        heightOutput = 0;
	SET_CELL_SIZE_IN(0,sizeof(image_t));
    SET_CELL_SIZE_OUT(0,sizeof(float));

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

/*
 * if the image has been inputted and is ready to be outputted, then
 * output either a row at a time or a column at a time on 
 * each visit
 */
if(imageInFlag) {
	   if(heightOutput == pheight) {
		/*
		 * reset and collect another matrix again
		 */
		pointCount = 0;
		numberRowsInput=0;
       		widthOutput = 0;
       		heightOutput = 0;
		imageInFlag=FALSE;
		return(0);
	   }
           for(j=0; j<pwidth; j++) {
	          if(IT_OUT(0) ){
			KrnOverflow("imgserout",0);
			return(99);
		  }
		  y(0) = mat_PP[heightOutput][j];
	   }
	   heightOutput++;
	   return(0);
}
/*
 * collect the image
 */
while(MIN_AVAIL() && imageInFlag==FALSE) {
	j=pointCount;
	IT_IN(0);
	img=x(0);

	mat_PP=img.image_PP;
	pwidth=img.width;
	pheight=img.height;
	imageInFlag=TRUE;
}
return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

