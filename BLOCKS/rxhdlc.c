 
#ifdef LICENSE

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

#endif
 
#ifdef SHORT_DESCRIPTION

Process an HDLC frame and generate ACK and NACK. Use only in ARQ simulation

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 

#include "bits.h"


 

#define GENERATOR_POLY 0x8005


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int  __byteCount;
      int  __numberBytes;
      UINT8*  __vect_P;
      UINT16  __buildByte;
      int  __buildByteBits;
      UINT16  __acc;
      int  __count;
      UINT16  __shreg;
      UINT16  __fcsshreg;
      int  __bitCount;
      int  __endFrame;
      int  __fcs;
      int  __frameCount;
      int  __errorCount;
      int  __correctCount;
      int  __contFlag;
      int  __done;
      int  __removeZero;
      int  __first;
      int  __first2;
      int  __begFrame;
      int  __fcsReg;
      int  __fcsbit;
      int  __blocktFCS;
      int  __bit;
      int  __rxFrameFlag;
      int  __rxBitFlag;
      int  __frameBits;
      int  __nr;
      int  __errorFlag;
      FILE*  __debug_F;
      int  __totalBitsInput;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define byteCount (state_P->__byteCount)
#define numberBytes (state_P->__numberBytes)
#define vect_P (state_P->__vect_P)
#define buildByte (state_P->__buildByte)
#define buildByteBits (state_P->__buildByteBits)
#define acc (state_P->__acc)
#define count (state_P->__count)
#define shreg (state_P->__shreg)
#define fcsshreg (state_P->__fcsshreg)
#define bitCount (state_P->__bitCount)
#define endFrame (state_P->__endFrame)
#define fcs (state_P->__fcs)
#define frameCount (state_P->__frameCount)
#define errorCount (state_P->__errorCount)
#define correctCount (state_P->__correctCount)
#define contFlag (state_P->__contFlag)
#define done (state_P->__done)
#define removeZero (state_P->__removeZero)
#define first (state_P->__first)
#define first2 (state_P->__first2)
#define begFrame (state_P->__begFrame)
#define fcsReg (state_P->__fcsReg)
#define fcsbit (state_P->__fcsbit)
#define blocktFCS (state_P->__blocktFCS)
#define bit (state_P->__bit)
#define rxFrameFlag (state_P->__rxFrameFlag)
#define rxBitFlag (state_P->__rxBitFlag)
#define frameBits (state_P->__frameBits)
#define nr (state_P->__nr)
#define errorFlag (state_P->__errorFlag)
#define debug_F (state_P->__debug_F)
#define totalBitsInput (state_P->__totalBitsInput)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define x(DELAY) (*((float  *)PIN(0,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define y(delay) *(byteVector_t  *)POUT(0,delay)
#define rack(delay) *(int  *)POUT(1,delay)

/*         
 *    PARAMETER DEFINES 
 */ 
#define numberOfBits (param_P[0]->value.d)
#define debugFlag (param_P[1]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

rxhdlc 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

UINT16	stuffCheck;
UINT16	flagCheck;
unsigned short	carry;
int	i;
int	numberOfSamples;
byteVector_t	codedBlock;
int	ns;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Number of bits per frame (Info Only)";
     char   *ptype0 = "int";
     char   *pval0 = "128";
     char   *pname0 = "numberOfBits";
     char   *pdef1 = "Debug:1=true,0=false";
     char   *ptype1 = "int";
     char   *pval1 = "0";
     char   *pname1 = "debugFlag";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);

      }
break;
   


/*         
 *    OUTPUT BUFFER SYSTEM  INITS 
 */ 
 case OUTPUT_BUFFER_INIT: 
 {
 int indexOC = block_P->model_index;
     char   *ptypeOut0 = "byteVector_t";
     char   *pnameOut0 = "y";
     char   *ptypeOut1 = "int";
     char   *pnameOut1 = "rack";
KrnModelConnectionOutput(indexOC,0 ,pnameOut0,ptypeOut0);
KrnModelConnectionOutput(indexOC,1 ,pnameOut1,ptypeOut1);
}
 break;

/*         
 *    INPUT BUFFER SYSTEM  INITS 
 */ 
 case INPUT_BUFFER_INIT:
 {
 int indexIC = block_P->model_index;
     char   *ptypeIn0 = "float";
     char   *pnameIn0 = "x";
KrnModelConnectionInput(indexIC,0 ,pnameIn0,ptypeIn0);
}
 break;

/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            byteCount=0;
       numberBytes=0;
       buildByte=0;
       buildByteBits=0;
       acc=0;
       count=0;
       shreg=0;
       fcsshreg=0;
       bitCount=0;
       endFrame=0;
       fcs=0;
       frameCount=0;
       errorCount=0;
       correctCount=0;
       done=0;
       removeZero=0;
       first=1;
       first2=1;
       begFrame=0;
       fcsReg=0;
       blocktFCS=0;
       bit=0;
       rxFrameFlag=0;
       rxBitFlag=0;
       frameBits=0;
       nr=0;
       errorFlag=0;
       totalBitsInput=0;



         
   if(NO_OUTPUT_BUFFERS() != 2 ){
       fprintf(stdout,"%s:2 outputs expected; %d connected\n",
              STAR_NAME,NO_OUTPUT_BUFFERS());
	      return(201);
   }

   SET_CELL_SIZE_OUT(0,sizeof(byteVector_t));

   SET_CELL_SIZE_OUT(1,sizeof(int));

         
   if(NO_INPUT_BUFFERS() != 1 ){
       fprintf(stdout,"%s:1 inputs expected; %d connected\n",
              STAR_NAME,NO_INPUT_BUFFERS());
	      return(200);
   }

   SET_CELL_SIZE_IN(0,sizeof(float));

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

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


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


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
		if(blocktFCS) {
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
			blocktFCS=0;
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
		 * reset and blockt over. 
		 * reject frame and request retransmission
		 */
			frameBits=0;
			endFrame=1;
			first=1;
			begFrame=0;
			shreg=0;
			fcsshreg=0;
			acc=0;
			blocktFCS=0;
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
	if(blocktFCS) {
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
			blocktFCS=0;
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
		 * blockt FCS after first FLAG
		 * delay also allows time to check for end of frame flag
		 * so that it is not used in computation of FCS
		 */
		if(count == 10) { 
			blocktFCS=1;
		
			if(debugFlag)
				   fprintf(debug_F,"Begin blocktFCS\n");
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
			blocktFCS=0;
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


break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

	fprintf(stderr,"RxHDLC: number of received frames=%d\n",frameCount);
	fprintf(stderr,"RxHDLC: number of bits received %d\n",totalBitsInput);
	fprintf(stderr,"RxHDLC: number of errors =%d\n",errorCount);
	fprintf(stderr,"RxHDLC: number of correct frames =%d\n",correctCount);
	if(debugFlag)
		fclose(debug_F);


break;
}
return(0);
}
