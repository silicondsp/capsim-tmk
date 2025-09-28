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

zc 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* zc.s */
/***************************************************************
			zc() 
****************************************************************
	Inputs:		x, the signal of interest
	Outputs: 	impulse at zero crossing	
	Parameters:	int edge, the edge to trigger on
****************************************************************
<NAME>
zc
</NAME>
<DESCRIPTION>
Zero crossing detector. Outputs impulses at zero crossing.
	Inputs:		x, the signal of interest
	Outputs: 	impulse at zero crossing	
	Parameters:	int edge, the edge to trigger on
</DESCRIPTION>
<PROGRAMMERS>
Programmer:     Sasan H. Ardalan	
Date:	 	October 27, 1989	
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
Zero crossing detector. Outputs impulses at zero crossing.
</DESC_SHORT>


<DEFINES> 

#define true 1
#define false 0

</DEFINES> 

<DECLARATIONS> 

	int no_samples;
	float this_x,last_x;
	int x_falling,x_rising;

</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF>Trigger edge: 1= Rising, 0=Falling</DEF>
	<TYPE>int</TYPE>
	<NAME>edge</NAME>
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

	if ((edge >= 0) && (edge >= 1))
		;
	else
		return(1);

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

 
	for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) 
 
	{
		/* read x and check for edge		*/
		last_x = x(0);
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
 
 
		if(IT_OUT(0)) {
			KrnOverflow("zc", 0);
			return(99);
		}
		if (x_falling && edge ) 
			y(0)=1;
		else
		if(x_rising && !edge) 
			y(0) = 1;
		else
			y(0) = 0;
			
	}
 
 
	return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

