<BLOCK>
<LICENSE>
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
</LICENSE>
<BLOCK_NAME>

server 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* server.s */
/**********************************************************************
			server()
***********************************************************************
This star models an M/M/1 queue
The input buffer is the customer inter arrival times. Thus,
each sample on the input buffer represents the arrival of a customer.
The value of the sample is the customer inter arrival time.
The server places the customer in a queue if necessary and processes the
next available customer.
The server does not need to output anything but we have chosen to output
the current delay in the queue. Thus by connecting the output of
the server star to the plot star, you can observe the delay in the queue
over time. 
Many other output combinations are possible but this star is used to serve
as an example.
The server star implements the C code in "Simulation Modeling and Analysis"
by Averill M. Law and W. David Kelton, Second Edition 1991.
We have included original comments.
The parameters are:
(1) The type of distribution for the server 
(2) The mean service time
(3) An expression for the random number generator seeds.
(4) The time to end the simulation
Notes:
   (1) The simulation will end when there are no more customers.
   However, the simulation can end using parameter 4 as a condition.
   (2) Presently, parameter 1 is ignored and exponential distribution is used.
The input buffers are arbitrary so that in the future multiple customer 
sources may be modeled with a single server.
The number of input buffers is arbitrary and determined at run time.
The number of output buffers is also arbitrary (auto-fanout).
<NAME>
server
</NAME>
<DESCRIPTION>
This star models an M/M/1 queue
The input buffer is the customer inter arrival times. Thus,
each sample on the input buffer represents the arrival of a customer.
The value of the sample is the customer inter arrival time.
The server places the customer in a queue if necessary and processes the
next available customer.
The server does not need to output anything but we have chosen to output
the current delay in the queue. Thus by connecting the output of
the server star to the plot star, you can observe the delay in the queue
over time. 
Many other output combinations are possible but this star is used to serve
as an example.
The server star implements the C code in "Simulation Modeling and Analysis"
by Averill M. Law and W. David Kelton, Second Edition 1991.
We have included original comments.
The parameters are:
(1) The type of distribution for the server 
(2) The mean service time
(3) An expression for the random number generator seeds.
(4) The time to end the simulation
Notes:
   (1) The simulation will end when there are no more customers.
   However, the simulation can end using parameter 4 as a condition.
   (2) Presently, parameter 1 is ignored and exponential distribution is used.
The input buffers are arbitrary so that in the future multiple customer 
sources may be modeled with a single server.
The number of input buffers is arbitrary and determined at run time.
The number of output buffers is also arbitrary (auto-fanout).
</DESCRIPTION>
<PROGRAMMERS>
Programmer: Sasan Ardalan 
Date:	November 6, 1993
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This star models an M/M/1 queue
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 

#include <math.h>
#include <ranlib.h>

]]>
</INCLUDES> 

<DEFINES> 

#define DIST_EXPONENTIAL 0
#define DIST_GAMMA 1
#define DIST_WEIBULL 2
#define Q_LIMIT	100
#define 	BUSY	1
#define		IDLE	0
#define 	INFINITY	1.0e30
#define 	REQUEST_NUMBER_IN_QUEUE 0
#define		REQUEST_SERVER_STATUS	1

</DEFINES> 

                    

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>ibufs</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>obufs</NAME>
	</STATE>
	<STATE>
		<TYPE>long</TYPE>
		<NAME>seed1</NAME>
	</STATE>
	<STATE>
		<TYPE>long</TYPE>
		<NAME>seed2</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>nextEventType</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberCustomersDelayed</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberEvents</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberInQ</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>serverStatus</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>areaNumberInQ</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>areaServerStatus</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>meanInterArrival</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>time</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>timeArrival_A[Q_LIMIT+1]</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>timeLastEvent</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>timeNextEvent_A[4]</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>totalOfDelays</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>first</NAME>
		<VALUE>1</VALUE>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i,j;
	int samples;
	float sampleOut;
	float	x;
	float	arrivalInterval;
	float	minTimeNextEvent;
	float	timeSinceLastEvent;
	float delay;

</DECLARATIONS> 

             

<PARAMETERS>
<PARAM>
	<DEF>Type:0=exp,1=gamma</DEF>
	<TYPE>int</TYPE>
	<NAME>type</NAME>
	<VALUE>0</VALUE>
</PARAM>
<PARAM>
	<DEF>Mean service time</DEF>
	<TYPE>float</TYPE>
	<NAME>meanServiceTime</NAME>
	<VALUE>0.5</VALUE>
</PARAM>
<PARAM>
	<DEF>Expression for random number generator</DEF>
	<TYPE>file</TYPE>
	<NAME>expression</NAME>
	<VALUE>any expresssion</VALUE>
</PARAM>
<PARAM>
	<DEF>Time to end</DEF>
	<TYPE>float</TYPE>
	<NAME>timeEnd</NAME>
	<VALUE>480.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Output Request:0=Number in queue,1=Server Status</DEF>
	<TYPE>int</TYPE>
	<NAME>outputRequest</NAME>
	<VALUE>0</VALUE>
</PARAM>
</PARAMETERS>

<INIT_CODE>
<![CDATA[ 

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

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


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


]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

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

]]>
</WRAPUP_CODE> 



</BLOCK> 

