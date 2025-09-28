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

srlatch 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*
	srlatch.s:	SR latch
	parameters:	none
	inputs:		S and R
	outputs:	Q and Q'
	Truth table:
	S    R  *  Q    Q'
	****************** 
	1    0  *  1    0
	0    0  *  1    0   (after S=1, R=0)
	0    1  *  0    1
	0    0  *  0    1   (after S=0, R=1)
	1    1  *  0    0
<NAME>
srlatch
</NAME>
<DESCRIPTION>
	srlatch.s:	SR latch
	parameters:	none
	inputs:		S and R
	outputs:	Q and Q'
	Truth table:
	S    R  *  Q    Q'
	****************** 
	1    0  *  1    0
	0    0  *  1    0   (after S=1, R=0)
	0    1  *  0    1
	0    0  *  0    1   (after S=0, R=1)
	1    1  *  0    0
</DESCRIPTION>
<PROGRAMMERS>
			December 4, 1990
</PROGRAMMERS>
 */

]]>
</COMMENTS> 

    
<DESC_SHORT>
SR latch
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
	float in_s;
	float in_r;

</DECLARATIONS> 

   
       

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>s</NAME>
		<DELAY><TYPE>max</TYPE><VALUE_MAX>1</VALUE_MAX></DELAY>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>r</NAME>
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
		in_s = s(0);
		in_r = r(0);
		if(in_s > 0.5 && in_r > 0.5)
		{
			temp_q = 0.0;
			temp_qp = 0.0;
		}

		if(in_s > 0.5 && in_r == 0.0)
		{
			temp_q = 1.0;
			temp_qp = 0.0;
		}

		if(in_s == 0.0 && in_r > 0.5)
		{
			temp_q = 0.0;
			temp_qp = 1.0;
		}

		if(IT_OUT(0)) {
			KrnOverflow("srlatch",0);
			return(99);
		}
		q(0) = temp_q;
		if(IT_OUT(1)) {
			KrnOverflow("srlatch",0);
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

