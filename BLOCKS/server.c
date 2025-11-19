 
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

This block models an M/M/1 queue

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
#define Q_LIMIT	100
#define 	BUSY	1
#define		IDLE	0
#define 	INFINITY	1.0e30
#define 	REQUEST_NUMBER_IN_QUEUE 0
#define		REQUEST_SERVER_STATUS	1


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int  __ibufs;
      int  __obufs;
      long  __seed1;
      long  __seed2;
      int  __nextEventType;
      int  __numberCustomersDelayed;
      int  __numberEvents;
      int  __numberInQ;
      int  __serverStatus;
      float  __areaNumberInQ;
      float  __areaServerStatus;
      float  __meanInterArrival;
      float  __time;
      float  __timeArrival_A[Q_LIMIT+1];
      float  __timeLastEvent;
      float  __timeNextEvent_A[4];
      float  __totalOfDelays;
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
#define numberCustomersDelayed (state_P->__numberCustomersDelayed)
#define numberEvents (state_P->__numberEvents)
#define numberInQ (state_P->__numberInQ)
#define serverStatus (state_P->__serverStatus)
#define areaNumberInQ (state_P->__areaNumberInQ)
#define areaServerStatus (state_P->__areaServerStatus)
#define meanInterArrival (state_P->__meanInterArrival)
#define time (state_P->__time)
#define timeArrival_A (state_P->__timeArrival_A)
#define timeLastEvent (state_P->__timeLastEvent)
#define timeNextEvent_A (state_P->__timeNextEvent_A)
#define totalOfDelays (state_P->__totalOfDelays)
#define first (state_P->__first)

/*         
 *    PARAMETER DEFINES 
 */ 
#define type (param_P[0]->value.d)
#define meanServiceTime (param_P[1]->value.f)
#define expression (param_P[2]->value.s)
#define timeEnd (param_P[3]->value.f)
#define outputRequest (param_P[4]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

server 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int i,j;
	int samples;
	float sampleOut;
	float	x;
	float	arrivalInterval;
	float	minTimeNextEvent;
	float	timeSinceLastEvent;
	float delay;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Type:0=exp,1=gamma";
     char   *ptype0 = "int";
     char   *pval0 = "0";
     char   *pname0 = "type";
     char   *pdef1 = "Mean service time";
     char   *ptype1 = "float";
     char   *pval1 = "0.5";
     char   *pname1 = "meanServiceTime";
     char   *pdef2 = "Expression for random number generator";
     char   *ptype2 = "file";
     char   *pval2 = "anyexpresssion";
     char   *pname2 = "expression";
     char   *pdef3 = "Time to end";
     char   *ptype3 = "float";
     char   *pval3 = "480.0";
     char   *pname3 = "timeEnd";
     char   *pdef4 = "Output Request:0=Number in queue,1=Server Status";
     char   *ptype4 = "int";
     char   *pval4 = "0";
     char   *pname4 = "outputRequest";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);
KrnModelParam(indexModel88,3 ,pdef3,ptype3,pval3,pname3);
KrnModelParam(indexModel88,4 ,pdef4,ptype4,pval4,pname4);

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
		fprintf(stderr,"server: no input buffers\n");
		return(2);
	}
	if((obufs = NO_OUTPUT_BUFFERS()) < 1) {
		fprintf(stderr,"server: no output buffers\n");
		return(3);
	}
	/*
	 * Get seeds from expression
	 */
	phrtsd(expression,&seed1,&seed2);
	fprintf(stderr,"server: seed1=%d seed2=%d\n",seed1,seed2);
	setall(seed1,seed2);
	/*
	 * Specify the number of events for the timing function
	 */
	numberEvents=3;
	time=0.0;
	serverStatus=IDLE;
	numberInQ = 0;
	timeLastEvent=0.0;
	/*
	 * Initialize statistical counters
	 */
	numberCustomersDelayed =0;
	totalOfDelays=0.0;
	areaNumberInQ=0.0;
	areaServerStatus=0.0;
	/*
	 * Initialize event list. Since no customers are present
	 * the departure (service completion) event is eliminated
	 * from consideration. The end-simulation event type (type 3) is 
	 * scheduled for time timeEnd.
	 */
	timeNextEvent_A[1] = time;
	timeNextEvent_A[2] = INFINITY;
	timeNextEvent_A[3]= timeEnd;


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
		arrivalInterval = INF(i,0);
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
	 * Update area under number-in-queue function
	 */
	areaNumberInQ += numberInQ* timeSinceLastEvent;
	
	/*
	 * Update area under server-busy indicator function
	 */
	areaServerStatus += serverStatus *timeSinceLastEvent;

	/*
 	 * End 
 	 *********************************************************/
	
	/*
	 * Invoke the appropriate event function
	 */

	switch (nextEventType) {
		case 1:
			/*
			 * Arrive
			 */
			/*
			 * schedule next arrival
			 */
			timeNextEvent_A[1]= time+arrivalInterval;
			/*
			 * check to see if server is busy
			 */
			if(serverStatus == BUSY) {
				/*
				 * Server is busy, so increment the 
				 * the number of customers in queue
				 */
				++numberInQ;
				/*
			 	 * Check to see if an overflow condition
				 * exists
				 */
				if(numberInQ > Q_LIMIT) {

				   /*
				    * the queue has overflowed
				    */
				   fprintf(stderr,"\nOverflow of array time of arrival ar time %f\n",time);
				   return(6);
				}
				/*
			 	 * there is still room in the queue
				 */
				timeArrival_A[numberInQ]= time;
			}
			else {
				/*
				 * Server is idle, so arriving customer has
				 * a delay of zero
				 */
				delay= 0.0;
				totalOfDelays += delay;
				/*
				 * Incrementthe number of customers delayed
				 * and make server busy
				 */

				++numberCustomersDelayed;
				serverStatus= BUSY;

				/*
				 * Schedule a departure (service completion)
				 */
				timeNextEvent_A[2]= time + genexp(meanServiceTime);
			}
			break;
		case 2:
			/*
			 * Depart
			 */

			/*
			 * Check to see whether the queue is empty
			 */
			if(numberInQ == 0) {
				/*
				 * The queue is empty so make the server
				 * idle and eliminate the  departure
				 * ( service completion )  event from 
				 * consideration
				 */
				 serverStatus = IDLE;
				 timeNextEvent_A[2]= INFINITY;
			}
			else {
				/*
				 * the queue is nonempty, so decrease the 
				 * number of customers in queue
				 */
				--numberInQ;
				/*
				 * compute the delay of the customers delayed
				 * who is beginning service and update the
				 * total delay accumulator
				 */
				delay = time - timeArrival_A[1];
				totalOfDelays += delay;
				
				/*
				 * increment the number of customers delayed
				 * and schedule departure
			 	 */
				++numberCustomersDelayed;
				timeNextEvent_A[2]= time+ genexp(meanServiceTime);
				/*
				 * Move each customer in queue (if any) up
				 * one place
				 */
				for(i=1; i<=numberInQ; ++i) 
					timeArrival_A[i] = timeArrival_A[i+1];
			}
			break;
		case 3:
			/*
			 * report
			 */
			return(0);
			break;
	}
	switch(outputRequest) {
		case REQUEST_SERVER_STATUS:
			sampleOut = serverStatus;
			break;
		case REQUEST_NUMBER_IN_QUEUE:
			sampleOut = numberInQ;
			break;
	}
	if(obufs==1 ) {
		if(IT_OUT(0)) {
			fprintf(stderr,"server: Buffer %d is full\n",0);;
			return(99);
		}
		OUTF(0,0) = sampleOut;
	}
	else if( obufs ==2) {
		if(IT_OUT(0)) {
			fprintf(stderr,"server: Buffer %d is full\n",0);;
			return(99);
		}
		OUTF(0,0) = time;
		if(IT_OUT(1)) {
			fprintf(stderr,"server: Buffer %d is full\n",1);;
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
fprintf(stderr,"Single-server queueing system \n");
fprintf(stderr,"Mean service time %f \n", meanServiceTime);
fprintf(stderr,"\n\nAverage delay in queue %11.3f minutes\n\n",
	totalOfDelays/numberCustomersDelayed);
fprintf(stderr,"Average number in queue %10.3f\n\n",
	areaNumberInQ/time);
fprintf(stderr,"Server utilization %15.3f\n\n",
	areaServerStatus/time);
fprintf(stderr,"Number of delays completed %7d\n",
	numberCustomersDelayed);


break;
}
return(0);
}
