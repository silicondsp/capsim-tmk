 
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

Zero crossing detector. Outputs impulses at zero crossing.

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
 *    INPUT BUFFER DEFINES 
 */ 
#define x(DELAY) (*((float  *)PIN(0,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define y(delay) *(float  *)POUT(0,delay)

/*         
 *    PARAMETER DEFINES 
 */ 
#define edge (param_P[0]->value.d)
/*-------------- BLOCK CODE ---------------*/


zc 

(run_state,block_P)

	int run_state;
	block_Pt block_P;
{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
/*
 *              Declarations 
 */
 

	int no_samples;
	float this_x,last_x;
	int x_falling,x_rising;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Trigger edge: 1= Rising, 0=Falling";
     char   *ptype0 = "int";
     char   *pval0 = "1";
     char   *pname0 = "edge";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);

      }
break;
   


/*         
 *    OUTPUT BUFFER SYSTEM  INITS 
 */ 
 case OUTPUT_BUFFER_INIT: 
 {
 int indexOC = block_P->model_index;
     char   *ptypeOut0 = "float";
     char   *pnameOut0 = "y";
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
KrnModelConnectionInput(indexIC,0 ,pnameIn0,ptypeIn0);
}
 break;

/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     

         
   if(NO_OUTPUT_BUFFERS() != 1 ){
       fprintf(stdout,"%s:1 outputs expected; %d connected\n",
              STAR_NAME,NO_OUTPUT_BUFFERS());
	      return(201);
   }

   SET_CELL_SIZE_OUT(0,sizeof(float));

         
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

 

	if ((edge >= 0) && (edge >= 1))
		;
	else
		return(1);


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 

 
	for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) 
 
	{
		/* read x and check for edge		*/
		last_x = x(0);
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
 
 
		if(IT_OUT(0)) {
			KrnOverflow("zc", 0);
			return(99);
		}
		if (x_falling && edge ) 
			y(0)=1;
		else
		if(x_rising && !edge) 
			y(0) = 1;
		else
			y(0) = 0;
			
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
