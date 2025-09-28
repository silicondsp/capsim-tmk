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

wave 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* wave.s */
/***************************************************************
				wave.s 	
****************************************************************
This star simulates a wave generator.  
	waveType	wave description
	---------------------------------------
	0		sine
	1		cosine
	2		square
	3		triangle
	4		sawtooth
Notes:
Pacer support.
Auto fan-out. 
CONTROL PARAMETERS:
	numberOfSamples     = total number of samples to output.
	paceRate          = multiplies the number of samples received 
			     on pace input (if connected) to determine 
			     how many samples to output.
	samplesFirstTime = the number of samples to put out on the
			     first call if pace input connected. It can
			     be zero. negative values = 0.
CONTROL DESCRIPTION:
If the pace input is not connected:
      The numberOfSamples parameter sets the maximum number of samples
	that the star will output. If numberOfSamples < 0, an indefinite
	number of samples can be output.
      The star will output a maximum of NUMBER_SAMPLES_PER_VISIT on each call.
If the pace input is connected:
      The numberOfSamples parameter sets the maximum number of samples
        that the star will output. If num_samplesOutput < 0, an infinite
	number of samples can be output.
      The pace input paces the number of output samples on each call.
      At each call of the star all samples are read from the pace input
	and a running total of how many there have been is kept.
      An outputTarget  is computed at each pass = pace_input_total *
	paceRate. If paceRate < 0, the absolute value is used.
      On the first call:
	output = lesser of (samplesFirstTime, numberOfSamples)
      On subsequent calls:
	output = lesser of (NUMBER_SAMPLES_PER_VISIT, outputTarget)
	   outputTarget = samplesFirstTime +
		 paceRate * pace_input_total - to that point
      The total number of samples that will be output:
	samplesOutput_total = lesser of (numberOfSamples,
		     samplesFirstTime + paceRate * pace_input_total)
<NAME>
wave
</NAME>
<DESCRIPTION>
This star simulates a wave generator.  
	waveType	wave description
	---------------------------------------
	0		sine
	1		cosine
	2		square
	3		triangle
	4		sawtooth
Notes:
Pacer support.
Auto fan-out. 
CONTROL PARAMETERS:
	numberOfSamples     = total number of samples to output.
	paceRate          = multiplies the number of samples received 
			     on pace input (if connected) to determine 
			     how many samples to output.
	samplesFirstTime = the number of samples to put out on the
			     first call if pace input connected. It can
			     be zero. negative values = 0.
CONTROL DESCRIPTION:
If the pace input is not connected:
      The numberOfSamples parameter sets the maximum number of samples
	that the star will output. If numberOfSamples < 0, an indefinite
	number of samples can be output.
      The star will output a maximum of NUMBER_SAMPLES_PER_VISIT on each call.
If the pace input is connected:
      The numberOfSamples parameter sets the maximum number of samples
        that the star will output. If num_samplesOutput < 0, an infinite
	number of samples can be output.
      The pace input paces the number of output samples on each call.
      At each call of the star all samples are read from the pace input
	and a running total of how many there have been is kept.
      An outputTarget  is computed at each pass = pace_input_total *
	paceRate. If paceRate < 0, the absolute value is used.
      On the first call:
	output = lesser of (samplesFirstTime, numberOfSamples)
      On subsequent calls:
	output = lesser of (NUMBER_SAMPLES_PER_VISIT, outputTarget)
	   outputTarget = samplesFirstTime +
		 paceRate * pace_input_total - to that point
      The total number of samples that will be output:
	samplesOutput_total = lesser of (numberOfSamples,
		     samplesFirstTime + paceRate * pace_input_total)
</DESCRIPTION>
<PROGRAMMERS>
Programmer: 	Prayson W. Pate
Date:		August 18, 1987
Modified: 	Sasan H. Ardalan	
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This star simulates a wave generator.  
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 

#include <math.h>

]]>
</INCLUDES> 

<DEFINES> 

#define 	PI 		3.141592653589793
#define 	WAVE_SINE 	0
#define 	WAVE_COSINE 	1
#define 	WAVE_SQUARE 	2
#define 	WAVE_TRIANGLE 	3
#define 	WAVE_SAWTOOTH 	4

</DEFINES> 

            

<STATES>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>count</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>halfPeriod</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>radFreq</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>slope</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>samplesOutput</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>paceInTotal</NAME>
		<VALUE>0.0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>outputTarget</NAME>
		<VALUE>NUMBER_SAMPLES_PER_VISIT</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberInputBuffers</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberOutputBuffers</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>pass</NAME>
		<VALUE>0</VALUE>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i,j;
	float waveValue;
	float theta;

</DECLARATIONS> 

               

<PARAMETERS>
<PARAM>
	<DEF>total number of samples to output</DEF>
	<TYPE>int</TYPE>
	<NAME>numberOfSamples</NAME>
	<VALUE>128</VALUE>
</PARAM>
<PARAM>
	<DEF>Wave type:0=sine,1=cos,2=sqr,3=triangle,4=sawtooth</DEF>
	<TYPE>int</TYPE>
	<NAME>waveType</NAME>
	<VALUE>0</VALUE>
</PARAM>
<PARAM>
	<DEF>Samples per period.</DEF>
	<TYPE>float</TYPE>
	<NAME>period</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Peak value.</DEF>
	<TYPE>float</TYPE>
	<NAME>peak</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF>pace rate to determine how many samples to output</DEF>
	<TYPE>float</TYPE>
	<NAME>paceRate</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF>number of samples on the first call if paced</DEF>
	<TYPE>int</TYPE>
	<NAME>samplesFirstTime</NAME>
	<VALUE>128</VALUE>
</PARAM>
</PARAMETERS>

<INIT_CODE>
<![CDATA[ 

        /* 
	 * note and store the number of output buffers 
	 */
        if((numberOutputBuffers = NO_OUTPUT_BUFFERS() ) <= 0) {
                fprintf(stdout,"wave: no output buffers\n");
                return(1); /* no output buffers */
        }
	if ((waveType >= 0) && (waveType <= 4))
		;
	else
	{
		fprintf(stderr,"Error in wave (2) \n");
		return(2);
	}
	if (period <= 0.0)
	{
		fprintf(stderr,"Error in wave (3) \n");
		return(3);
	}
	radFreq = (2*PI)/period;
	count = 0.0;
	halfPeriod = period/2.0;
	slope = 0.0;
	if (waveType == 3)
		slope = 4*peak/period;
	if (waveType == 4)
		slope = 2*peak/period;
	/*
	 * pacer code
	 */
        numberInputBuffers = NO_INPUT_BUFFERS();
        if(numberInputBuffers == 1)
           outputTarget = samplesFirstTime;
        else
           outputTarget = numberOfSamples;
        if(outputTarget > numberOfSamples)
           outputTarget = numberOfSamples;
        if(paceRate < 0) paceRate = -paceRate;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

	/*
	 * check pacer
	 */
        if(numberInputBuffers == 1) {
           while(IT_IN(0))
                paceInTotal += 1.0;
           if(pass == 1) {
                outputTarget = samplesFirstTime + (int) (paceRate *
                                paceInTotal + 0.5);
                if(outputTarget > numberOfSamples && numberOfSamples > 0)
                       outputTarget = numberOfSamples;
	   }
	}
        pass = 1;
        i = 0;
 
	/* generate NUMBER_SAMPLES_PER_VISIT samples, then return */
        while(samplesOutput < outputTarget) {
                /* 
		 * return if all samples have been output 
		 */
                if(++i > NUMBER_SAMPLES_PER_VISIT) return(0);

			
		count = count + 1.0;
		if(count > period)
			count = count - period;
 
		switch(waveType) {
			     case  WAVE_SINE:	
				theta = count * radFreq;
				waveValue = peak*sin(theta);
				break;
			     case WAVE_COSINE:
				theta = count * radFreq;
				waveValue = peak*cos(theta);
				break;
			     case WAVE_SQUARE:
				if (count < halfPeriod)
					waveValue = peak;
				else
					waveValue = -1.0*peak;
				break;
			     case WAVE_TRIANGLE:
				if (count < halfPeriod)
					waveValue = slope*count - peak;
				else
					waveValue = peak-slope
						*(count-halfPeriod);
				break;
			      case WAVE_SAWTOOTH: 
				waveValue = slope*count - peak;
				break;
		}
		for(j=0; j<numberOutputBuffers; j++) {
			if(IT_OUT(0)) {
				KrnOverflow("wave",0);
				return(99);
			}
			OUTF(j,0)=waveValue;
		}
		samplesOutput += 1;
      }
      return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

