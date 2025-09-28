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

arprocess 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* arprocess.s */
/**********************************************************************
			arprocess()
***********************************************************************
This star generates a selectable number of samples from an AR process,
represented as an IIR filter driven by Gaussian noise.
The order of the process, and the weighting values can be selected,
via array parameter 2.
Maximum order is 10 (since this is max array size).
Parameter 3 selects the variance of the gaussian driving noise.
This star supports auto-fanout.
CONTROL PARAMETERS:
	num_of_samples     = total number of samples to output.
	pace_rate          = multiplies the number of samples received 
			     on pace input (if connected) to determine 
			     how many samples to output.
	samples_first_time = the number of samples to put out on the
			     first call if pace input connected. It can
			     be zero. negative values = 0.
CONTROL DESCRIPTION:
If the pace input is not connected:
      The num_of_samples parameter sets the maximum number of samples
	that the star will output. If num_of_samples < 0, an indefinite
	number of samples can be output.
      The star will output a maximum of NUMBER_SAMPLES_PER_VISIT on each call.
If the pace input is connected:
      The num_of_samples parameter sets the maximum number of samples
        that the star will output. If num_samples_out < 0, an infinite
	number of samples can be output.
      The pace input paces the number of output samples on each call.
      At each call of the star all samples are read from the pace input
	and a running total of how many there have been is kept.
      An output_target  is computed at each pass = pace_input_total *
	pace_rate. If pace_rate < 0, the absolute value is used.
      On the first call:
	output = lesser of (samples_first_time, num_of_samples)
      On subsequent calls:
	output = lesser of (NUMBER_SAMPLES_PER_VISIT, output_target)
	   output_target = samples_first_time +
		 pace_rate * pace_input_total - to that point
      The total number of samples that will be output:
	samples_out_total = lesser of (num_of_samples,
		     samples_first_time + pace_rate * pace_input_total)
<NAME>
arprocess
</NAME>
<DESCRIPTION>
/**********************************************************************
			arprocess()
***********************************************************************
This star generates a selectable number of samples from an AR process,
represented as an IIR filter driven by Gaussian noise.
The order of the process, and the weighting values can be selected,
via array parameter 2.
Maximum order is 10 (since this is max array size).
Parameter 3 selects the variance of the gaussian driving noise.
This star supports auto-fanout.
</DESCRIPTION>
<PROGRAMMERS>
Programmer: L.J. Faber
Date: April, 1988.
</PROGRAMMERS>
*/

]]>
</COMMENTS> 
<DESC_SHORT>
This star generates a selectable number of samples from an AR process represented as an IIR filter driven by Gaussian noise
</DESC_SHORT>

<INCLUDES>
<![CDATA[ 

#include <math.h>
#include "random.h"


]]>
</INCLUDES> 

           

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>outbufs</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>countout</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>dev</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>samples_out_total</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>double</TYPE>
		<NAME>pace_in_total</NAME>
		<VALUE>0.0</VALUE>
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
</STATES>
 
<DECLARATIONS> 

	int i,j;
	float sum;
	int max = 0x7fffffff;
	double s,t,u,v,k,w,x;
	float y1,y2;

</DECLARATIONS> 

             

<PARAMETERS>
<PARAM>
	<DEF>Number of samples to generate</DEF>
	<TYPE>int</TYPE>
	<NAME>num_of_samples</NAME>
	<VALUE>128</VALUE>
</PARAM>
<PARAM>
	<DEF>Array of weights</DEF>
	<TYPE>array</TYPE>
	<NAME>weights</NAME>
	<VALUE></VALUE>
</PARAM>
<PARAM>
	<DEF>Variance of innovations process</DEF>
	<TYPE>float</TYPE>
	<NAME>variance</NAME>
	<VALUE>1.0</VALUE>
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

<PARAM>
	<DEF>Seed</DEF>
	<TYPE>int</TYPE>
	<NAME>seed</NAME>
	<VALUE>333444</VALUE>
</PARAM>


</PARAMETERS>

<INIT_CODE>
<![CDATA[ 

	if((outbufs = NO_OUTPUT_BUFFERS()) < 1 ) {
		fprintf(stderr,"arprocess: no output buffers connected\n");
		return(3);
	}
	if (variance < 0.0 ) {
		fprintf(stderr,"arprocess: improper parameter\n");
		return(1);
	}
#ifdef RANDOM_64_BIT	
	init_genrand64((unsigned long long) seed);
#endif
#ifdef RANDOM_32_BIT	
	init_genrand((unsigned  long) seed);
#endif

	
	/*
	 * pacer code
	 */
        no_inbuf = NO_INPUT_BUFFERS();
        if(no_inbuf == 1)
           output_target = samples_first_time;
        else
           output_target = num_of_samples;
        if(output_target > num_of_samples)
           output_target = num_of_samples;
        if(pace_rate < 0) pace_rate = -pace_rate;
	/*
	 * end pacer code
	 */
fprintf(stderr,"var = %f\n",variance);
 	dev = sqrt(variance);
	SET_DMAX_OUT(0,n_weights);
fprintf(stderr,"dev = %f\n",dev);

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

        if(no_inbuf == 1) {
           while(IT_IN(0))
                pace_in_total += 1.0;
           if(pass == 1) {
                output_target = samples_first_time + (int) (pace_rate *
                                pace_in_total + 0.5);
                if(output_target > num_of_samples && num_of_samples > 0)
                       output_target = num_of_samples;
           }
        }
        pass = 1;

        i = 0;

        while(samples_out_total < output_target) {

                /* return if all samples have been output */
                if(++i > NUMBER_SAMPLES_PER_VISIT) return(0);

		sum = 0;
		for(j=0; j<n_weights; j++)
			sum += weights[j] * OUTF(0,j);
		/* generate driving noise */
	       do {
		   /* get two random numbers in the interval (-1,1) */
		   
		   
		//   s = random();
		//   u = -1.0 + 2.0*(s/max);
#ifdef RANDOM_64_BIT			   
		   s=genrand64_real1();
#endif
#ifdef RANDOM_32_BIT			   
		   s=genrand_real1();
#endif

		      u = -1.0 + 2.0*(s);
		   
		//   t = random();
		//   v = -1.0 + 2.0*(t/max);
		   
		     
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
	
		sum += y1;

		for(j=0; j<outbufs; j++) {
			if(IT_OUT(j)) {
				KrnOverflow("arprocess",j);
				return(99);
			}
			OUTF(j,0) = sum;
		}
                samples_out_total += 1;
	}
	return(0);


]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

