 
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

Read an image from a file.

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
      FILE*  __fp;
      int  __width;
      int  __height;
      int  __numberRowsRead;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define obufs (state_P->__obufs)
#define fp (state_P->__fp)
#define width (state_P->__width)
#define height (state_P->__height)
#define numberRowsRead (state_P->__numberRowsRead)

/*         
 *    PARAMETER DEFINES 
 */ 
#define file_name (param_P[0]->value.s)
/*-------------- BLOCK CODE ---------------*/
 int  

rdimage 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int i,j;
	float x;
	FILE *fopen();


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "File that contains image";
     char   *ptype0 = "file";
     char   *pval0 = "stdin";
     char   *pname0 = "file_name";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);

      }
break;
   


/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
     
break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

	if(strcmp(file_name,"stdin") == 0)
		fp = stdin;
	else if((fp = fopen(file_name,"r")) == NULL) {
		fprintf(stderr,"rdimage: cannot open file\n");
		return(1); /* file cannot be opened */
	}
	if( (obufs = NO_OUTPUT_BUFFERS()) < 1 ) {
		fprintf(stderr,"rdimage: no output buffers\n");
		return(2);
	}
	fscanf(fp,"%d %d",&width,&height);
	fprintf(stderr,"Image width= %d, height = %d \n",width,height);
	numberRowsRead =0;


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


   	if(numberRowsRead >= height) return(0); 
	/* 
	 * output a row 
	 */
	for(i=0; i < width; ++i) {

		/* Read input lines until EOF */
		if(fscanf(fp,"%f",&x) == EOF)
			break;

		/* input sample available: 
		 *
		 * increment time on output buffer(s) 
		 * and output a sample 
		 */
		for(j=0; j<obufs; j++) {
			if(IT_OUT(j)) {
				KrnOverflow("rdimage",j);
				return(99);
			}
			OUTF(j,0) = x;
		}
	}
	numberRowsRead++;
	


break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

        if (fp != stdout)
             fclose(fp);
        return(0);


break;
}
return(0);
}
