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

imgsubimg 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* imgsubimg.s */
/***********************************************************************
                             imgsubimg()
************************************************************************
This star inputs an image and transposes  or flips it.
<NAME>
imgsubimg
</NAME>
<DESCRIPTION>
This star inputs an image and transposes  or flips it.
</DESCRIPTION>
<PROGRAMMERS>
Programmer:  	Sasan Ardalan	
Date: 		April 15, 1988
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This star inputs an image and transposes  or flips it.
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
	<DEF>Sub image offset width</DEF>
	<TYPE>int</TYPE>
	<NAME>widthOffset</NAME>
	<VALUE>0</VALUE>
</PARAM>
<PARAM>
	<DEF>Sub image offset height</DEF>
	<TYPE>int</TYPE>
	<NAME>heightOffset</NAME>
	<VALUE>0</VALUE>
</PARAM>
<PARAM>
	<DEF>Sub image width</DEF>
	<TYPE>int</TYPE>
	<NAME>subWidth</NAME>
	<VALUE>1</VALUE>
</PARAM>
<PARAM>
	<DEF>Sub image height</DEF>
	<TYPE>int</TYPE>
	<NAME>subHeight</NAME>
	<VALUE>1</VALUE>
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
	fprintf(stderr,"width and height op %d %d \n",pwidth,pheight);
	if(subWidth+widthOffset>pwidth) {
		fprintf(stderr,"imgsubimg error: subwidth + widthOffset> input image width.\n");
		return(1);
	}
	if(subHeight+heightOffset>pheight) {
		fprintf(stderr,"imgsubimg error: subheight + heightOffset > input image height.\n");
		return(1);
	}

/*
 * if the image has been inputted and is ready to be outputted
 */
	   matTrans_PP=(float**)calloc(subHeight,sizeof(float*));
	   if(matTrans_PP == NULL) {
		fprintf(stderr,"imgsubimg: Could not allocate during run time.\n");
		return(1);
	   }
	   for(k=0; k<subHeight; k++) {
		matTrans_PP[k]=(float*)calloc(subWidth,sizeof(float));
	   	if(matTrans_PP[k] == NULL) {
			fprintf(stderr,"imgsubimg: Could not allocate during run time.\n");
			return(1);
	   	}
	   }
	   for(k=heightOffset; k<subHeight+heightOffset; k++) {
              for(j=widthOffset; j<subWidth+widthOffset; j++) {
		matTrans_PP[k-heightOffset][j-widthOffset]=mat_PP[k][j];
	      }
           }
	   img.width=subWidth;
	   img.height=subHeight;
    	   img.image_PP=matTrans_PP;
	   if(IT_OUT(0)) {
			KrnOverflow("imgsubimg",0);
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

