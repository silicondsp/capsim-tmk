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

tee 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* tee.s */
/******************************************************************
			tee() 
*******************************************************************
This star is a programmable tap-off for data lines.  It can be used
for example as a connector to print or plot stars.  It is inserted
into a connection line between two stars; input data flows to Output 0
unchanged.  Output 1 is a modified version of the input:
	Parameter 1: (int) number samples to output; default => all
		2: (int) index first sample; default => start from first
		3: (float) gain; default => unity gain
		4: (float) dc offset; default => no offset
Example:        to printfile
                    ^
                    |
                    |1
                 -------|
data line ---->0|  tee  |0-----> data line
                |_______|
<NAME>
tee
</NAME>
<DESCRIPTION>
This star is a programmable tap-off for data lines.  It can be used
for example as a connector to print or plot stars.  It is inserted
into a connection line between two stars; input data flows to Output 0
unchanged.  Output 1 is a modified version of the input:
	Parameter 1: (int) number samples to output; default => all
		2: (int) index first sample; default => start from first
		3: (float) gain; default => unity gain
		4: (float) dc offset; default => no offset
Example:        to printfile
                    ^
                    |
                    |1
                 -------|
data line ---->0|  tee  |0-----> data line
                |_______|
</DESCRIPTION>
<PROGRAMMERS>
Programmer: 	L.J. Faber
Date:		May 1988
Modified:
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

    
<DESC_SHORT>
This star is a programmable tap-off for data lines.
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>count</NAME>
		<VALUE>N</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>wait</NAME>
		<VALUE>first</VALUE>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i,j;
	float xval;

</DECLARATIONS> 

           

<PARAMETERS>
<PARAM>
	<DEF>Number of samples to output</DEF>
	<TYPE>int</TYPE>
	<NAME>N</NAME>
	<VALUE>30000</VALUE>
</PARAM>
<PARAM>
	<DEF>First sample to start from</DEF>
	<TYPE>int</TYPE>
	<NAME>first</NAME>
	<VALUE>0</VALUE>
</PARAM>
<PARAM>
	<DEF>Gain</DEF>
	<TYPE>float</TYPE>
	<NAME>gain</NAME>
	<VALUE>1.</VALUE>
</PARAM>
<PARAM>
	<DEF>DC Offset</DEF>
	<TYPE>float</TYPE>
	<NAME>offset</NAME>
	<VALUE>0.</VALUE>
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
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>xmod</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 


]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	for(i=MIN_AVAIL();i>0; --i) {
		IT_IN(0);
		xval = x(0);
		if(IT_OUT(0)) {
			KrnOverflow("tee",0);
			return(99);
		}
		y(0) = xval;
		if(wait-- <= 0 ) {
			if(count-- > 0) {
				if(IT_OUT(1)) {
					KrnOverflow("tee",0);
					return(99);
				}
				xmod(0) = gain * xval + offset;
			}
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

