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

sine 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* sine.s */
/***************************************************************************
                          sine()
*****************************************************************************
This star generates a sinusoid ( cosine for zero phase) . 
If a second buffer is connected, the quadrature signal is output.
Parameters: 
The first parameter, which defaults to 128, tells how many total samples
to send out.
The second parameter is the magnitude which defaults to one.
The third parameter is the sampling frequency.
The 4th parameter is the frequency.
The fifth parameter is the phase in degrees.
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
	that the star will output. If num_of_samples is less than  0, an indefinite
	number of samples can be output.
      The star will output a maximum of NUMBER_SAMPLES_PER_VISIT on each call.
If the pace input is connected:
      The num_of_samples parameter sets the maximum number of samples
        that the star will output. If num_samples_out  is less than 0, an infinite
	number of samples can be output.
      The pace input paces the number of output samples on each call.
      At each call of the star all samples are read from the pace input
	and a running total of how many there have been is kept.
      An output_target  is computed at each pass = pace_input_total *
	pace_rate. If pace_rate is lesss than  0, the absolute value is used.
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
sine
</NAME>
<DESCRIPTION>
This star generates a sinusoid ( cosine for zero phase) . 
If a second buffer is connected, the quadrature signal is output.
Parameters: 
The first parameter, which defaults to 128, tells how many total samples
to send out.
The second parameter is the magnitude which defaults to one.
The third parameter is the sampling frequency.
The 4th parameter is the frequency.
The fifth parameter is the phase in degrees.
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
	that the star will output. If num_of_samples is less than  0, an indefinite
	number of samples can be output.
      The star will output a maximum of NUMBER_SAMPLES_PER_VISIT on each call.
If the pace input is connected:
      The num_of_samples parameter sets the maximum number of samples
        that the star will output. If num_samples_out is less than  0, an infinite
	number of samples can be output.
      The pace input paces the number of output samples on each call.
      At each call of the star all samples are read from the pace input
	and a running total of how many there have been is kept.
      An output_target  is computed at each pass = pace_input_total *
	pace_rate. If pace_rate is lesss than 0, the absolute value is used.
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
Programmer:	Sasan Ardalan
Date:		Nov. 1987
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This star generates a sinusoid ( cosine for zero phase). If a second buffer is connected, the quadrature signal is output.
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 


]]>
</INCLUDES> 

<DEFINES> 

#define PI 3.141592654


#define PIDIV2  1.570796327


#define PI2  6.283185307

</DEFINES> 

           

<STATES>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>dt</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>phaseRad</NAME>
	</STATE>
	<STATE>
		<TYPE>long</TYPE>
		<NAME>samples_out</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>double</TYPE>
		<NAME>pace_in_total</NAME>
		<VALUE>0.0</VALUE>
	</STATE>
	<STATE>
		<TYPE>long</TYPE>
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
		<TYPE>double</TYPE>
		<NAME>angle</NAME>
		<VALUE>0</VALUE>
	</STATE>
</STATES>
 
<DECLARATIONS> 

     long  i,j;

</DECLARATIONS> 

                 

<PARAMETERS>
<PARAM>
	<DEF>total number of samples to output</DEF>
	<TYPE>int</TYPE>
	<NAME>num_of_samples</NAME>
	<VALUE>128</VALUE>
</PARAM>
<PARAM>
	<DEF>Enter Magnitude</DEF>
	<TYPE>float</TYPE>
	<NAME>magnitude</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Enter Sampling Rate</DEF>
	<TYPE>float</TYPE>
	<NAME>fs</NAME>
	<VALUE>32000.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Enter Frequency</DEF>
	<TYPE>float</TYPE>
	<NAME>freq</NAME>
	<VALUE>1000.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Enter Phase</DEF>
	<TYPE>float</TYPE>
	<NAME>phase</NAME>
	<VALUE>0.0</VALUE>
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

	phaseRad = phase *PI/180.0;
	dt = 2.*PI*freq/fs;
	angle= -dt;
        /* note and store the number of output buffers */
        if((no_outbuf = NO_OUTPUT_BUFFERS() ) <= 0) {
                fprintf(stdout,"sine: no output buffers\n");
                return(1); /* no output buffers */
        }
        if(no_outbuf > 2) {
                fprintf(stdout,"sine: too many output buffers\n");
                return(1); /*  */
        }
        no_inbuf = NO_INPUT_BUFFERS();
        if(no_inbuf == 1)
           output_target = samples_first_time;
        else
           output_target = num_of_samples;
        if(output_target > num_of_samples)
           output_target = num_of_samples;
        if(pace_rate < 0) pace_rate = -pace_rate;

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
     
		if(IT_OUT(0)) {
			KrnOverflow("sine",0);
			return(99);
		}

	
		angle= angle +dt;
		angle=fmod(angle,PI2);
		
		
		OUTF(0,0) = magnitude*cos(angle+phaseRad);
		
		
		
		if(no_outbuf == 2) {
			if(IT_OUT(1)){
				KrnOverflow("sine",1);
				return(99);
			}
			OUTF(1,0) = magnitude*cos(PIDIV2- angle-phaseRad);
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

