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

divby2 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*
<NAME>
divby2
</NAME>
<DESCRIPTION>
divby2.s:		divide frequency by two, produce sqaure 
  			wave					
 	parameters:	none						
 	inputs:		in, the signal to be divided			
 	outputs:	out, square wave with half the frequency	
 	description:	This block produces a square wave at half the    
 			frequency of the incomming wave			
</DESCRIPTION>
<PROGRAMMERS>
written by Sasan Ardalan
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

    
<DESC_SHORT>
This block produces a square wave at half the frequency of the incomming wave	
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>xprev</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>state</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	float xin;

</DECLARATIONS> 

   
    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>in</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
     

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>out</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

	state = 1;
	xprev = 0.0;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

	while(IT_IN(0))
	{
		if(IT_OUT(0)) {
			KrnOverflow("divby2",0);
			return(99);
		}
		xin = in(0);
		if((xin*xprev <=0) && (xprev != 0.0) && (xin > 0.0)) 
			if(state) state = 0;
		        else state = 1; 
		xprev = xin;
		out(0) = 2*state -1;
		
	}

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

