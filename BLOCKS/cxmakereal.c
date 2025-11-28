 
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

This star creates a two real  buffers from one complex input buffer.

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

cxmakereal 

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
	complex inSamp;


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
                fprintf(stderr,"cxmakereal: no input buffers\n");
                return(2);
        }
        if(numInBuffers >1 ) {
                fprintf(stderr,"cxmakecx: too many inputs connected\n");
                return(3);
        }
        if((numOutBuffers = NO_OUTPUT_BUFFERS()) < 1) {
                fprintf(stderr,"cxmakecx: no output buffers\n");
                return(4);
        }       
        SET_CELL_SIZE_IN(0,sizeof(complex));


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


	/* note the minimum number of samples on the 	*/
	/* input buffers and iterate that many times 	*/
	
	for(no_samples=(MIN_AVAIL() );no_samples >0; --no_samples) 

	{
		IT_IN(0);	
		inSamp = INCX(0,0);

		if(numOutBuffers == 1) {
                        if(IT_OUT(0)) {
				KrnOverflow("cxmakereal",0);
				return(99);
			}
                        OUTF(0,0) = inSamp.re;
		} else {
                        if(IT_OUT(0)) {
				KrnOverflow("cxmakereal",0);
				return(99);
			}
                        OUTF(0,0) = inSamp.re;
                        if(IT_OUT(1)) {
				KrnOverflow("cxmakereal",1);
				return(99);
			}
                        OUTF(1,0) = inSamp.im;

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
