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

phi_meter 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* phi_meter.s */
/***************************************************************
			phi_meter() 
****************************************************************
	Inputs:		x, the signal of interest
			ref, the reference signal
	Outputs:	phi, the phase difference in degrees
	Parameters:	int edge, the edge to trigger on
			int sync, specifies if a value is to be
				output for every input sample
****************************************************************
This star finds the relative phase of a signal to a reference.  
Both signals are assumed to be digital and between 0.0 and 1.0.
One parameter specifies the trigger edge (true for rising, false 
for falling).  The other specifies the output rate (synchronous 
or one per cycle).  The output is the phase difference of the 
chosen edges in degrees.
<NAME>
phi_meter
</NAME>
<DESCRIPTION>
This star finds the relative phase of a signal to a reference.  
Both signals are assumed to be digital and between 0.0 and 1.0.
One parameter specifies the trigger edge (true for rising, false 
for falling).  The other specifies the output rate (synchronous 
or one per cycle).  The output is the phase difference of the 
chosen edges in degrees.
</DESCRIPTION>
<PROGRAMMERS>
Programmer:	Prayson W. Pate
Date:		June 2, 1987
Modified:	August 17, 1987
		September 2, 1987
		October 1, 1987
		December 3, 1987
		February 2, 1988
		February 22, 1988
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This star finds the relative phase of a signal to a reference.
</DESC_SHORT>


<DEFINES> 

#define	true	1
#define	false	0

</DEFINES> 

        

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>ref_count</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
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
</STATES>
 
<DECLARATIONS> 

	int no_samples;
	int this_x,last_x,x_falling,x_rising;
	int this_ref,last_ref,ref_falling,ref_rising;

</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF></DEF>
	<TYPE>int</TYPE>
	<NAME>edge</NAME>
	<VALUE>1</VALUE>
</PARAM>
<PARAM>
	<DEF></DEF>
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
	ref_count = 0;
	x_count = 0;
	counting = 0;
	phi_max = 180;
	tau = 0.0;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

 
	for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) 
 
		{
		/* read x and check for edge		*/
		if (x(0) > 0.5)
			last_x = 1;
		else
			last_x = 0;
 
		IT_IN(0);	
 
		if (x(0) > 0.5)
			this_x = 1;
		else
			this_x = 0;
 
		if (!this_x && last_x)
			x_falling = 1;
		else
			x_falling = 0;
 
		if (this_x && !last_x)
			x_rising = 1;
		else
			x_rising = 0;
 
 
		/* read ref and check for falling edge		*/
		if (ref(0) > 0.5)
			last_ref = 1;
		else
			last_ref = 0;
 
 
		IT_IN(1);	
 
		if (ref(0) > 0.5)
			this_ref = 1;
		else
			this_ref = 0;
 
		if (!this_ref && last_ref)
			ref_falling = 1;
		else
			ref_falling = 0;
 
		if (this_ref && !last_ref)
			ref_rising = 1;
		else
			ref_rising = 0;
 
 
		if ((edge && ref_rising) || (!edge && ref_falling))
			{
			counting = true;
			tau = ref_count + 1.0;
			ref_count = 0;
			x_count = 0;
			}
		else
			++ref_count;
 
		if ((edge && x_rising) || (!edge && x_falling))
			{
			if(IT_OUT(0)) {
				KrnOverflow("phi_meter",0);
				return(99);
			}
			counting = false;
 
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
		/* else, continue to count and output last phase */
		else 
			{
			if (sync)
				{
				if(IT_OUT(0)) {
					KrnOverflow("phi_meter",0);
					return(99);
				}
				phi(0) = last_phi;
				}
			if (counting)
				++x_count;
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

