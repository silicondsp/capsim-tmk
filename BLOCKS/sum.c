 
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

This star is an extension of "add".  It creates a Weighted Sum of all input channels and sends it to the output buffer(s).

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
 int  sum(int run_state,block_Pt block_P)

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
     char   *pdef0 = "Array of weights: number_of_weights w0 w1 w2 ... ";
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

 

	if((inbufs = NO_INPUT_BUFFERS()) < 1
		|| (outbufs = NO_OUTPUT_BUFFERS()) < 1) {
		fprintf(stderr,"sum: i/o buffers connect problem\n");
		return(1);
	}
	if(inbufs != n_weights) {
		fprintf(stderr,"sum: parameters disagree with inputs\n");
		return(2);
	}
        for(j=0; j<inbufs; j++) {

           printf("SUM WEIGHT[%d]=%f\n",j,weights[j]);
        }


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


	for(i=0; i<MIN_AVAIL(); i++) {
		sum = 0;
		for(j=0; j<inbufs; j++) {
			IT_IN(j);
			sum += weights[j] * INF(j,0);
		}
		for(j=0; j<outbufs; j++) {
			if(IT_OUT(j)) {
				KrnOverflow("sum",j);
				return(99);
			}
			OUTF(j,0) = sum;
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
