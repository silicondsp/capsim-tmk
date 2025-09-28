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

encoder 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*encoder.s*/
/*
 * Inputs: 	 
 *		x:	The  digital data stream	
 * Outputs:		
 *		y:	The encoded output	
 *
 * Parameters:	codeType:  Coding technique 
 *
 * This star  encodes incoming data accoding to the first parameter 
 * as listed below:
 * Type	name				"0" code	"1" code
 * ---------------------------------------
 * 0	non-return-to -zero (NRZ)	-1		+1
 * 1	manchester			-1 +1		+1 -1
 * 2 	differential manchester		[-1]+1 -1	[-1]-1+1
 * 					[+1]-1 +1	[+1]+1 -1
 * 3	partial response		(0) 0		(0) 1
 *					(1) -1		(1) 0
 * 4	alternate mark inversion (AMI)	0		alt. +1 and -1
 *
 * Type	Name		levels		codes
 * ------------------------------------------------------
 * 5	2B1Q		4		-3,-1,1,3
 *
 * Type  Name		"0" code		"1" code
 * 6	Return-to-zero (RZ) 	0 -1		0 +1
 *
 * Programmer: Prayson Pate
 * Date: 	August 31, 1987
 *
<NAME>
encoder
</NAME>
<DESCRIPTION>
 *
 * Parameters:	codeType:  Coding technique 
 *
 * This star  encodes incoming data accoding to the first parameter 
 * as listed below:
 * Type	name				"0" code	"1" code
 * ---------------------------------------
 * 0	non-return-to -zero (NRZ)	-1		+1
 * 1	manchester			-1 +1		+1 -1
 * 2 	differential manchester		[-1]+1 -1	[-1]-1+1
 * 					[+1]-1 +1	[+1]+1 -1
 * 3	partial response		(0) 0		(0) 1
 *					(1) -1		(1) 0
 * 4	alternate mark inversion (AMI)	0		alt. +1 and -1
 *
 * Type	Name		levels		codes
 * ------------------------------------------------------
 * 5	2B1Q		4		-3,-1,1,3
 *
 * Type  Name		"0" code		"1" code
 * 6	Return-to-zero (RZ) 	0 -1		0 +1
 * Inputs: 	 
 *		x:	The  digital data stream	
 * Outputs:		
 *		y:	The encoded output	
</DESCRIPTION>
<PROGRAMMERS>
</PROGRAMMERS> 
 */

]]>
</COMMENTS> 

<DESC_SHORT>
This star  encodes incoming data accoding to the first parameter:NRZ,Manchester,Diff Manchester,Partial Response,AMI,2B1Q,RZ
</DESC_SHORT>


<DEFINES> 

#define NRZ	0
#define MANCHESTER 	1
#define DIFFERENTIAL_MANCHESTER	2
#define PARTIAL_RESPONSE 3
#define AMI	4
#define _2B1Q 5
#define RZ	6

</DEFINES> 

   

<STATES>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>sign</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int	i;
	int	numberSamples;
	float	thisX,thisY,lastX,lastY;

</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF>Code Type:0=NRZ,1=manch,2=diff_manch,3=part_resp,4=AMI,5=2B1Q,6=RZ</DEF>
	<TYPE>int</TYPE>
	<NAME>codeType</NAME>
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

	if(!(codeType >= 0) && (codeType <=6))
	{
		fprintf(stderr,"encoder: code type %d is not allowed",
			codeType);
		return(1);
	}
	sign= -1.0;
	lastX= 0;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


for(numberSamples = MIN_AVAIL(); numberSamples > 0; -- numberSamples) {
	if(codeType == _2B1Q) {
		if(numberSamples > 1)
			IT_IN(0);
		else
			return(0);
	}
	else 
		IT_IN(0);
	if(x(0) > 0.5) 
		thisX = 1;
	else
		thisX = 0;
	
	switch (codeType) {
		case  NRZ:
			if(IT_OUT(0)) {
				KrnOverflow("encoder",0);
				return(99);
			}
			if(thisX) 
				y(0)= 1.0;
			else
				y(0) = -1.0;
			break;
		case MANCHESTER:
			if(thisX) {
				if(IT_OUT(0)) {
					KrnOverflow("encoder",0);
					return(99);
				}
				y(0)= -1.0;
				if(IT_OUT(0)) {
					KrnOverflow("encoder",0);
					return(99);
				}
				y(0) = 1.0;
			}
			else {
				if(IT_OUT(0)) {
					KrnOverflow("encoder",0);
					return(99);
				}
				y(0)= 1.0;
				if(IT_OUT(0)) {
					KrnOverflow("encoder",0);
					return(99);
				}
				y(0) = -1.0;
			}
			break;
		case DIFFERENTIAL_MANCHESTER:
			if(y(0) > 0.0)
				lastY = 1;
			else
				lastY=0;
			if(thisX) {
				if(lastY) {
					if(IT_OUT(0)) {
						KrnOverflow("encoder",0);
						return(99);
					}
					y(0) = 1.0;
					if(IT_OUT(0)) {
						KrnOverflow("encoder",0);
						return(99);
					}
					y(0) = -1.0;
				}
				else {
					if(IT_OUT(0)) {
						KrnOverflow("encoder",0);
						return(99);
					}
					y(0) = -1.0;
					if(IT_OUT(0)) {
						KrnOverflow("encoder",0);
						return(99);
					}
					y(0) = 1.0;
				}
			}
			else {
				if(lastY) {
					if(IT_OUT(0)) {
						KrnOverflow("encoder",0);
						return(99);
					}
					y(0) = -1.0;
					if(IT_OUT(0)) {
						KrnOverflow("encoder",0);
						return(99);
					}
					y(0) = 1.0;
				}
				else {
					if(IT_OUT(0)) {
						KrnOverflow("encoder",0);
						return(99);
					}
					y(0)= 1.0;
					if(IT_OUT(0)) {
						KrnOverflow("encoder",0);
						return(99);
					}
					y(0) = -1.0;
				}
			}
			break;
		case PARTIAL_RESPONSE:
			if(thisX) {
					if(IT_OUT(0)) {
						KrnOverflow("encoder",0);
						return(99);
					}
				if(lastX) {
					y(0)=0.0;
				}
				else {
					y(0) = 1.0;
				}
			}
			else {
				if(IT_OUT(0)) {
					KrnOverflow("encoder",0);
					return(99);
				}
				if(lastX) {
					y(0) = 0.0;
				}
				else {
					y(0) = 0.0;
				}
			}
			break;
		case AMI:
			if(IT_OUT(0)) {
				KrnOverflow("encoder",0);
				return(99);
			}
			if(thisX) {
				y(0) = sign;
				sign = 0.0 - sign;
			} 
			else {
				y(0) = 0.0;
			}
			break;
		case _2B1Q:
			--numberSamples;
			IT_IN(0);
			if(IT_OUT(0)) {
				KrnOverflow("encoder",0);
				return(99);
			}

			if(thisX) {
				if(x(0) > 0.5) 
					y(0) = 3.0;
				else 
					y(0) = 1.0;
			}
			else {
				if(x(0) > 0.5)
					y(0) = -1.0;
				else
					y(0) = -3.0;
			}
			break;
		case RZ:
			if(IT_OUT(0)) {
				KrnOverflow("encoder",0);
				return(99);
			}
			y(0)= 0.0;
			if(thisX) {
				if(IT_OUT(0)) {
					KrnOverflow("encoder",0);
					return(99);
				}
				y(0) = 1.0;
			}
			else {
				if(IT_OUT(0)) {
					KrnOverflow("encoder",0);
					return(99);
				}
				y(0) = -1.0;
			}
			break;
		
	}
	lastX=thisX;	
			
}	


return(0);


]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

