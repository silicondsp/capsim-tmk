 
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

This block stretches the incoming data.

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
      int  __last_clk;
      float  __last_x;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define last_clk (state_P->__last_clk)
#define last_x (state_P->__last_x)

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define y(delay) *(float  *)POUT(0,delay)

/*         
 *    PARAMETER DEFINES 
 */ 
#define s (param_P[0]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

strch 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int i,j,no_samples;
	int clk;
	float x;
	float z;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "";
     char   *ptype0 = "int";
     char   *pval0 = "1";
     char   *pname0 = "s";
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

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

	if (NO_OUTPUT_BUFFERS() == 1)
		;
	else
		return(1);
	if (s == 0)
		{
		if (NO_INPUT_BUFFERS() == 2)
			;
		else
			return(2);
		}
	else if (s > 0)
		{
		if (NO_INPUT_BUFFERS() == 1)
			;
		else
			return(3);
		}
	else
		return(4);
	last_clk = 0;


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


	/* note the minimum number of samples on the input buffers	*/
	/* and iterate that many times 					*/

	if (i > 0)
		{
		for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) 
			{
			IT_IN(0);
			x = INF(0,0);
			 
			for(i=0; i<s; ++i) 
				{
				if(IT_OUT(0)) {
					KrnOverflow("strch",0);
					return(99);
				}
				y(0) = x;
				}
			}
		return(0);
		}
	else
		{
		for(no_samples=MIN_AVAIL(); no_samples >0; --no_samples) 
			{
			IT_IN(1);
			if(IT_OUT(0) ) {
				KrnOverflow("strch",0);
				return(99);
			}

			z = INF(1,0);
			if (z > 0.5)
				clk = 1;
			else
				clk = 0;

			if (clk && !last_clk)
				{
				IT_IN(0);
				last_x = INF(0,0);
				}
			last_clk = clk;

			y(0) = last_x;
			}
		return(0);
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
