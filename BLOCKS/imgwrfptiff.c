 
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

Writes an input image to a TIFF file as floating point  samples. Also store the current colormap.

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 
#include <string.h>


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
       int   __fp;
       int   __ibufs;
       int   __obufs;
       char*   __buff;
       image_t   __img;
       int   __pwidth;
       int   __pheight;
       float**   __mat_PP;
       char *   __theFileName;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define  fp  (state_P->__fp)
#define  ibufs  (state_P->__ibufs)
#define  obufs  (state_P->__obufs)
#define  buff  (state_P->__buff)
#define  img  (state_P->__img)
#define  pwidth  (state_P->__pwidth)
#define  pheight  (state_P->__pheight)
#define  mat_PP  (state_P->__mat_PP)
#define  theFileName  (state_P->__theFileName)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define x(DELAY) (*(( image_t   *)PIN(0,DELAY)))

/*         
 *    PARAMETER DEFINES 
 */ 
#define fileName (param_P[0]->value.s)
#define colorMapFile (param_P[1]->value.s)
/*-------------- BLOCK CODE ---------------*/
 int  
imgwrfptiff
(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int i,j,k,ii;
	unsigned short pixel;
	float	fpixel;
    int IIP_WriteMatrixFloatingPointTIFFText(float**	matrix_PP,unsigned int	width,unsigned int	height, char*, char*	);


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = " Name of output file ";
     char   *ptype0 = "file";
     char   *pval0 = "output.tif";
     char   *pname0 = "fileName";
     char   *pdef1 = " Color Map File ";
     char   *ptype1 = "file";
     char   *pval1 = "ther.map";
     char   *pname1 = "colorMapFile";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);

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

 

	if((ibufs = NO_INPUT_BUFFERS()) != 1) {
		fprintf(stdout,"imgwrtiff: no input buffer\n");
		return(1);
	}
	if((obufs = NO_OUTPUT_BUFFERS()) > ibufs) {
		fprintf(stdout,"imgwrfptiff: more output than input buffers\n");
		return(2);
	}
	for(j=0; j<obufs; j++)
                SET_CELL_SIZE_OUT(j,sizeof(image_t));
	for(i=0; i<ibufs; i++)
        	SET_CELL_SIZE_IN(i,sizeof(image_t));
	for(i=0; i<obufs; i++)
        	SET_CELL_SIZE_OUT(i,sizeof(image_t));

        theFileName= (char*) calloc(256, sizeof(char));

        strcpy(theFileName,fileName);


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 

        /* This mode synchronizes all input buffers */
for(ii = MIN_AVAIL(); ii>0; ii--) {
        IT_IN(0);
	img=x(0);
	pheight=img.height;
	pwidth=img.width;
	mat_PP=img.image_PP;
	fprintf(stderr,"imgwrtiff to produce %d x  %d image file\n",pwidth,pheight);
	if(IIP_WriteMatrixFloatingPointTIFFText(mat_PP,pwidth,pheight,theFileName,colorMapFile)) {
                fprintf(stderr,"imgwrfptiff: can't write TIFF image\n");
                return(4);
        }

	if(obufs==1) {
                if(IT_OUT(0)) {
			KrnOverflow("imgwrfptiff",0);
			return(99);
		}
                OUTIMAGE(0,0) = img;
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
