 
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

Function prints samples from an arbitrary number of input buffers to the terminal output using the "more" command (one sample from each input is printed on each line)

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
      int  __no_buffers;
      FILE*  __fp;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define no_buffers (state_P->__no_buffers)
#define fp (state_P->__fp)
/*-------------- BLOCK CODE ---------------*/


more 

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
 

	int buffer_no,no_samples;
	FILE *popen();


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

 

	/* determine and store as state the number of input buffers */
	if((no_buffers = NO_INPUT_BUFFERS()) <= 0) {
		fprintf(stderr,"more: no input buffers\n");
		return(1); /* no input buffers */
	}
	if( (fp = popen("more","w")) == NULL)
			return(1); /* pipe can't be created */


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


	for(no_samples=MIN_AVAIL();no_samples>0;--no_samples) {

		for(buffer_no=0; buffer_no<no_buffers; ++buffer_no) {
			IT_IN(buffer_no);
			fprintf(fp, "%f ",*(float *)PIN(buffer_no,0));
			}
		fprintf(fp,"\n");
		}

	return(0);	/* one input buffer empty */



break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

	pclose(fp);
        return(0);


break;
}
return(0);
}
