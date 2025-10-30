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
imgfft
</BLOCK_NAME> 


<DESC_SHORT>
This block inputs an image and computes its forward or inverse FFT.
For a forward FFT a real matrix is expected and a complex image is
produced.
For an inverse FFT a complex image is expected ( possible result of a 
forward FFT).
Complex images store real and imaginary parts as even and odd sample 
</DESC_SHORT>


<COMMENTS>
<![CDATA[ 

/* imgfft.s */
/***********************************************************************
                             imgfft()
************************************************************************
This block inputs an image and computes its forward or inverse FFT.
For a forward FFT a real matrix is expected and a complex image is
produced.
For an inverse FFT a complex image is expected ( possible result of a 
forward FFT).
Complex images store real and imaginary parts as even and odd sample 
columns. Thus for complex images width =2*height.
Programmer:  	Sasan Ardalan	
Date: 		September 10, 1993
*/
]]>
</COMMENTS> 

<INCLUDES>
<![CDATA[ 

#include <math.h>
#include "dsp.h" 

]]>
</INCLUDES> 

<DEFINES> 

#define FORWARD_FFT 0
#define INVERSE_FFT 1

</DEFINES> 

<DECLARATIONS> 

	int no_samples;
	int i,j,k;
	int	factor;
	float	temp;
	float	tempReal;
	float	tempImag;
	int fftexp;
        int fftl;
        int fftwidth;
	float	norm;
	int	pts;
	int	order;

</DECLARATIONS> 




<STATES>
	<STATE>
		<TYPE> float** </TYPE>
		<NAME> mat_PP </NAME>
	</STATE>
	<STATE>
		<TYPE> float** </TYPE>
		<NAME> matTrans_PP </NAME>
	</STATE>
	<STATE>
		<TYPE> int </TYPE>
		<NAME> pwidth </NAME>
	</STATE>
	<STATE>
		<TYPE> int </TYPE>
		<NAME> pheight </NAME>
	</STATE>
	<STATE>
		<TYPE> image_t </TYPE>
		<NAME> img </NAME>
	</STATE>
	<STATE>
		<TYPE> dsp_floatMatrix_Pt </TYPE>
		<NAME> fftMat_P </NAME>
	</STATE>
	<STATE>
		<TYPE> dsp_floatMatrix_t </TYPE>
		<NAME> matrix </NAME>
	</STATE>
	<STATE>
		<TYPE> float* </TYPE>
		<NAME> window_P </NAME>
	</STATE>
</STATES>



<PARAMETERS>
	<PARAM>
		<DEF> Operation: 0=Forward FFT, 1= Inverse FFT </DEF>
		<TYPE> int </TYPE>
		<NAME> fftType </NAME>
		<VALUE> 0 </VALUE>
	</PARAM>
	<PARAM>
		<DEF> Center: 0=None , 1= Yes </DEF>
		<TYPE> int </TYPE>
		<NAME> centerFlag </NAME>
		<VALUE> 0 </VALUE>
	</PARAM>
	<PARAM>
		<DEF> 1=free input image, 0= don't </DEF>
		<TYPE> int </TYPE>
		<NAME> freeImageFlag </NAME>
		<VALUE> 0 </VALUE>
	</PARAM>
</PARAMETERS>



<INPUT_BUFFERS>
	<BUFFER>
		<TYPE> image_t </TYPE>
		<NAME> x </NAME>
	</BUFFER>
</INPUT_BUFFERS>



<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE> image_t </TYPE>
		<NAME> y </NAME>
	</BUFFER>
</OUTPUT_BUFFERS>

<INIT_CODE>
<![CDATA[ 

window_P=NULL;

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

	if(fftType == FORWARD_FFT && pwidth != pheight) {
		fprintf(stderr,"2-D FFT of Square images only. Sorry!\n");
		return(1);
	}
	if(fftType == INVERSE_FFT && pwidth != 2*pheight) {
		fprintf(stderr,"2-D FFT of Square images only. Sorry!\n");
		return(1);
	}
	/*
	 * round points to next power of 2
	 */
	order = (int) (log((float)pwidth)/log(2.0)+0.5);
	pts = 1 << order;
	if (pts > pwidth ) {
        	pts = pts/2;
        	order -= 1;
	}

	window_P=(float*)calloc(pts,sizeof(float));
	if(window_P == NULL) {
		fprintf(stderr,"imgfft: could not allocate space\n");
		return(3);
	}
	for(i=0; i<pts; i++) {
		/*
 		 * Rectangular window for now
		 */
		window_P[i]=1.0;

	}
	mat_PP=img.image_PP;
	matrix.matrix_PP=mat_PP;
	matrix.width=pwidth;
	matrix.height=pheight;
	/*
	 * Compute FFT
	 */
	fftMat_P=Dsp_MatrixFFT(&matrix,window_P,pts,fftType,centerFlag);

	free(window_P);
	/*
	 * Put image on output buffer
	 */

        if(freeImageFlag) {
                        for(i=0; i<img.height; i++)
                                free(img.image_PP[i]);
                        free(img.image_PP);
        }


	   img.width=fftMat_P->width;
	   img.height=fftMat_P->height;
    	   img.image_PP=fftMat_P->matrix_PP;
	   if(IT_OUT(0)) {
				KrnOverflow("imgfft",0);
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

