 
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

This star inputs a sequence of images  and creates  a larger image with the inputted images forming subimages from left to right top to bottom. 

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 

#include <math.h>
#include  <dsp.h> 



/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int  __widthOffset;
      int  __heightOffset;
      int  __createImageFlag;
      dsp_floatMatrix_Pt  __matrix_P;
      int  __done;
      int  __ibufs;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define widthOffset (state_P->__widthOffset)
#define heightOffset (state_P->__heightOffset)
#define createImageFlag (state_P->__createImageFlag)
#define matrix_P (state_P->__matrix_P)
#define done (state_P->__done)
#define ibufs (state_P->__ibufs)

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define y(delay) *(image_t  *)POUT(0,delay)

/*         
 *    PARAMETER DEFINES 
 */ 
#define imageWidth (param_P[0]->value.d)
#define imageHeight (param_P[1]->value.d)
#define levels (param_P[2]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

imgbuild 

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
	float	temp;
	dsp_floatMatrix_t	matrix;
	dsp_floatMatrix_Pt	subMatrix_P;
	int	pwidth;
	int	pheight;
	float**		mat_PP;
	image_t	img;
	//dsp_floatMatrix_Pt Dsp_SubMatrix();


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Image width";
     char   *ptype0 = "int";
     char   *pval0 = "128";
     char   *pname0 = "imageWidth";
     char   *pdef1 = "Image height";
     char   *ptype1 = "int";
     char   *pval1 = "128";
     char   *pname1 = "imageHeight";
     char   *pdef2 = "Levels (for inverse)";
     char   *ptype2 = "int";
     char   *pval2 = "256";
     char   *pname2 = "levels";
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
     char   *ptypeOut0 = "image_t";
     char   *pnameOut0 = "y";
KrnModelConnectionOutput(indexOC,0 ,pnameOut0,ptypeOut0);
}
 break;

/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            widthOffset=0;
       heightOffset=0;
       createImageFlag=1;
       done=0;


         
   if(NO_OUTPUT_BUFFERS() != 1 ){
       fprintf(stdout,"%s:1 outputs expected; %d connected\n",
              STAR_NAME,NO_OUTPUT_BUFFERS());
	      return(201);
   }

   SET_CELL_SIZE_OUT(0,sizeof(image_t));

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

/*
 * get number of input buffers
 */
if((ibufs = NO_INPUT_BUFFERS()) <= 0) {
        fprintf(stderr,"imgbuild: no inputs connected\n");
        return(2);
}
SET_CELL_SIZE_OUT(0,sizeof(image_t));
for(i=0; i<ibufs; i++)
        SET_CELL_SIZE_IN(i,sizeof(image_t));


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


/*
 * collect the images
 */
for (no_samples = MIN_AVAIL(); no_samples > 0; --no_samples) {
	/*
 	 * Create the image if necessary
	 */
	if(createImageFlag) {
		matrix_P= Dsp_AllocateMatrix(imageWidth,imageHeight);
		if(matrix_P == NULL) {
			fprintf(stderr,"imgbuild: allocation failure\n");
			return(4);
		}
		createImageFlag=0;
		done=0;
		heightOffset=0;
		widthOffset=0;

	}
	/*
	 * get images
	 */
	IT_IN(0);
	img=INIMAGE(0,0);
	pheight=img.height;
	pwidth=img.width;
	mat_PP=img.image_PP;


	/*
	 * copy inputted image into image
	 */
	for(k=heightOffset; k<pheight+heightOffset; k++) {
              for(j=widthOffset; j<pwidth+widthOffset; j++) {
                 if(k < matrix_P->height && j < matrix_P->width ) {
		    temp= mat_PP[k-heightOffset][j-widthOffset];
		    matrix_P->matrix_PP[k][j] += temp;
		 }
              }
	}

	/*
	 * move along image
	 */
	widthOffset += pwidth;
	if(widthOffset >= matrix_P->width) {
			heightOffset += pheight;
			widthOffset =0;
    	}

        if(heightOffset >= matrix_P->height) {
            fprintf(stderr,"Create a new image heightOffset=%d\n",heightOffset);
			/*
			 * We have filled the image with sub images
			 * we can now create a new image
			 * and continue to fill it
			 */
			widthOffset=0;
			heightOffset=0;
	     		createImageFlag=1;
			done=1;
	}
	if(done) {
	     /*
	      * filled image of sub images 
	      * now output
	      */
	
          fprintf(stderr,"Output new image heightOffset=%d\n",heightOffset);

          if(IT_OUT(0) ){
		    KrnOverflow("imgbuild",0);
		    return(99);
	      }

	      img.image_PP=matrix_P->matrix_PP;
	      img.width=matrix_P->width;
	      img.height=matrix_P->height;

	      y(0) = img;

	}
			
			
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
