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

imginterp 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* imginterp.s */
/***********************************************************************
                             imginterp()
************************************************************************
This block inputs an image and interpolates it.
NOTE: Input and output buffers are of image_t type.
<NAME>
imginterp
</NAME>
<DESCRIPTION>
This block inputs an image and interpolates it.
NOTE: Input and output buffers are of image_t type.
</DESCRIPTION>
<PROGRAMMERS>
Programmer:  	Sasan Ardalan	
Date: 		May 12, 1993
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This block inputs an image and interpolates it.
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
	int i,j,k,kk;
	int	factor;
	float	temp;
	float	pixel;
	int	row,column;
	int	newWidth,newHeight;

</DECLARATIONS> 

       

<PARAMETERS>
<PARAM>
	<DEF>width factor</DEF>
	<TYPE>int</TYPE>
	<NAME>widthFactor</NAME>
	<VALUE>1</VALUE>
</PARAM>
<PARAM>
	<DEF>heightFactor</DEF>
	<TYPE>int</TYPE>
	<NAME>heightFactor</NAME>
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

/*
 * if the image has been inputted and is ready to be outputted
 */
	   newWidth=pwidth*widthFactor;
	   newHeight=pheight*heightFactor;
	   matTrans_PP=(float**)calloc(newHeight,sizeof(float*));
	   if(matTrans_PP == NULL) {
		fprintf(stderr,"imginterp: Could not allocate during run time.\n");
		return(1);
	   }
	   for(k=0; k<newHeight; k++) {
		matTrans_PP[k]=(float*)calloc(newWidth,sizeof(float));
	   	if(matTrans_PP[k] == NULL) {
			fprintf(stderr,"imginterp: Could not allocate during run time.\n");
			return(1);
	   	}
	   }
	   row=0;
	   column=0;
	   for(i=0; i<pheight; i++) {
              for(j=0; j<pwidth; j++) {
		pixel=mat_PP[i][j];
		for(k=0; k<widthFactor; k++) {
		    for(kk=0; kk<heightFactor; kk++)
			matTrans_PP[row+kk][column]=pixel;
		    column++;
		}
	      }
	      column=0;
	      row=row+heightFactor;
           }
	   img.width=newWidth;
	   img.height=newHeight;
    	   img.image_PP=matTrans_PP;
	   if(IT_OUT(0)) {
			KrnOverflow("imginterp",0);
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

