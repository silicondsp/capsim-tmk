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

mau 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*mau.s*/
/*
 * Inputs: 	in0:	The data from one direction 
 *		in1:	The data from the other direction	
 *		tx:	The data to be transmitted	
 * Outputs:	out0:	Transmit data in one direction	
 *		out1:	The transmit data in the other direction
 *		rx:	The received data 
 *		cd:	The Collision detect signal 
 *
 * Parameters:	bitTime: The width of a bit in samples 
 *
 * This star simulates an Ethernet media access unit (MAU or transceiver) 
 *
 *
 <NAME>
mau
</NAME>
<DESCRIPTION>
 * This star simulates an Ethernet media access unit (MAU or transceiver) 
 * Inputs: 	in0:	The data from one direction 
 *		in1:	The data from the other direction	
 *		tx:	The data to be transmitted	
 * Outputs:	out0:	Transmit data in one direction	
 *		out1:	The transmit data in the other direction
 *		rx:	The received data 
 *		cd:	The Collision detect signal 
 *
 * Parameters:	bitTime: The width of a bit in samples 
 *
 *
</DESCRIPTION>
<PROGRAMMERS>
Programmer: Prayson W. Pate
Date: September 18, 1987
</PROGRAMMERS>
 */

]]>
</COMMENTS> 

<DESC_SHORT>
This star simulates an Ethernet media access unit (MAU or transceiver)
</DESC_SHORT>


<DEFINES> 

#define DC_BIAS	-1.0 	/* DC voltage placed on cox when transmitting */
#define HI_LIMIT 0.0	/* Coax DC limit */
#define LOW_LIMIT -5.0	/* Coax DC LIMIT   */
#define CD_THRESHOLD -1.5	/* Collision detect threshold */
#define SQUELCH 0.175 	/* Transmit squelch threshold */
#define PEAK	0.7	/* Peak ac value on xcvr cable and coax */

</DEFINES> 

            

<STATES>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>tone</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>cd0</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>cd1</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>rx0</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>rx1</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>halfBit</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>cdCount</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>cdPole</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>rxPole</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>collision</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int	i;
	int	numberSamples;
	float	z;
	double fabs();
	float	txData;

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
		<NAME>in0</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>in1</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>tx</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
       

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>out0</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>out1</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>rx</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>cd</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

	collision=0;
	tone=1.0;
	cd0=0.0;
	cd1=0.0;
	cdCount=0;
	halfBit= bitTime >> 1;
	cdPole= 1.0/(8.0*bitTime);
	rxPole= 1.0/(3.0*bitTime);

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


for(numberSamples = MIN_AVAIL(); numberSamples > 0; -- numberSamples) {
	IT_IN(0);
	IT_IN(1);
	IT_IN(2);

	if(IT_OUT(0)) {
			KrnOverflow("mau",0);
			return(99);
	}
	if(IT_OUT(1) ) {
			KrnOverflow("mau",1);
			return(99);
	}
	if(IT_OUT(2) ) {
			KrnOverflow("mau",2);
			return(99);
	}
	if(IT_OUT(3)) {
			KrnOverflow("mau",3);
			return(99);
	}
	
	/*
	 * find dc levels on both sides 
 	 */
	
	rx0= (rxPole * in0(0)) + (1.0-rxPole)*rx0;
	rx1= (rxPole * in1(0)) + (1.0-rxPole)*rx1;
	
	/*
	 * output received network data
	 */
	
	z=tx(0) +(in0(0) - rx0) + (in1(0) - rx1);

	if(z > SQUELCH)
		rx(0) = PEAK;
	else if (z < -1.0 * SQUELCH)
		rx(0) = -1.0* PEAK;
	else
		rx(0) = 0.0;

	if(tx(0) > SQUELCH)
		txData = DC_BIAS + PEAK;
	else if ( tx(0) < ( -1.0 * SQUELCH))
		txData = DC_BIAS - PEAK;
	else
		txData = 0.0;

	/*
	 * Transmit data on medium out side 0
 	 */
	z= in1(0) + txData;
	if( z < LOW_LIMIT)
		out0(0) = LOW_LIMIT;
	else if(z > HI_LIMIT)
		out0(0) = HI_LIMIT;
	else
		out0(0)=z;

	/*
	 * transmit data on medium out side 1
	 */

	z= in0(0) + txData;

	if( z < LOW_LIMIT)
		out1(0) = LOW_LIMIT;
	else if (z > HI_LIMIT)
		out1(0) = HI_LIMIT;
	else
		out1(0)=z;		

	/*
	 * output collision tone
	 */

	cd0 = (cdPole* out0(0)) + (1.0-cdPole) * cd0;
	cd1 = (cdPole* out1(0)) + (1.0-cdPole) * cd1;
	
	if(( cd0 < CD_THRESHOLD ) || ( cd1 < CD_THRESHOLD))
		collision =1;
	else
		collision = 0; 

	if( collision || ( cdCount > 0)) {
		if(cdCount <=0)
			cdCount = bitTime;
		if(cdCount > halfBit)
			cd(0) = PEAK;
		else
			cd(0) = -1.0 * PEAK;
		--cdCount;
	}
	else
		cd(0) = 0.0;
}	

return(0);


]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

