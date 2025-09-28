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

seqgen 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* seqgen.s */
/**********************************************************************
                seqgen()
***********************************************************************
This function generates a sequence of bits, which can be used
to exercise a data transmission system.
Any degree polynomial can be implemented
as specified in a parameter array.
Input parameters:
	shift_length: Length of shift register
	poly[]: Generation polynomial in array
	shift_reg: Initial shift reg for pseudo random sequence
	num_of_samples: Number of samples
	num_per_chip: Number of samples per chip
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
seqgen
</NAME>
<DESCRIPTION>
This function generates a sequence of bits, which can be used
to exercise a data transmission system.
Any degree polynomial can be implemented
as specified in a parameter array.
Input parameters:
	shift_length: Length of shift register
	poly[]: Generation polynomial in array
	shift_reg: Initial shift reg for pseudo random sequence
	num_of_samples: Number of samples
	num_per_chip: Number of samples per chip
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
</DESCRIPTION>
<PROGRAMMERS>
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This function generates a sequence of bits, which can be used to exercise a data transmission system. Any degree polynomial can be implemented as specified in a parameter array.
</DESC_SHORT>


<DEFINES> 

#define OUT_SAMPLES NUMBER_SAMPLES_PER_VISIT 

</DEFINES> 

         

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>shift_reg</NAME>
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

	int i,j,k;
	int temp_val;
	int kp;
	float fbit;

</DECLARATIONS> 

                 

<PARAMETERS>
<PARAM>
	<DEF>total number of samples to output</DEF>
	<TYPE>int</TYPE>
	<NAME>num_of_samples</NAME>
	<VALUE>128</VALUE>
</PARAM>
<PARAM>
	<DEF>number of samples per chip</DEF>
	<TYPE>int</TYPE>
	<NAME>num_per_chip</NAME>
	<VALUE>8</VALUE>
</PARAM>
<PARAM>
	<DEF>Length of shift register</DEF>
	<TYPE>int</TYPE>
	<NAME>shift_length</NAME>
	<VALUE>10</VALUE>
</PARAM>
<PARAM>
	<DEF>Initialization for shift register</DEF>
	<TYPE>int</TYPE>
	<NAME>initialize</NAME>
	<VALUE>12</VALUE>
</PARAM>
<PARAM>
	<DEF>Array of polynomial (0 or 1)</DEF>
	<TYPE>array</TYPE>
	<NAME>poly</NAME>
	<VALUE></VALUE>
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
	shift_reg = initialize;

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

		temp_val = 0;

		for(k=0; k<shift_length; k++)
		{
			kp = poly[k];
			temp_val = temp_val + ((shift_reg >> k) & kp);
		}
		shift_reg = (temp_val % 2) + (shift_reg << 1);
			
		fbit = (float) ((shift_reg >> shift_length) & 1) ;
		
		for(k=0; k<num_per_chip; k++)
		{
			for(j=0; j<no_outbuf; j++) {
				if(IT_OUT(j)) {
					KrnOverflow("seqgen",j);
					return(99);
				}
				OUTF(j,0) = fbit;
			}
		}
		samples_out_total += num_per_chip;
	}
	return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

