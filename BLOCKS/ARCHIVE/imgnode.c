 
#ifdef LICENSE

/*  Capsim (r) Text Mode Kernel (TMK) Star Library (Blocks)
    Copyright (C) 1989-2002  XCAD Corporation 

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

    http://www.xcad.com
    XCAD Corporation
    Raleigh, North Carolina */

#endif
 
#ifdef SHORT_DESCRIPTION

Function has a single image input buffer, and outputs each input image sample to an arbitrary number of output buffers.
For each output a duplicate image is created and outputed.

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int  __obufs;
      image_t*  __img_A;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define obufs (state_P->__obufs)
#define img_A (state_P->__img_A)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define x(DELAY) (*((image_t  *)PIN(0,DELAY)))
/*-------------- BLOCK CODE ---------------*/


imgnode 

(run_state,block_P)

	int run_state;
	block_Pt block_P;
{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int no_samples;
	int i;
        int width,height;
        int j,k;
        image_t imgIn;
        float **mat_PP;


switch (run_state) {


 /********* PARAMETER INITIALIZATION CODE ************/
case PARAM_INIT:

        {
        int indexModel88 = block_P->model_index;

        KrnModelParam(indexModel88,-1,"","","");
        }

break;
   
          
 
/*         
 *    INPUT BUFFER SYSTEM  INITS 
 */ 
 case INPUT_BUFFER_INIT:
 {
 int indexIC = block_P->model_index;
     char   *ptypeIn0 = "image_t";
     char   *pnameIn0 = "x";
KrnModelConnectionInput(indexIC,0 ,pnameIn0,ptypeIn0);
}
 break;

/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
     

         
   if(NO_INPUT_BUFFERS() != 1 ){
       fprintf(stdout,"%s:1 inputs expected; %d connected\n",
              STAR_NAME,NO_INPUT_BUFFERS());
	      return(200);
   }

   SET_CELL_SIZE_IN(0,sizeof(image_t));

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

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



break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 

				

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



break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 



break;
}
return(0);
}
