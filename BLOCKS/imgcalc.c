 
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

Perform a mathematical or logical operation on an image using another image.

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
      image_t  __img;
      dsp_floatMatrix_Pt  __filter_P;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define img (state_P->__img)
#define filter_P (state_P->__filter_P)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define x(DELAY) (*((image_t  *)PIN(0,DELAY)))
#define y(DELAY) (*((image_t  *)PIN(1,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define z(delay) *(image_t  *)POUT(0,delay)

/*         
 *    PARAMETER DEFINES 
 */ 
#define operation (param_P[0]->value.d)
#define widthOffset (param_P[1]->value.d)
#define heightOffset (param_P[2]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

imgcalc 

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
	dsp_floatMatrix_t	matrix1;
	dsp_floatMatrix_t	matrix2;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = " Operation:0=x,1=-,2:*,3:/,4:&,5:|,6:xor,7:cmpl,8:copy";
     char   *ptype0 = "int";
     char   *pval0 = "6";
     char   *pname0 = "operation";
     char   *pdef1 = "width offset";
     char   *ptype1 = "int";
     char   *pval1 = "0";
     char   *pname1 = "widthOffset";
     char   *pdef2 = "height offset";
     char   *ptype2 = "int";
     char   *pval2 = "0";
     char   *pname2 = "heightOffset";
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
     char   *pnameOut0 = "z";
KrnModelConnectionOutput(indexOC,0 ,pnameOut0,ptypeOut0);
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
     char   *ptypeIn1 = "image_t";
     char   *pnameIn1 = "y";
KrnModelConnectionInput(indexIC,0 ,pnameIn0,ptypeIn0);
KrnModelConnectionInput(indexIC,1 ,pnameIn1,ptypeIn1);
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

   SET_CELL_SIZE_OUT(0,sizeof(image_t));

         
   if(NO_INPUT_BUFFERS() != 2 ){
       fprintf(stdout,"%s:2 inputs expected; %d connected\n",
              STAR_NAME,NO_INPUT_BUFFERS());
	      return(200);
   }

   SET_CELL_SIZE_IN(0,sizeof(image_t));

   SET_CELL_SIZE_IN(1,sizeof(image_t));

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

	SET_CELL_SIZE_IN(0,sizeof(image_t));
	SET_CELL_SIZE_IN(1,sizeof(image_t));
    SET_CELL_SIZE_OUT(0,sizeof(image_t));


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 

/*
 * collect the image
 */
for (no_samples = MIN_AVAIL(); no_samples > 0; --no_samples) {
	/*
	 * input an image
	 */
	IT_IN(0);
	img=x(0);

	matrix1.height=img.height;
	matrix1.width=img.width;
	matrix1.matrix_PP=img.image_PP;

	IT_IN(1);
	img=y(0);


	matrix2.height=img.height;
	matrix2.width=img.width;
	matrix2.matrix_PP=img.image_PP;

	Dsp_CalculateMatrix(&matrix1,&matrix2,
                operation,widthOffset,heightOffset,256);
        /*
         * Send image out
	 */

	img.width=matrix1.width;
	img.height=matrix1.height;
    	img.image_PP=matrix1.matrix_PP;

	if(IT_OUT(0)) {
				KrnOverflow("imgcalc",0);
				return(99);
	}
	z(0) = img;
	
			
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
