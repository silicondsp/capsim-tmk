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

bitvec 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* bitvec.s */
/***********************************************************************
                             bitvec()
************************************************************************
<NAME>
bitvec
</NAME>
<DESCRIPTION>
This block converts a bit stream to variable length vectors.
Note that the END of a stream segment is designated by an 0xff followed by
a non zero byte. 
Each segment is packed into bytes. A vector with a pointer to the
bytes and  the length of the vector is output. The output contains the
0xFF and following byte.
At the beginning, a 16 byte array is allocated. If more bytes are needed
a reallocation takes place.
</DESCRIPTION>
<PROGRAMMERS>
Programmer:  	Sasan Ardalan	
Date: 		Nov. 22, 1993
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This block converts a bit stream to variable length vectors.
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 

#include <math.h>
#include "bits.h"

]]>
</INCLUDES> 

       

<STATES>
	<STATE>
		<TYPE>UINT8</TYPE>
		<NAME>byteval</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>bitCount</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>byteCount</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>UINT8*</TYPE>
		<NAME>vect_P</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>markerFlag</NAME>
		<VALUE>0</VALUE>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int no_samples;
	int i,j,k,kk;
	long	templ;
	byteVector_t 	codedBlock;
	int	bit;
	short	*decode_P;

</DECLARATIONS> 

   
    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>y</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
    

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>byteVector_t</TYPE>
		<NAME>x</NAME>
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
	 * collect the bits 
	 */
	IT_IN(0);
	bit=(int)(y(0)+0.001);
	byteval |= (bit << bitCount); 
	bitCount += 1;
	if(bitCount == 8) {
		if(vect_P==NULL) {
			vect_P=(unsigned char*)malloc(16*sizeof(char));
			if(vect_P == NULL) {
			   fprintf(stderr,"bitvec: could not allocate space\n");
			   return(2);
 			}
		}
		vect_P[byteCount]=byteval;
		byteCount++;
		if(!(byteCount % 16)) {
			/*
			 * time to reallocate vect_P in 16 byte chunks
			 */
			vect_P=(unsigned char*)realloc((char*)vect_P,
					sizeof(char)*(byteCount+16));
			if(vect_P == NULL) {
			   fprintf(stderr,"bitvec: could not allocate space\n");
			   return(3);
 			}

		}
		if(markerFlag) {
		   if(byteval) {
			/*
			 * found marker
			 * package vector and length and output
			 */
			codedBlock.length=byteCount;
			codedBlock.vector_P=vect_P;
           		if(IT_OUT(0) ){ KrnOverflow("bitvec",0); return(99); }
       	     		x(0) = codedBlock;
			/*
			 * set vect_P to NULL so that it will be allocated 
			 * for next segment
			 */
			vect_P=NULL;
			/*
			 * reset all others
			 */
			byteCount=0;
			markerFlag=0;
	

		   } else {
			/*
			 * 0xFF followed by a zero. Treat as regular data
			 * so reset markerFlag
			 */
			markerFlag=0;

		   }
		}
		if(byteval == 0xff) {
			markerFlag=1;
		} 
		byteval=0;
		bitCount=0;

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

