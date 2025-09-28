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

imgproc 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* imgproc.s */
/***********************************************************************
                             imgproc()
************************************************************************
This star inputs an image and transposes  or flips it.
Programmer:  	Sasan Ardalan	
Date: 		April 15, 1988
<NAME>
imgproc
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
This block inputs an image and transposes  or flips it.
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
	<DEF>Operation: 0=Transpose, 1= flip</DEF>
	<TYPE>int</TYPE>
	<NAME>operation</NAME>
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
    fprintf(stderr,"width and height op %d %d %d \n",pwidth,pheight,operation);

/*
 * if the image has been inputted and is ready to be outputted, then
 * output either a row at a time or a column at a time on 
 * each visit
 */
	    switch(operation) {
	        case 0:
		   matTrans_PP=(float**)calloc(pwidth,sizeof(float*));
		   for(k=0; k<pwidth; k++) {
			matTrans_PP[k]=(float*)calloc(pheight,sizeof(float));
		   }
		   for(k=0; k<pheight; k++) {
	              for(j=0; j<pwidth; j++) {
			matTrans_PP[j][k]=mat_PP[k][j];
		      }
                   }
		   free(mat_PP);
		   img.width=pheight;
		   img.height=pwidth;
    		   img.image_PP=matTrans_PP;
		   if(IT_OUT(0)) {
				KrnOverflow("imgproc",0);
				return(99);
		   }
		   y(0) = img;
		
		   return(0);
		   break;
	        case 1:
		   for(k=0; k<pheight/2; k++) {
	              for(j=0; j<pwidth; j++) {
			   temp=mat_PP[k][j];
			   mat_PP[k][j]=mat_PP[pheight-k-1][j];
			   mat_PP[pheight-k-1][j]=temp;
		      }
                   }
		   
		   if(IT_OUT(0) ){
				KrnOverflow("imgproc",0);
				return(99);
		   }
		   y(0) = img;
		   return(0);
		   break;
	     }
			
}
return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

