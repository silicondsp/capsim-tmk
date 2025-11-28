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

inverse 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* invert.s */
/**********************************************************************
                          invert()
***********************************************************************
This star inverts  the incoming data stream and multiplies by  the parameter
coefficient after inversion , and outputs the resulting data values.
Specifically, 
	y= a/x
where x is the input sample.
Also, the value to use for 1/x in case x=0.0 is input as a parameter.
Auto fanout is supported.
<NAME>
invert
</NAME>
<DESCRIPTION>
This star inverts  the incoming data stream and multiplies by  the parameter
coefficient after inversion , and outputs the resulting data values.
Specifically, 
	y= a/x
where x is the input sample.
Also, the value to use for 1/x in case x=0.0 is input as a parameter.
Auto fanout is supported.
</DESCRIPTION>
<PROGRAMMERS>
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

   
<DESC_SHORT>
This star inverts  the incoming data stream and multiplies by  the parameter coefficient after inversion , and outputs the resulting data values.
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>obufs</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i;
	int samples;
	float val;
	float outVal;

</DECLARATIONS> 

       

<PARAMETERS>
<PARAM>
	<DEF>Gain factor</DEF>
	<TYPE>float</TYPE>
	<NAME>factor</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Infinity !</DEF>
	<TYPE>float</TYPE>
	<NAME>infinity</NAME>
	<VALUE>1.0e6</VALUE>
</PARAM>
</PARAMETERS>

    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>x</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

	if((obufs = NO_OUTPUT_BUFFERS()) <= 0) {
		fprintf(stdout,"gain: no output buffers\n");
		return(2);
	}

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


for(samples = MIN_AVAIL(); samples >0; --samples) {
	IT_IN(0);
	val = x(0);
	for(i=0; i<obufs; i++) {
		if (val ==0.0) 
			outVal = factor*infinity;
		else
			outVal=factor/val;
			
		if(IT_OUT(i)) {
			KrnOverflow("inverse",i);
			return(99);	
		}
		OUTF(i,0) = outVal;
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

