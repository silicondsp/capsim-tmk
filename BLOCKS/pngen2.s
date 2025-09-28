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

pngen2 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* pngen2.s */
/**********************************************************************
                pngen2()
***********************************************************************
This function generates a random sequence of bits, which can be used
to exercise a data transmission system.
The early, reference, and late signals are generated with the early
signal shifted with the positive edge of the input clock.
Any degree polynomial can be implemented
as specified in a parameter array.
Input parameters:
	num_delay: Number of samples to delay each way
	shift_length: Length of shift register
	poly[]: Generation polynomial in array
	shift_reg: Initial shift reg for pseudo random sequence
	hi_level: high logic level
	lo_level: low logic level
<NAME>
pngen2
</NAME>
<DESCRIPTION>
This function generates a random sequence of bits, which can be used
to exercise a data transmission system.
The early, reference, and late signals are generated with the early
signal shifted with the positive edge of the input clock.
Any degree polynomial can be implemented
as specified in a parameter array.
</DESCRIPTION>
<PROGRAMMERS>
</PROGRAMMERS>	
*/

]]>
</COMMENTS> 

       
<DESC_SHORT>
This function generates a random sequence of bits, which can be usedto exercise a data transmission system. The early, reference, and late signals are generated with the earlysignal shifted with the positive edge of the input clock. Any degree polynomial can be implemented as specified in a parameter array.
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>shift_reg</NAME>
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
		<TYPE>float</TYPE>
		<NAME>fbit_early[100]</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>fbit_temp[100]</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i,j,k;
	int samples;
	int temp_val;
	int kp;

</DECLARATIONS> 

               

<PARAMETERS>
<PARAM>
	<DEF>number of samples to delay each way</DEF>
	<TYPE>int</TYPE>
	<NAME>num_delay</NAME>
	<VALUE>4</VALUE>
</PARAM>
<PARAM>
	<DEF>Length of shift register</DEF>
	<TYPE>int</TYPE>
	<NAME>shift_length</NAME>
	<VALUE>7</VALUE>
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
	<DEF>High logic level</DEF>
	<TYPE>float</TYPE>
	<NAME>hi_level</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Low logic level</DEF>
	<TYPE>float</TYPE>
	<NAME>lo_level</NAME>
	<VALUE>-1.0</VALUE>
</PARAM>
</PARAMETERS>

    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>clock</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
      

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>early</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>reference</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>late</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

	if((no_outbuf = NO_OUTPUT_BUFFERS() ) <= 0) {
		fprintf(stderr,"pngen: no output buffers\n");
		return(1); /* no output buffers */
	}
	shift_reg = initialize;
	for(i=0; i<101; i++)
	{
		fbit_early[i] = 0.0;
	}

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	for(samples = MIN_AVAIL(); samples > 0; --samples) {

		temp_val = 0;
		IT_IN(0);
		for(i=0; i<2*num_delay; i++)
		{
			fbit_temp[i] = fbit_early[i];
		}

		if(clock(1) == 0.0 && clock(0) == 1.0) {

			for(i=0; i<shift_length; i++)
			{
				kp = poly[i];
				temp_val = temp_val + ((shift_reg >> i) & kp);
			}
			shift_reg = (temp_val % 2) + (shift_reg << 1);
			
			for(j=1; j<2*num_delay; j++)
			{
				fbit_early[j] = fbit_temp[j-1];
			}
			fbit_early[0] = (float) ((shift_reg >> shift_length) & 1);
		}
		else
		{
			for(k=1; k<2*num_delay; k++)
			{
				fbit_early[k] = fbit_temp[k-1];
			}
			fbit_early[0] = fbit_temp[0]; 
		}

		if(IT_OUT(0)) {
			KrnOverflow("pngen2",0);
			return(99);
		}
		if(fbit_early[0] == 0.0)
		{
			early(0) = lo_level;
		}
		else
		{
			early(0) = hi_level;
		}

		if(IT_OUT(1) ) {
			KrnOverflow("pngen2",1);
			return(99);
		}
		if(fbit_early[num_delay - 1] == 0.0)
		{
			reference(0) = lo_level;
		}
		else
		{
			reference(0) = hi_level;
		}

		if(IT_OUT(2)) {
			KrnOverflow("pngen2",2);
			return(99);
		}
		if(fbit_early[2*num_delay-1] == 0.0)
		{
			late(0) = lo_level;
		}
		else
		{
			late(0) = hi_level;
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

