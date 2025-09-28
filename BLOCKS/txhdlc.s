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
/*
 * 
 * Written by: Sasan H. Ardalan
 * Date: November 30, 1993
 */

</LICENSE>
<BLOCK_NAME>

txhdlc 

</BLOCK_NAME> 



<NAME>
txhdlc
</NAME>
<DESCRIPTION>
Generate HDLC frame. Also queue (8 level) for retransmission
</DESCRIPTION>
<PROGRAMMERS>
 Written by: Sasan H. Ardalan
 Date: November 30, 1993
</PROGRAMMERS>


<DESC_SHORT>
Generate HDLC frame. Also queue (8 level) for retransmission
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 

#include "bits.h"

]]>
</INCLUDES> 

<DEFINES> 

#define GENERATOR_POLY 0x8005
#define TRUE 1
#define FALSE 0

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
		<NAME>infoComplete</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>nr</NAME>
		<VALUE>1</VALUE>
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
		<NAME>totalBitsOutput</NAME>
		<VALUE>0</VALUE>
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
int	wait;

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
	<BUFFER>
		<TYPE>int</TYPE>
		<NAME>r</NAME>
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
        debug_F=fopen("txhdlc.dbg","w");
        if(debug_F == NULL) return(2);
}
rx=0;
outBitsCount=8;
outBits=0x7e00;
begFlag=1;
infoLengthBytes = numberOfBits/8+1;
for(i=0; i<8; i++) {
	queue_A[i]=(char*)calloc(infoLengthBytes,sizeof(char));
	if(queue_A[i]==NULL) {
		fprintf(stderr,"txhdlc could not allocate space\n");
		return(1);
	}
}

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


if(IT_IN(1)) {
	if(first) {
		nt=0;
		nr=0;
		wait=FALSE;
		rr=1;
		rej=0;
		first=0;
if(debugFlag)
	fprintf(debug_F,"txhdlc: first nt=%d nr=%d \n",nt,nr);
	} else {
		wait=FALSE;
		rc=r(0);
		nr=rc&0x07;
		rc &= 0xf0;
		rej=(rc == 0x90) ? 1:0;
		rr= (rc == 0x80) ? 1:0;
		if(rej) {
if(debugFlag)
	fprintf(debug_F,"txhdlc: reject nt=%d nr=%d \n",nt,nr);
			nt= nr;
			if(nt < 0) nt=7;
		}	
		else {
if(debugFlag)
		fprintf(debug_F,"txhdlc: accept nt=%d nr=%d \n",nt,nr);
			nt=nr;
		}
	}
} else {

	wait=TRUE;
}


if(!rej  ) { 
 while(IT_IN(0)) {
       	/*
       	 * collect the bits
	 * and store them in a buffer
	 * first info frames are stored in queue zero
       	 */
       	bit=(int)(x(0)+0.001);
	buildByte |= bit;
	buildByteBits++;
	if(buildByteBits == 8) {
		queue_A[nss][byteCount]=buildByte;
		buildByte=0;
		buildByteBits=0;
		byteCount++;
	}
	buildByte <<= 1;
	
	bitCount++;
	if(bitCount == numberOfBits) {
		nss++;
		nss %= 8;
		infoComplete=1;
		byteCount=0;
		buildByte=0;
		buildByteBits=0;
		bitCount=0;
		break;
	}
  }
}

if(wait)
	return(0);

if(( infoComplete)   || rej) {
  if(rr) infoComplete=0;
  done=0;
  bitsProc=0;
  while(!done) {
  /*
   * output HDLC Frame
   */

    contFlag=1;
    while(contFlag) {
      if(!insertZero) { 
	if(outBitsCount) {
		bit= (0x8000 & outBits) ? 1:0;
		outBits <<= 1;
		outBitsCount--;
		if(begFlag && !outBitsCount) {
			begFlag=0;
			/*
			 * send address and control
			 */
			outBits=0x0000 | (nt << 3);
			outBitsCount=16;
		}
		if(fcs && !outBitsCount) {
			/*
			 * Finished outputting FCS now get ready to
			 * output end flag with no zero stuffing
			 */
			outBits=0x7e7e;
			outBitsCount=16;
			fcs=0;
			endFlag=1;
		}
	  } else {
        	/*
        	 * collect the bits
        	 */
		bytePos=bitsProc/8;
		bitPos = 7-(bitsProc % 8);
		mask=1; mask <<= bitPos;
		bit = (queue_A[nt][bytePos] & mask) ? 1:0;
		bitsProc++;
		if(bitsProc == numberOfBits) { 
			endFrame=1;
			bitsProc=0;
		}
	  }
	  /*
	   * compute FCS without bit stuffing
	   */
          if( !(endFlag || begFlag || fcs )) {
		/*
		 * ignore flags when computing FCS
		 * also do not compute when outputting FCS itself
		 */
    		carry=(rx&0x8000) ? 1:0;
    		rx <<= 1;
    		rx ^= ((bit ^ carry) ? GENERATOR_POLY:0);
    	  }
      } else {
		/*
		 * stuff a zero and reset flag
		 */
		bit=0;
		insertZero=0;
      }
      shreg |= bit;
      checkStuff= shreg & 0x1f;
      if(checkStuff == 0x1f &&   !begFlag && !endFlag) {	
		/*
		 * five consecutive ones
		 * set zero insert flag
		 */
		insertZero=1;
      }
      /*
       * Output bit
       */
      if(IT_OUT(0) ){ KrnOverflow("txhdlc",0); return(99); }
      y(0) = bit;
      totalBitsOutput++;
      if(endFrame) {
	/*
	 * set fcs so that FCS is output but remainder is not computed
	 */
	fcs=1;
	outBits=rx;
	outBitsCount=16;
	endFrame=0;
      }
      if(endFlag && !outBitsCount) {
	/*
	 * Finished outputting Info and FCS
	 * and end flag
	 * Reset everything
	 */
	begFlag=1;
	outBits=0x7e00;
	outBitsCount=8;
	rx=0;
	fcs=0;
	shreg=0;
	frameCount++;
	endFlag=0;

	done=1;
	contFlag=0;
	insertZero=0;

      }
	

#if 0
	fprintf(stderr,"shreg=%x bit=%d\n",shreg,bit);
#endif
      if(!done) {
    	shreg <<= 1;
    	shreg &= 0x1f;
    	if(outBitsCount ) 
		contFlag=1;
    	else
		contFlag=0;
      }
    }
  }
}

	
return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

	fprintf(stderr,"TxHDLC: number of outputted frames=%d\n",frameCount);
	fprintf(stderr,"TxHDLC: number of bits outputted =%d\n",totalBitsOutput);
for(i=0; i<8; i++) 
	free(queue_A[i]);
	if(debugFlag)
		fclose(debug_F);

]]>
</WRAPUP_CODE> 



</BLOCK> 

