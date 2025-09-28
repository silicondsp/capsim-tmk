 
#ifdef LICENSE

/*  Capsim (r) Text Mode Kernel (TMK) Star Library (Blocks)
    Copyright (C) 1989-2002  XCAD Corporation 

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

    http://www.xcad.com
    XCAD Corporation
    Raleigh, North Carolina */

#endif
 
#ifdef SHORT_DESCRIPTION

Generate HDLC frame. Also queue (8 level) for retransmission

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
#define TRUE 1
#define FALSE 0


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      UINT16  __rx;
      UINT16  __outBits;
      int  __outBitsCount;
      int  __outFlag;
      int  __count;
      int  __insertZero;
      int  __shreg;
      int  __bitCount;
      int  __endFrame;
      int  __begFlag;
      int  __endFlag;
      int  __fcs;
      int  __frameCount;
      int  __contFlag;
      int  __nss;
      int  __nt;
      int  __infoLengthBytes;
      char*  __queue_A[8];
      int  __numberBitsCollected;
      UINT16  __buildByte;
      int  __buildByteBits;
      int  __byteCount;
      int  __bitsProc;
      int  __infoComplete;
      int  __nr;
      int  __rej;
      int  __rr;
      int  __first;
      FILE*  __debug_F;
      int  __totalBitsOutput;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define rx (state_P->__rx)
#define outBits (state_P->__outBits)
#define outBitsCount (state_P->__outBitsCount)
#define outFlag (state_P->__outFlag)
#define count (state_P->__count)
#define insertZero (state_P->__insertZero)
#define shreg (state_P->__shreg)
#define bitCount (state_P->__bitCount)
#define endFrame (state_P->__endFrame)
#define begFlag (state_P->__begFlag)
#define endFlag (state_P->__endFlag)
#define fcs (state_P->__fcs)
#define frameCount (state_P->__frameCount)
#define contFlag (state_P->__contFlag)
#define nss (state_P->__nss)
#define nt (state_P->__nt)
#define infoLengthBytes (state_P->__infoLengthBytes)
#define queue_A (state_P->__queue_A)
#define numberBitsCollected (state_P->__numberBitsCollected)
#define buildByte (state_P->__buildByte)
#define buildByteBits (state_P->__buildByteBits)
#define byteCount (state_P->__byteCount)
#define bitsProc (state_P->__bitsProc)
#define infoComplete (state_P->__infoComplete)
#define nr (state_P->__nr)
#define rej (state_P->__rej)
#define rr (state_P->__rr)
#define first (state_P->__first)
#define debug_F (state_P->__debug_F)
#define totalBitsOutput (state_P->__totalBitsOutput)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define x(DELAY) (*((float  *)PIN(0,DELAY)))
#define r(DELAY) (*((int  *)PIN(1,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define y(delay) *(float  *)POUT(0,delay)

/*         
 *    PARAMETER DEFINES 
 */ 
#define numberOfBits (param_P[0]->value.d)
#define debugFlag (param_P[1]->value.d)
/*-------------- BLOCK CODE ---------------*/


txhdlc 

(run_state,block_P)

	int run_state;
	block_Pt block_P;
{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

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
     char   *ptypeOut0 = "float";
     char   *pnameOut0 = "y";
KrnModelConnectionOutput(indexOC,0 ,pnameOut0,ptypeOut0);
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
     char   *ptypeIn1 = "int";
     char   *pnameIn1 = "r";
KrnModelConnectionInput(indexIC,0 ,pnameIn0,ptypeIn0);
KrnModelConnectionInput(indexIC,1 ,pnameIn1,ptypeIn1);
}
 break;

/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            rx=0;
       outBits=0;
       outBitsCount=0;
       outFlag=0;
       count=0;
       insertZero=0;
       shreg=0;
       bitCount=0;
       endFrame=0;
       begFlag=1;
       endFlag=0;
       fcs=0;
       frameCount=0;
       nss=0;
       nt=0;
       numberBitsCollected=0;
       buildByte=0;
       buildByteBits=0;
       byteCount=0;
       bitsProc=0;
       infoComplete=0;
       nr=1;
       rej=0;
       rr=1;
       first=1;
       totalBitsOutput=0;



         
   if(NO_OUTPUT_BUFFERS() != 1 ){
       fprintf(stdout,"%s:1 outputs expected; %d connected\n",
              STAR_NAME,NO_OUTPUT_BUFFERS());
	      return(201);
   }

   SET_CELL_SIZE_OUT(0,sizeof(float));

         
   if(NO_INPUT_BUFFERS() != 2 ){
       fprintf(stdout,"%s:2 inputs expected; %d connected\n",
              STAR_NAME,NO_INPUT_BUFFERS());
	      return(200);
   }

   SET_CELL_SIZE_IN(0,sizeof(float));

   SET_CELL_SIZE_IN(1,sizeof(int));

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

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


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


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


break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

	fprintf(stderr,"TxHDLC: number of outputted frames=%d\n",frameCount);
	fprintf(stderr,"TxHDLC: number of bits outputted =%d\n",totalBitsOutput);
for(i=0; i<8; i++) 
	free(queue_A[i]);
	if(debugFlag)
		fclose(debug_F);


break;
}
return(0);
}
