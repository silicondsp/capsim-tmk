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

inventory 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* inventory.s */
/**********************************************************************
			inventory()
***********************************************************************
This star models an inventory system. 
The input buffer is the customer inter arrival times and
product demand. 
The input are complex with the real part equal to the inter arrival time
and the imaginary part equal to the product demand.
The inventory does not need to output anything but we have chosen to output
the inventory level.  Thus by connecting the output of
the inventory star to the plot star, you can observe the inventory level
over time. 
Many other output combinations are possible but this star is used to serve
as an example.
The inventory star implements the C code in "Simulation Modeling and Analysis"
by Averill M. Law and W. David Kelton, Second Edition 1991.
We have included original comments.
The parameters are:
     (1) 	Initial inventory level
     (2) 	Number of months
     (3) 	Set up cost
     (4) 	Incremental  cost
     (5) 	Holding  cost
     (6) 	Shortage  cost
     (7) 	Minimum lag
     (8) 	Maximum lag
     (9) 	Order threshold (s)
     (10) 	Inventory Level  (S)
     (11) 	Expression for random number generator
     (12)	Output Request:0=Inventory Level,1=Demand Size
Notes:
   (1) The simulation will end when there are no more customers.
   However, the simulation can end using parameter 2 as a condition.
The input buffers are arbitrary so that in the future multiple customer 
sources may be modeled with a single inventory.
The number of input buffers is arbitrary and determined at run time.
The number of output buffers is also arbitrary (auto-fanout).
<NAME>
inventory
</NAME>
<DESCRIPTION>
This star models an inventory system. 
The input buffer is the customer inter arrival times and
product demand. 
The input are complex with the real part equal to the inter arrival time
and the imaginary part equal to the product demand.
The inventory does not need to output anything but we have chosen to output
the inventory level.  Thus by connecting the output of
the inventory star to the plot star, you can observe the inventory level
over time. 
Many other output combinations are possible but this star is used to serve
as an example.
The inventory star implements the C code in "Simulation Modeling and Analysis"
by Averill M. Law and W. David Kelton, Second Edition 1991.
We have included original comments.
The parameters are:
     (1) 	Initial inventory level
     (2) 	Number of months
     (3) 	Set up cost
     (4) 	Incremental  cost
     (5) 	Holding  cost
     (6) 	Shortage  cost
     (7) 	Minimum lag
     (8) 	Maximum lag
     (9) 	Order threshold (s)
     (10) 	Inventory Level  (S)
     (11) 	Expression for random number generator
     (12)	Output Request:0=Inventory Level,1=Demand Size
Notes:
   (1) The simulation will end when there are no more customers.
   However, the simulation can end using parameter 2 as a condition.
The input buffers are arbitrary so that in the future multiple customer 
sources may be modeled with a single inventory.
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
This star models an inventory system. 
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
#define 	INFINITY	1.0e30
#define 	REQUEST_INVENTORY_ORDER 1
#define		REQUEST_INVENTORY_LEVEL	0

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
		<NAME>numberEvents</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>inventoryStatus</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>areaHolding</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>areaShortage</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>time</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>timeLastEvent</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>timeNextEvent_A[5]</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>totalOrderingCost</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>inventoryLevel</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>amount</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>first</NAME>
		<VALUE>1</VALUE>
	</STATE>
</STATES>
 
<DECLARATIONS> 

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

</DECLARATIONS> 

                           

<PARAMETERS>
<PARAM>
	<DEF>Initial inventory level</DEF>
	<TYPE>int</TYPE>
	<NAME>initialInventoryLevel</NAME>
	<VALUE>60</VALUE>
</PARAM>
<PARAM>
	<DEF>number of months</DEF>
	<TYPE>int</TYPE>
	<NAME>numberMonths</NAME>
	<VALUE>120</VALUE>
</PARAM>
<PARAM>
	<DEF>set up cost</DEF>
	<TYPE>float</TYPE>
	<NAME>setupCost</NAME>
	<VALUE>32.0</VALUE>
</PARAM>
<PARAM>
	<DEF>incremental  cost</DEF>
	<TYPE>float</TYPE>
	<NAME>incrementalCost</NAME>
	<VALUE>3.0</VALUE>
</PARAM>
<PARAM>
	<DEF>holding  cost</DEF>
	<TYPE>float</TYPE>
	<NAME>holdingCost</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF>shortage  cost</DEF>
	<TYPE>float</TYPE>
	<NAME>shortageCost</NAME>
	<VALUE>5.0</VALUE>
</PARAM>
<PARAM>
	<DEF>minimum lag</DEF>
	<TYPE>float</TYPE>
	<NAME>minLag</NAME>
	<VALUE>0.5</VALUE>
</PARAM>
<PARAM>
	<DEF>maximum lag</DEF>
	<TYPE>float</TYPE>
	<NAME>maxLag</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Order threshold (s)</DEF>
	<TYPE>float</TYPE>
	<NAME>smalls</NAME>
	<VALUE>20.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Inventory Level  (S)</DEF>
	<TYPE>float</TYPE>
	<NAME>bigs</NAME>
	<VALUE>60.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Expression</DEF>
	<TYPE>file</TYPE>
	<NAME>expression</NAME>
	<VALUE>any expresssion</VALUE>
</PARAM>
<PARAM>
	<DEF>Output Request:0=Inventory Level,1=Demand Size</DEF>
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


]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

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

]]>
</WRAPUP_CODE> 



</BLOCK> 

