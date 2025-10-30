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

rangen 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*rangen.s */
/***************************************************************************
                          rangen()
*****************************************************************************
This block generates  random samples. 
The first parameter, which defaults to NUMBER_SAMPLES_PER_VISIT, tells how many total samples
to send out.
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
      The block will output a maximum of NUMBER_SAMPLES on each call.
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
	output = lesser of (NUMBER_SAMPLES, output_target)
	   output_target = samples_first_time +
		 pace_rate * pace_input_total - to that point
      The total number of samples that will be output:
	samples_out_total = lesser of (num_of_samples,
		     samples_first_time + pace_rate * pace_input_total)
<NAME>
rangen
</NAME>
<DESCRIPTION>
This block generates  random samples. 
The first parameter, which defaults to NUMBER_SAMPLES, tells how many total samples
to send out.
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
      The block will output a maximum of NUMBER_SAMPLES on each call.
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
	output = lesser of (NUMBER_SAMPLES, output_target)
	   output_target = samples_first_time +
		 pace_rate * pace_input_total - to that point
      The total number of samples that will be output:
	samples_out_total = lesser of (num_of_samples,
		     samples_first_time + pace_rate * pace_input_total)
</DESCRIPTION>
<PROGRAMMERS>
Sasan Ardalan
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This block generates  random samples. 
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 

#include <math.h>
#include <ranlib.h>

]]>
</INCLUDES> 

<DEFINES> 
#define DIST_NORMAL 0
#define DIST_UNIFORM 1
#define DIST_EXPONENTIAL 2
#define DIST_GAMMA 3
#define DIST_SPIKE 12
#define DIST_RAYLEIGH 2
#define DIST_WEIBULL 3
#define DIST_BETA 7
#define DIST_CHI_SQUARE 8
#define DIST_F 9
#define DIST_BINOMIAL 10
#define DIST_POISSON 11
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
		<TYPE>long</TYPE>
		<NAME>seed1</NAME>
	</STATE>
	<STATE>
		<TYPE>long</TYPE>
		<NAME>seed2</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

     int i,j,ok,n;
     int numin;
     int count = 0;
     float	x;

</DECLARATIONS> 

                 

<PARAMETERS>
<PARAM>
	<DEF>total number of samples to output</DEF>
	<TYPE>int</TYPE>
	<NAME>num_of_samples</NAME>
	<VALUE>128</VALUE>
</PARAM>
<PARAM>
	<DEF>Type:0=normal,1=uniform,2=exp,3=gamma</DEF>
	<TYPE>int</TYPE>
	<NAME>type</NAME>
	<VALUE>0</VALUE>
</PARAM>
<PARAM>
	<DEF>Parameter 1(mean,a,lambda)</DEF>
	<TYPE>float</TYPE>
	<NAME>p1</NAME>
	<VALUE>0.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Parameter 2(std,b)</DEF>
	<TYPE>float</TYPE>
	<NAME>p2</NAME>
	<VALUE>0.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Expression</DEF>
	<TYPE>file</TYPE>
	<NAME>expression</NAME>
	<VALUE>any expresssion</VALUE>
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
                fprintf(stderr,"rangen: no output buffers\n");
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
	/*
	 * Get seeds from expression
	 */
	phrtsd(expression,&seed1,&seed2);
	fprintf(stderr,"genrad: seed1=%d seed2=%d\n",seed1,seed2);
	setall(seed1,seed2);

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

                /* 
		 * return if all samples have been output 
		 */
                if((i += 1) > NUMBER_SAMPLES_PER_VISIT) return(0);
  		/*
		 * generate random deviate
		 */ 
	        switch(type) {
		   case DIST_GAMMA:
			x=gengam(p1,p2);
			break;
		   case DIST_NORMAL:
			x=gennor(p1,p2);
			break;
		   case DIST_UNIFORM:
			x=genunf(p1,p2);
			break;
		   case DIST_EXPONENTIAL:
			x=genexp(p1);
			break;
		}


		samples_out_total += 1;

		/*
		 * output sample auto fan-out
		 */
		for(j=0; j<obufs; j++) {
		   if(IT_OUT(j)) {
			KrnOverflow("rangen",j);
			return(99);	
		   }
		   OUTF(j,0) = x;
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

