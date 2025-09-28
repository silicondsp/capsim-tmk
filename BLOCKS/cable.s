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

cable 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*cable.s*/
/*
 * Inputs: 	txIn: The transmit data out
 *		rxIn:	The receive data out
 *		cdIn:	The collision data out
 * Outputs:	TxOut:	Transmit data out
 *		RxOut	The receive data out
 *		CdOut	The Collision out
 *
 * Parameters:	SamplesDelay: The Delay of the cable
 *
 * This star simulates an Ethernet transceiver cable by introducing a
 * fixed delay
 *
 * Programmer: Prayson W. Pate
 * Date: September 29, 1987
 *
<NAME>
cable
</NAME>
<DESCRIPTION>
* Inputs: 	txIn: The transmit data out
 *		rxIn:	The receive data out
 *		cdIn:	The collision data out
 * Outputs:	TxOut:	Transmit data out
 *		RxOut	The receive data out
 *		CdOut	The Collision out
 *
 * Parameters:	SamplesDelay: The Delay of the cable
 *
 * This star simulates an Ethernet transceiver cable by introducing a
 * fixed delay
</DESCRIPTION>
<PROGRAMMERS>
Programmer: Prayson W. Pate
Date: September 29, 1987
</PROGRAMMERS>
 */

]]>
</COMMENTS> 

   
<DESC_SHORT>
This star simulates an Ethernet transceiver cable by introducing a fixed delay
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>first</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int	i;
	int	numberSamples;

</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF>The delay of the cable in samples</DEF>
	<TYPE>int</TYPE>
	<NAME>samplesDelay</NAME>
	<VALUE>0</VALUE>
</PARAM>
</PARAMETERS>

      

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>txIn</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>rxIn</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>cdIn</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
      

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>txOut</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>rxOut</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>cdOut</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

	if ((samplesDelay >= 0) && (samplesDelay < 100))
	;
	else {
		fprintf(stderr,"cable: parameter out of range");
		return(1);
	}
	first=1;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

if(first) {
	first=0;
	i=0;
	while ( i< samplesDelay) {
	if(IT_OUT(0)) {
		KrnOverflow("cable",0);
		return(99);
	}
	if(IT_OUT(1)) {
		KrnOverflow("cable",1);
		return(99);
	}
	if(IT_OUT(2)) {
		KrnOverflow("cable",2);
		return(99);
	}

	rxOut(0)=0.0;
	txOut(0)= 0.0;
	cdOut(0) = 0.0;
	++i;
	}
}

for(numberSamples = MIN_AVAIL(); numberSamples > 0; -- numberSamples) {
	IT_IN(0);
	IT_IN(1);
	IT_IN(2);


	if(IT_OUT(0)) {
		KrnOverflow("cable",0);
		return(99);
	}
	if(IT_OUT(1)) {
		KrnOverflow("cable",1);
		return(99);
	}
	if(IT_OUT(2)) {
		KrnOverflow("cable",2);
		return(99);
	}
	rxOut(0)=rxIn(0);
	txOut(0)=txIn(0);
	cdOut(0)=cdIn(0);
}
return(0);


]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

