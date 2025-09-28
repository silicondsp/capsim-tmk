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

stretch 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* stretch.s */
/*************************************************************************
			stretch() 
**************************************************************************
	Inputs:		in(0), the data to be stretched
			in(1), a clock (optional)
	Outputs:	y, the stretched data
	Parameters:	s, the stretch factor
**************************************************************************
This star stretches the incoming data.  If the paramater s is 0 then the
data is clocked by the rising edge of the second input.  Else, the data 
is stretched by the fixed factor of s.  Each case is shown below.
	s = 0:
		x: 	1  2  3 4 5   6   7  8  9
		clk:	110110101011001100110110110
		y: 	111222334455556666777888999
	s > 3:
		x: 	1  2  3  4  5  6  7  8  9
		y: 	111222333444555666777888999
<NAME>
stretch
</NAME>
<DESCRIPTION>
This star stretches the incoming data.  If the paramater s is 0 then the
data is clocked by the rising edge of the second input.  Else, the data 
is stretched by the fixed factor of s.  Each case is shown below.
	s = 0:
		x: 	1  2  3 4 5   6   7  8  9
		clk:	110110101011001100110110110
		y: 	111222334455556666777888999
	s > 3:
		x: 	1  2  3  4  5  6  7  8  9
		y: 	111222333444555666777888999
</DESCRIPTION>
<PROGRAMMERS>
Programmer: 	Prayson W. Pate
Date:		June 1, 1987
Modified:	September 2, 1987
		September 14, 1987
		October 6, 1987
		March 29, 1988
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

    
<DESC_SHORT>
This star stretches the incoming data.
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>last_clk</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>last_x</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i,j,no_samples;
	int clk;
	float x;
	float z;

</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF>Stretch factor</DEF>
	<TYPE>int</TYPE>
	<NAME>s</NAME>
	<VALUE>1</VALUE>
</PARAM>
</PARAMETERS>

    

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>y</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

	if (NO_OUTPUT_BUFFERS() == 1)
		;
	else
		return(1);
	if (s == 0)
		{
		if (NO_INPUT_BUFFERS() == 2)
			;
		else
			return(2);
		}
	else if (s > 0)
		{
		if (NO_INPUT_BUFFERS() == 1)
			;
		else
			return(3);
		}
	else
		return(4);
	last_clk = 0;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	/* note the minimum number of samples on the input buffers	*/
	/* and iterate that many times 					*/

	if (i > 0)
		{
		for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) 
			{
			IT_IN(0);
			x = INF(0,0);
			 
				if(IT_OUT(0)) {
					KrnOverflow("stretch",0);
					return(99);
				}
				y(0) = x;
			for(i=1; i<s; ++i) 
				{
				if(IT_OUT(0)) {
					KrnOverflow("stretch",0);
					return(99);
				}
				y(0) = 0;
				}
			}
		return(0);
		}
	else
		{
		for(no_samples=MIN_AVAIL(); no_samples >0; --no_samples) 
			{
			IT_IN(1);
			if(IT_OUT(0) ) {
				KrnOverflow("stretch",0);
				return(99);
			}

			z = INF(1,0);
			if (z > 0.5)
				clk = 1;
			else
				clk = 0;

			if (clk && !last_clk)
				{
				IT_IN(0);
				last_x = INF(0,0);
				}
			last_clk = clk;

			y(0) = last_x;
			}
		return(0);
		}

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

