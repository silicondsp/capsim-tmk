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

sn74ls93 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*
	sn74ls93.s:	counter with QA connected to CKB
	parameters:	none	
	inputs:		cka, clock input
			note: no ckb input because ckb connected to qa
			r01, reset 1
			r02, reset 2
			note: if r01=r02=1 all outputs are 0
	outputs:	qa, qb, qc, and qd
<NAME>
sn74ls93
</NAME>
<DESCRIPTION>
counter with QA connected to CKB
	parameters:	none	
	inputs:		cka, clock input
			note: no ckb input because ckb connected to qa
			r01, reset 1
			r02, reset 2
			note: if r01=r02=1 all outputs are 0
	outputs:	qa, qb, qc, and qd
</DESCRIPTION>
<PROGRAMMERS>
			written by Ray Kassel
			November 8, 1990
</PROGRAMMERS>
 */

]]>
</COMMENTS> 

   
<DESC_SHORT>
counter with QA connected to CKB
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>count_val</NAME>
		<VALUE>0</VALUE>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int samples;
	int in_r01;
	int in_r02;

</DECLARATIONS> 

   
         

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>cka</NAME>
		<DELAY><TYPE>max</TYPE><VALUE_MAX>1</VALUE_MAX></DELAY>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>r01</NAME>
		<DELAY><TYPE>max</TYPE><VALUE_MAX>1</VALUE_MAX></DELAY>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>r02</NAME>
		<DELAY><TYPE>max</TYPE><VALUE_MAX>1</VALUE_MAX></DELAY>
	</BUFFER>
</INPUT_BUFFERS>
 
       

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>qa</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>qb</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>qc</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>qd</NAME>
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
		IT_IN(2);
		in_r01 = r01(0);
		in_r02 = r02(0);
		if(in_r01 == 0 || in_r02 == 0)
		{
			if(cka(0) == 0.0 && cka(1) == 1.0)
			{
				++ count_val;
				if(count_val == 16) count_val =0;
			}
		}
		else
		{
			count_val = 0;
		}

		if(IT_OUT(0) ) {
			KrnOverflow("sn74ls93",0);
			return(99);
		}
		qa(0) = count_val & 1;
		if(IT_OUT(1) ) {
			KrnOverflow("sn74ls93",1);
			return(99);
		}
		qb(0) = (count_val & 2) >> 1;
		if(IT_OUT(2) ) {
			KrnOverflow("sn74ls93",2);
			return(99);
		}
		qc(0) = (count_val & 4) >> 2;
		if(IT_OUT(3)) {
			KrnOverflow("sn74ls93",3);
			return(99);
		}
		qd(0) = (count_val & 8) >> 3;
	}
	return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

