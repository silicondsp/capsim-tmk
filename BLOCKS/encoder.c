 
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

This block  encodes incoming data accoding to the first parameter:NRZ,Manchester,Diff Manchester,Partial Response,AMI,2B1Q,RZ

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>


 

#define NRZ	0
#define MANCHESTER 	1
#define DIFFERENTIAL_MANCHESTER	2
#define PARTIAL_RESPONSE 3
#define AMI	4
#define _2B1Q 5
#define RZ	6


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      float  __sign;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define sign (state_P->__sign)

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
#define codeType (param_P[0]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

encoder 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int	i;
	int	numberSamples;
	float	thisX,thisY,lastX,lastY;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Code Type:0=NRZ,1=manch,2=diff_manch,3=part_resp,4=AMI,5=2B1Q,6=RZ";
     char   *ptype0 = "int";
     char   *pval0 = "0";
     char   *pname0 = "codeType";
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

 

	if(!(codeType >= 0) && (codeType <=6))
	{
		fprintf(stderr,"encoder: code type %d is not allowed",
			codeType);
		return(1);
	}
	sign= -1.0;
	lastX= 0;


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


for(numberSamples = MIN_AVAIL(); numberSamples > 0; -- numberSamples) {
	if(codeType == _2B1Q) {
		if(numberSamples > 1)
			IT_IN(0);
		else
			return(0);
	}
	else 
		IT_IN(0);
	if(x(0) > 0.5) 
		thisX = 1;
	else
		thisX = 0;
	
	switch (codeType) {
		case  NRZ:
			if(IT_OUT(0)) {
				KrnOverflow("encoder",0);
				return(99);
			}
			if(thisX) 
				y(0)= 1.0;
			else
				y(0) = -1.0;
			break;
		case MANCHESTER:
			if(thisX) {
				if(IT_OUT(0)) {
					KrnOverflow("encoder",0);
					return(99);
				}
				y(0)= -1.0;
				if(IT_OUT(0)) {
					KrnOverflow("encoder",0);
					return(99);
				}
				y(0) = 1.0;
			}
			else {
				if(IT_OUT(0)) {
					KrnOverflow("encoder",0);
					return(99);
				}
				y(0)= 1.0;
				if(IT_OUT(0)) {
					KrnOverflow("encoder",0);
					return(99);
				}
				y(0) = -1.0;
			}
			break;
		case DIFFERENTIAL_MANCHESTER:
			if(y(0) > 0.0)
				lastY = 1;
			else
				lastY=0;
			if(thisX) {
				if(lastY) {
					if(IT_OUT(0)) {
						KrnOverflow("encoder",0);
						return(99);
					}
					y(0) = 1.0;
					if(IT_OUT(0)) {
						KrnOverflow("encoder",0);
						return(99);
					}
					y(0) = -1.0;
				}
				else {
					if(IT_OUT(0)) {
						KrnOverflow("encoder",0);
						return(99);
					}
					y(0) = -1.0;
					if(IT_OUT(0)) {
						KrnOverflow("encoder",0);
						return(99);
					}
					y(0) = 1.0;
				}
			}
			else {
				if(lastY) {
					if(IT_OUT(0)) {
						KrnOverflow("encoder",0);
						return(99);
					}
					y(0) = -1.0;
					if(IT_OUT(0)) {
						KrnOverflow("encoder",0);
						return(99);
					}
					y(0) = 1.0;
				}
				else {
					if(IT_OUT(0)) {
						KrnOverflow("encoder",0);
						return(99);
					}
					y(0)= 1.0;
					if(IT_OUT(0)) {
						KrnOverflow("encoder",0);
						return(99);
					}
					y(0) = -1.0;
				}
			}
			break;
		case PARTIAL_RESPONSE:
			if(thisX) {
					if(IT_OUT(0)) {
						KrnOverflow("encoder",0);
						return(99);
					}
				if(lastX) {
					y(0)=0.0;
				}
				else {
					y(0) = 1.0;
				}
			}
			else {
				if(IT_OUT(0)) {
					KrnOverflow("encoder",0);
					return(99);
				}
				if(lastX) {
					y(0) = 0.0;
				}
				else {
					y(0) = 0.0;
				}
			}
			break;
		case AMI:
			if(IT_OUT(0)) {
				KrnOverflow("encoder",0);
				return(99);
			}
			if(thisX) {
				y(0) = sign;
				sign = 0.0 - sign;
			} 
			else {
				y(0) = 0.0;
			}
			break;
		case _2B1Q:
			--numberSamples;
			IT_IN(0);
			if(IT_OUT(0)) {
				KrnOverflow("encoder",0);
				return(99);
			}

			if(thisX) {
				if(x(0) > 0.5) 
					y(0) = 3.0;
				else 
					y(0) = 1.0;
			}
			else {
				if(x(0) > 0.5)
					y(0) = -1.0;
				else
					y(0) = -3.0;
			}
			break;
		case RZ:
			if(IT_OUT(0)) {
				KrnOverflow("encoder",0);
				return(99);
			}
			y(0)= 0.0;
			if(thisX) {
				if(IT_OUT(0)) {
					KrnOverflow("encoder",0);
					return(99);
				}
				y(0) = 1.0;
			}
			else {
				if(IT_OUT(0)) {
					KrnOverflow("encoder",0);
					return(99);
				}
				y(0) = -1.0;
			}
			break;
		
	}
	lastX=thisX;	
			
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
