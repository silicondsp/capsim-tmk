 
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

This star simulates an Ethernet local repeater 

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>


 

#define DC_INIT	-4.0	
#define POLE 0.1
#define IDLE 0	/* idle: no data repeated */
#define LEFT_TO_RIGHT 1	/* Repeat data from left to right */
#define RIGHT_TO_LEFT 2 /* Repeat data from right to left */
#define COLL 3	/* Send jam signal on both sides */
#define JAM 4 	/* Send jam signal on both sides */
#define JAM_LIMIT 10
#define SQUELCH 0.175 	/* Transmit squelch threshold */
#define PEAK	0.7	/* Peak ac value on xcvr cable and coax */


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int  __direction;
      float  __dataLeft;
      float  __dataRight;
      float  __collLeft;
      float  __collRight;
      int  __jamCount;
      int  __bitCount;
      int  __hiState;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define direction (state_P->__direction)
#define dataLeft (state_P->__dataLeft)
#define dataRight (state_P->__dataRight)
#define collLeft (state_P->__collLeft)
#define collRight (state_P->__collRight)
#define jamCount (state_P->__jamCount)
#define bitCount (state_P->__bitCount)
#define hiState (state_P->__hiState)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define inLeft(DELAY) (*((float  *)PIN(0,DELAY)))
#define cdLeft(DELAY) (*((float  *)PIN(1,DELAY)))
#define inRight(DELAY) (*((float  *)PIN(2,DELAY)))
#define cdRight(DELAY) (*((float  *)PIN(3,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define outLeft(delay) *(float  *)POUT(0,delay)
#define outRight(delay) *(float  *)POUT(1,delay)

/*         
 *    PARAMETER DEFINES 
 */ 
#define bitTime (param_P[0]->value.d)
/*-------------- BLOCK CODE ---------------*/


repeater 

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
 

	int	i;
	int	numberSamples;
	double fabs();


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "The width of a bit in samples";
     char   *ptype0 = "int";
     char   *pval0 = "8";
     char   *pname0 = "bitTime";
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
     char   *pnameOut0 = "outLeft";
     char   *ptypeOut1 = "float";
     char   *pnameOut1 = "outRight";
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
     char   *pnameIn0 = "inLeft";
     char   *ptypeIn1 = "float";
     char   *pnameIn1 = "cdLeft";
     char   *ptypeIn2 = "float";
     char   *pnameIn2 = "inRight";
     char   *ptypeIn3 = "float";
     char   *pnameIn3 = "cdRight";
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

 

	direction = IDLE;
	dataLeft=0.0;
	dataRight = 0.0;
	collRight =0.0;
	collLeft = 0.0;
	jamCount = 0;
	bitCount = 0;
	hiState=0;


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


for(numberSamples = MIN_AVAIL(); numberSamples > 0; -- numberSamples) {
	IT_IN(0);
	IT_IN(1);
	IT_IN(2);
	IT_IN(3);

	if(IT_OUT(0)) {
		KrnOverflow("repeater",0);
		return(99);
	}
	if(IT_OUT(1)) {
		KrnOverflow("repeater",1);
		return(99);
	}

	dataLeft = (1.0-POLE)*dataLeft + POLE*fabs(inLeft(0));
	dataRight = (1.0-POLE)*dataRight + POLE*fabs(inRight(0));
	
	collLeft = (1.0-POLE)*collLeft + POLE*fabs(cdLeft(0));
	collRight = (1.0-POLE)*collRight + POLE*fabs(cdRight(0));

	switch(direction) {
		case IDLE:
			if(dataLeft > SQUELCH)
				direction = LEFT_TO_RIGHT;
			else if (dataRight > SQUELCH)
				direction = RIGHT_TO_LEFT;
			else if ((collLeft > SQUELCH) || (collRight > SQUELCH))
				direction = COLL;
			outLeft(0) = 0.0;
			outRight(0) = 0.0;
			break;

		case LEFT_TO_RIGHT:
			if (dataLeft <= SQUELCH) {
				direction = IDLE;
				outRight(0) =0.0;
			} else {
				/*
				 * Repeat data from left to right 
				 */
				if ( inLeft(0) > 0.0 ) 
					outRight(0) = PEAK;
				else
					outRight(0) = -1.0 * PEAK;
			}
			/*
			 * Squelch data from right to left
			 */
			outLeft(0) = 0.0;

			if(( collLeft > SQUELCH ) || ( collRight > SQUELCH))
				direction = COLL;
			break;
			
		case RIGHT_TO_LEFT:
			if ( dataRight <= SQUELCH) {
				direction=IDLE;
				outLeft(0) = 0.0;
			}
			else {
				/*
				 * Repeat data from right to left 
				 */

				if( inRight(0) > 0.0 )
					outLeft(0) = PEAK;
				else
					outLeft(0) = -1.0*PEAK;
			}
			
			/*
			 * Squelch data from left to right
			 */
			outRight(0) = 0.0;
			if((collLeft > SQUELCH ) || ( collRight > SQUELCH))
				direction= COLL;
			break;

		case COLL:

			if (hiState) {
				if( bitCount < bitTime) {
					outLeft(0) = PEAK;
					outRight(0) = PEAK;
				}
				else {
					hiState = 0;
					bitCount = 0;
					outLeft(0) = -1.0*PEAK;
					outRight(0) = -1.0*PEAK;
				}
			}
			else {
				if(bitCount < bitTime) {
					outLeft(0) = -1.0 * PEAK;
					outRight(0) = -1.0 * PEAK;
				}
				else {

					hiState =1;
					bitCount = 0;
					outLeft(0) = PEAK;
					outRight(0) = PEAK;
				}
			}
			++bitCount;
			if(( collLeft < SQUELCH) && (collRight < SQUELCH)) {
				jamCount =0;
				direction = JAM;
			}
		case JAM:
			if(hiState) {
				if (bitCount < bitTime ) {
					outLeft(0) = PEAK;
					outRight(0) = PEAK;
				}
				else {
					hiState = 0;
					bitCount = 0;
					outLeft(0) = -1.0*PEAK;
					outRight(0) = -1.0*PEAK;
				}
			}
			else {
				if( bitCount < bitTime) {
					outLeft(0) = -1.0*PEAK;
					outRight(0) = -1.0*PEAK;
				}
				else {
					hiState = 1;
					bitCount = 0;
					outLeft(0) = PEAK;
					outRight(0) = PEAK;
					++jamCount;
				}
			}
			++bitCount;
			if((collLeft > SQUELCH ) || (collRight > SQUELCH)) {
				jamCount = 0;
				direction = COLL;
			}
			else if ( jamCount > JAM_LIMIT) {
				direction = IDLE;
				jamCount = 0;
			}
			break;
		default:
			fprintf(stderr,"Repeater in illegal state %i ",direction);
			return(1);
			break;
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
