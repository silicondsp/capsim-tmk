 
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

JK flip-flop positive edge triggered

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
      float  __temp_q;
      float  __temp_qp;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define temp_q (state_P->__temp_q)
#define temp_qp (state_P->__temp_qp)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define j(DELAY) (*((float  *)PIN(0,DELAY)))
#define k(DELAY) (*((float  *)PIN(1,DELAY)))
#define cp(DELAY) (*((float  *)PIN(2,DELAY)))
#define re(DELAY) (*((float  *)PIN(3,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define q(delay) *(float  *)POUT(0,delay)
#define qp(delay) *(float  *)POUT(1,delay)
/*-------------- BLOCK CODE ---------------*/


jkff 

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
 

	int samples;
	float in_j;
	float in_k;


switch (run_state) {


 /********* PARAMETER INITIALIZATION CODE ************/
case PARAM_INIT:

        {
        int indexModel88 = block_P->model_index;

        KrnModelParam(indexModel88,-1,"","","");
        }

break;
   
          
 
/*         
 *    OUTPUT BUFFER SYSTEM  INITS 
 */ 
 case OUTPUT_BUFFER_INIT: 
 {
 int indexOC = block_P->model_index;
     char   *ptypeOut0 = "float";
     char   *pnameOut0 = "q";
     char   *ptypeOut1 = "float";
     char   *pnameOut1 = "qp";
KrnModelConnectionOutput(indexOC,0 ,pnameOut0,ptypeOut0);
KrnModelConnectionOutput(indexOC,1 ,pnameOut1,ptypeOut1);
}
 break;

/*         
 *    INPUT BUFFER SYSTEM  INITS 
 */ 
 case INPUT_BUFFER_INIT:
 {
 int indexIC = block_P->model_index;
     char   *ptypeIn0 = "float";
     char   *pnameIn0 = "j";
     char   *ptypeIn1 = "float";
     char   *pnameIn1 = "k";
     char   *ptypeIn2 = "float";
     char   *pnameIn2 = "cp";
     char   *ptypeIn3 = "float";
     char   *pnameIn3 = "re";
KrnModelConnectionInput(indexIC,0 ,pnameIn0,ptypeIn0);
KrnModelConnectionInput(indexIC,1 ,pnameIn1,ptypeIn1);
KrnModelConnectionInput(indexIC,2 ,pnameIn2,ptypeIn2);
KrnModelConnectionInput(indexIC,3 ,pnameIn3,ptypeIn3);
}
 break;

/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            temp_q=0.0;
       temp_qp=1.0;


  delay_max(star_P->inBuffer_P[0],1);
  delay_max(star_P->inBuffer_P[1],1);
  delay_max(star_P->inBuffer_P[2],1);
  delay_max(star_P->inBuffer_P[3],1);

         
   if(NO_OUTPUT_BUFFERS() != 2 ){
       fprintf(stdout,"%s:2 outputs expected; %d connected\n",
              STAR_NAME,NO_OUTPUT_BUFFERS());
	      return(201);
   }

   SET_CELL_SIZE_OUT(0,sizeof(float));

   SET_CELL_SIZE_OUT(1,sizeof(float));

         
   if(NO_INPUT_BUFFERS() != 4 ){
       fprintf(stdout,"%s:4 inputs expected; %d connected\n",
              STAR_NAME,NO_INPUT_BUFFERS());
	      return(200);
   }

   SET_CELL_SIZE_IN(0,sizeof(float));

   SET_CELL_SIZE_IN(1,sizeof(float));

   SET_CELL_SIZE_IN(2,sizeof(float));

   SET_CELL_SIZE_IN(3,sizeof(float));

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

 


	for(samples = MIN_AVAIL(); samples>0; --samples)
	{
		IT_IN(0);
		IT_IN(1);
		IT_IN(2);
		IT_IN(3);
		in_j = j(0);
		in_k = k(0);
		if(re(0) > 0.5)
		{
			temp_q = 0.0;
			temp_qp = 1.0;
		}
		else
		{
			if(cp(0) > 0.5 && cp(1) == 0.0)
			{
				if(in_j > 0.5 && in_k > 0.5 
					&& temp_q == 0.0)
				{
					temp_q = 1.0;
					temp_qp = 0.0;
				}
				else if(in_j > 0.5 && in_k > 0.5
					&& temp_q == 1.0)
				{
					temp_q = 0.0;
					temp_qp = 1.0;
				}
	
				if(in_j > 0.5 && in_k == 0.0)
				{
					temp_q = 1.0;
					temp_qp = 0.0;
				}
	
				if(in_j == 0.0 && in_k > 0.5)
				{
					temp_q = 0.0;
					temp_qp = 1.0;
				}
			}
		}

		if(IT_OUT(0)) {
			KrnOverflow("jkff",0);
			return(99);
		}
		q(0) = temp_q;
		if(IT_OUT(1)) {
			KrnOverflow("jkff",1);
			return(99);
		}
		qp(0) = temp_qp;
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
