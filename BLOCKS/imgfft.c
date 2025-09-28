 
#ifdef LICENSE

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

#endif
 
#ifdef SHORT_DESCRIPTION

This block inputs an image and computes its forward or inverse FFT.
For a forward FFT a real matrix is expected and a complex image is
produced.
For an inverse FFT a complex image is expected ( possible result of a 
forward FFT).
Complex images store real and imaginary parts as even and odd sample 

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 

#include <math.h>
#include "dsp.h" 


 

#define FORWARD_FFT 0
#define INVERSE_FFT 1


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
       float**   __mat_PP;
       float**   __matTrans_PP;
       int   __pwidth;
       int   __pheight;
       image_t   __img;
       dsp_floatMatrix_Pt   __fftMat_P;
       dsp_floatMatrix_t   __matrix;
       float*   __window_P;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define  mat_PP  (state_P->__mat_PP)
#define  matTrans_PP  (state_P->__matTrans_PP)
#define  pwidth  (state_P->__pwidth)
#define  pheight  (state_P->__pheight)
#define  img  (state_P->__img)
#define  fftMat_P  (state_P->__fftMat_P)
#define  matrix  (state_P->__matrix)
#define  window_P  (state_P->__window_P)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define x(DELAY) (*(( image_t   *)PIN(0,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define y(delay) *( image_t   *)POUT(0,delay)

/*         
 *    PARAMETER DEFINES 
 */ 
#define fftType (param_P[0]->value.d)
#define centerFlag (param_P[1]->value.d)
#define freeImageFlag (param_P[2]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  
imgfft
(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

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


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = " Operation: 0=Forward FFT, 1= Inverse FFT ";
     char   *ptype0 = "int";
     char   *pval0 = "0";
     char   *pname0 = "fftType";
     char   *pdef1 = " Center: 0=None , 1= Yes ";
     char   *ptype1 = "int";
     char   *pval1 = "0";
     char   *pname1 = "centerFlag";
     char   *pdef2 = " 1=free input image, 0= don't ";
     char   *ptype2 = "int";
     char   *pval2 = "0";
     char   *pname2 = "freeImageFlag";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);

      }
break;
   


/*         
 *    OUTPUT BUFFER SYSTEM  INITS 
 */ 
 case OUTPUT_BUFFER_INIT: 
 {
 int indexOC = block_P->model_index;
     char   *ptypeOut0 = " image_t ";
     char   *pnameOut0 = " y ";
KrnModelConnectionOutput(indexOC,0 ,pnameOut0,ptypeOut0);
}
 break;

/*         
 *    INPUT BUFFER SYSTEM  INITS 
 */ 
 case INPUT_BUFFER_INIT:
 {
 int indexIC = block_P->model_index;
     char   *ptypeIn0 = " image_t ";
     char   *pnameIn0 = " x ";
KrnModelConnectionInput(indexIC,0 ,pnameIn0,ptypeIn0);
}
 break;

/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
     


         
   if(NO_OUTPUT_BUFFERS() != 1 ){
       fprintf(stdout,"%s:1 outputs expected; %d connected\n",
              STAR_NAME,NO_OUTPUT_BUFFERS());
	      return(201);
   }

   SET_CELL_SIZE_OUT(0,sizeof( image_t ));

         
   if(NO_INPUT_BUFFERS() != 1 ){
       fprintf(stdout,"%s:1 inputs expected; %d connected\n",
              STAR_NAME,NO_INPUT_BUFFERS());
	      return(200);
   }

   SET_CELL_SIZE_IN(0,sizeof( image_t ));

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

window_P=NULL;


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 

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


break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 



break;
}
return(0);
}
