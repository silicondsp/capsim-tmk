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

imgrdasc 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*************************************************************
			imgrdasc()
***************************************************************
Description:  Read a ASCII image.
    Read the image and output a single image sample.
	Auto fan-out.
<NAME>
imgrdasc
</NAME>
<DESCRIPTION>
Description:  Read a ASCII image.
    Read the image and output a single image sample.
	Auto fan-out.
</DESCRIPTION>
<PROGRAMMERS>
Programmer: Sasan Ardalan
Date: November 4, 1990 
</PROGRAMMERS>
*/

]]>
</COMMENTS> 


<INCLUDES>
<![CDATA[ 
#include <string.h>
]]>
</INCLUDES> 
         
<DESC_SHORT>
Read a ASCII image. Read the image and output a single image sample.
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>obufs</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberRowsRead</NAME>
		<VALUE>0</VALUE>
	</STATE>
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
	<STATE>
		<TYPE>int</TYPE>
		<NAME>done</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>FILE*</TYPE>
		<NAME>fp</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i,j,k;
	float x;
	int  n;
	image_t	img;
	int CsInfo(char *string);

</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF>File that contains image. Note width and height must be first line.</DEF>
	<TYPE>file</TYPE>
	<NAME>fileName</NAME>
	<VALUE>stdin</VALUE>
</PARAM>
</PARAMETERS>

<INIT_CODE>
<![CDATA[ 

    done=0;
	if(strcmp(fileName,"stdin") == 0)
		fp = stdin;
	else if((fp = fopen(fileName,"r")) == NULL) {
		fprintf(stderr,"imgrdasc: cannot open file\n");
		return(1); /* file cannot be opened */
	}
	fscanf(fp,"%d %d",&pwidth,&pheight);
	numberRowsRead =0;
	if( (obufs = NO_OUTPUT_BUFFERS()) < 1 ) {
		fprintf(stderr,"imgrdasc: no output buffers\n");
		return(2);
	}
	mat_PP = (float**)calloc(pheight+1,sizeof(float*));
	if(mat_PP == NULL) {
		fprintf(stderr,"imgrdasc could not allocate space \n");
		return(5);
	}
    for(i=0; i<pheight; i++) {
      mat_PP[i]=(float*)calloc(pwidth+1,sizeof(float));
	  if(mat_PP[i] == NULL) {
		fprintf(stderr,"imgrdasc could not allocate space \n");
		return(6);
	  }
	}
    for(j=0; j<obufs; j++) 
		SET_CELL_SIZE_OUT(j,sizeof(image_t));

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


while(!done) {
   	if(numberRowsRead >= pheight) {
	     return(0); 
	}
	/* 
	 * read a row 
	 */
	for(i=0; i < pwidth; ++i) {

		/* Read input lines until EOF */
		if(fscanf(fp,"%f",&x) == EOF){
		    CsInfo("imgrdasc: EOF");
			done=1;
		}
		else 
		   mat_PP[numberRowsRead][i]=x;

	}



	/* 
	 * Check if all of matrix has been input.
	 * increment time on output buffer(s) 
	 * and output a sample image
	 */

	if(numberRowsRead == pheight-1) {
		  
		    for(j=0; j<obufs; j++) {
			   if(IT_OUT(j)){
	
				   KrnOverflow("imgrdasc",j);
				   return(99);
			   }
			   img.image_PP = mat_PP;
			   img.width = pwidth;
			   img.height = pheight;
			   OUTIMAGE(j,0) = img;
		       done=1;
			}
	 }

	 numberRowsRead++;



}


return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

        if (fp != stdout)
             fclose(fp);

]]>
</WRAPUP_CODE> 



</BLOCK> 

