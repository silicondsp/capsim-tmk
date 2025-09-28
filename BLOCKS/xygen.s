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

xygen 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* xygen.s */
/***************************************************************************
                          xygen()
*****************************************************************************
<NAME>
xygen
</NAME>
<DESCRIPTION>
Generate xy sweep
</DESCRIPTION>
<PROGRAMMERS>
Programmer:	Sasan Ardalan
Date:		April 1991	
</PROGRAMMERS>
*****************************************************************************/

]]>
</COMMENTS> 

<DESC_SHORT>
Generate xy sweep
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 

#include <math.h>

]]>
</INCLUDES> 

<DEFINES> 

#define PI 3.1415926

</DEFINES> 

      

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberOfRows</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>samplesOut</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>no_inbuf</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>no_outbuf</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

     int i,j;
     float step,ramp;

</DECLARATIONS> 

             

<PARAMETERS>
<PARAM>
	<DEF>Matrix Dimension</DEF>
	<TYPE>int</TYPE>
	<NAME>matrixDim</NAME>
	<VALUE>32</VALUE>
</PARAM>
<PARAM>
	<DEF>Minimum x</DEF>
	<TYPE>float</TYPE>
	<NAME>xMin</NAME>
	<VALUE>0.0</VALUE>
</PARAM>
<PARAM>
	<DEF>x step</DEF>
	<TYPE>float</TYPE>
	<NAME>xStep</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Minimum y</DEF>
	<TYPE>float</TYPE>
	<NAME>yMin</NAME>
	<VALUE>0.0</VALUE>
</PARAM>
<PARAM>
	<DEF>y step</DEF>
	<TYPE>float</TYPE>
	<NAME>yStep</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
</PARAMETERS>

     

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>x</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>y</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

numberOfRows=0;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


if (numberOfRows >= matrixDim) return(0);

for(i=0; i< matrixDim; i++) {

	if(IT_OUT(0)) {
			KrnOverflow("xygen",0);
			return(99);
	}
	ramp = i*xStep+xMin;
	x(0) = ramp; 
	if(IT_OUT(1)) {
			KrnOverflow("xygen",1);
			return(99);
	}
	step= numberOfRows*yStep + yMin;
	y(0)=step;
}
numberOfRows++;
	
         
return(0);


]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

