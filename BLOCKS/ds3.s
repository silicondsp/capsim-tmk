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

ds3 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/***************************************************************************
		ds3.s
****************************************************************************
This star is a self-contained third order delta sigma modulator.  Ouput 0
is the output of the circuit. Output 1 is the input to the comparator if
an output is connected.
-Parameter one: the gain of the first integrator
-Parameter two: the gain of the second integrator
-Parameter third: the gain of the third integrator
-Parameter fourth: the value for delta
<NAME>
ds3
</NAME>
<DESCRIPTION>
This star is a self-contained third order delta sigma modulator.  Ouput 0
is the output of the circuit. Output 1 is the input to the comparator if
an output is connected.
-Parameter one: the gain of the first integrator
-Parameter two: the gain of the second integrator
-Parameter third: the gain of the third integrator
-Parameter fourth: the value for delta
</DESCRIPTION>
<PROGRAMMERS>
Programmer:	John T. Stonick
Date:		February 1989
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This star is a self-contained third order delta sigma modulator. 
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 

#include <math.h>

]]>
</INCLUDES> 

              

<STATES>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>y</NAME>
		<VALUE>1.0</VALUE>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>a</NAME>
		<VALUE>0.0</VALUE>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>b</NAME>
		<VALUE>0.0</VALUE>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>c</NAME>
		<VALUE>0.0</VALUE>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>olda</NAME>
		<VALUE>0.0</VALUE>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>oldc</NAME>
		<VALUE>0.0</VALUE>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>olda1</NAME>
		<VALUE>0.0</VALUE>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>oldc1</NAME>
		<VALUE>0.0</VALUE>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>d</NAME>
		<VALUE>0.0</VALUE>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>e</NAME>
		<VALUE>0.0</VALUE>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>g</NAME>
		<VALUE>0.0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberOutputBuffers</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i;
	float x;
	float dd;
	float aa;
	float cc;
	float bb;
	float ee;
	float gg;

</DECLARATIONS> 

           

<PARAMETERS>
<PARAM>
	<DEF>Gain of first integrator</DEF>
	<TYPE>float</TYPE>
	<NAME>g1</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Gain of second integrator</DEF>
	<TYPE>float</TYPE>
	<NAME>g2</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Gain of third integrator</DEF>
	<TYPE>float</TYPE>
	<NAME>g3</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Binary Quantizer Level</DEF>
	<TYPE>float</TYPE>
	<NAME>delta</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
</PARAMETERS>

    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>in</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

       /* note and store the number of output buffers */
        if((numberOutputBuffers = NO_OUTPUT_BUFFERS() ) <= 0) {
                fprintf(stderr,"ds3: no output buffers\n");
                return(1); /* no output buffers */
        }
	if(numberOutputBuffers > 2) {
                fprintf(stderr,"ds3: more than two outputs\n");
                return(2); 
	}

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

while(IT_IN(0)) {

	x = in(0);
	g = x - y;
	gg = g1 * g;
	aa = a;
	a = aa + gg;
	b = aa - y;
	bb = g2 * b;
	cc = c;
	c = cc + bb;
	d = cc - y;
	dd = g3 * d;
	ee = e;
	e = ee + dd;
	y = delta;
	if(e < 0.0) y = 0.0 - delta;

	
	if(numberOutputBuffers==1) {
		if(IT_OUT(0) ) {
			KrnOverflow("ds3",0);
			return(99);
		}
		OUTF(0,0)=y;
	} else {
		if(IT_OUT(0) ) {
			KrnOverflow("ds3",0);
			return(99);
		}
		OUTF(0,0)=y;
		if(IT_OUT(1) ) {
			KrnOverflow("ds3",1);
			return(99);
		}
		OUTF(0,0)=e;

	}

}

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

