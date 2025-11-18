 
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

This block creates a complex buffer from one or two input buffers. 

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
      int  __numOutBuffers;
      int  __numInBuffers;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define numOutBuffers (state_P->__numOutBuffers)
#define numInBuffers (state_P->__numInBuffers)
/*-------------- BLOCK CODE ---------------*/
 int  

cxmakecx 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int no_samples;
	float a,b;
	int 	i;
	complex calc;


switch (run_state) {


 /********* PARAMETER INITIALIZATION CODE ************/
case PARAM_INIT:

        {
        int indexModel88 = block_P->model_index;

        KrnModelParam(indexModel88,-1,"","","","");
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

 

       /* store as state the number of input/output buffers */
        if((numInBuffers = NO_INPUT_BUFFERS()) < 1) {
                fprintf(stderr,"cxmakecx: no input buffers\n");
                return(2);
        }
        if(numInBuffers >2 ) {
                fprintf(stderr,"cxmakecx: too many inputs connected\n");
                return(3);
        }
        if((numOutBuffers = NO_OUTPUT_BUFFERS()) < 1) {
                fprintf(stderr,"cxmakecx: no output buffers\n");
                return(4);
        }       
	for (i=0; i<numOutBuffers; i++)
                SET_CELL_SIZE_OUT(i,sizeof(complex));


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


	/* note the minimum number of samples on the 	*/
	/* input buffers and iterate that many times 	*/
	
	for(no_samples=(MIN_AVAIL());no_samples >0; --no_samples) 

	{
		if(numInBuffers == 1) {
			/*
			 * only one input buffer connected 
			 * get the sample and set imaginary part to zero
			 */
			IT_IN(0);	
			a = INF(0,0);
			b=0.0;

		} else {
			/*
			 * two input  buffers  connected 
			 */
			IT_IN(0);	
			a = INF(0,0);
			IT_IN(1);	
			b = INF(1,0);
		}

               for(i=0; i<numOutBuffers; i++) {
			/*
			 * form complex sample and output on all connected
			 * output buffers
			 */
                        if(IT_OUT(i)) {
				KrnOverflow("cxmakecx",i);
				return(99);
			}
			calc.re = a;
			calc.im = b;
                        OUTCX(i,0) = calc;
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
