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

hold 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* hold.s */
/**************************************************************
			hold.s 
****************************************************************
	Inputs:	x, the data stream
	Outputs:	y, the chosen samples of x
	Parameters:     Number of samples to hold	
****************************************************************
This star simulates a sample and hold circuit.  The lone parameter 
specifies the number of samples to hold the value. 
Triggering is on the positive edge of the clock. 
<NAME>
hold
</NAME>
<DESCRIPTION>
This star simulates a sample and hold circuit.  The lone parameter 
specifies the number of samples to hold the value. 
Triggering is on the positive edge of the clock. 
</DESCRIPTION>
<PROGRAMMERS>
Programmer: 	Sasan Ardalan,Prayson W. Pate
Date:			July 29, 1987
Modified:		September 14, 1987
			October 1, 1987
			February 3, 1988
			February 22, 1988
</PROGRAMMERS> 
*/

]]>
</COMMENTS> 

    
<DESC_SHORT>
This star simulates a sample and hold circuit.   
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>hold_sample</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>count</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int this_clock,last_clock,get_sample;
	int no_samples;

</DECLARATIONS> 

    

<PARAMETERS>
<PARAM>
	<DEF></DEF>
	<TYPE>int</TYPE>
	<NAME>holdTime</NAME>
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
		<NAME>clock</NAME>
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

	hold_sample = 0.0;
	count = 0;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

 
	/* note the minimum number of samples on the input 	*/
	/* buffers and iterate that many times 			*/
	
	for(no_samples=MIN_AVAIL(); no_samples >0; --no_samples) 
 
		{
		if (clock(0) > 0.5)
			last_clock = 1;
		else
			last_clock = 0;
 
		IT_IN(0);	
		IT_IN(1);	
 
		if (clock(0) > 0.5)
			this_clock = 1;
		else
			this_clock = 0;
		
		get_sample = 0;
 
			if (this_clock && !last_clock)
				get_sample = 1;
 
		if (get_sample)
			{
			hold_sample = x(0);
			count = 0; 
			}
		if(IT_OUT(0)) {
			KrnOverflow("hold",0);
			return(99);
		}
		if (count < holdTime)
			y(0) = hold_sample;
		else 
			y(0) = 0.0;
	 	count++;	
 
		}
 
	return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

