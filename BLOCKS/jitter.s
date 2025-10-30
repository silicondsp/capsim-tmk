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

jitter 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* jitter.s */
/***************************************************************
			jitter() 
****************************************************************
	Inputs:		x, the signal of interest
			ref, the reference signal
	Outputs:	phi, the phase difference in degrees
	Parameters:	int edge, the edge to trigger on
			int sync, specifies if a value is to be
				output for every input sample
****************************************************************
This block finds the relative phase of a signal to a reference.  
One parameter specifies the trigger edge (true for rising, false 
for falling).  The other specifies the output rate (synchronous 
or one per cycle).  The output is the phase difference of the 
chosen edges in degrees.
The phase is found from a linear interpolation of the values on 
either side of a zero crossing.
<NAME>
jitter
</NAME>
<DESCRIPTION>
This block finds the relative phase of a signal to a reference.  
One parameter specifies the trigger edge (true for rising, false 
for falling).  The other specifies the output rate (synchronous 
or one per cycle).  The output is the phase difference of the 
chosen edges in degrees.
The phase is found from a linear interpolation of the values on 
either side of a zero crossing.
</DESCRIPTION>
<PROGRAMMERS>
Programmer: 	Prayson W. Pate
Date:		February 2, 1988
Modified:	February 22, 1988
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This block finds the relative phase of a signal to a reference. 
</DESC_SHORT>

<DEFINES> 

#define true 1
#define false 0

</DEFINES> 

            

<STATES>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>ref_count</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>x_count</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>tau</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>counting</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>last_phi</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>phi_max</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>this_x</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>last_x</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>this_ref</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>last_ref</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int no_samples;
	int x_falling,x_rising;
	int ref_falling,ref_rising;
	float delta;

</DECLARATIONS> 

       

<PARAMETERS>
<PARAM>
	<DEF>Trigger edge: 1= Rising, 0=Falling</DEF>
	<TYPE>int</TYPE>
	<NAME>edge</NAME>
	<VALUE>1</VALUE>
</PARAM>
<PARAM>
	<DEF>Output Rate. Synchronous/One per cycle</DEF>
	<TYPE>int</TYPE>
	<NAME>sync</NAME>
	<VALUE>1</VALUE>
</PARAM>
</PARAMETERS>

     

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>x</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>ref</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
    

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>phi</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

	if ((edge >= 0) && (edge >= 1))
		;
	else
		return(1);
	ref_count = 0.0;
	x_count = 0.0;
	counting = 0;
	phi_max = 180.0;
	tau = 0.0;
	this_x=0.0;
	this_ref=0.0;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

 
	for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) 
 
	{
		/* read x and check for edge		*/
		last_x = this_x;
		IT_IN(0);	
		this_x = x(0);
 
		if ((this_x <= 0.0) && (last_x > 0.0))
			x_falling = 1;
		else
			x_falling = 0;
 
		if ((this_x >= 0.0) && (last_x < 0.0))
			x_rising = 1;
		else
			x_rising = 0;
 
 
		/* read ref and check for falling edge	*/
		last_ref = ref(0);
		IT_IN(1);	
		this_ref = ref(0);
 
		if ((this_ref <= 0.0) && (last_ref > 0.0))
			ref_falling = 1;
		else
			ref_falling = 0;
 
		if ((this_ref >= 0.0) && (last_ref < 0.0))
			ref_rising = 1;
		else
			ref_rising = 0;
 
		if ((edge && ref_rising)||(!edge && ref_falling))
			{
 
			counting = true;
 
			/* find distance from last sample */
			/* to zero crossing		*/
			delta = last_ref/(last_ref - this_ref);
 
 
			tau = ref_count + delta; 
			ref_count = 1.0 - delta;
			x_count = 0.0 - delta;
			}
		else
			{
			ref_count = ref_count + 1.0;
			delta = 0.0;
			}
 
		if (((edge && x_rising) || (!edge && x_falling)) 
			&& counting)
			{
			if(IT_OUT(0)) {
				KrnOverflow("jitter",0);
				return(99);
			}
			counting = false;
 
			/* find distance from last sample to	*/
			/* zero crossing			*/
			if (delta != 0.0)
				{
				delta = last_x/(last_x - this_x) 
					- delta;
				x_count = delta;
				}
			else
				{
				delta = last_x/(last_x - this_x);
				x_count = x_count + delta;
				}
 
 
			if (tau > 0)
				phi(0) = (x_count * 360.0)/tau;
			else
				phi(0) = 0.0;
 
			while (phi(0) > 360.0)
				phi(0) = phi(0) - 360.0;
 
			if (phi(0) > phi_max)
				phi(0) = phi(0) - (2 * phi_max);
 
			last_phi = phi(0);
			}
		/* else, continue to count and output last phase*/
		else 
			{
			if (sync)
				{
				if(IT_OUT(0)) {
					KrnOverflow("jitter",0);
					return(99);
				}
				phi(0) = last_phi;
				}
			if (counting)
				x_count = x_count + 1.0;
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

