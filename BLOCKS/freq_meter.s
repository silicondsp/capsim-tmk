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

freq_meter 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* freq_meter.s */
/*************************************************************************
			freq_meter() 
**************************************************************************
	inputs:		x, the signal of interest
	outputs:	y, the frequency of x
	parameters:	int parm, function determined by value
**************************************************************************
This block simulates a frequency counter.  The single parameter determines 
if the output is relative or absolute.
<NAME>
freq_meter
</NAME>
<DESCRIPTION>
This block simulates a frequency counter.  The single parameter determines 
if the output is relative or absolute.
	inputs:		x, the signal of interest
	outputs:	y, the frequency of x
	parameters:	int parm, function determined by value
</DESCRIPTION>
<PROGRAMMERS>
Programmer: 	Prayson W. Pate
Date:		June 2, 1987
Modified:	March 28, 1988
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

       
<DESC_SHORT>
This block simulates a frequency counter.  The single parameter determines if the output is relative or absolute.
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>cycles</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>limit</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>absolute</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>center</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>count</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i,rising,no_samples;
	int this_x,last_x;
	float last_y;

</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF>Input relative or absolute, see code!</DEF>
	<TYPE>int</TYPE>
	<NAME>parm</NAME>
	<VALUE>1</VALUE>
</PARAM>
</PARAMETERS>

    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>x</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
    

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>y</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

	if (parm > 0)
		;
	else
		return(2);
	if (parm < 21)
		{
		absolute = 1;
		limit = parm;
		}
	else
		{
		absolute = 0;
		limit = 1;
		center = 1.0/parm;
		}
	count = 0.0;
	cycles = 0;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) 

		/* increment time on the output and set sample to zero */
		{

		if (x(0) > 0.5)
			last_x = 1;
		else
			last_x = 0;


		IT_IN(0);	

		if (x(0) > 0.5)
			this_x = 1;
		else
			this_x = 0;

		if (this_x && !last_x)
			rising = 1;
		else
			rising = 0;

		count = count + 1.0;

		if (rising)
			{
			++cycles;
			if(cycles > limit)
				{
				if(IT_OUT(0) ) {
					KrnOverflow("freq_meter",0);
					return(99);
				}
				if (absolute)
					{
					if (count == 0)
						count = 1;	
					y(0) = 1.0/(count*limit);
					}
				else
					{
					if (count == 0)
						count = 1;	
					y(0) = (1.0/count) - center;
					y(0) = 100 * (y(0)/center);
					}
				count = 0.0;
				cycles = 1;
				}
			}
		else
			{
			last_y = y(0);
			if(IT_OUT(0)) {
					KrnOverflow("freq_meter",0);
					return(99);
			}
			y(0) = last_y;
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

