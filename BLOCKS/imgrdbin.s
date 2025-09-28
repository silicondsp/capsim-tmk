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

imgrdbin 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*************************************************************
			imgrdbin()
***************************************************************
Description:  Read a binary image.
	On each visit a row is read from file.
	An image sample is output.
	Auto fan-out.
<NAME>
imgrdbin
</NAME>
<DESCRIPTION>
Description:  Read a binary image.
	On each visit a row is read from file.
	An image sample is output.
	Auto fan-out.
</DESCRIPTION>
<PROGRAMMERS>
Programmer: Sasan Ardalan
Date: November 4, 1990 
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
ead a binary image. On each visit a row is read from file. An image sample is output.
</DESC_SHORT>
       
<INCLUDES>
<![CDATA[ 

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

]]>
</INCLUDES> 

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>obufs</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>fd</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberRowsRead</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>char*</TYPE>
		<NAME>buff</NAME>
	</STATE>
	<STATE>
		<TYPE>float**</TYPE>
		<NAME>mat_PP</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i,j,k;
	float x;
	int  n;
	image_t	img;

</DECLARATIONS> 

           

<PARAMETERS>
<PARAM>
	<DEF>Image width</DEF>
	<TYPE>int</TYPE>
	<NAME>pwidth</NAME>
	<VALUE>128</VALUE>
</PARAM>
<PARAM>
	<DEF>Image height</DEF>
	<TYPE>int</TYPE>
	<NAME>pheight</NAME>
	<VALUE>128</VALUE>
</PARAM>
<PARAM>
	<DEF>File that contains binary image</DEF>
	<TYPE>file</TYPE>
	<NAME>file_name</NAME>
	<VALUE>test.img</VALUE>
</PARAM>
<PARAM>
	<DEF>Number of bytes to skip</DEF>
	<TYPE>int</TYPE>
	<NAME>skip</NAME>
	<VALUE>0</VALUE>
</PARAM>
</PARAMETERS>

<INIT_CODE>
<![CDATA[ 

	if((fd = open(file_name,0)) == -1) {
		fprintf(stderr,"rdbinimage: cannot open file\n");
		return(1); /* file cannot be opened */
	}
	if( (obufs = NO_OUTPUT_BUFFERS()) < 1 ) {
		fprintf(stderr,"rdbinimage: no output buffers\n");
		return(2);
	}
	fprintf(stderr,"Image width= %d, height = %d \n",pwidth,pheight);
	numberRowsRead =0;
	buff = (char *) calloc(pwidth,sizeof(char));
	if(buff == NULL) {
		fprintf(stderr,"rdbinimage: can't allocate space\n");
		return(3);
	}
	for(i=0; i<skip; i++) {
		n= read(fd,buff,1);
		if(!n) { 
		    fprintf(stderr,"rdbinimage: skipped too many\n");
		    return(4);
		}
	}
	mat_PP = (float**)calloc(pheight+1,sizeof(float*));
	if(mat_PP == NULL) {
		fprintf(stderr,"imgrdbin2 could not allocate space \n");
		return(5);
	}
        for(i=0; i<pheight; i++) {
          mat_PP[i]=(float*)calloc(pwidth+1,sizeof(float));
	  if(mat_PP == NULL) {
		fprintf(stderr,"imgrdbin2 could not allocate space \n");
		return(6);
	  }
	}
    for(j=0; j<obufs; j++) 
		  SET_CELL_SIZE_OUT(j,sizeof(image_t));

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


while(numberRowsRead < pheight) { 
	/* 
	 * output a row 
	 */
	        n= read(fd,buff,pwidth);
		/* 
		 *
		 * increment time on output buffer(s) 
		 * and output a sample 
		 */
		for (k = 0; k< n; k++) 
			mat_PP[numberRowsRead][k]=buff[k];
		if(numberRowsRead == pheight-1) {
		  
		  for(j=0; j<obufs; j++) {
			if(IT_OUT(j)){
	
				KrnOverflow("imgrdbin2",j);
				return(99);
			}
			img.image_PP = mat_PP;
			img.width = pwidth;
			img.height = pheight;
			OUTIMAGE(j,0) = img;
		  }
		}
	numberRowsRead++;
}
return(0);
	

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

        /* free up allocated space      */
        close(fd);
	free(buff);
        return(0);

]]>
</WRAPUP_CODE> 



</BLOCK> 

