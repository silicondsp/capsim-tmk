 
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

Input an image and perform nonlinear filtering on  it.

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
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define img (state_P->__img)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define x(DELAY) (*((image_t  *)PIN(0,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define y(delay) *(image_t  *)POUT(0,delay)

/*         
 *    PARAMETER DEFINES 
 */ 
#define type (param_P[0]->value.d)
#define order (param_P[1]->value.d)
#define freeImageFlag (param_P[2]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

imgnonlinfil 

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
	dsp_floatMatrix_Pt	filtered_P;
	dsp_floatMatrix_t	matrix;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Nonliner Filter Type:2=min,3=median,4=max";
     char   *ptype0 = "int";
     char   *pval0 = "3";
     char   *pname0 = "type";
     char   *pdef1 = "Order";
     char   *ptype1 = "int";
     char   *pval1 = "3";
     char   *pname1 = "order";
     char   *pdef2 = "1=free input image, 0= don't";
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
     char   *ptypeOut0 = "image_t";
     char   *pnameOut0 = "y";
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

   SET_CELL_SIZE_OUT(0,sizeof(image_t));

         
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

 

             SET_CELL_SIZE_IN(0,sizeof(image_t));
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

	matrix.height=img.height;
	matrix.width=img.width;
	matrix.matrix_PP=img.image_PP;

	filtered_P=Dsp_NonlinearFilter(&matrix,type,order);
	if(filtered_P==NULL) {
		fprintf(stderr,"imgnonlinfilter: could not  filter. \n");
		return(1);
	}


        /*
         * Send image out
	 */

        if(freeImageFlag) {
              for(i=0; i<img.height; i++)
                         free(img.image_PP[i]);
              free(img.image_PP);
        }

	img.width=filtered_P->width;
	img.height=filtered_P->height;
    	img.image_PP=filtered_P->matrix_PP;

	if(IT_OUT(0)) {
				KrnOverflow("imgnonlinfilter",0);
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
