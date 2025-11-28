 
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

This function performs the simple task of reading sample values in from a file, and then placing them on its output buffer. The file may have multiple sample values per line, which can be integer or float. If more than one output buffer is connected, then the samples are routed to each buffer in sequence mod the number of buffers.

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
      int  __obufs;
      int  __j;
      FILE*  __fp;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define obufs (state_P->__obufs)
#define j (state_P->__j)
#define fp (state_P->__fp)

/*         
 *    PARAMETER DEFINES 
 */ 
#define file_name (param_P[0]->value.s)
/*-------------- BLOCK CODE ---------------*/
 int  

rdmulti 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int i,k;
	float x;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "File that contains data";
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
            j=0;

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

	if(strcmp(file_name,"stdin") == 0)
		fp = stdin;
	else if((fp = fopen(file_name,"r")) == NULL) {
		fprintf(stderr,"read_file: cannot open file\n");
		return(1); /* file cannot be opened */
	}
	if( (obufs = NO_OUTPUT_BUFFERS()) < 1 ) {
		fprintf(stderr,"read_file: no output buffers\n");
		return(2);
	}


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


	/* output a maximum of NUMBER_SAMPLES_PER_VISIT samples to output buffer(s) */
	for(i=0; i < NUMBER_SAMPLES_PER_VISIT; ++i) {

		/* Read input lines until EOF */
		if(fscanf(fp,"%f",&x) == EOF)
			break;

		/* input sample available: */
		/* increment time on output buffer(s) */
		/* and output a sample */
			if(IT_OUT(j)) {
				KrnOverflow("rdmulti",j);
				return(99);
			}
			OUTF(j,0) = x;
		j += 1;
		if(j == obufs) j=0;
	}


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
