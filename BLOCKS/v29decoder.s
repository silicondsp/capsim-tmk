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

v29decoder 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/**********************************************************************
 			 	v29decoder()
***********************************************************************
Description:
This star inputs inPhase and quadPhase of the CCITT v.29 coordinates
and decodes the input into binary data.  Input buffer(0) is the inPhase
and input buffer(1) is the quadPhase.
<NAME>
v29decoder
</NAME>
<DESCRIPTION>
This star inputs inPhase and quadPhase of the CCITT v.29 coordinates
and decodes the input into binary data.  Input buffer(0) is the inPhase
and input buffer(1) is the quadPhase.
</DESCRIPTION>
<PROGRAMMERS>
Programmer: A. S. Sadri
Date: Aug. 3, 1990
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

     
<DESC_SHORT>
This star inputs inPhase and quadPhase of the CCITT v.29 coordinates and decodes the input into binary data.
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>intVal0</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>intVal1</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>bit</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int	n,i;
	float   tmp1, tmp0;

</DECLARATIONS> 

   
     

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>inPhase</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>quadPhase</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
    

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>data</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 


]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

	while(MIN_AVAIL()) {
		
		IT_IN(0);
		tmp0 = inPhase(0);
		IT_IN(1);
		tmp1 = quadPhase(0);
/*
 * Calculating the integer value of the inputs
 */
		if(tmp0 < 0.00001)
			intVal0 = (int)(tmp0 - 0.5);
		else
			intVal0 = (int)(tmp0 + 0.5);
			
		if(tmp1 < 0.00001)
			intVal1 = (int)(tmp1 - 0.5);
		else
			intVal1 = (int)(tmp1 + 0.5);
/*
 * Mapping the coordinates into the decimal value of the decoded inputs
 */
		if(intVal0 == 1 && intVal1 == 1)
			n = 0;
		else if(intVal0 == 3 && intVal1 == 0)
			n = 8;
		else if(intVal0 == 0 && intVal1 == 3)
			n = 4;
		else if(intVal0 == -1 && intVal1 == 1)
			n = 12;
		else if(intVal0 == 0 && intVal1 == -3)
			n = 2;
		else if(intVal0 == 1 && intVal1 == -1)
			n = 10;
		else if(intVal0 == -1 && intVal1 == -1)
			n = 6;
		else if(intVal0 == -3 && intVal1 == 0)
			n = 14;
		else if(intVal0 == 3 && intVal1 == 3)
			n = 1;
		else if(intVal0 == 5 && intVal1 == 0)
			n = 9;
		else if(intVal0 == 0 && intVal1 == 5)
			n = 5;
		else if(intVal0 == -3 && intVal1 == 3)
			n = 13;
		else if(intVal0 == 0 && intVal1 == -5)
			n = 3;
		else if(intVal0 == 3 && intVal1 == -3)
			n = 11;
		else if(intVal0 == -3 && intVal1 == -3)
			n = 7;
		else if(intVal0 == -5 && intVal1 == 0)
			n = 15;
/*
 * Calculating the binary representation of the decimal value
 */
		for(i=0; i<4; i++){
			if(n % 2)
				bit = 1;
			else
				bit = 0;
			n = n >> 1;
  			if(IT_OUT(0) ) {
				KrnOverflow("v29decoder",0);
				return(99);
			}
			data(0) = bit;	
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

