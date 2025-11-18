 
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

This block outputs a weighted sum of delayed input data.

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
      int  __inbufs;
      int  __outbufs;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define inbufs (state_P->__inbufs)
#define outbufs (state_P->__outbufs)

/*         
 *    PARAMETER DEFINES 
 */ 
#define weights ((float*)param_P[0]->value.s)
#define n_weights  (param_P[0]->array_size)
/*-------------- BLOCK CODE ---------------*/
 int  

fir 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int i,j;
	float sum;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Array of weights";
     char   *ptype0 = "array";
     char   *pval0 = "";
     char   *pname0 = "weights";
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

 

	if((inbufs = NO_INPUT_BUFFERS()) < 1 || inbufs > 2) {
		fprintf(stderr,"fir: wrong number input buffers\n");
		return(2);
	}
	if((outbufs = NO_OUTPUT_BUFFERS()) < 1 || outbufs > 2) {
		fprintf(stderr,"fir: wrong number output buffers\n");
		return(3);
	}
	/* setup input buffer memory */
	SET_DMAX_IN(0, n_weights );


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


	for(i=0; i<MIN_AVAIL(); i++) {
		IT_IN(0);
		sum = 0;
		for(j=0; j<n_weights; j++)
			sum += weights[j] * INF(0,j);
		if(inbufs == 2) {
			IT_IN(1);
			sum += INF(1,0);
		}

		if(outbufs == 1) {
			if(IT_OUT(0)) {
				KrnOverflow("fir",0);
				return(99);
			}
			OUTF(0,0) = sum;
		}
		else {	/* outbufs == 2 */
			if(IT_OUT(0)) {
				KrnOverflow("fir",0);
				return(99);
			}
			if(IT_OUT(1)) {
				KrnOverflow("fir",1);
				return(99);
			}
			OUTF(0,0) = INF(0,n_weights);
			OUTF(1,0) = sum;
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
