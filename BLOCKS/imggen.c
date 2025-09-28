 
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

Generate a rectangular image.

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
      int  __generated;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define generated (state_P->__generated)

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define y(delay) *(image_t  *)POUT(0,delay)

/*         
 *    PARAMETER DEFINES 
 */ 
#define pixel (param_P[0]->value.f)
#define pwidth (param_P[1]->value.d)
#define pheight (param_P[2]->value.d)
#define rectWidth (param_P[3]->value.d)
#define rectHeight (param_P[4]->value.d)
#define widthOffset (param_P[5]->value.d)
#define heightOffset (param_P[6]->value.d)
#define complexFlag (param_P[7]->value.d)
#define complementFlag (param_P[8]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

imggen 

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
	dsp_floatMatrix_t	matrix;
	dsp_floatMatrix_Pt	matrix_P;
	image_t		img;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Pixel Value";
     char   *ptype0 = "float";
     char   *pval0 = "1.0";
     char   *pname0 = "pixel";
     char   *pdef1 = "Image Width";
     char   *ptype1 = "int";
     char   *pval1 = "128";
     char   *pname1 = "pwidth";
     char   *pdef2 = "Image Height";
     char   *ptype2 = "int";
     char   *pval2 = "128";
     char   *pname2 = "pheight";
     char   *pdef3 = "Rectangle Width";
     char   *ptype3 = "int";
     char   *pval3 = "128";
     char   *pname3 = "rectWidth";
     char   *pdef4 = "Rectangle Height";
     char   *ptype4 = "int";
     char   *pval4 = "128";
     char   *pname4 = "rectHeight";
     char   *pdef5 = "Rectangle Width Offset";
     char   *ptype5 = "int";
     char   *pval5 = "0";
     char   *pname5 = "widthOffset";
     char   *pdef6 = "Rectangle Height Offset";
     char   *ptype6 = "int";
     char   *pval6 = "0";
     char   *pname6 = "heightOffset";
     char   *pdef7 = "Complex Flag";
     char   *ptype7 = "int";
     char   *pval7 = "0";
     char   *pname7 = "complexFlag";
     char   *pdef8 = "Complement Flag";
     char   *ptype8 = "int";
     char   *pval8 = "0";
     char   *pname8 = "complementFlag";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);
KrnModelParam(indexModel88,3 ,pdef3,ptype3,pval3,pname3);
KrnModelParam(indexModel88,4 ,pdef4,ptype4,pval4,pname4);
KrnModelParam(indexModel88,5 ,pdef5,ptype5,pval5,pname5);
KrnModelParam(indexModel88,6 ,pdef6,ptype6,pval6,pname6);
KrnModelParam(indexModel88,7 ,pdef7,ptype7,pval7,pname7);
KrnModelParam(indexModel88,8 ,pdef8,ptype8,pval8,pname8);

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
            generated=0;


         
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

 

		     SET_CELL_SIZE_OUT(0,sizeof(image_t));


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


while(!generated) {
	generated=1;
	matrix_P = Dsp_GenMatrix(pwidth,pheight,rectWidth,rectHeight,
                        widthOffset,heightOffset,
                        pixel,complexFlag,complementFlag);





	if(matrix_P==NULL) {
		fprintf(stderr,"imggen: could not generate image \n");
		return(1);
	}


    /*
     * Send image out
	 */

	img.width=matrix_P->width;
	img.height=matrix_P->height;
    	img.image_PP=matrix_P->matrix_PP;

	if(IT_OUT(0)) {
				KrnOverflow("imggen",0);
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
