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
<BLOCK_NAME>addnoise</BLOCK_NAME> 

<COMMENTS> 

/**********************************************************************
		addnoise.s 	
************************************************************************
<BLOCK_NAME>
addnoise
</BLOCK_NAME>
<DESCRIPTION>
This star adds white gaussian noise to the input data stream.
Param. 1 (float) sets the power of the added noise and should be >= 0. 
Param. 2 (int) sets a seed for the random number generator.  Random
sequences can be unique and repeatable for each instance of this star.
</DESCRIPTION>
<PROGRAMMERS>
Programmer: 	L. James Faber
Date:		November, 1987
Modified:	November 3, 1987
Mods:		ljfaber, 12/87
</PROGRAMMERS>
*/

</COMMENTS> 

<DESC_SHORT>
Adds gaussian noise to the input buffer.
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 

#include <math.h>
#include "random.h"

]]>
</INCLUDES> 

<DEFINES> 

#define m 0x7fffffff

</DEFINES> 

     

<STATES>
	<STATE>
		<TYPE>char</TYPE>
		<NAME>rand_state[256]</NAME>
	</STATE>
	<STATE>
		<TYPE>double</TYPE>
		<NAME>max</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>dev</NAME>
		<VALUE>sqrt(fabs(power))</VALUE>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i,j,ok;
	int numin;
	int count = 0;
	int trouble;
	double s,t,u,v,k,w,x;
	float y1,y2;

</DECLARATIONS> 

       

<PARAMETERS>
<PARAM>
	<DEF>Noise power</DEF>
	<TYPE>float</TYPE>
	<NAME>power</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Seed for random number generator</DEF>
	<TYPE>int</TYPE>
	<NAME>seed</NAME>
	<VALUE>333</VALUE>
</PARAM>
</PARAMETERS>

    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>inp</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
    

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>out</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

	if (power < 0.0) {
		fprintf(stderr,"addnoise: improper parameter\n");
		return(2);
	}
#ifdef RANDOM_32_BIT
	init_genrand((unsigned  long) seed);
#endif
#ifdef RANDOM_64_BIT
	init_genrand64((unsigned long long) seed);
#endif
	//srandom(seed);
	max = m;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

	if ((numin = AVAIL(0)) > 0) {
		while(count < numin) {

/****************************************************************/
/* 		gauss						*/
/* code written by Prayson Pate					*/
/* This code generates two random variables that are normally 	*/
/* distributed with mean 0 and variance 1 i.e N(0,1).	 	*/
/* The polar method is used to generate normally distributed    */
/* samples from a sequence that is uniform on (-1,1).  The      */
/* resulting distribution is described exactly by N(0,1).       */
/* This method is based	on the inverse distribution function.   */
/****************************************************************/
	trouble = 0;
	do {
		if(++trouble > 100) {
			fprintf(stderr,"addnoise: problem with random number generator\n");
			return(2);
		}
		/* get two random numbers in the interval (-1,1) */
		//s = random();
		//u = -1.0 + 2.0*(s/max);
		
#ifdef RANDOM_64_BIT
		 s=genrand64_real1();
#endif
#ifdef RANDOM_32_BIT
		 s=genrand_real1();
#endif
		 u = -1.0 + 2.0*(s);
		 
		// t = random();
		// v = -1.0 + 2.0*(t/max);
#ifdef RANDOM_64_BIT		
		 t=genrand64_real1();
#endif
#ifdef RANDOM_32_BIT
		 t=genrand_real1();
#endif
		v = -1.0 + 2.0*(t);
		w = u*u + v*v;
		/* is point (u,v) in the unit circle? */
	} while (w >= 1.0 || w == 0.0);

	x = sqrt((-2.0 * log(w))/w);
	/* find two independent values of y	*/
	y1 = dev * u * x;
	y2 = dev * v * x;
	
/****************** End of Gauss Code ****************************/

		IT_IN(0);
		if(IT_OUT(0)) {
			fprintf(stderr,"addnoise buffer 0 overflow\n");
			return(99);
		}
		out(0) = inp(0) + y1;
		++count;
		if(count < numin) {
			IT_IN(0);
			if(IT_OUT(0)){
				fprintf(stderr,"addnoise buffer 0 overflow\n");
				return(99);
			}
			out(0) = inp(0) + y2;
			++count;
		}
	}
	}

	return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

