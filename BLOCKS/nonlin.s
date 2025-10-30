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

nonlin 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* nonlin.s */
/**********************************************************************
                nonlin()
***********************************************************************
Gives two outputs for bifurcation diagram
Input parameters:
	min_param: minimum parameter value
	max_param: maximum parameter value
	num_inc: number of increments
	length_iterate: number of iterations
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
nonlin
</NAME>
<DESCRIPTION>
Gives two outputs for bifurcation diagram
Input parameters:
	min_param: minimum parameter value
	max_param: maximum parameter value
	num_inc: number of increments
	length_iterate: number of iterations
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
Gives two outputs for bifurcation diagram
</DESC_SHORT>


<DEFINES> 

#define OUT_SAMPLES NUMBER_SAMPLES_PER_VISIT 

</DEFINES> 

            

<STATES>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>increment_val</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>differ</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>temp_param</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>temp_val</NAME>
		<VALUE>0.5</VALUE>
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

	int i,j,k,k2;

</DECLARATIONS> 

               

<PARAMETERS>
<PARAM>
	<DEF>total number of samples to output</DEF>
	<TYPE>int</TYPE>
	<NAME>num_of_samples</NAME>
	<VALUE>100</VALUE>
</PARAM>
<PARAM>
	<DEF>minimum parameter value</DEF>
	<TYPE>float</TYPE>
	<NAME>min_param</NAME>
	<VALUE>0.0</VALUE>
</PARAM>
<PARAM>
	<DEF>maximum parameter value</DEF>
	<TYPE>float</TYPE>
	<NAME>max_param</NAME>
	<VALUE>5.0</VALUE>
</PARAM>
<PARAM>
	<DEF>length of iteration</DEF>
	<TYPE>int</TYPE>
	<NAME>length_iterate</NAME>
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
	temp_param = min_param;
	differ = (float)(max_param - min_param);
	increment_val = differ/(float)(num_of_samples);

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
	while(samples_out_total < output_target) {

		/* return if all samples have been output */
		if(++i > NUMBER_SAMPLES_PER_VISIT) return(0);

		for(k=0; k<num_of_samples; k++)
		{
			temp_param += increment_val;
			for(j=0; j<length_iterate; j++)
			{
				temp_val = temp_param*temp_val*
					(1.0-temp_val);
			}
			for(k2=0; k2<num_of_samples; k2++)
			{
				temp_val = temp_param*temp_val*
					(1.0-temp_val);
				if(IT_OUT(0)) {
					KrnOverflow("nonlin",0);
					return(99);
				}
				OUTF(0,0) = temp_param;
				if(IT_OUT(1) ) {
					KrnOverflow("nonlin",0);
					return(99);
				}
				OUTF(1,0) = temp_val;
			}
			samples_out_total ++;
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

