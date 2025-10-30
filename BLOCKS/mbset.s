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

mbset 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* mbset.s */
/**********************************************************************
                mbset()
***********************************************************************
Gives one outputs for Mandelbrot Set
Input parameters:
	min_x: minimum x value
	max_x: maximum x value
	min_y: minimum y value
	max_y: maximum y value
	max_iterate: maximum number of iterations
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
mbset
</NAME>
<DESCRIPTION>
Gives one outputs for Mandelbrot Set
Input parameters:
	min_x: minimum x value
	max_x: maximum x value
	min_y: minimum y value
	max_y: maximum y value
	max_iterate: maximum number of iterations
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
Gives one outputs for Mandelbrot Set
</DESC_SHORT>


<DEFINES> 

#define OUT_SAMPLES NUMBER_SAMPLES_PER_VISIT 

</DEFINES> 

              

<STATES>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>differ_x</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>differ_y</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>increment_x</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>increment_y</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>x_val</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>y_val</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>samples_out</NAME>
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

	int i,j,k,k2;
	float temp_x;
	float temp_y;
	float sqr_temp_x;
	float sqr_temp_y;
	float cutoff;

</DECLARATIONS> 

                     

<PARAMETERS>
<PARAM>
	<DEF>number of points in each direction</DEF>
	<TYPE>int</TYPE>
	<NAME>num_of_points</NAME>
	<VALUE>100</VALUE>
</PARAM>
<PARAM>
	<DEF>total number of samples</DEF>
	<TYPE>int</TYPE>
	<NAME>num_of_samples</NAME>
	<VALUE>10000</VALUE>
</PARAM>
<PARAM>
	<DEF>minimum x value</DEF>
	<TYPE>float</TYPE>
	<NAME>min_x</NAME>
	<VALUE>-2.0</VALUE>
</PARAM>
<PARAM>
	<DEF>maximum x value</DEF>
	<TYPE>float</TYPE>
	<NAME>max_x</NAME>
	<VALUE>2.0</VALUE>
</PARAM>
<PARAM>
	<DEF>minimum y value</DEF>
	<TYPE>float</TYPE>
	<NAME>min_y</NAME>
	<VALUE>-2.0</VALUE>
</PARAM>
<PARAM>
	<DEF>maximum y value</DEF>
	<TYPE>float</TYPE>
	<NAME>max_y</NAME>
	<VALUE>2.0</VALUE>
</PARAM>
<PARAM>
	<DEF>maximum number of iterations</DEF>
	<TYPE>int</TYPE>
	<NAME>max_iterate</NAME>
	<VALUE>100</VALUE>
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

	if((no_outbuf = NO_OUTPUT_BUFFERS() ) <= 0) {
		fprintf(stderr,"seqgen: no output buffers\n");
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
	differ_x = max_x - min_x;
	differ_y = max_y - min_y;
	increment_x = differ_x/(float)(num_of_points);
	increment_y = differ_y/(float)(num_of_points);

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

	/* generate NUMBER_SAMPLES_PER_VISIT samples, then return */
	while(samples_out < output_target) {

		/* return if all samples have been output */
		if(++i > NUMBER_SAMPLES_PER_VISIT) return(0);

		y_val = min_y;

		for(k=0; k<num_of_points; k++)
		{
			x_val = min_x;
			for(j=0; j<num_of_points; j++)
			{
				temp_x = 0.0;
				temp_y = 0.0;
				cutoff = 0.0;
				for(k2=0; k2<max_iterate; k2++)
				{
				if(temp_x*temp_x < 4.0 && temp_y*temp_y < 4.0)
				{
				sqr_temp_x = temp_x*temp_x-temp_y*temp_y;
				sqr_temp_y = 2.0*temp_x*temp_y;
				temp_x = sqr_temp_x + x_val;
				temp_y = sqr_temp_y + y_val;
				cutoff = (float)k2;
				}
				}

				if(IT_OUT(0)) {
					KrnOverflow("mbset",0);
					return(99);
				}
				OUTF(0,0) = cutoff;

				x_val += increment_x;
				samples_out += 1;
			}
			y_val += increment_y;
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

