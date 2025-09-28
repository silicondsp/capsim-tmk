 
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

Multiplex N input image channels to one output channel. The multiplexing order is from input channel 0 to N-1 for N input channels.

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
/*-------------- BLOCK CODE ---------------*/


imgmux 

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
	int buffer_id;
	image_t	img;


switch (run_state) {


 /********* PARAMETER INITIALIZATION CODE ************/
case PARAM_INIT:

        {
        int indexModel88 = block_P->model_index;

        KrnModelParam(indexModel88,-1,"","","");
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

 

	if((inbufs = NO_INPUT_BUFFERS()) < 2
		|| (outbufs = NO_OUTPUT_BUFFERS()) < 1) {
		fprintf(stderr,"imgmux.s: i/o buffers connect problem\n");
		return(1);
	}
	for(i=0; i<inbufs; i++)
                SET_CELL_SIZE_IN(i,sizeof(image_t));
        for(i=0; i<outbufs; i++)
                SET_CELL_SIZE_OUT(i,sizeof(image_t));


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


	for(i=MIN_AVAIL(); i>0; i--) {
		for(j=0; j<inbufs; j++) {
		    IT_IN(j);
		    img= INIMAGE(j,0);
		    for(k=0; k<outbufs; k++) {
				if(IT_OUT(k)) {
					KrnOverflow("imgmux.s",k);
					return(99);
				}
				OUTIMAGE(k,0) = img;
		    }
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
