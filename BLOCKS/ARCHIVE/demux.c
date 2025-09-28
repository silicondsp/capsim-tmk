 
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

This star provides periodic demultiplexing of an input data stream.

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
      int*  __out_time;
      int  __obufs;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define out_time (state_P->__out_time)
#define obufs (state_P->__obufs)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define x(DELAY) (*((float  *)PIN(0,DELAY)))

/*         
 *    PARAMETER DEFINES 
 */ 
#define N (param_P[0]->value.d)
#define phases ((float*)param_P[1]->value.s)
#define n_phases  (param_P[1]->array_size)
/*-------------- BLOCK CODE ---------------*/


demux 

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
 

	int i;
	int no_samples;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Ratio input rate/output rate,N";
     char   *ptype0 = "int";
     char   *pval0 = "8";
     char   *pname0 = "N";
     char   *pdef1 = "Array: Specifies the phase (delay in samples relative to first input sample) for each output.";
     char   *ptype1 = "array";
     char   *pval1 = "";
     char   *pname1 = "phases";
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

 

	if(N < 1 ) {
		fprintf(stderr,"demux: improper parameter\n");
		return(1);
	}
	for(i=0; i<n_phases; i++) {
		if(phases[i] < 0) {
			fprintf(stderr,"demux: improper array params\n");
			return(2);
		}
	}
	if((obufs = NO_OUTPUT_BUFFERS()) != n_phases) {
		fprintf(stderr,"demux: param array != topology\n");
		return(3);
	}
	if( (out_time = (int*)calloc(obufs,sizeof(float))) == NULL ) {
		fprintf(stderr,"demux: can't allocate space\n");
		return(4);
	}
	for(i=0; i<n_phases; i++)
		out_time[i] = phases[i];


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 

	for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) {
		IT_IN(0);
		for(i=0; i<n_phases; i++) {
			if(out_time[i] <= 0) {
				if(IT_OUT(i)) {
					KrnOverflow("demux",i);
					return(99);
				}
				OUTF(i,0) = INF(0,0);
				out_time[i] += N;
			}
			--out_time[i];
		}
	}


break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 



break;
}
return(0);
}
