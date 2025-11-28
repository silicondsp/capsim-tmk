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

datagen 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* datagen.s */
/**********************************************************************
                datagen()
***********************************************************************
Programmer:  R. T. Wietelmann/G.H.Brand
Date: Oct 7, 1982
Modified for V2.0 by D.G.Messerschmitt March 11, 1985
Mod: ljfaber 12/87  add 'auto fanout'
This function generates a random sequence of bits, which can be used
to exercise a data transmission system.
Input parameters:
	int initialize: Initialize shift reg for pseudo random sequence
The pseudo-random sequence generator uses the polynomial x**10+x**3+1.
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
datagen
</NAME>
<DESCRIPTION>
This function generates a random sequence of bits, which can be used
to exercise a data transmission system.
Input parameters:
	int initialize: Initialize shift reg for pseudo random sequence
The pseudo-random sequence generator uses the polynomial x**10+x**3+1.
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
Programmer:  R. T. Wietelmann/G.H.Brand
Date: Oct 7, 1982
Modified for V2.0 by D.G.Messerschmitt March 11, 1985
Mod: ljfaber 12/87  add 'auto fanout'
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This function generates a random sequence of bits, which can be used to exercise a data transmission system.
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
		<NAME>obufs</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>pass</NAME>
		<VALUE>0</VALUE>
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

	int i,j;
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
	<DEF>Payload Length</DEF>
	<TYPE>int</TYPE>
	<NAME>payloadLength</NAME>
	<VALUE>128</VALUE>
</PARAM>
<PARAM>
	<DEF>Initialization for shift register</DEF>
	<TYPE>int</TYPE>
	<NAME>initialize</NAME>
	<VALUE>12</VALUE>
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
		fprintf(stderr,"datagen: no output buffers\n");
		return(1); /* no output buffers */
	}
	no_inbuf = NO_INPUT_BUFFERS();
	if(no_inbuf != 1) {
		fprintf(stderr,"datagen: no input buffers\n");
		return(2); /* no output buffers */
	}
	shift_reg = initialize;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 



	/* generate NUMBER_SAMPLES_PER_VISIT samples, then return */
	if(IT_IN(0)) {
	    for(i=0; i< payloadLength; i++) { 


		/* run the shift register sequence to obtain another bit */
		shift_reg = ((((shift_reg >> 10)&1) + ((shift_reg >> 3)&1)
			+1 ) % 2)+(shift_reg << 1);
			
		/* put out the new bit as a floating number */
		fbit = (float) (shift_reg & 1) ;
		
		samples_out_total += 1;
		for(j=0; j<obufs; j++) {
			if(IT_OUT(j)) {
				fprintf(stderr,"datagen: Serious overflow on Buffer %d \n",j);
				return(1);
			}
				
			OUTF(j,0) = fbit;
		}
		if(samples_out_total > num_of_samples) 
				return(0);
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

