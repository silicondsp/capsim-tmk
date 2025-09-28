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

target 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*
 	target.s:	this simulates target range measurements
 			from a track-while-scan radar 
 	parameters:	cv - closing velocity in knots
 			initial_range - initial range in nautical miles
 			sdf - standard deviation in feet
 			num_of_samples - number of samples
 			ts - sampling interval in milliseconds
 			pd - data probability
			seed - random number seed
 	inputs:		none
 	outputs:	range measurements
 	description:	This star generates range measurements from
 			a track-while-scan radar with measurement
 			uncertainty.  If there is a missed range
 			value a "0" is output.
 			written by Ray Kassel
			August 13, 1990 
<NAME>
target
</NAME>
<DESCRIPTION>
This star generates range measurements from
 			a track-while-scan radar with measurement
 			uncertainty.  If there is a missed range
 			value a "0" is output.
</DESCRIPTION>
<PROGRAMMERS>
			written by Ray Kassel
			August 13, 1990 
</PROGRAMMERS>
 */

]]>
</COMMENTS> 



<INCLUDES>
<![CDATA[ 

#include <math.h>
#include "random.h"

]]>
</INCLUDES> 



<DESC_SHORT>
This simulates target range measurements from a track-while-scan radar
</DESC_SHORT>



<DEFINES> 

#define m 0x7fffffff
#define pi 3.1415926

</DEFINES> 

           

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>samples_out</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>double</TYPE>
		<NAME>pace_in_total</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>output_target</NAME>
		<VALUE>NUMBER_SAMPLES_PER_VISIT</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>no_inbuf</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>no_outbuf</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>pass</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>xm[10000]</NAME>
	</STATE>
	<STATE>
		<TYPE>char</TYPE>
		<NAME>rand_state[256]</NAME>
	</STATE>
	<STATE>
		<TYPE>double</TYPE>
		<NAME>max</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i,j,k;
	float tdel;
	double sd,yn,zn,ynr,znc,zns,u;

</DECLARATIONS> 

                     

<PARAMETERS>
<PARAM>
	<DEF>closing velocity (knots)</DEF>
	<TYPE>float</TYPE>
	<NAME>cv</NAME>
	<VALUE>-600.0</VALUE>
</PARAM>
<PARAM>
	<DEF>initial range (nautical miles)</DEF>
	<TYPE>float</TYPE>
	<NAME>initial_range</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF>standard deviation (feet)</DEF>
	<TYPE>float</TYPE>
	<NAME>sdf</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF>number of samples</DEF>
	<TYPE>int</TYPE>
	<NAME>num_of_samples</NAME>
	<VALUE>128</VALUE>
</PARAM>
<PARAM>
	<DEF>interval (msec)</DEF>
	<TYPE>float</TYPE>
	<NAME>ts</NAME>
	<VALUE>10.0</VALUE>
</PARAM>
<PARAM>
	<DEF>data probability</DEF>
	<TYPE>float</TYPE>
	<NAME>pd</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF>random number seed</DEF>
	<TYPE>int</TYPE>
	<NAME>seed</NAME>
	<VALUE>1287</VALUE>
</PARAM>
<PARAM>
	<DEF>pace rate to determine how many samples to output</DEF>
	<TYPE>float</TYPE>
	<NAME>pace_rate</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF>number of samples on the first call if paced</DEF>
	<TYPE>int</TYPE>
	<NAME>samples_first_time</NAME>
	<VALUE>128</VALUE>
</PARAM>
</PARAMETERS>

<INIT_CODE>
<![CDATA[ 

	if((no_outbuf = NO_OUTPUT_BUFFERS() ) <= 0)  {
		fprintf(stderr,"target: no output buffers\n");
		return(1); /* no output buffers */
	}
	no_inbuf = NO_INPUT_BUFFERS();
	if(no_inbuf == 1)
		output_target = samples_first_time;
	else
		output_target = num_of_samples;
	if(output_target > num_of_samples)
		output_target = num_of_samples;
	if(pace_rate < 0) pace_rate = -pace_rate;
	tdel = ts*0.001;
	xm[0] = initial_range;
	sd = sdf/6076.0;
#ifdef RANDOM_64_BIT
	init_genrand64((unsigned long long) seed);
#endif

#ifdef RANDOM_32_BIT
	init_genrand32((unsigned long long) seed);
#endif
//	srandom(seed);
	max = m;
	
	
	
	for(k=1; k<num_of_samples; k++)  xm[k] = xm[k-1] + cv*tdel/3600.0;
	for(k=0; k<num_of_samples-2; k=k+2)  {
	
	
	//	yn = random()/max;
	//	zn = random()/max;
#ifdef RANDOM_64_BIT		
		 yn=genrand64_real1();
		 zn=genrand64_real1();
#endif
#ifdef RANDOM_32_BIT		
		 yn=genrand_real1();
		 zn=genrand_real1();
#endif

		
		ynr = -2.0*log(yn);
		znc = cos(2.0*pi*zn);
		zns = sin(2.0*pi*zn);
		xm[k] += sd*sqrt(ynr)*znc;
		xm[k+1] += sd*sqrt(ynr)*zns;
	}
	for(k=0; k<num_of_samples; k++)  {
	//	u = random()/max;
	
#ifdef RANDOM_64_BIT		
		 u=genrand64_real1();
#endif
#ifdef RANDOM_32_BIT		
		 u=genrand_real1();
#endif	
	
	//	u=genrand64_real1();
		
		
		if(u > pd)  xm[k] = 0.0;
	}

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

	if(no_inbuf == 1)  {
		while(IT_IN(0))
			pace_in_total += 1.0;
		if(pass == 1)  {
			output_target = samples_first_time + (int) (pace_rate *
					pace_in_total + 0.5);
			if(output_target > num_of_samples && num_of_samples > 0)
				output_target = num_of_samples;
		}
	}
	pass = 1;
	i = 0;

	while(samples_out < output_target)  {

		if(++i > NUMBER_SAMPLES_PER_VISIT) return(0);

		for(j=0; j<no_outbuf; j++)  {

				if(IT_OUT(j)) {
					KrnOverflow("target",j);
					return(99);
				}
				OUTF(j,0) = xm[samples_out];
		}
		samples_out += 1;
	}
	return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

