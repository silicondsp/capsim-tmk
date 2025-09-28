 
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

ead a binary image. On each visit a row is read from file. An image sample is output.

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>



/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int  __obufs;
      int  __fd;
      int  __numberRowsRead;
      char*  __buff;
      float**  __mat_PP;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define obufs (state_P->__obufs)
#define fd (state_P->__fd)
#define numberRowsRead (state_P->__numberRowsRead)
#define buff (state_P->__buff)
#define mat_PP (state_P->__mat_PP)

/*         
 *    PARAMETER DEFINES 
 */ 
#define pwidth (param_P[0]->value.d)
#define pheight (param_P[1]->value.d)
#define file_name (param_P[2]->value.s)
#define skip (param_P[3]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

imgrdbin 

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


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Image width";
     char   *ptype0 = "int";
     char   *pval0 = "128";
     char   *pname0 = "pwidth";
     char   *pdef1 = "Image height";
     char   *ptype1 = "int";
     char   *pval1 = "128";
     char   *pname1 = "pheight";
     char   *pdef2 = "File that contains binary image";
     char   *ptype2 = "file";
     char   *pval2 = "test.img";
     char   *pname2 = "file_name";
     char   *pdef3 = "Number of bytes to skip";
     char   *ptype3 = "int";
     char   *pval3 = "0";
     char   *pname3 = "skip";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);
KrnModelParam(indexModel88,3 ,pdef3,ptype3,pval3,pname3);

      }
break;
   


/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            numberRowsRead=0;

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

	if((fd = open(file_name,0)) == -1) {
		fprintf(stderr,"rdbinimage: cannot open file\n");
		return(1); /* file cannot be opened */
	}
	if( (obufs = NO_OUTPUT_BUFFERS()) < 1 ) {
		fprintf(stderr,"rdbinimage: no output buffers\n");
		return(2);
	}
	fprintf(stderr,"Image width= %d, height = %d \n",pwidth,pheight);
	numberRowsRead =0;
	buff = (char *) calloc(pwidth,sizeof(char));
	if(buff == NULL) {
		fprintf(stderr,"rdbinimage: can't allocate space\n");
		return(3);
	}
	for(i=0; i<skip; i++) {
		n= read(fd,buff,1);
		if(!n) { 
		    fprintf(stderr,"rdbinimage: skipped too many\n");
		    return(4);
		}
	}
	mat_PP = (float**)calloc(pheight+1,sizeof(float*));
	if(mat_PP == NULL) {
		fprintf(stderr,"imgrdbin2 could not allocate space \n");
		return(5);
	}
        for(i=0; i<pheight; i++) {
          mat_PP[i]=(float*)calloc(pwidth+1,sizeof(float));
	  if(mat_PP == NULL) {
		fprintf(stderr,"imgrdbin2 could not allocate space \n");
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

 


while(numberRowsRead < pheight) { 
	/* 
	 * output a row 
	 */
	        n= read(fd,buff,pwidth);
		/* 
		 *
		 * increment time on output buffer(s) 
		 * and output a sample 
		 */
		for (k = 0; k< n; k++) 
			mat_PP[numberRowsRead][k]=buff[k];
		if(numberRowsRead == pheight-1) {
		  
		  for(j=0; j<obufs; j++) {
			if(IT_OUT(j)){
	
				KrnOverflow("imgrdbin2",j);
				return(99);
			}
			img.image_PP = mat_PP;
			img.width = pwidth;
			img.height = pheight;
			OUTIMAGE(j,0) = img;
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

 

        /* free up allocated space      */
        close(fd);
	free(buff);
        return(0);


break;
}
return(0);
}
