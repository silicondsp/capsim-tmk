 
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

Charge pump and loop filter for PLL

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
      float  __t_out;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define t_out (state_P->__t_out)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define up(DELAY) (*((float  *)PIN(0,DELAY)))
#define down(DELAY) (*((float  *)PIN(1,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define y(delay) *(float  *)POUT(0,delay)

/*         
 *    PARAMETER DEFINES 
 */ 
#define g1 (param_P[0]->value.f)
#define vs (param_P[1]->value.f)
/*-------------- BLOCK CODE ---------------*/
 int  

pump 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int samples;
	float t_in;
	float t_in2;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Integrate gain";
     char   *ptype0 = "float";
     char   *pval0 = "1.0";
     char   *pname0 = "g1";
     char   *pdef1 = "Voltage step";
     char   *ptype1 = "float";
     char   *pval1 = "1.0";
     char   *pname1 = "vs";
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
     char   *pnameIn0 = "up";
     char   *ptypeIn1 = "float";
     char   *pnameIn1 = "down";
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
            t_out=0.0;


  delay_max(star_P->inBuffer_P[0],2);
  delay_max(star_P->inBuffer_P[1],2);

         
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

 



break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 

	for(samples = MIN_AVAIL();samples > 0; --samples)
	{
		IT_IN(0);
		IT_IN(1);
		t_in = down(0)-up(0);
		t_in2 = down(1)-up(1);

		if(t_in == 0.0)
		{
			if(t_in2 == -1.0)
			{
				t_out += vs;
			}
			if(t_in2 == 1.0)
			{
				t_out -= vs;
			}
		}
		if(t_in == 1.0)
		{
			if(t_in2 == 0.0)
			{
				t_out += vs;
			}
			else
			{
				t_out += g1;
			}
		}
		if(t_in == -1.0)
		{
			if(t_in2 == 0.0)
			{
				t_out -= vs;
			}
			else
			{
				t_out -= g1;
			}
		}
		if(IT_OUT(0)) {
			KrnOverflow("pump",0);
			return(99);
		}
		y(0)=t_out;
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
