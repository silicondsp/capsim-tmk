 
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

This block finds the relative phase of a signal to a reference. 

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>


 

#define true 1
#define false 0


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      float  __ref_count;
      float  __x_count;
      float  __tau;
      int  __counting;
      float  __last_phi;
      float  __phi_max;
      float  __this_x;
      float  __last_x;
      float  __this_ref;
      float  __last_ref;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define ref_count (state_P->__ref_count)
#define x_count (state_P->__x_count)
#define tau (state_P->__tau)
#define counting (state_P->__counting)
#define last_phi (state_P->__last_phi)
#define phi_max (state_P->__phi_max)
#define this_x (state_P->__this_x)
#define last_x (state_P->__last_x)
#define this_ref (state_P->__this_ref)
#define last_ref (state_P->__last_ref)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define x(DELAY) (*((float  *)PIN(0,DELAY)))
#define ref(DELAY) (*((float  *)PIN(1,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define phi(delay) *(float  *)POUT(0,delay)

/*         
 *    PARAMETER DEFINES 
 */ 
#define edge (param_P[0]->value.d)
#define sync (param_P[1]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

jitter 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int no_samples;
	int x_falling,x_rising;
	int ref_falling,ref_rising;
	float delta;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Trigger edge: 1= Rising, 0=Falling";
     char   *ptype0 = "int";
     char   *pval0 = "1";
     char   *pname0 = "edge";
     char   *pdef1 = "Output Rate. Synchronous/One per cycle";
     char   *ptype1 = "int";
     char   *pval1 = "1";
     char   *pname1 = "sync";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);

      }
break;
   


/*         
 *    OUTPUT BUFFER SYSTEM  INITS 
 */ 
 case OUTPUT_BUFFER_INIT: 
 {
 int indexOC = block_P->model_index;
     char   *ptypeOut0 = "float";
     char   *pnameOut0 = "phi";
KrnModelConnectionOutput(indexOC,0 ,pnameOut0,ptypeOut0);
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
     char   *ptypeIn1 = "float";
     char   *pnameIn1 = "ref";
KrnModelConnectionInput(indexIC,0 ,pnameIn0,ptypeIn0);
KrnModelConnectionInput(indexIC,1 ,pnameIn1,ptypeIn1);
}
 break;

/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
     


         
   if(NO_OUTPUT_BUFFERS() != 1 ){
       fprintf(stdout,"%s:1 outputs expected; %d connected\n",
              STAR_NAME,NO_OUTPUT_BUFFERS());
	      return(201);
   }

   SET_CELL_SIZE_OUT(0,sizeof(float));

         
   if(NO_INPUT_BUFFERS() != 2 ){
       fprintf(stdout,"%s:2 inputs expected; %d connected\n",
              STAR_NAME,NO_INPUT_BUFFERS());
	      return(200);
   }

   SET_CELL_SIZE_IN(0,sizeof(float));

   SET_CELL_SIZE_IN(1,sizeof(float));

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

	if ((edge >= 0) && (edge >= 1))
		;
	else
		return(1);
	ref_count = 0.0;
	x_count = 0.0;
	counting = 0;
	phi_max = 180.0;
	tau = 0.0;
	this_x=0.0;
	this_ref=0.0;


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 

 
	for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) 
 
	{
		/* read x and check for edge		*/
		last_x = this_x;
		IT_IN(0);	
		this_x = x(0);
 
		if ((this_x <= 0.0) && (last_x > 0.0))
			x_falling = 1;
		else
			x_falling = 0;
 
		if ((this_x >= 0.0) && (last_x < 0.0))
			x_rising = 1;
		else
			x_rising = 0;
 
 
		/* read ref and check for falling edge	*/
		last_ref = ref(0);
		IT_IN(1);	
		this_ref = ref(0);
 
		if ((this_ref <= 0.0) && (last_ref > 0.0))
			ref_falling = 1;
		else
			ref_falling = 0;
 
		if ((this_ref >= 0.0) && (last_ref < 0.0))
			ref_rising = 1;
		else
			ref_rising = 0;
 
		if ((edge && ref_rising)||(!edge && ref_falling))
			{
 
			counting = true;
 
			/* find distance from last sample */
			/* to zero crossing		*/
			delta = last_ref/(last_ref - this_ref);
 
 
			tau = ref_count + delta; 
			ref_count = 1.0 - delta;
			x_count = 0.0 - delta;
			}
		else
			{
			ref_count = ref_count + 1.0;
			delta = 0.0;
			}
 
		if (((edge && x_rising) || (!edge && x_falling)) 
			&& counting)
			{
			if(IT_OUT(0)) {
				KrnOverflow("jitter",0);
				return(99);
			}
			counting = false;
 
			/* find distance from last sample to	*/
			/* zero crossing			*/
			if (delta != 0.0)
				{
				delta = last_x/(last_x - this_x) 
					- delta;
				x_count = delta;
				}
			else
				{
				delta = last_x/(last_x - this_x);
				x_count = x_count + delta;
				}
 
 
			if (tau > 0)
				phi(0) = (x_count * 360.0)/tau;
			else
				phi(0) = 0.0;
 
			while (phi(0) > 360.0)
				phi(0) = phi(0) - 360.0;
 
			if (phi(0) > phi_max)
				phi(0) = phi(0) - (2 * phi_max);
 
			last_phi = phi(0);
			}
		/* else, continue to count and output last phase*/
		else 
			{
			if (sync)
				{
				if(IT_OUT(0)) {
					KrnOverflow("jitter",0);
					return(99);
				}
				phi(0) = last_phi;
				}
			if (counting)
				x_count = x_count + 1.0;
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
