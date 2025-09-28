 
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

This star inputs a complex image height*(2*width) and creates a new real image height*width  of magnitudes

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
#define xx(DELAY) (*((image_t  *)PIN(0,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define yy(delay) *(image_t  *)POUT(0,delay)
/*-------------- BLOCK CODE ---------------*/


imgcxmag 

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
	float	y,x;


switch (run_state) {


 /********* PARAMETER INITIALIZATION CODE ************/
case PARAM_INIT:

        {
        int indexModel88 = block_P->model_index;

        KrnModelParam(indexModel88,-1,"","","");
        }

break;
   
          
 
/*         
 *    OUTPUT BUFFER SYSTEM  INITS 
 */ 
 case OUTPUT_BUFFER_INIT: 
 {
 int indexOC = block_P->model_index;
     char   *ptypeOut0 = "image_t";
     char   *pnameOut0 = "yy";
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
     char   *pnameIn0 = "xx";
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
	img=xx(0);
	pheight=img.height;
	pwidth=img.width;
	mat_PP=img.image_PP;
fprintf(stderr,"imgcxmag width and height %d %d \n",pwidth,pheight);


		   matTrans_PP=(float**)calloc(pheight,sizeof(float*));
		   for(k=0; k<pheight; k++) {
			matTrans_PP[k]=(float*)calloc(pwidth/2,sizeof(float));
		   }
		   for(k=0; k<pheight; k++) {
	              for(j=0; j<pwidth/2; j++) {
			x=mat_PP[k][2*j];
			y=mat_PP[k][2*j+1];
			matTrans_PP[k][j]=sqrt(x*x+y*y);
		      }
                   }
		   img.width=pwidth/2;
		   img.height=pheight;
    		   img.image_PP=matTrans_PP;
		   if(IT_OUT(0)) {
				KrnOverflow("imgcxmag",0);
				return(99);
		   }
		   yy(0) = img;
		
			
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
