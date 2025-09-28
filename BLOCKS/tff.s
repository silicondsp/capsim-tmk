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

tff 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*
	tff.s:		T flip-flop
			positive edge triggered
	parameters:	none	
	inputs:		t, input buffer 0
			cp, input buffer 1 (clock)
	outputs:	Q and Q'
	Truth table:
	Q    T  *  Q(t+1)
	*****************
	0    0  *  0
	0    1  *  1
	1    0  *  1
	1    1  *  0
			December 4, 1990
<NAME>
tff
</NAME>
<DESCRIPTION>
T flip-flop positive edge triggered
inputs:		t, input buffer 0
			cp, input buffer 1 (clock)
	outputs:	Q and Q'
	Truth table:
	Q    T  *  Q(t+1)
	*****************
	0    0  *  0
	0    1  *  1
	1    0  *  1
	1    1  *  0
</DESCRIPTION>
<PROGRAMMERS>
December 4, 1990
</PROGRAMMERS>
 */

]]>
</COMMENTS> 

    
<DESC_SHORT>
T flip-flop positive edge triggered
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>temp_q</NAME>
		<VALUE>0.0</VALUE>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>temp_qp</NAME>
		<VALUE>1.0</VALUE>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int samples;
	float in_t;

</DECLARATIONS> 

   
       

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>t</NAME>
		<DELAY><TYPE>max</TYPE><VALUE_MAX>1</VALUE_MAX></DELAY>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>cp</NAME>
		<DELAY><TYPE>max</TYPE><VALUE_MAX>1</VALUE_MAX></DELAY>
	</BUFFER>
</INPUT_BUFFERS>
 
     

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>q</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>qp</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 


]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	for(samples = MIN_AVAIL(); samples>0; --samples)
	{
		IT_IN(0);
		IT_IN(1);
		in_t = t(0);
		if(cp(0) > 0.5 && cp(1) == 0.0)
		{
			if(in_t > 0.5 && temp_q == 0.0) 
			{
				temp_q = 1.0;
				temp_qp = 0.0;
			}
			else if(in_t > 0.5 && temp_q == 1.0) 
			{
				temp_q = 0.0;
				temp_qp = 1.0;
			}
		}

		if(IT_OUT(0) ) {
			KrnOverflow("tff",0);
			return(99);
		}
		q(0) = temp_q;
		if(IT_OUT(1) ) {
			KrnOverflow("tff",1);
			return(99);
		}
		qp(0) = temp_qp;
	}
	return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

