 
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

This star produces samples of the outputs every 1/fs seconds.  The dco behaves just	like an FM modulator.  The phase is updated	as theta=theta+lambda (integrates the input)

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 

#include <math.h>


 
#define  PI 3.141592654
#define PIDIV2  1.570796327
#define PI2  6.283185307

/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int  __t;
      float  __theta;
      float  __dt;
      double  __angle;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define t (state_P->__t)
#define theta (state_P->__theta)
#define dt (state_P->__dt)
#define angle (state_P->__angle)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define lambda(DELAY) (*((float  *)PIN(0,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define cout(delay) *(float  *)POUT(0,delay)
#define sout(delay) *(float  *)POUT(1,delay)

/*         
 *    PARAMETER DEFINES 
 */ 
#define fs (param_P[0]->value.f)
#define fo (param_P[1]->value.f)
#define A (param_P[2]->value.f)
/*-------------- BLOCK CODE ---------------*/


dco2 

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
 

	float	lambdax;	


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Sampling Rate";
     char   *ptype0 = "float";
     char   *pval0 = "1.";
     char   *pname0 = "fs";
     char   *pdef1 = "Center Frequency";
     char   *ptype1 = "float";
     char   *pval1 = "1.";
     char   *pname1 = "fo";
     char   *pdef2 = "Amplitude";
     char   *ptype2 = "float";
     char   *pval2 = "1.";
     char   *pname2 = "A";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);

      }
break;
   


/*         
 *    OUTPUT BUFFER SYSTEM  INITS 
 */ 
 case OUTPUT_BUFFER_INIT: 
 {
 int indexOC = block_P->model_index;
     char   *ptypeOut0 = "float";
     char   *pnameOut0 = "cout";
     char   *ptypeOut1 = "float";
     char   *pnameOut1 = "sout";
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
     char   *pnameIn0 = "lambda";
KrnModelConnectionInput(indexIC,0 ,pnameIn0,ptypeIn0);
}
 break;

/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            t=0.;
       theta=0.;
       dt=0;
       angle=0;



         
   if(NO_OUTPUT_BUFFERS() != 2 ){
       fprintf(stdout,"%s:2 outputs expected; %d connected\n",
              STAR_NAME,NO_OUTPUT_BUFFERS());
	      return(201);
   }

   SET_CELL_SIZE_OUT(0,sizeof(float));

   SET_CELL_SIZE_OUT(1,sizeof(float));

         
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

 

	dt = 2.*PI*fo/fs;
	angle= -dt;


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


	while(IT_IN(0))
	{
		if(IT_OUT(0)) {
			KrnOverflow("dco",0);
			return(99);
		}
		if(IT_OUT(1)) {
			KrnOverflow("dco",1);
			return(99);
		}
		
		
		lambdax=lambda(0);
		angle= angle +dt+lambdax;
		angle=fmod(angle,PI2);
		
		

		cout(0)=A*cos((angle));
		sout(0)=A*sin((angle));
		
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
