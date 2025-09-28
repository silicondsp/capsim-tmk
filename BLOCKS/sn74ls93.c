 
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

counter with QA connected to CKB

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
      int  __count_val;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define count_val (state_P->__count_val)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define cka(DELAY) (*((float  *)PIN(0,DELAY)))
#define r01(DELAY) (*((float  *)PIN(1,DELAY)))
#define r02(DELAY) (*((float  *)PIN(2,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define qa(delay) *(float  *)POUT(0,delay)
#define qb(delay) *(float  *)POUT(1,delay)
#define qc(delay) *(float  *)POUT(2,delay)
#define qd(delay) *(float  *)POUT(3,delay)
/*-------------- BLOCK CODE ---------------*/
 int  

sn74ls93 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int samples;
	int in_r01;
	int in_r02;


switch (run_state) {


 /********* PARAMETER INITIALIZATION CODE ************/
case PARAM_INIT:

        {
        int indexModel88 = block_P->model_index;

        KrnModelParam(indexModel88,-1,"","","","");
        }

break;
   
          
 
/*         
 *    OUTPUT BUFFER SYSTEM  INITS 
 */ 
 case OUTPUT_BUFFER_INIT: 
 {
 int indexOC = block_P->model_index;
     char   *ptypeOut0 = "float";
     char   *pnameOut0 = "qa";
     char   *ptypeOut1 = "float";
     char   *pnameOut1 = "qb";
     char   *ptypeOut2 = "float";
     char   *pnameOut2 = "qc";
     char   *ptypeOut3 = "float";
     char   *pnameOut3 = "qd";
KrnModelConnectionOutput(indexOC,0 ,pnameOut0,ptypeOut0);
KrnModelConnectionOutput(indexOC,1 ,pnameOut1,ptypeOut1);
KrnModelConnectionOutput(indexOC,2 ,pnameOut2,ptypeOut2);
KrnModelConnectionOutput(indexOC,3 ,pnameOut3,ptypeOut3);
}
 break;

/*         
 *    INPUT BUFFER SYSTEM  INITS 
 */ 
 case INPUT_BUFFER_INIT:
 {
 int indexIC = block_P->model_index;
     char   *ptypeIn0 = "float";
     char   *pnameIn0 = "cka";
     char   *ptypeIn1 = "float";
     char   *pnameIn1 = "r01";
     char   *ptypeIn2 = "float";
     char   *pnameIn2 = "r02";
KrnModelConnectionInput(indexIC,0 ,pnameIn0,ptypeIn0);
KrnModelConnectionInput(indexIC,1 ,pnameIn1,ptypeIn1);
KrnModelConnectionInput(indexIC,2 ,pnameIn2,ptypeIn2);
}
 break;

/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            count_val=0;


  delay_max(star_P->inBuffer_P[0],1);
  delay_max(star_P->inBuffer_P[1],1);
  delay_max(star_P->inBuffer_P[2],1);

         
   if(NO_OUTPUT_BUFFERS() != 4 ){
       fprintf(stdout,"%s:4 outputs expected; %d connected\n",
              STAR_NAME,NO_OUTPUT_BUFFERS());
	      return(201);
   }

   SET_CELL_SIZE_OUT(0,sizeof(float));

   SET_CELL_SIZE_OUT(1,sizeof(float));

   SET_CELL_SIZE_OUT(2,sizeof(float));

   SET_CELL_SIZE_OUT(3,sizeof(float));

         
   if(NO_INPUT_BUFFERS() != 3 ){
       fprintf(stdout,"%s:3 inputs expected; %d connected\n",
              STAR_NAME,NO_INPUT_BUFFERS());
	      return(200);
   }

   SET_CELL_SIZE_IN(0,sizeof(float));

   SET_CELL_SIZE_IN(1,sizeof(float));

   SET_CELL_SIZE_IN(2,sizeof(float));

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
		in_r01 = r01(0);
		in_r02 = r02(0);
		if(in_r01 == 0 || in_r02 == 0)
		{
			if(cka(0) == 0.0 && cka(1) == 1.0)
			{
				++ count_val;
				if(count_val == 16) count_val =0;
			}
		}
		else
		{
			count_val = 0;
		}

		if(IT_OUT(0) ) {
			KrnOverflow("sn74ls93",0);
			return(99);
		}
		qa(0) = count_val & 1;
		if(IT_OUT(1) ) {
			KrnOverflow("sn74ls93",1);
			return(99);
		}
		qb(0) = (count_val & 2) >> 1;
		if(IT_OUT(2) ) {
			KrnOverflow("sn74ls93",2);
			return(99);
		}
		qc(0) = (count_val & 4) >> 2;
		if(IT_OUT(3)) {
			KrnOverflow("sn74ls93",3);
			return(99);
		}
		qd(0) = (count_val & 8) >> 3;
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
