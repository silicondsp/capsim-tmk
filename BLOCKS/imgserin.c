 
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

This block inputs rows and creates an  image and outputs it to the image buffer

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
      int  __pointCount;
      int  __numberRowsInput;
      int  __widthOutput;
      int  __heightOutput;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define mat_PP (state_P->__mat_PP)
#define pointCount (state_P->__pointCount)
#define numberRowsInput (state_P->__numberRowsInput)
#define widthOutput (state_P->__widthOutput)
#define heightOutput (state_P->__heightOutput)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define x(DELAY) (*((float  *)PIN(0,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define y(delay) *(image_t  *)POUT(0,delay)

/*         
 *    PARAMETER DEFINES 
 */ 
#define pwidth (param_P[0]->value.d)
#define pheight (param_P[1]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

imgserin 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int no_samples;
	int i,j;
	int	factor;
	image_t	img;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Image Width";
     char   *ptype0 = "int";
     char   *pval0 = "1";
     char   *pname0 = "pwidth";
     char   *pdef1 = "Image Height";
     char   *ptype1 = "int";
     char   *pval1 = "1";
     char   *pname1 = "pheight";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);

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
     char   *ptypeIn0 = "float";
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
            pointCount=0;
       numberRowsInput=0;
       widthOutput=0;
       heightOutput=0;



         
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

   SET_CELL_SIZE_IN(0,sizeof(float));

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

	mat_PP = (float**)calloc(pheight+1,sizeof(float*));
	if(mat_PP == NULL) {
		fprintf(stderr,"Could not allocate in imgserin.\n");
		return(4);
	}
	for(i=0; i<pheight; i++) {
	  mat_PP[i]=(float*)calloc(pwidth+1,sizeof(float));
		if(mat_PP[i] == NULL) {
			fprintf(stderr,"Could not allocate in imgserin.\n");
			return(5);
		}
	}
	pointCount = 0;
	numberRowsInput=0;
        widthOutput = 0;
        heightOutput = 0;
    SET_CELL_SIZE_OUT(0,sizeof(image_t));


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 

/*
 * if the image has been inputted and is ready to be outputted, then
 * output either a row at a time or a column at a time on 
 * each visit
 */
if(numberRowsInput == pheight) {
	
	   {
	   	/* 
	    	 * now, output real  samples		
	     	 */
		if(IT_OUT(0)) {
			KrnOverflow("imgserin",0);
			return(99);
		}
		img.image_PP=mat_PP;
		img.width=pwidth;
		img.height=pheight;
		y(0) = img;
			
	   }
	/*
	 * reset and collect another matrix again
	 */
	pointCount = 0;
	numberRowsInput=0;
       	widthOutput = 0;
       	heightOutput = 0;
   	return(0);
}
/*
 * collect the image
 */
for (no_samples = MIN_AVAIL(); no_samples > 0; --no_samples) {
	j=pointCount;
	IT_IN(0);
	mat_PP[numberRowsInput][j]=x(0);
	pointCount++;


			

	/* 
	 * Get enough points				
	 */
	if(pointCount == pwidth ) {
		numberRowsInput++;
		pointCount =0;
		if(numberRowsInput == pheight) {
			return(0);
		}
	}
}
return(0);


break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

	/* 
	 * free up allocated space      
	 */
#if 0
        for(i=0; i<pheight; i++)
                free((char*)mat_PP[i]);
#endif


break;
}
return(0);
}
