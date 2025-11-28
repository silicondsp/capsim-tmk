 
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

Input image and store as ASCII in a file

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
      FILE*  __fp;
      int  __ibufs;
      int  __obufs;
      int  __displayFlag;
      image_t  __img;
      int  __pwidth;
      int  __pheight;
      float**  __mat_PP;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define fp (state_P->__fp)
#define ibufs (state_P->__ibufs)
#define obufs (state_P->__obufs)
#define displayFlag (state_P->__displayFlag)
#define img (state_P->__img)
#define pwidth (state_P->__pwidth)
#define pheight (state_P->__pheight)
#define mat_PP (state_P->__mat_PP)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define x(DELAY) (*((image_t  *)PIN(0,DELAY)))

/*         
 *    PARAMETER DEFINES 
 */ 
#define fileName (param_P[0]->value.s)
/*-------------- BLOCK CODE ---------------*/
 int  

imgprasc 

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


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Name of output file";
     char   *ptype0 = "file";
     char   *pval0 = "output-asc.img";
     char   *pname0 = "fileName";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);

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
            displayFlag=0;


         
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

 

	if((ibufs = NO_INPUT_BUFFERS()) != 1) {
		fprintf(stdout,"imgprasc: no input buffer\n");
		return(1);
	}
	if((obufs = NO_OUTPUT_BUFFERS()) > ibufs) {
		fprintf(stdout,"imgprasc: more output than input buffers\n");
		return(2);
	}
	for(j=0; j<obufs; j++)
                SET_CELL_SIZE_OUT(j,sizeof(image_t));
	if(strcmp(fileName,"stdout") == 0) {
		fp = stdout;
		displayFlag = 1;
	}
	else if(strcmp(fileName,"stderr") == 0) {
		fp = stderr;
		displayFlag = 1;
	}
	else if((fp = fopen(fileName,"w")) == NULL) {
		fprintf(stdout,"primage: can't open output file '%s'\n",
			fileName);
		return(3);
	}
	for(i=0; i<ibufs; i++)
        	SET_CELL_SIZE_IN(i,sizeof(image_t));
	for(i=0; i<obufs; i++)
        	SET_CELL_SIZE_OUT(i,sizeof(image_t));


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 

for(ii = MIN_AVAIL(); ii>0; ii--) {
    IT_IN(0);
	img=x(0);
	pheight=img.height;
	pwidth=img.width;
	mat_PP=img.image_PP;
	fprintf(stderr,"imgprasc to produce %d x  %d image file\n",pwidth,pheight);

	if(obufs==1) {
        if(IT_OUT(0)) {
			KrnOverflow("imgprbin",0);
			return(99);
		}
        OUTIMAGE(0,0) = img;
    }
	fprintf(fp,"%d %d\n",pwidth,pheight);
	for(i=0; i<pheight; i++) {
		for(j=0; j<pwidth; j++) {
			fpixel = mat_PP[i][j];
			fprintf(fp,"%f\n",fpixel);

		}
	}
}
	
return(0);



break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

	fclose(fp);


break;
}
return(0);
}
