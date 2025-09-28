 
#ifdef LICENSE

/*  Capsim (r) Text Mode Kernel (TMK) Block Library (Blocks)
    Copyright (C) 1989-2017  Silicon DSP  Corporation 

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
    Silicon DSP Corporation
     
*/

#endif
 
#ifdef SHORT_DESCRIPTION

Read  an 8 bit  TIFF  image.

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 

#include "dsp.h"



/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
       int   __obufs;
       int   __haveRead;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define  obufs  (state_P->__obufs)
#define  haveRead  (state_P->__haveRead)

/*         
 *    PARAMETER DEFINES 
 */ 
#define fileName (param_P[0]->value.s)
/*-------------- BLOCK CODE ---------------*/
 int  
imgrdtiff
(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int i,j,k;
	float x;
	int  n;
	image_t	img;
	dsp_floatMatrix_Pt	tiffImage_P;
	dsp_floatMatrix_Pt IIP_ReadTIFFMatrixText(char *);
       


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = " File that contains  TIFF image ";
     char   *ptype0 = "file";
     char   *pval0 = "image.tif";
     char   *pname0 = "fileName";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);

      }
break;
   


/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
             haveRead = 0 ;

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 
fprintf(stderr,"INIT imgrdtiff: reading: %s \n",fileName);
	if( (obufs = NO_OUTPUT_BUFFERS()) < 1 ) {
		fprintf(stderr,"imgrdtiff: no output buffers\n");
		return(2);
	}
        for(j=0; j<obufs; j++) 
		SET_CELL_SIZE_OUT(j,sizeof(image_t));


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 
  fprintf(stderr,"imgrdtiff: reading: %s \n",fileName);
while(!haveRead) {
	   fprintf(stderr,"imgrdtiff: reading: %s \n",fileName);
	  tiffImage_P=IIP_ReadTIFFMatrixText(fileName);
	  if(tiffImage_P == NULL) {
		fprintf(stderr,"imgrdtiff: could not read image\n");
		return(3);
	  }
	  haveRead=1;

	  for(j=0; j<obufs; j++) {
		if(IT_OUT(j)){

			KrnOverflow("imgrdtiff",j);
			return(99);
		}
		img.image_PP = tiffImage_P->matrix_PP;
		img.width = tiffImage_P->width;
		img.height = tiffImage_P->height;
		OUTIMAGE(j,0) = img;
	  }
}
return(0);
	


break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

        return(0);


break;
}
return(0);
}
