 
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

This star inputs an image and transposes  or flips it.

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 

#include <math.h>



/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      float**  __mat_PP;
      float**  __matTrans_PP;
      int  __pwidth;
      int  __pheight;
      image_t  __img;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define mat_PP (state_P->__mat_PP)
#define matTrans_PP (state_P->__matTrans_PP)
#define pwidth (state_P->__pwidth)
#define pheight (state_P->__pheight)
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
#define operation (param_P[0]->value.d)
/*-------------- BLOCK CODE ---------------*/


imgproc 

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
	int i,j,k;
	int	factor;
	float	temp;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Operation: 0=Transpose, 1= flip";
     char   *ptype0 = "int";
     char   *pval0 = "0";
     char   *pname0 = "operation";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);

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


break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 



break;
}
return(0);
}
