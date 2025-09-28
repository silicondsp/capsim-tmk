 
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

This star simulates a frequency counter.  The single parameter determines if the output is relative or absolute.

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
      int  __cycles;
      int  __limit;
      int  __absolute;
      float  __center;
      float  __count;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define cycles (state_P->__cycles)
#define limit (state_P->__limit)
#define absolute (state_P->__absolute)
#define center (state_P->__center)
#define count (state_P->__count)

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
#define parm (param_P[0]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

freq_meter 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int i,rising,no_samples;
	int this_x,last_x;
	float last_y;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Input relative or absolute, see code!";
     char   *ptype0 = "int";
     char   *pval0 = "1";
     char   *pname0 = "parm";
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
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
     


         
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

 

	if (parm > 0)
		;
	else
		return(2);
	if (parm < 21)
		{
		absolute = 1;
		limit = parm;
		}
	else
		{
		absolute = 0;
		limit = 1;
		center = 1.0/parm;
		}
	count = 0.0;
	cycles = 0;


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


	for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) 

		/* increment time on the output and set sample to zero */
		{

		if (x(0) > 0.5)
			last_x = 1;
		else
			last_x = 0;


		IT_IN(0);	

		if (x(0) > 0.5)
			this_x = 1;
		else
			this_x = 0;

		if (this_x && !last_x)
			rising = 1;
		else
			rising = 0;

		count = count + 1.0;

		if (rising)
			{
			++cycles;
			if(cycles > limit)
				{
				if(IT_OUT(0) ) {
					KrnOverflow("freq_meter",0);
					return(99);
				}
				if (absolute)
					{
					if (count == 0)
						count = 1;	
					y(0) = 1.0/(count*limit);
					}
				else
					{
					if (count == 0)
						count = 1;	
					y(0) = (1.0/count) - center;
					y(0) = 100 * (y(0)/center);
					}
				count = 0.0;
				cycles = 1;
				}
			}
		else
			{
			last_y = y(0);
			if(IT_OUT(0)) {
					KrnOverflow("freq_meter",0);
					return(99);
			}
			y(0) = last_y;
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
