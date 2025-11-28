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

rxhdlc 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*
 * 
 * Written by: Sasan H. Ardalan
 * Date: November 30, 1993
 */
 /*
  * IMPORTANT:
  *  This star assumes that an HDLC frame worth of bits is on its input buffer.
  *  To guarantee this, make sure that the input is comming from a galaxy
  *  This way the galaxy (data pump) will consume all of its input bits
  * from the transmitter, and output them on its output terminal before
  * returning control to the connected block ( rxhdlc in this case).
  * If you do not do this, there is no gaurantee that a whole Frame (damaged
  * or not) is at the input buffer. It could arrive in pieces. 
  * The reason for requiring this, is so that rxhdlc can asses whether a 
  * damaged flag exists or other conditions.
  * If this condition is not to be detected then the code must be modified.
  * A more elaborate scheme must be devised to detect damaged frame flags.
  * See main_code at the if(rxframeFlag) statement. If input has been
  * exausted and this flag has not been set ( either correct
  * an FCS error or abort) then flags were damaged.
  */
/*
<NAME>
rxhdlc
</NAME>
<DESCRIPTION>
Process an HDLC frame and generate ACK and NACK. Use only in ARQ simulation
  * IMPORTANT:
  *  This star assumes that an HDLC frame worth of bits is on its input buffer.
  *  To guarantee this, make sure that the input is comming from a galaxy
  *  This way the galaxy (data pump) will consume all of its input bits
  * from the transmitter, and output them on its output terminal before
  * returning control to the connected block ( rxhdlc in this case).
  * If you do not do this, there is no gaurantee that a whole Frame (damaged
  * or not) is at the input buffer. It could arrive in pieces. 
  * The reason for requiring this, is so that rxhdlc can asses whether a 
  * damaged flag exists or other conditions.
  * If this condition is not to be detected then the code must be modified.
  * A more elaborate scheme must be devised to detect damaged frame flags.
  * See main_code at the if(rxframeFlag) statement. If input has been
  * exausted and this flag has not been set ( either correct
  * an FCS error or abort) then flags were damaged.
</DESCRIPTION>
<PROGRAMMERS>
Written by: Sasan H. Ardalan
Date: November 30, 1993
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
Process an HDLC frame and generate ACK and NACK. Use only in ARQ simulation
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
		<TYPE>int</TYPE>
		<NAME>byteCount</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberBytes</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>UINT8*</TYPE>
		<NAME>vect_P</NAME>
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
		<TYPE>UINT16</TYPE>
		<NAME>acc</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>count</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>UINT16</TYPE>
		<NAME>shreg</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>UINT16</TYPE>
		<NAME>fcsshreg</NAME>
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
		<NAME>errorCount</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>correctCount</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>contFlag</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>done</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>removeZero</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>first</NAME>
		<VALUE>1</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>first2</NAME>
		<VALUE>1</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>begFrame</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>fcsReg</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>fcsbit</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>startFCS</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>bit</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>rxFrameFlag</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>rxBitFlag</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>frameBits</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>nr</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>errorFlag</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>FILE*</TYPE>
		<NAME>debug_F</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>totalBitsInput</NAME>
		<VALUE>0</VALUE>
	</STATE>
</STATES>
 
<DECLARATIONS> 

UINT16	stuffCheck;
UINT16	flagCheck;
unsigned short	carry;
int	i;
int	numberOfSamples;
byteVector_t	codedBlock;
int	ns;

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
		<TYPE>byteVector_t</TYPE>
		<NAME>y</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>int</TYPE>
		<NAME>rack</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

/*
 * account for address and control and FCS 
 * we will ignore on output
 */
numberBytes=numberOfBits/8+1+1+1+2;
acc=0;
if(debugFlag) {
	debug_F=fopen("rxhdlc.dbg","w");
	if(debug_F == NULL) return(2);
}

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


if(first2) {

	IT_OUT(1);
	nr=0;
	rxFrameFlag=1;
	rack(0) = 0x80 | nr;
}
first2=0;

while(IT_IN(0)) {
	rxBitFlag=1;
	/*
	 * output the bit check if address+cntrl+info+FCS
 	 * also ignore if removing a zero
	 */
	if(!removeZero && begFrame) {
		/*
		 */ 
		fcsshreg |= bit;
		if(startFCS) {
			fcsbit = (0x100 & fcsshreg) ? 1:0;
			{
				carry=(acc&0x8000) ? 1:0;
				acc <<= 1;
				acc ^= ((fcsbit ^ carry) ? GENERATOR_POLY:0);
			}
		}
#if 1
if(debugFlag)
	fprintf(debug_F,"shreg=%4x fcsshreg=%4x fcsbit=%d bit=%d acc=%4x\n",shreg,fcsshreg,fcsbit,bit,acc);
#endif
		fcsshreg <<= 1;
		buildByte |= bit;
		buildByteBits++;
		if(buildByteBits == 8) {
			vect_P[byteCount]=buildByte;
			buildByte=0;
			buildByteBits=0;
			byteCount++;
		}
		buildByte <<= 1;
		frameBits++;
		/*
		 * check if received bits  exceeds payload size plus address
		 * control,and FCS
		 */
		if(frameBits > numberOfBits +8+8+16+8) {
			/*
			 * If exceeds then we have an error condition.
			 * Possiblility is that end flag corrupted.
			 * In this case we request retransmission as if error
			 * occured.
			 * We must also flush out input buffer.
			 */
			frameBits=0;
			endFrame=1;
			first=1;
			begFrame=0;
			shreg=0;
			fcsshreg=0;
			acc=0;
			startFCS=0;
			bit=0;
			count=0;

			/*
			 * get ns from transmitted frame
			 */
			ns=vect_P[1];
			ns = ns >> 3;
			ns = ns & 0x07;
			
			IT_OUT(1);
			rack(0) = 0x90 | nr;
			rxFrameFlag=1;
			if(debugFlag)
				fprintf(debug_F,"Bad End Flag Received NS=%d NR %d\n",ns,nr);
			/*
			 * Flush input port
			 */
			while(IT_IN(0));
			break;
		}
	}
	else
		removeZero=0;


     	/*
      	 * collect the bits
       	 */
       	bit=(int)(x(0)+0.001);
	totalBitsInput++;

	shreg |= bit;
	stuffCheck=shreg & 0x3f;
	if(stuffCheck == 0x3e ) {	
		if(debugFlag)
			fprintf(debug_F,"Unstuff zero condition\n");
		removeZero=1;
	}
	stuffCheck=shreg & 0x7f;
	if(stuffCheck == 0x7f ) {	
		if(debugFlag)
			fprintf(debug_F,"Abort condition\n");

		/*
		 * reset and start over. 
		 * reject frame and request retransmission
		 */
			frameBits=0;
			endFrame=1;
			first=1;
			begFrame=0;
			shreg=0;
			fcsshreg=0;
			acc=0;
			startFCS=0;
			bit=0;
			count=0;

			/*
			 * get ns from transmitted frame
			 */
			ns=vect_P[1];
			ns = ns >> 3;
			ns = ns & 0x07;
			
			IT_OUT(1);
			rack(0) = 0x90 | nr;
			rxFrameFlag=1;
			if(debugFlag)
				fprintf(debug_F,"Abort Received NS=%d NR %d\n",ns,nr);
			/*
			 * Flush input port
			 */
			while(IT_IN(0));
			break;
	}
	/*
	 * Frame Check Sequence
	 */
	if(startFCS) {
	}
	/*
	 * check if FLAG (beginning or end)
	 */
	flagCheck=shreg & 0xff;
	if(flagCheck == 0x7e) {
		/*
		 * found a flag
		 */
		removeZero=0;
		if(first) {
			/*
			 * beginning of frame flag
			 */
			acc=0;
			first=0;
			begFrame=1;
			if(debugFlag)
				fprintf(debug_F,"Start Flag\n");
			frameCount++;
			bitCount=0;
			/*
			 * beginning of frame
			 * allocate vector of bytes 
			 */
			
			vect_P=(char*)calloc(numberBytes,sizeof(char));
			byteCount=0;
			buildByte=0;
			buildByteBits=0;
#if 1
			/*
			 * a trick to not include last bit of flag in
			 * output vector
			 */
			removeZero=1;
#endif
		}
		else {
			/*
			 * end of frame flag
		 	 */
			if(debugFlag)
				fprintf(debug_F,"END Flag\n");
			if(shreg == 0x7e7e) {
				/*
				 * Two consecutive flags encountered.
				 * Set state to beginning
				 * flag 
				 */
				count=0;
				fcsshreg =  0;
				acc=0;
				shreg=0x7e;
				first=0;
				begFrame=1;
				byteCount=0;
				buildByte=0;
				buildByteBits=0;
				removeZero=1;
				frameBits=0;

			} else {
			frameBits=0;
			fcsshreg =  0;
			for(i=0; i<2; i++) {
				/*
				 * Flush FCS
				 */
				fcsshreg <<=1;
				fcsbit = (0x100 & fcsshreg) ? 1:0;
				{
					carry=0;
					acc <<= 1;
					acc ^= ((fcsbit ^ carry) ? GENERATOR_POLY:0);
				}
#if 0
fprintf(stderr,"Flushing fcsshreg=%4x acc=%4x \n",fcsshreg,acc);
#endif
			}
			errorFlag=0;
			if( acc) { 
				errorFlag=1;
				if(debugFlag)
				   fprintf(debug_F,"Frame Error\n");
				errorCount++;

			}  
			else
				correctCount++;
			endFrame=1;
			first=1;
			begFrame=0;
			shreg=0;
			fcsshreg=0;
			acc=0;
			startFCS=0;
			bit=0;
			count=0;

			/*
			 * get ns from transmitted frame
			 */
			ns=vect_P[1];
			ns = ns >> 3;
			ns = ns & 0x07;
			
    			if(!errorFlag) {
			   if(IT_OUT(0) ){ KrnOverflow("rxhdlc",0);return(99);}
			   codedBlock.vector_P=&vect_P[2];
			   codedBlock.length=byteCount-2-2;
			   if(codedBlock.length > numberBytes) {
				fprintf(debug_F,"rxhdlc: bad frame length=%d\n",
					codedBlock.length);
				codedBlock.length=numberBytes;
			   }
    			   y(0) = codedBlock; 
			}
		
			IT_OUT(1);
			if(errorFlag) {
				rxFrameFlag=1;
				rack(0) = 0x90 | nr;
			} else {
				nr++;
				nr %= 8;
				rxFrameFlag=1;
				rack(0) = 0x80 | nr;

			}
			if(debugFlag)
				fprintf(debug_F,"Received NS=%d NR %d\n",ns,nr);
			} /*end double flag */

			
		}
	} 
	shreg <<= 1;
	if(begFrame ) {
		/*
		 * start FCS after first FLAG
		 * delay also allows time to check for end of frame flag
		 * so that it is not used in computation of FCS
		 */
		if(count == 10) { 
			startFCS=1;
		
			if(debugFlag)
				   fprintf(debug_F,"Begin startFCS\n");
		}
		count++;
	} 
	
}
if(!rxFrameFlag && rxBitFlag) {
	/*
	 * Bad news all input bits exhausted but no frame encountered.
	 * This could be due to the fact that a flag got corrupted
	 * In this case request retransmission and reset every thing
	 */
			frameBits=0;
			endFrame=1;
			first=1;
			begFrame=0;
			shreg=0;
			fcsshreg=0;
			acc=0;
			startFCS=0;
			bit=0;
			count=0;
			/*
			 * reject and request retransmission
			 */
			IT_OUT(1);
			rack(0) = 0x90 | nr;
			rxFrameFlag=1;
			if(debugFlag)
				fprintf(debug_F,"Damaged Frame:NR %d\n",nr);

}
rxFrameFlag=0;
rxBitFlag=0;

return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

	fprintf(stderr,"RxHDLC: number of received frames=%d\n",frameCount);
	fprintf(stderr,"RxHDLC: number of bits received %d\n",totalBitsInput);
	fprintf(stderr,"RxHDLC: number of errors =%d\n",errorCount);
	fprintf(stderr,"RxHDLC: number of correct frames =%d\n",correctCount);
	if(debugFlag)
		fclose(debug_F);

]]>
</WRAPUP_CODE> 



</BLOCK> 

