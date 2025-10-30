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

v29encoder 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/**********************************************************************
				v29encoder()
 *********************************************************************
Description:
This block inputs data and ouputs the coordinates of th CCITT v.29
encoder constlations.  Output0 corresponds to the real value and 
Output1 corresponds to the coordinates of the immaginary.
<NAME>
v29encoder
</NAME>
<DESCRIPTION>
This block inputs data and ouputs the coordinates of th CCITT v.29
encoder constlations.  Output0 corresponds to the real value and 
Output1 corresponds to the coordinates of the immaginary.
</DESCRIPTION>
<PROGRAMMERS>
Progrramer: A. S. Sadri
Date: Aug. 2, 1990
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

    
<DESC_SHORT>
This block inputs data and ouputs the coordinates of the CCITT v.29 encoder constlations. 
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>array_A[4]</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberBits</NAME>
		<VALUE>0</VALUE>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int	i,k,j;
	static float a_A[16] = {1,3,0,-1,0,1,-1,-3,3,5,0,-3,0,3,-3,-5};
	static float b_A[16] = {1,0,3,1,-3,-1,-1,0,3,0,5,3,-5,-3,-3,0};

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

	for(i=0; i<4; i++) 
		array_A[i]=0;
	numberBits =0;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

	while(IT_IN(0)) {

		for(k=0; k<3; k++){
			j=3-k;
			array_A[j] = array_A[j-1];
		}
		array_A[0] = data(0);
			
		numberBits++;
		if(numberBits == 4){	
			numberBits=0;

			array_A[1] = array_A[1]*2;
			array_A[2] = array_A[2]*4;
			array_A[3] = array_A[3]*8;
 	
			i = 0;
			for (k=0; k<4;k++)
				i += array_A[k];	

  			if(IT_OUT(0)) {
				KrnOverflow("v29encoder",0) ;
				return(99);
			}
			
  			if(IT_OUT(1) ) {
				KrnOverflow("v29encoder",0) ;
				return(99);
			}
  			inPhase(0) = a_A[i];
  			quadPhase(0) = b_A[i];
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

