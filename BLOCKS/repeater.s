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

repeater 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*repeater.s*/
/*
 * Inputs: 	inLeft:	The  left input data signal 
 *		inRight:	The  right input data signal	
 *		cdLeft:	The left collision signal	
 *		cdRight:	The right collision signal	
 * Outputs:	outLeft:	The left output data signal	
 *		outRight:	The right output data signal 
 *
 * Parameters:	bitTime: The width of a bit in samples 
 *
 * This star simulates an Ethernet local repeater 
 *
 * Programmer: Prayson W. Pate
 * Date: September 28, 1987
 *
<NAME>
repeater
</NAME>
<DESCRIPTION>
 * Inputs: 	inLeft:	The  left input data signal 
 *		inRight:	The  right input data signal	
 *		cdLeft:	The left collision signal	
 *		cdRight:	The right collision signal	
 * Outputs:	outLeft:	The left output data signal	
 *		outRight:	The right output data signal 
 *
 * Parameters:	bitTime: The width of a bit in samples 
 *
 * This star simulates an Ethernet local repeater 
</DESCRIPTION>
<PROGRAMMERS>
 Prayson W. Pate
 Date: September 28, 1987
</PROGRAMMERS>
 */

]]>
</COMMENTS> 

<DESC_SHORT>
This star simulates an Ethernet local repeater 
</DESC_SHORT>


<DEFINES> 

#define DC_INIT	-4.0	
#define POLE 0.1
#define IDLE 0	/* idle: no data repeated */
#define LEFT_TO_RIGHT 1	/* Repeat data from left to right */
#define RIGHT_TO_LEFT 2 /* Repeat data from right to left */
#define COLL 3	/* Send jam signal on both sides */
#define JAM 4 	/* Send jam signal on both sides */
#define JAM_LIMIT 10
#define SQUELCH 0.175 	/* Transmit squelch threshold */
#define PEAK	0.7	/* Peak ac value on xcvr cable and coax */

</DEFINES> 

          

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>direction</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>dataLeft</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>dataRight</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>collLeft</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>collRight</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>jamCount</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>bitCount</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>hiState</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int	i;
	int	numberSamples;
	double fabs();

</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF>The width of a bit in samples</DEF>
	<TYPE>int</TYPE>
	<NAME>bitTime</NAME>
	<VALUE>8</VALUE>
</PARAM>
</PARAMETERS>

       

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>inLeft</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>cdLeft</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>inRight</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>cdRight</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
     

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>outLeft</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>outRight</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

	direction = IDLE;
	dataLeft=0.0;
	dataRight = 0.0;
	collRight =0.0;
	collLeft = 0.0;
	jamCount = 0;
	bitCount = 0;
	hiState=0;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


for(numberSamples = MIN_AVAIL(); numberSamples > 0; -- numberSamples) {
	IT_IN(0);
	IT_IN(1);
	IT_IN(2);
	IT_IN(3);

	if(IT_OUT(0)) {
		KrnOverflow("repeater",0);
		return(99);
	}
	if(IT_OUT(1)) {
		KrnOverflow("repeater",1);
		return(99);
	}

	dataLeft = (1.0-POLE)*dataLeft + POLE*fabs(inLeft(0));
	dataRight = (1.0-POLE)*dataRight + POLE*fabs(inRight(0));
	
	collLeft = (1.0-POLE)*collLeft + POLE*fabs(cdLeft(0));
	collRight = (1.0-POLE)*collRight + POLE*fabs(cdRight(0));

	switch(direction) {
		case IDLE:
			if(dataLeft > SQUELCH)
				direction = LEFT_TO_RIGHT;
			else if (dataRight > SQUELCH)
				direction = RIGHT_TO_LEFT;
			else if ((collLeft > SQUELCH) || (collRight > SQUELCH))
				direction = COLL;
			outLeft(0) = 0.0;
			outRight(0) = 0.0;
			break;

		case LEFT_TO_RIGHT:
			if (dataLeft <= SQUELCH) {
				direction = IDLE;
				outRight(0) =0.0;
			} else {
				/*
				 * Repeat data from left to right 
				 */
				if ( inLeft(0) > 0.0 ) 
					outRight(0) = PEAK;
				else
					outRight(0) = -1.0 * PEAK;
			}
			/*
			 * Squelch data from right to left
			 */
			outLeft(0) = 0.0;

			if(( collLeft > SQUELCH ) || ( collRight > SQUELCH))
				direction = COLL;
			break;
			
		case RIGHT_TO_LEFT:
			if ( dataRight <= SQUELCH) {
				direction=IDLE;
				outLeft(0) = 0.0;
			}
			else {
				/*
				 * Repeat data from right to left 
				 */

				if( inRight(0) > 0.0 )
					outLeft(0) = PEAK;
				else
					outLeft(0) = -1.0*PEAK;
			}
			
			/*
			 * Squelch data from left to right
			 */
			outRight(0) = 0.0;
			if((collLeft > SQUELCH ) || ( collRight > SQUELCH))
				direction= COLL;
			break;

		case COLL:

			if (hiState) {
				if( bitCount < bitTime) {
					outLeft(0) = PEAK;
					outRight(0) = PEAK;
				}
				else {
					hiState = 0;
					bitCount = 0;
					outLeft(0) = -1.0*PEAK;
					outRight(0) = -1.0*PEAK;
				}
			}
			else {
				if(bitCount < bitTime) {
					outLeft(0) = -1.0 * PEAK;
					outRight(0) = -1.0 * PEAK;
				}
				else {

					hiState =1;
					bitCount = 0;
					outLeft(0) = PEAK;
					outRight(0) = PEAK;
				}
			}
			++bitCount;
			if(( collLeft < SQUELCH) && (collRight < SQUELCH)) {
				jamCount =0;
				direction = JAM;
			}
		case JAM:
			if(hiState) {
				if (bitCount < bitTime ) {
					outLeft(0) = PEAK;
					outRight(0) = PEAK;
				}
				else {
					hiState = 0;
					bitCount = 0;
					outLeft(0) = -1.0*PEAK;
					outRight(0) = -1.0*PEAK;
				}
			}
			else {
				if( bitCount < bitTime) {
					outLeft(0) = -1.0*PEAK;
					outRight(0) = -1.0*PEAK;
				}
				else {
					hiState = 1;
					bitCount = 0;
					outLeft(0) = PEAK;
					outRight(0) = PEAK;
					++jamCount;
				}
			}
			++bitCount;
			if((collLeft > SQUELCH ) || (collRight > SQUELCH)) {
				jamCount = 0;
				direction = COLL;
			}
			else if ( jamCount > JAM_LIMIT) {
				direction = IDLE;
				jamCount = 0;
			}
			break;
		default:
			fprintf(stderr,"Repeater in illegal state %i ",direction);
			return(1);
			break;
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

