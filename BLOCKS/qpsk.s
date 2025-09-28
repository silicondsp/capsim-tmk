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

qpsk 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/**********************************************************************
				qpsk
 *********************************************************************
Description:
This star inputs data and ouputs the coordinates based on qpsk.
It produces an in phase and quadrature component.
Not very efficient but illustrative.
<NAME>
qpsk
</NAME>
<DESCRIPTION>
This star inputs data and ouputs the coordinates based on qpsk.
It produces an in phase and quadrature component.
Not very efficient but illustrative.
</DESCRIPTION>
<PROGRAMMERS>
Progrramer: Sasan Ardalan
Date: Dec 14, 2000
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

   
<DESC_SHORT>
This star inputs data and ouputs the coordinates based on qpsk. It produces an in phase and quadrature component.
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberBits</NAME>
		<VALUE>0</VALUE>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int	i,k,j;
	static float a_A[4]= {1,1,-1,-1};
	static float b_A[4]= {1,-1,1,-1};
	float x,y;

</DECLARATIONS> 

   
    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>data</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
     

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>inPhase</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>quadPhase</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

	numberBits =0;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

	while(IT_IN(0)) {

			
		numberBits++;
		if(numberBits == 2){	
			numberBits=0;

			
	                j=(int)(data(0)+2*data(1));
	                x=a_A[j];
	                y=b_A[j];
	
	                /* printf("data(0)=%f data(1)=%f j=%d x=%f y=%f \n",data(0),data(1),j,x,y); */


  			if(IT_OUT(0)) {
				KrnOverflow("qpsk",0) ;
				return(99);
			}
			
  			if(IT_OUT(1) ) {
				KrnOverflow("qpsk",0) ;
				return(99);
			}
  			inPhase(0) = x;
  			quadPhase(0) = y;
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

