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

ethline 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*ethline.s*/
/*
 * Inputs: 
 *	
 * Outputs:	
 *
 * Parameters:	SamplesDelay: The Delay of the cable
 *
 * This star simulates an Ethernet cable.
 * If it is connected as a one-port it acts as a termination. If
 * connected as a two-port, it acts as a delay line of length samplesDelay 
 *
 * Programmer: Prayson W. Pate
 * Date: September 24, 1987
<NAME>
ethline
</NAME>
<DESCRIPTION>
 *
 * This star simulates an Ethernet cable.
 * If it is connected as a one-port it acts as a termination. If
 * connected as a two-port, it acts as a delay line of length samplesDelay 
 *
 * Parameters:	SamplesDelay: The Delay of the cable
</DESCRIPTION>
<PROGRAMMERS>
  Programmer: Prayson W. Pate
  Date: September 24, 1987
</PROGRAMMERS>
 *
 */

]]>
</COMMENTS> 

<DESC_SHORT>
This star simulates an Ethernet cable.
</DESC_SHORT>


<DEFINES> 

#define DC_INIT 0.0

</DEFINES> 

     

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>first</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>term</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>dc</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int	i;
	int	numberSamples;
	int	numberInputBuffers;
	int	numberOutputBuffers;

</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF>The delay of the line in samples</DEF>
	<TYPE>int</TYPE>
	<NAME>samplesDelay</NAME>
	<VALUE>0</VALUE>
</PARAM>
</PARAMETERS>

<INIT_CODE>
<![CDATA[ 

	if (!((samplesDelay >= 0) && (samplesDelay < 100))) {
		fprintf(stderr,"line: parameter out of range");
		return(1);
	}
	numberInputBuffers=NO_INPUT_BUFFERS();
	numberOutputBuffers=NO_OUTPUT_BUFFERS();
	if(numberInputBuffers <1 ) {
		fprintf(stderr,"line: Too few inputs");
		return(2);
	}
	if(numberInputBuffers  > 2 ) {
		fprintf(stderr,"line: Too many  inputs");
		return(3);
	}
	if(numberOutputBuffers   < 1 ) {
		fprintf(stderr,"line: Too few outputs");
		return(4);
	}
	if(numberOutputBuffers   > 2 ) {
		fprintf(stderr,"line: Too many outputs");
		return(5);
	}
	if(numberOutputBuffers    != numberInputBuffers ) {
		fprintf(stderr,"line: mismatched inputs and outputs ");
		return(6);
	}
	if(numberInputBuffers == 1)
		term=1;
	else
		term=0;
fprintf(stderr,"Term = %d \n",term);
	first=1;
	dc = DC_INIT;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

if(first) {
	first=0;
	i=0;
	while ( i< samplesDelay) {
		if(term) {
			if(IT_OUT(0)) {
				KrnOverflow("ethline",0);
				return(99);
			}
			OUTF(0,0) = 0.0;
		} else {
			if(IT_OUT(0)) {
				KrnOverflow("ethline",0);
				return(99);
			}
			if(IT_OUT(1)) {
				KrnOverflow("ethline",1);
				return(99);
			}
			OUTF(0,0)=0.0;
			OUTF(1,0) = 0.0;
		}
		++i;
	}
}

for(numberSamples = MIN_AVAIL(); numberSamples > 0; -- numberSamples) {
	if(term) {
		IT_IN(0);
		if(IT_OUT(0)) {
				KrnOverflow("ethline",0);
				return(99);
		}
		OUTF(0,0) =dc;
	}
	else {
		IT_IN(0);
		IT_IN(1);
		if(IT_OUT(0)) {
				KrnOverflow("ethline",0);
				return(99);
		}
		if(IT_OUT(1)) {
				KrnOverflow("ethline",1);
				return(99);
		}

		OUTF(0,0)= INF(1,0);
		OUTF(1,0)= INF(0,0);
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

