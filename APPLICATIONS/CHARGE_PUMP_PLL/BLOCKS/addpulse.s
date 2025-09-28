<BLOCK>
<LICENSE>
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
</LICENSE>
<BLOCK_NAME>

addpulse 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* addpulse.s */
/**********************************************************************
                          addpulse()
***********************************************************************
This block adds a pulse with specified number of samples to skip to  the incoming data stream.
Auto fanout is supported.
<NAME>
addpulse
</NAME>
<DESCRIPTION>
This block adds a pulse with specified number of samples to skip to  the incoming data stream.
Auto fanout is supported.
</DESCRIPTION>
<PROGRAMMERS>
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

   
<DESC_SHORT>
This block adds a pulse with specified number of samples to skip to  the incoming data stream.
Auto fanout is supported.
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>long</TYPE>
		<NAME>count</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>widthCount</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>done</NAME>
	</STATE>
	
	
	<STATE>
		<TYPE>int</TYPE>
		<NAME>obufs</NAME>
	</STATE>	
</STATES>
 
<DECLARATIONS> 

	int i;
	int samples;
	float val;

</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF>Amplitude</DEF>
	<TYPE>float</TYPE>
	<NAME>amplitude</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Pulse Width</DEF>
	<TYPE>int</TYPE>
	<NAME>width</NAME>
	<VALUE>1</VALUE>
</PARAM>
<PARAM>
	<DEF>Sample Number to Start Addition</DEF>
	<TYPE>int</TYPE>
	<NAME>insert</NAME>
	<VALUE>0</VALUE>
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
    count=0;
    widthCount=0;
    done=0;

	if((obufs = NO_OUTPUT_BUFFERS()) <= 0) {
		fprintf(stderr,"addpulse: no output buffers\n"); 
		return(2);
	}

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


for(samples = MIN_AVAIL(); samples >0; --samples) {
	IT_IN(0);
	count++;
	val =  x(0);
	
	if(count > insert && !done) {
	     widthCount++;
	     if(widthCount  < width) {
	          val=val+amplitude;
	     } else {
	         done=1;
	     }
	}
	for(i=0; i<obufs; i++) {
		if(IT_OUT(i)) {
			KrnOverflow("addpulse",i);
			return(99);
		}
		OUTF(i,0) = val;
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

