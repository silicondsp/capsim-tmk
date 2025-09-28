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

imgnode 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* imgnode.s */
/**********************************************************************
                            imgnode()
***********************************************************************
Function has a single input buffer, and outputs each input sample to
an arbitrary number of output buffers.
<NAME>
node
</NAME>
<DESCRIPTION>
Function has a single input buffer, and outputs each input sample to an arbitrary number of output buffers.
</DESCRIPTION>
<PROGRAMMERS>
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

   
<DESC_SHORT>
Function has a single image input buffer, and outputs each input image sample to an arbitrary number of output buffers.
For each output a duplicate image is created and outputed.
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>obufs</NAME>
	</STATE>
	<STATE>
		<TYPE>image_t*</TYPE>
		<NAME>img_A</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int no_samples;
	int i;
        int width,height;
        int j,k;
        image_t imgIn;
        float **mat_PP;

</DECLARATIONS> 

   
    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>image_t</TYPE>
		<NAME>x</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

	/* note and store the number of output buffers */
	if((obufs = NO_OUTPUT_BUFFERS() ) <= 0) {
		fprintf(stdout,"node: no output buffers\n");
		return(1); /* no output buffers */
	}
        for(i=0; i<obufs; i++) {

              SET_CELL_SIZE_OUT(i,sizeof(image_t));
        }
        img_A=(image_t*)calloc(obufs,sizeof(image_t));
        if(!img_A) {
		   fprintf(stdout,"imgnode: could not allocate space\n");
		   return(2); /* no output buffers */
	 }


]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

				

	for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) {
		IT_IN(0);
                imgIn=x(0);
                width=imgIn.width;
                height=imgIn.height;
		for(i=0;i<obufs;++i) {
			if(IT_OUT(i)) {
				KrnOverflow("node",i);
				return(99);
			} 
			else { 

                            mat_PP=(float**)calloc(height,sizeof(float*));
                            if(mat_PP == NULL) {
                                    fprintf(stderr,"imgnode: Could not allocate during run time.\n");
                                    return(5);
                            }
                            for(k=0; k<height; k++) {
                                   mat_PP[k]=(float*)calloc(width,sizeof(float));
                                   if(mat_PP[k] == NULL) {
                                         fprintf(stderr,"imgnode: Could not allocate during run time.\n");
                                         return(6);
                                   }
                           }
                           img_A[i].width=width;
                           img_A[i].height=height;
                           img_A[i].image_PP=mat_PP;
                           for(k=0; k<height; k++)
                              for(j=0; j<width; j++)
                                   mat_PP[k][j]=imgIn.image_PP[k][j];

			    OUTIMAGE(i,0) = img_A[i];


                        }
		}
	}

    	return(0);  /* input buffer empty */


]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

