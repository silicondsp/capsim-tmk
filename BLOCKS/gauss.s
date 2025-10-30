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

gauss 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*gauss.s */
/***************************************************************************
                          gauss()
*****************************************************************************
This block generates  gaussian samples. 
The first parameter, which defaults to NUMBER_SAMPLES_PER_VISIT, tells how many total samples
to send out.
The second parameter is the standard deviation which defaults to one.
The third parameter is the random number seed.
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
	that the block will output. If num_of_samples < 0, an indefinite
	number of samples can be output.
      The block will output a maximum of NUMBER_SAMPLES_PER_VISIT on each call.
If the pace input is connected:
      The num_of_samples parameter sets the maximum number of samples
        that the block will output. If num_samples_out < 0, an infinite
	number of samples can be output.
      The pace input paces the number of output samples on each call.
      At each call of the block all samples are read from the pace input
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
gauss
</NAME>
<DESCRIPTION>
This block generates  gaussian samples. 
The first parameter, which defaults to NUMBER_SAMPLES_PER_VISIT, tells how many total samples
to send out.
The second parameter is the standard deviation which defaults to one.
The third parameter is the random number seed.
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
	that the block will output. If num_of_samples < 0, an indefinite
	number of samples can be output.
      The block will output a maximum of NUMBER_SAMPLES_PER_VISIT on each call.
If the pace input is connected:
      The num_of_samples parameter sets the maximum number of samples
        that the block will output. If num_samples_out < 0, an infinite
	number of samples can be output.
      The pace input paces the number of output samples on each call.
      At each call of the block all samples are read from the pace input
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
</DESCRIPTION>
<PROGRAMMERS>
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This block generates  gaussian samples. 
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
		<NAME>obufs</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>pass</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>char</TYPE>
		<NAME>rand_state[256]</NAME>
	</STATE>
	<STATE>
		<TYPE>double</TYPE>
		<NAME>max</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>overFlowBuffer_A[25]</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>sample_A[25]</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

     int i,j,ok,n;
     int numin;
     int count = 0;
     int trouble;
     double s,t,u,v,w,x;
     float y1,y2;

</DECLARATIONS> 

             

<PARAMETERS>
<PARAM>
	<DEF>total number of samples to output</DEF>
	<TYPE>int</TYPE>
	<NAME>num_of_samples</NAME>
	<VALUE>128</VALUE>
</PARAM>
<PARAM>
	<DEF>Noise Standard Deviation</DEF>
	<TYPE>float</TYPE>
	<NAME>dev</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Seed for random number generator</DEF>
	<TYPE>int</TYPE>
	<NAME>seed</NAME>
	<VALUE>333</VALUE>
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

	if((obufs = NO_OUTPUT_BUFFERS() ) <= 0) {
                fprintf(stderr,"bdata: no output buffers\n");
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
	if (dev < 0.0) {
		fprintf(stderr,"gauss: improper parameter\n");
		return(2);
	}
#ifdef RANDOM_64_BIT	
	init_genrand64((unsigned long long) seed);
#endif

#ifdef RANDOM_32_BIT	
	//init_genrand((unsigned  long) seed);
	
	unsigned long init[4]={0x123, 0x234, 0x345, 0x456}, length=4;
        init_by_array(init, length);
#endif

	//srand48((long int)seed);
	max = m;
       for(j=0; j<obufs; j++)
                        overFlowBuffer_A[j] = FALSE;

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

       /*
	*  generate NUMBER_SAMPLES_PER_VISIT samples, then return 
	*/
        while(samples_out_total < output_target) {

                /* return if all samples have been output */
                if((i += 2) > NUMBER_SAMPLES_PER_VISIT) return(0);
   
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
				fprintf(stderr,"gauss: problem with random number\
					 generator\n");
				return(2);
			}
			/* 
		 	 * get two random numbers in the interval (-1,1) 
		 	 */
#ifdef RANDOM_64_BIT			   
		   s=genrand64_real1();
#endif
#ifdef RANDOM_32_BIT			   
		   s=genrand_real2();
#endif
//fprintf(stderr,"GAUSS: s=%f\n", s);

		      u = -1.0 + 2.0*(s);
		   
		//   t = random();
		//   v = -1.0 + 2.0*(t/max);
		   
		     
#ifdef RANDOM_64_BIT			   
		   t=genrand64_real1();
#endif
#ifdef RANDOM_32_BIT			   
		   t=genrand_real2();
#endif	
//fprintf(stderr,"GAUSS: t=%f\n", t);
			v = -1.0 + 2.0*t;
			w = u*u + v*v;
			/* 
			 * is point (u,v) in the unit circle? 
			 */
		} while (w >= 1.0 || w == 0.0);

		x = sqrt((-2.0 * log(w))/w);
		/* 
		 * find two independent values of y	
		 */
		y1 = dev * u * x;
		y2 = dev * v * x;
	
		/****************** End of Gauss Code ****************************/

		samples_out_total += 2;
		for(j=0; j<obufs; j++) {
		   if(IT_OUT(j)) {
			KrnOverflow("gauss",j);
			return(99);	
		   }
		   OUTF(j,0) = y1;
		}
		for(j=0; j<obufs; j++) {
		   if(IT_OUT(j)) {
			KrnOverflow("gauss",j);
			return(99);	
		   }
		   OUTF(j,0) = y2;
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

