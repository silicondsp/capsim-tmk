 
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

This function generates a random sequence of bits, which can be usedto exercise a data transmission system. The early, reference, and late signals are generated with the earlysignal shifted with the positive edge of the input clock. Any degree polynomial can be implemented as specified in a parameter array.

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
      int  __shift_reg;
      int  __no_inbuf;
      int  __no_outbuf;
      float  __fbit_early[100];
      float  __fbit_temp[100];
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define shift_reg (state_P->__shift_reg)
#define no_inbuf (state_P->__no_inbuf)
#define no_outbuf (state_P->__no_outbuf)
#define fbit_early (state_P->__fbit_early)
#define fbit_temp (state_P->__fbit_temp)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define clock(DELAY) (*((float  *)PIN(0,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define early(delay) *(float  *)POUT(0,delay)
#define reference(delay) *(float  *)POUT(1,delay)
#define late(delay) *(float  *)POUT(2,delay)

/*         
 *    PARAMETER DEFINES 
 */ 
#define num_delay (param_P[0]->value.d)
#define shift_length (param_P[1]->value.d)
#define initialize (param_P[2]->value.d)
#define poly ((float*)param_P[3]->value.s)
#define n_poly  (param_P[3]->array_size)
#define hi_level (param_P[4]->value.f)
#define lo_level (param_P[5]->value.f)
/*-------------- BLOCK CODE ---------------*/


pngen2 

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
	int samples;
	int temp_val;
	int kp;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "number of samples to delay each way";
     char   *ptype0 = "int";
     char   *pval0 = "4";
     char   *pname0 = "num_delay";
     char   *pdef1 = "Length of shift register";
     char   *ptype1 = "int";
     char   *pval1 = "7";
     char   *pname1 = "shift_length";
     char   *pdef2 = "Initialization for shift register";
     char   *ptype2 = "int";
     char   *pval2 = "12";
     char   *pname2 = "initialize";
     char   *pdef3 = "Array of polynomial (0 or 1)";
     char   *ptype3 = "array";
     char   *pval3 = "";
     char   *pname3 = "poly";
     char   *pdef4 = "High logic level";
     char   *ptype4 = "float";
     char   *pval4 = "1.0";
     char   *pname4 = "hi_level";
     char   *pdef5 = "Low logic level";
     char   *ptype5 = "float";
     char   *pval5 = "-1.0";
     char   *pname5 = "lo_level";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);
KrnModelParam(indexModel88,3 ,pdef3,ptype3,pval3,pname3);
KrnModelParam(indexModel88,4 ,pdef4,ptype4,pval4,pname4);
KrnModelParam(indexModel88,5 ,pdef5,ptype5,pval5,pname5);

      }
break;
   


/*         
 *    OUTPUT BUFFER SYSTEM  INITS 
 */ 
 case OUTPUT_BUFFER_INIT: 
 {
 int indexOC = block_P->model_index;
     char   *ptypeOut0 = "float";
     char   *pnameOut0 = "early";
     char   *ptypeOut1 = "float";
     char   *pnameOut1 = "reference";
     char   *ptypeOut2 = "float";
     char   *pnameOut2 = "late";
KrnModelConnectionOutput(indexOC,0 ,pnameOut0,ptypeOut0);
KrnModelConnectionOutput(indexOC,1 ,pnameOut1,ptypeOut1);
KrnModelConnectionOutput(indexOC,2 ,pnameOut2,ptypeOut2);
}
 break;

/*         
 *    INPUT BUFFER SYSTEM  INITS 
 */ 
 case INPUT_BUFFER_INIT:
 {
 int indexIC = block_P->model_index;
     char   *ptypeIn0 = "float";
     char   *pnameIn0 = "clock";
KrnModelConnectionInput(indexIC,0 ,pnameIn0,ptypeIn0);
}
 break;

/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
     


         
   if(NO_OUTPUT_BUFFERS() != 3 ){
       fprintf(stdout,"%s:3 outputs expected; %d connected\n",
              STAR_NAME,NO_OUTPUT_BUFFERS());
	      return(201);
   }

   SET_CELL_SIZE_OUT(0,sizeof(float));

   SET_CELL_SIZE_OUT(1,sizeof(float));

   SET_CELL_SIZE_OUT(2,sizeof(float));

         
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

 

	if((no_outbuf = NO_OUTPUT_BUFFERS() ) <= 0) {
		fprintf(stderr,"pngen: no output buffers\n");
		return(1); /* no output buffers */
	}
	shift_reg = initialize;
	for(i=0; i<101; i++)
	{
		fbit_early[i] = 0.0;
	}


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


	for(samples = MIN_AVAIL(); samples > 0; --samples) {

		temp_val = 0;
		IT_IN(0);
		for(i=0; i<2*num_delay; i++)
		{
			fbit_temp[i] = fbit_early[i];
		}

		if(clock(1) == 0.0 && clock(0) == 1.0) {

			for(i=0; i<shift_length; i++)
			{
				kp = poly[i];
				temp_val = temp_val + ((shift_reg >> i) & kp);
			}
			shift_reg = (temp_val % 2) + (shift_reg << 1);
			
			for(j=1; j<2*num_delay; j++)
			{
				fbit_early[j] = fbit_temp[j-1];
			}
			fbit_early[0] = (float) ((shift_reg >> shift_length) & 1);
		}
		else
		{
			for(k=1; k<2*num_delay; k++)
			{
				fbit_early[k] = fbit_temp[k-1];
			}
			fbit_early[0] = fbit_temp[0]; 
		}

		if(IT_OUT(0)) {
			KrnOverflow("pngen2",0);
			return(99);
		}
		if(fbit_early[0] == 0.0)
		{
			early(0) = lo_level;
		}
		else
		{
			early(0) = hi_level;
		}

		if(IT_OUT(1) ) {
			KrnOverflow("pngen2",1);
			return(99);
		}
		if(fbit_early[num_delay - 1] == 0.0)
		{
			reference(0) = lo_level;
		}
		else
		{
			reference(0) = hi_level;
		}

		if(IT_OUT(2)) {
			KrnOverflow("pngen2",2);
			return(99);
		}
		if(fbit_early[2*num_delay-1] == 0.0)
		{
			late(0) = lo_level;
		}
		else
		{
			late(0) = hi_level;
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
