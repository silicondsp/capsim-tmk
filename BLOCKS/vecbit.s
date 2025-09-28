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

vecbit 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* vecbit.s */
/***********************************************************************
                             vecbit()
************************************************************************
This star converts a byte input vector to a digital stream.
<NAME>
vecbit
</NAME>
<DESCRIPTION>
This star converts a byte input vector to a digital stream.
</DESCRIPTION>
<PROGRAMMERS>
Programmer:  	Sasan Ardalan	
Date: 		Nov. 22, 1993
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This star converts a byte input vector to a digital stream.
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 

#include <math.h>
#include "bits.h"

]]>
</INCLUDES> 

    

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>blockNumber</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>FILE*</TYPE>
		<NAME>fp</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int no_samples;
	int i,j,k,kk;
	long	templ;
	shortVector_t	vector;
	byteVector_t 	codedBlock;
	unsigned char byte;
	int	bitCount;
	int	bit;
	int	mask;
	short	*decode_P;

</DECLARATIONS> 

   
    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>byteVector_t</TYPE>
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


]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

for (no_samples = MIN_AVAIL(); no_samples > 0; --no_samples) {
	/*
	 * collect the vector
	 */
	IT_IN(0);
	codedBlock=x(0);
	for(i=0; i<codedBlock.length; i++) {
	    byte=codedBlock.vector_P[i];
	    mask=1;
	    for(j=0; j<8; j++) {  
		bit = (byte & mask) ? 1:0;
		mask <<= 1;
        	/*
        	 * Output bits 
        	 */
           	if(IT_OUT(0) ){ KrnOverflow("vecbit",0); return(99); }
       	     	y(0) = bit;
	    }


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

