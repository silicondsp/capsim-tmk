 
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

This star models an inventory system. 

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 

#include <math.h>
#include <ranlib.h>


 

#define DIST_EXPONENTIAL 0
#define DIST_GAMMA 1
#define DIST_WEIBULL 2
#define 	INFINITY	1.0e30
#define 	REQUEST_INVENTORY_ORDER 1
#define		REQUEST_INVENTORY_LEVEL	0


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int  __ibufs;
      int  __obufs;
      long  __seed1;
      long  __seed2;
      int  __nextEventType;
      int  __numberEvents;
      int  __inventoryStatus;
      float  __areaHolding;
      float  __areaShortage;
      float  __time;
      float  __timeLastEvent;
      float  __timeNextEvent_A[5];
      float  __totalOrderingCost;
      int  __inventoryLevel;
      int  __amount;
      int  __first;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define ibufs (state_P->__ibufs)
#define obufs (state_P->__obufs)
#define seed1 (state_P->__seed1)
#define seed2 (state_P->__seed2)
#define nextEventType (state_P->__nextEventType)
#define numberEvents (state_P->__numberEvents)
#define inventoryStatus (state_P->__inventoryStatus)
#define areaHolding (state_P->__areaHolding)
#define areaShortage (state_P->__areaShortage)
#define time (state_P->__time)
#define timeLastEvent (state_P->__timeLastEvent)
#define timeNextEvent_A (state_P->__timeNextEvent_A)
#define totalOrderingCost (state_P->__totalOrderingCost)
#define inventoryLevel (state_P->__inventoryLevel)
#define amount (state_P->__amount)
#define first (state_P->__first)

/*         
 *    PARAMETER DEFINES 
 */ 
#define initialInventoryLevel (param_P[0]->value.d)
#define numberMonths (param_P[1]->value.d)
#define setupCost (param_P[2]->value.f)
#define incrementalCost (param_P[3]->value.f)
#define holdingCost (param_P[4]->value.f)
#define shortageCost (param_P[5]->value.f)
#define minLag (param_P[6]->value.f)
#define maxLag (param_P[7]->value.f)
#define smalls (param_P[8]->value.f)
#define bigs (param_P[9]->value.f)
#define expression (param_P[10]->value.s)
#define outputRequest (param_P[11]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

inventory 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int 	i,j;
	int 	samples;
	float 	sampleOut;
	float	x;
	float	arrivalInterval;
	float	minTimeNextEvent;
	float	timeSinceLastEvent;
	float	averageOrderingCost;
	float	averageHoldingCost;
	float	averageShortageCost;
	float 	delay;
	float	demandSize;
	complex sampIn;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Initial inventory level";
     char   *ptype0 = "int";
     char   *pval0 = "60";
     char   *pname0 = "initialInventoryLevel";
     char   *pdef1 = "number of months";
     char   *ptype1 = "int";
     char   *pval1 = "120";
     char   *pname1 = "numberMonths";
     char   *pdef2 = "set up cost";
     char   *ptype2 = "float";
     char   *pval2 = "32.0";
     char   *pname2 = "setupCost";
     char   *pdef3 = "incremental  cost";
     char   *ptype3 = "float";
     char   *pval3 = "3.0";
     char   *pname3 = "incrementalCost";
     char   *pdef4 = "holding  cost";
     char   *ptype4 = "float";
     char   *pval4 = "1.0";
     char   *pname4 = "holdingCost";
     char   *pdef5 = "shortage  cost";
     char   *ptype5 = "float";
     char   *pval5 = "5.0";
     char   *pname5 = "shortageCost";
     char   *pdef6 = "minimum lag";
     char   *ptype6 = "float";
     char   *pval6 = "0.5";
     char   *pname6 = "minLag";
     char   *pdef7 = "maximum lag";
     char   *ptype7 = "float";
     char   *pval7 = "1.0";
     char   *pname7 = "maxLag";
     char   *pdef8 = "Order threshold (s)";
     char   *ptype8 = "float";
     char   *pval8 = "20.0";
     char   *pname8 = "smalls";
     char   *pdef9 = "Inventory Level  (S)";
     char   *ptype9 = "float";
     char   *pval9 = "60.0";
     char   *pname9 = "bigs";
     char   *pdef10 = "Expression";
     char   *ptype10 = "file";
     char   *pval10 = "anyexpresssion";
     char   *pname10 = "expression";
     char   *pdef11 = "Output Request:0=Inventory Level,1=Demand Size";
     char   *ptype11 = "int";
     char   *pval11 = "0";
     char   *pname11 = "outputRequest";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);
KrnModelParam(indexModel88,3 ,pdef3,ptype3,pval3,pname3);
KrnModelParam(indexModel88,4 ,pdef4,ptype4,pval4,pname4);
KrnModelParam(indexModel88,5 ,pdef5,ptype5,pval5,pname5);
KrnModelParam(indexModel88,6 ,pdef6,ptype6,pval6,pname6);
KrnModelParam(indexModel88,7 ,pdef7,ptype7,pval7,pname7);
KrnModelParam(indexModel88,8 ,pdef8,ptype8,pval8,pname8);
KrnModelParam(indexModel88,9 ,pdef9,ptype9,pval9,pname9);
KrnModelParam(indexModel88,10 ,pdef10,ptype10,pval10,pname10);
KrnModelParam(indexModel88,11 ,pdef11,ptype11,pval11,pname11);

      }
break;
   


/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            first=1;

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

	/* 
	 * store as state the number of input/output buffers 
	 */
	if((ibufs = NO_INPUT_BUFFERS()) < 1) {
		fprintf(stderr,"inventory: no input buffers\n");
		return(2);
	}
        for (i=0; i<ibufs; i++)
                SET_CELL_SIZE_IN(i,sizeof(complex));
	if((obufs = NO_OUTPUT_BUFFERS()) < 1) {
		fprintf(stderr,"inventory: no output buffers\n");
		return(3);
	}
	/*
	 * Get seeds from expression
	 */
	phrtsd(expression,&seed1,&seed2);
	setall(seed1,seed2);
	/*
	 * Specify the number of events for the timing function
	 */
	numberEvents=4;
	time=0.0;
	inventoryLevel = initialInventoryLevel;
	timeLastEvent=0.0;
	/*
	 * Initialize statistical counters
	 */
	totalOrderingCost=0.0;
	areaHolding=0.0;
	areaShortage=0.0;
	/*
	 * Initialize event list. Since no order is outstanding 
	 * the order-arrival event is eliminated
	 * from consideration. 
	 */
	timeNextEvent_A[1] = INFINITY;
	timeNextEvent_A[2] = time;
	timeNextEvent_A[3]= numberMonths;
	timeNextEvent_A[4]= 0.0;


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


/* 
 * read one sample from each input buffer 
 */
for(samples = MIN_AVAIL(); samples >0; --samples) {

	/*
 	 * get a customer and arrival interval
	 * from input buffer 
	 */
	for(i=0; i<ibufs; ++i) {
		IT_IN(i);
		sampIn=INCX(i,0);
		arrivalInterval = sampIn.re;
		demandSize = sampIn.im;
	}
	if(first ) timeNextEvent_A[1] += arrivalInterval;
	first=0; 


	/*********************************************************
	 * Timing
	 */
	
	nextEventType=0;
	minTimeNextEvent = 1.0e29;
	/*
 	 * Determine the event type of the next event to occur
	 */
	for(i=1; i<= numberEvents; ++i) {
		if(timeNextEvent_A[i] < minTimeNextEvent) {
			minTimeNextEvent = timeNextEvent_A[i];
			nextEventType =i;
		}
	}	
	/*
	 * Check to see if the event list is empty
	 */

	if(nextEventType == 0) {
		/*
		 * the event list is empty, so stop the simulation
		 */
		fprintf(stderr,"\nEvent list empty at time %f", time);
		return(0);
	}
	/*
	 * the event list is not empty, so advance the simulation clock
	 */
	time = minTimeNextEvent;

	/*
 	 * End 
 	 *********************************************************/




	/**********************************************************
	 * Update time-average statistical accumulators
	 */

	
	/*
	 * Compute time since last event, and update last-event-time marker
	 */
	timeSinceLastEvent = time-timeLastEvent;
	timeLastEvent =time;

	/*
	 * Determine the status of the inventory level during the previous
	 * interval. If the inventory level during the previous interval 
	 * was negative, update area_shortage. If it was positive, update
	 * area_holding. If it was zero, no update is needed.
	 */
	if(inventoryLevel <0 )
		areaShortage -= inventoryLevel *timeSinceLastEvent;
	else if(inventoryLevel > 0)
		areaHolding += inventoryLevel* timeSinceLastEvent;
	

	/*
 	 * End 
 	 *********************************************************/
	
	/*
	 * Invoke the appropriate event function
	 */

	switch (nextEventType) {
		case 1:
			/*
			 * Ordere Arrival
			 */
			/*
			 * Increment the inventory level by the amount ordered 
			 */
			inventoryLevel += amount;
			/*
			 * Since no order is now outstanding, eliminate the 
			 * order arrival from consideration
			 */
			timeNextEvent_A[1] = INFINITY;
			break;
		case 2:
			/*
			 * Demand
			 */

			/*
			 * Decrement the inventory level by the demand size 
			 */
			inventoryLevel -= demandSize;
			/*
			 * Schedule the time of the next demand
			 */
			timeNextEvent_A[2] = time +arrivalInterval;
			break;
		case 3:
			/*
			 * report
			 */
			return(0);
			break;
		case 4:
			/*
			 * Evaluate
			 */
			/*
			 * Check whether the inventory level is less than 
			 * smalls.
			 */
			if(inventoryLevel < smalls) {
				/*
				 * The inventory level is less than smalls
				 * So place an order for the appropriate 
				 * amount.
				 */
				amount = bigs -inventoryLevel;
				totalOrderingCost += setupCost + 
						incrementalCost*amount;
				/*
				 * Schedule the arrival of the order
				 */
				timeNextEvent_A[1] = time +
						genunf(minLag,maxLag);
			}
			/*
			 * Regardless of the place-order decision, schedule
			 * the next inventory evaluation
			 */
			timeNextEvent_A[4]= time +1.0;
			break;
	}
	switch(outputRequest) {
		case REQUEST_INVENTORY_LEVEL:
			sampleOut = inventoryLevel;
			break;
		case REQUEST_INVENTORY_ORDER:
			sampleOut = demandSize;
			break;
	}
	if(obufs==1 ) {
		if(IT_OUT(0)) {
			fprintf(stderr,"inventory: Buffer %d is full\n",0);;
			return(99);
		}
		OUTF(0,0) = sampleOut;
	}
	else if( obufs ==2) {
		if(IT_OUT(0)) {
			fprintf(stderr,"inventory: Buffer %d is full\n",0);;
			return(99);
		}
		OUTF(0,0) = time;
		if(IT_OUT(1)) {
			fprintf(stderr,"inventory: Buffer %d is full\n",1);;
			return(99);
		}
		OUTF(1,0) = sampleOut;


	}
}

return(0);	/* at least one input buffer empty */



break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

/*
 * Report results
 */
fprintf(stderr,"\n\nSingle product inventory system. \n");
fprintf(stderr,"Initial inventory level %d items \n", initialInventoryLevel);
fprintf(stderr,"Delivery lag ranges %f %f  \n", minLag,maxLag);
fprintf(stderr,"Length of the simulation %d months  \n", numberMonths);
fprintf(stderr,"Setup Cost: %f Incremental Cost: %f Holding Cost : %f Shortage Cost: %f\n", 
			setupCost,incrementalCost, holdingCost,shortageCost);
averageOrderingCost = totalOrderingCost/numberMonths;
averageHoldingCost = holdingCost*areaHolding/numberMonths;
averageShortageCost = shortageCost *areaShortage/numberMonths;
fprintf(stderr,"\n\n(S,s) (%f,%f)  \n", bigs,smalls);
fprintf(stderr,"Total Average Cost: %f\n", averageOrderingCost+averageHoldingCost+averageShortageCost);
fprintf(stderr,"Average Ordering Cost: %f\n", averageOrderingCost);
fprintf(stderr,"Average Holding Cost: %f\n", averageHoldingCost);
fprintf(stderr,"Average Shortage Cost: %f\n", averageShortageCost);


break;
}
return(0);
}
