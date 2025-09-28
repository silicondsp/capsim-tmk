 
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

This star simulates an Ethernet media access unit (MAU or transceiver)

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>


 

#define DC_BIAS	-1.0 	/* DC voltage placed on cox when transmitting */
#define HI_LIMIT 0.0	/* Coax DC limit */
#define LOW_LIMIT -5.0	/* Coax DC LIMIT   */
#define CD_THRESHOLD -1.5	/* Collision detect threshold */
#define SQUELCH 0.175 	/* Transmit squelch threshold */
#define PEAK	0.7	/* Peak ac value on xcvr cable and coax */


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      float  __tone;
      float  __cd0;
      float  __cd1;
      float  __rx0;
      float  __rx1;
      int  __halfBit;
      int  __cdCount;
      float  __cdPole;
      float  __rxPole;
      int  __collision;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define tone (state_P->__tone)
#define cd0 (state_P->__cd0)
#define cd1 (state_P->__cd1)
#define rx0 (state_P->__rx0)
#define rx1 (state_P->__rx1)
#define halfBit (state_P->__halfBit)
#define cdCount (state_P->__cdCount)
#define cdPole (state_P->__cdPole)
#define rxPole (state_P->__rxPole)
#define collision (state_P->__collision)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define in0(DELAY) (*((float  *)PIN(0,DELAY)))
#define in1(DELAY) (*((float  *)PIN(1,DELAY)))
#define tx(DELAY) (*((float  *)PIN(2,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define out0(delay) *(float  *)POUT(0,delay)
#define out1(delay) *(float  *)POUT(1,delay)
#define rx(delay) *(float  *)POUT(2,delay)
#define cd(delay) *(float  *)POUT(3,delay)

/*         
 *    PARAMETER DEFINES 
 */ 
#define bitTime (param_P[0]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

mau 

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
	float	z;
	double fabs();
	float	txData;


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
     char   *pnameOut0 = "out0";
     char   *ptypeOut1 = "float";
     char   *pnameOut1 = "out1";
     char   *ptypeOut2 = "float";
     char   *pnameOut2 = "rx";
     char   *ptypeOut3 = "float";
     char   *pnameOut3 = "cd";
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
     char   *pnameIn0 = "in0";
     char   *ptypeIn1 = "float";
     char   *pnameIn1 = "in1";
     char   *ptypeIn2 = "float";
     char   *pnameIn2 = "tx";
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

 

	collision=0;
	tone=1.0;
	cd0=0.0;
	cd1=0.0;
	cdCount=0;
	halfBit= bitTime >> 1;
	cdPole= 1.0/(8.0*bitTime);
	rxPole= 1.0/(3.0*bitTime);


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


for(numberSamples = MIN_AVAIL(); numberSamples > 0; -- numberSamples) {
	IT_IN(0);
	IT_IN(1);
	IT_IN(2);

	if(IT_OUT(0)) {
			KrnOverflow("mau",0);
			return(99);
	}
	if(IT_OUT(1) ) {
			KrnOverflow("mau",1);
			return(99);
	}
	if(IT_OUT(2) ) {
			KrnOverflow("mau",2);
			return(99);
	}
	if(IT_OUT(3)) {
			KrnOverflow("mau",3);
			return(99);
	}
	
	/*
	 * find dc levels on both sides 
 	 */
	
	rx0= (rxPole * in0(0)) + (1.0-rxPole)*rx0;
	rx1= (rxPole * in1(0)) + (1.0-rxPole)*rx1;
	
	/*
	 * output received network data
	 */
	
	z=tx(0) +(in0(0) - rx0) + (in1(0) - rx1);

	if(z > SQUELCH)
		rx(0) = PEAK;
	else if (z < -1.0 * SQUELCH)
		rx(0) = -1.0* PEAK;
	else
		rx(0) = 0.0;

	if(tx(0) > SQUELCH)
		txData = DC_BIAS + PEAK;
	else if ( tx(0) < ( -1.0 * SQUELCH))
		txData = DC_BIAS - PEAK;
	else
		txData = 0.0;

	/*
	 * Transmit data on medium out side 0
 	 */
	z= in1(0) + txData;
	if( z < LOW_LIMIT)
		out0(0) = LOW_LIMIT;
	else if(z > HI_LIMIT)
		out0(0) = HI_LIMIT;
	else
		out0(0)=z;

	/*
	 * transmit data on medium out side 1
	 */

	z= in0(0) + txData;

	if( z < LOW_LIMIT)
		out1(0) = LOW_LIMIT;
	else if (z > HI_LIMIT)
		out1(0) = HI_LIMIT;
	else
		out1(0)=z;		

	/*
	 * output collision tone
	 */

	cd0 = (cdPole* out0(0)) + (1.0-cdPole) * cd0;
	cd1 = (cdPole* out1(0)) + (1.0-cdPole) * cd1;
	
	if(( cd0 < CD_THRESHOLD ) || ( cd1 < CD_THRESHOLD))
		collision =1;
	else
		collision = 0; 

	if( collision || ( cdCount > 0)) {
		if(cdCount <=0)
			cdCount = bitTime;
		if(cdCount > halfBit)
			cd(0) = PEAK;
		else
			cd(0) = -1.0 * PEAK;
		--cdCount;
	}
	else
		cd(0) = 0.0;
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
