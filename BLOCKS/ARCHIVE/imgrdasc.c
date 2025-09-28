 
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

Read a ASCII image. Read the image and output a single image sample.

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
      int  __numberRowsRead;
      float**  __mat_PP;
      int  __pwidth;
      int  __pheight;
      int  __done;
      FILE*  __fp;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define obufs (state_P->__obufs)
#define numberRowsRead (state_P->__numberRowsRead)
#define mat_PP (state_P->__mat_PP)
#define pwidth (state_P->__pwidth)
#define pheight (state_P->__pheight)
#define done (state_P->__done)
#define fp (state_P->__fp)

/*         
 *    PARAMETER DEFINES 
 */ 
#define fileName (param_P[0]->value.s)
/*-------------- BLOCK CODE ---------------*/


imgrdasc 

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
 

	int i,j,k;
	float x;
	int  n;
	image_t	img;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "File that contains image. Note width and height must be first line.";
     char   *ptype0 = "file";
     char   *pval0 = "stdin";
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
            numberRowsRead=0;
       done=0;

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

    done=0;
	if(strcmp(fileName,"stdin") == 0)
		fp = stdin;
	else if((fp = fopen(fileName,"r")) == NULL) {
		fprintf(stderr,"imgrdasc: cannot open file\n");
		return(1); /* file cannot be opened */
	}
	fscanf(fp,"%d %d",&pwidth,&pheight);
	numberRowsRead =0;
	if( (obufs = NO_OUTPUT_BUFFERS()) < 1 ) {
		fprintf(stderr,"imgrdasc: no output buffers\n");
		return(2);
	}
	mat_PP = (float**)calloc(pheight+1,sizeof(float*));
	if(mat_PP == NULL) {
		fprintf(stderr,"imgrdasc could not allocate space \n");
		return(5);
	}
    for(i=0; i<pheight; i++) {
      mat_PP[i]=(float*)calloc(pwidth+1,sizeof(float));
	  if(mat_PP[i] == NULL) {
		fprintf(stderr,"imgrdasc could not allocate space \n");
		return(6);
	  }
	}
    for(j=0; j<obufs; j++) 
		SET_CELL_SIZE_OUT(j,sizeof(image_t));


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


while(!done) {
   	if(numberRowsRead >= pheight) {
	     return(0); 
	}
	/* 
	 * read a row 
	 */
	for(i=0; i < pwidth; ++i) {

		/* Read input lines until EOF */
		if(fscanf(fp,"%f",&x) == EOF){
		    CsInfo("imgrdasc: EOF");
			done=1;
		}
		else 
		   mat_PP[numberRowsRead][i]=x;

	}



	/* 
	 * Check if all of matrix has been input.
	 * increment time on output buffer(s) 
	 * and output a sample image
	 */

	if(numberRowsRead == pheight-1) {
		  
		    for(j=0; j<obufs; j++) {
			   if(IT_OUT(j)){
	
				   KrnOverflow("imgrdasc",j);
				   return(99);
			   }
			   img.image_PP = mat_PP;
			   img.width = pwidth;
			   img.height = pheight;
			   OUTIMAGE(j,0) = img;
		       done=1;
			}
	 }

	 numberRowsRead++;



}


return(0);


break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

        if (fp != stdout)
             fclose(fp);


break;
}
return(0);
}
