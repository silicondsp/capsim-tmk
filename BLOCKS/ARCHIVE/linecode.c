 
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

This star inputs 0/1 binary data and outputs various line codes (NRZ,Biphase Manchester,2B1Q,RZ-AMI).

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
      float*  __template;
      int  __even;
      int  __oneState;
      int  __numberOutputBuffers;
      float  __sample_A[25];
      int  __overFlowBuffer_A[25];
      int  __overFlowIndex;
      float  __overFlowCodeValue;
      int  __overFlow;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define template (state_P->__template)
#define even (state_P->__even)
#define oneState (state_P->__oneState)
#define numberOutputBuffers (state_P->__numberOutputBuffers)
#define sample_A (state_P->__sample_A)
#define overFlowBuffer_A (state_P->__overFlowBuffer_A)
#define overFlowIndex (state_P->__overFlowIndex)
#define overFlowCodeValue (state_P->__overFlowCodeValue)
#define overFlow (state_P->__overFlow)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define bindata(DELAY) (*((float  *)PIN(0,DELAY)))

/*         
 *    PARAMETER DEFINES 
 */ 
#define code_type (param_P[0]->value.d)
#define smplbd (param_P[1]->value.d)
/*-------------- BLOCK CODE ---------------*/


linecode 

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
 

	int i;
	int j;
	int sign;
	int mag;
	int code_val;
	int no_samples;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Code type:0-Binary(NRZ),1-Biphase(Manchester),2-2B1Q,3-RZ-AMI(Alternate mark inversion)";
     char   *ptype0 = "int";
     char   *pval0 = "0";
     char   *pname0 = "code_type";
     char   *pdef1 = "Samples per baud";
     char   *ptype1 = "int";
     char   *pval1 = "8";
     char   *pname1 = "smplbd";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);

      }
break;
   


/*         
 *    INPUT BUFFER SYSTEM  INITS 
 */ 
 case INPUT_BUFFER_INIT:
 {
 int indexIC = block_P->model_index;
     char   *ptypeIn0 = "float";
     char   *pnameIn0 = "bindata";
KrnModelConnectionInput(indexIC,0 ,pnameIn0,ptypeIn0);
}
 break;

/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            even=1;
       oneState=-1;

  delay_max(star_P->inBuffer_P[0],1);

         
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

 

	if((template = (float*)calloc(smplbd, sizeof(float))) == NULL) {
		fprintf(stderr, "linecode: cannot allocate space\n");
		return(1);
	}
	if((code_type == 0) || (code_type == 3)) {	/* Binary */
		template[0] = 1.;
	}
	else if(code_type == 1) {	/* Biphase */
		if(smplbd%2 != 0) {
			fprintf(stderr,
				"linecode: oversample rate not \
					compatible with code type\n");
			return(1);
		}
		template[0] = -1.;
		template[smplbd/2] = 1.;
	}
	else if(code_type == 2) {	/* 2B1Q */
		template[0] = 1.;
	}
	else {
		fprintf(stderr,"linecode: unrecognized code type\n");
		return(2);
	}
        numberOutputBuffers = NO_OUTPUT_BUFFERS();
	if(numberOutputBuffers == 0) {
                fprintf(stderr,"linecode: no output buffers connected \n");
                return(3);
        }	
	overFlow=FALSE;


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


 for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) {
		IT_IN(0);
		if(code_type == 2) {
			even = ++even % 2;
			if(even) {
				mag = 1;
				if(bindata(0) == bindata(1)) mag = 3;	
				sign = -1;
				if(bindata(0) > 0.5) sign = 1;
			}
			else   continue;
		}
		else if (code_type == 3) {
			if (bindata(0)) {
				oneState = -1*oneState;
				sign = oneState;
				mag = 1.0;
			} else {
				mag = 0.0;
			}
		}
		else 	{	/* other code types */
			mag = 1;
			sign = -1;
			if(bindata(0) > 0.5) sign = 1;
		}

		code_val = sign * mag;
		for(i=0; i<smplbd; i++) {
			if(overFlow) {
			   for(j=overFlowIndex; j<smplbd; j++) {
				if(IT_OUT(0)) {
					KrnOverflow("linecode",0);
					return(99); 
				}
				OUTF(0,0) = overFlowCodeValue * template[j];
				overFlow=FALSE;
			   }
			}
				
			if(IT_OUT(0)) {
				overFlowIndex=i;
				overFlowCodeValue=code_val;
				overFlow=TRUE;
				fprintf(stderr,"linecode: Buffer 0 is full \n");
				return(0);
			}
			OUTF(0,0) = code_val * template[i];
		}
                if( numberOutputBuffers == 2 ) {
			if(IT_OUT(1)) {
				KrnOverflow("linecode",1);
				return(99); 
			}
                        OUTF(1,0) =code_val;
		}
	}


break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

	free(template);


break;
}
return(0);
}
