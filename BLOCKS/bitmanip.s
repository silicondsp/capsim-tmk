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

bitmanip 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*
<NAME>
bitmanip
</NAME>
<DESCRIPTION>
Review code.
</DESCRIPTION>
<PROGRAMMERS>
Written by: Sasan H. Ardalan
Date: November 30, 1993
</PROGRAMMERS>
 */

]]>
</COMMENTS> 

<DESC_SHORT>
Review code.
</DESC_SHORT>

<INCLUDES>
<![CDATA[ 

#include "bits.h"

]]>
</INCLUDES> 

<DEFINES> 

#define GENERATOR_POLY 0x8005

</DEFINES> 

                                

<STATES>
	<STATE>
		<TYPE>UINT16</TYPE>
		<NAME>rx</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>UINT16</TYPE>
		<NAME>outBits</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>outBitsCount</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>outFlag</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>count</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>insertZero</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>shreg</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>bitCount</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>endFrame</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>begFlag</NAME>
		<VALUE>1</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>endFlag</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>fcs</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>frameCount</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>contFlag</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>ns</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>nss</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>nt</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>infoLengthBytes</NAME>
	</STATE>
	<STATE>
		<TYPE>char*</TYPE>
		<NAME>queue_A[8]</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberBitsCollected</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>UINT16</TYPE>
		<NAME>buildByte</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>buildByteBits</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>byteCount</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>bitsProc</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>nr</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>rej</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>rr</NAME>
		<VALUE>1</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>first</NAME>
		<VALUE>1</VALUE>
	</STATE>
	<STATE>
		<TYPE>FILE*</TYPE>
		<NAME>debug_F</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>infoComplete</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

unsigned short	carry;
int	bit;
int	i;
unsigned int	m;
int	numberOfSamples;
UINT16	checkStuff;
int	mask;
int	done;
int	bitPos;
int	bytePos;
int	rc;

</DECLARATIONS> 

       

<PARAMETERS>
<PARAM>
	<DEF>Number of bits per frame (Info Only)</DEF>
	<TYPE>int</TYPE>
	<NAME>numberOfBits</NAME>
	<VALUE>128</VALUE>
</PARAM>
<PARAM>
	<DEF>Debug:1=true,0=false</DEF>
	<TYPE>int</TYPE>
	<NAME>debugFlag</NAME>
	<VALUE>0</VALUE>
</PARAM>
</PARAMETERS>

    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
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

if(debugFlag) {
        debug_F=fopen("bitmanip.dbg","w");
        if(debug_F == NULL) return(2);
}
infoLengthBytes = numberOfBits/8+1;
for(i=0; i<8; i++) {
	queue_A[i]=(char*)calloc(infoLengthBytes,sizeof(char));
	if(queue_A[i]==NULL) {
		fprintf(stderr,"bitmanip could not allocate space\n");
		return(1);
	}
}

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 




while(IT_IN(0) ) {
       	/*
       	 * collect the bits
	 * and store them in a buffer
	 * first info frames are stored in queue zero
       	 */
       	bit=(int)(x(0)+0.001);
	buildByte |= bit;
	buildByteBits++;
if(debugFlag) 
	fprintf(debug_F,"bit=%d,buildByte=%4x,buildByteBits=%d,byteCount=%d\n",
		bit,buildByte,buildByteBits,byteCount);
	if(buildByteBits == 8) {

		queue_A[0][byteCount]=buildByte;
		buildByte=0;
		buildByteBits=0;
		byteCount++;
	}
	
	bitCount++;
	if(bitCount == numberOfBits) {
		infoComplete=1;
		queue_A[0][byteCount]=buildByte;
		byteCount=0;
		buildByte=0;
		buildByteBits=0;
		bitCount=0;
		break;
	}
	buildByte <<= 1;
}

if(infoComplete) {
   done=0;
   bitsProc=0;
   while(!done) {
       	/*
       	 * get a bit
       	 */
	bytePos=bitsProc >> 3;
	bitPos = 7-(bitsProc % 8);
	mask=1; mask <<= bitPos;
	bit = (queue_A[0][bytePos] & mask) ? 1:0;
if(debugFlag) 
	fprintf(debug_F,"output:bit=%d,queue=%4x,bitPos=%d,bytePos=%d\n", bit,queue_A[0][bytePos],bitPos,bytePos);
	bitsProc++;
	if(bitsProc == numberOfBits) { 
		endFrame=1;
		bitsProc=0;
	}
	/*
	 * Output bit
	 */
	if(IT_OUT(0) ){ KrnOverflow("bitmanip",0); return(99); }
	y(0) = bit;
	if(endFrame) {
		/*
		 * Finished outputting
		 * Reset everything
		 */
		frameCount++;

		done=1;
		infoComplete=0;
		endFrame=0;

	}
   }
	

}

	
return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

	fprintf(stderr,"bitmanip: number of outputted frames=%d\n",frameCount);
for(i=0; i<8; i++) 
	free(queue_A[i]);
	if(debugFlag)
		fclose(debug_F);

]]>
</WRAPUP_CODE> 



</BLOCK> 

