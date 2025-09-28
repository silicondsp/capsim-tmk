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

cxmakereal 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* cxmakereal.s */
/***************************************************************
		cxmakereal()
****************************************************************
	Inputs:	 	one complex  channels	
	Outputs:	two real channels for the real and imaginary parts 	
	Parameters: 	None
****************************************************************
This star creates a two real  buffers from one complex input buffer. 
If one output buffer(buffer 0) is connected, only the  real part is output. 
If two input channels exist then the second channel (buffer 1) is 
the imaginary part of the complex input sample.
<NAME>
cxmakereal
</NAME>
<DESCRIPTION>
This star creates a two real  buffers from one complex input buffer. 
If one output buffer(buffer 0) is connected, only the  real part is output. 
If two input channels exist then the second channel (buffer 1) is 
the imaginary part of the complex input sample.
</DESCRIPTION>
<PROGRAMMERS>
Programmer:  	Sasan Ardalan	
Date:		September 4, 1991
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This star creates a two real  buffers from one complex input buffer.
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 

#include <math.h>

]]>
</INCLUDES> 

    

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numOutBuffers</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numInBuffers</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int no_samples;
	float a,b;
	complex inSamp;

</DECLARATIONS> 

   
<INIT_CODE>
<![CDATA[ 

       /* store as state the number of input/output buffers */
        if((numInBuffers = NO_INPUT_BUFFERS()) < 1) {
                fprintf(stderr,"cxmakereal: no input buffers\n");
                return(2);
        }
        if(numInBuffers >1 ) {
                fprintf(stderr,"cxmakecx: too many inputs connected\n");
                return(3);
        }
        if((numOutBuffers = NO_OUTPUT_BUFFERS()) < 1) {
                fprintf(stderr,"cxmakecx: no output buffers\n");
                return(4);
        }       
        SET_CELL_SIZE_IN(0,sizeof(complex));

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	/* note the minimum number of samples on the 	*/
	/* input buffers and iterate that many times 	*/
	
	for(no_samples=(MIN_AVAIL() );no_samples >0; --no_samples) 

	{
		IT_IN(0);	
		inSamp = INCX(0,0);

		if(numOutBuffers == 1) {
                        if(IT_OUT(0)) {
				KrnOverflow("cxmakereal",0);
				return(99);
			}
                        OUTF(0,0) = inSamp.re;
		} else {
                        if(IT_OUT(0)) {
				KrnOverflow("cxmakereal",0);
				return(99);
			}
                        OUTF(0,0) = inSamp.re;
                        if(IT_OUT(1)) {
				KrnOverflow("cxmakereal",1);
				return(99);
			}
                        OUTF(1,0) = inSamp.im;

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

