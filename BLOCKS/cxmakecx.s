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

cxmakecx 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* cxmakecx.s */
/***************************************************************
		cxmakecx()
****************************************************************
	Inputs:	 	one or two channels	
	Outputs:	the complex channel	
	Parameters: 	None
****************************************************************
This block creates a complex buffer from one or two input buffers. 
If one input buffer(buffer 0) is connected, it is assumed to be the real part. 
The imaginary part of the complex output is set to zero.
If two input channels exist then the second channel (buffer 1) is assumed to be
the imaginary part of the complex output sample.
<NAME>
cxmakecx
</NAME>
<DESCRIPTION>
This block creates a complex buffer from one or two input buffers. 
If one input buffer(buffer 0) is connected, it is assumed to be the real part. 
The imaginary part of the complex output is set to zero.
If two input channels exist then the second channel (buffer 1) is assumed to be
the imaginary part of the complex output sample.
</DESCRIPTION>
<PROGRAMMERS>
Programmer:  	Sasan Ardalan	
Date:		September 4, 1991
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This block creates a complex buffer from one or two input buffers. 
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
	int 	i;
	complex calc;

</DECLARATIONS> 

   
<INIT_CODE>
<![CDATA[ 

       /* store as state the number of input/output buffers */
        if((numInBuffers = NO_INPUT_BUFFERS()) < 1) {
                fprintf(stderr,"cxmakecx: no input buffers\n");
                return(2);
        }
        if(numInBuffers >2 ) {
                fprintf(stderr,"cxmakecx: too many inputs connected\n");
                return(3);
        }
        if((numOutBuffers = NO_OUTPUT_BUFFERS()) < 1) {
                fprintf(stderr,"cxmakecx: no output buffers\n");
                return(4);
        }       
	for (i=0; i<numOutBuffers; i++)
                SET_CELL_SIZE_OUT(i,sizeof(complex));

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	/* note the minimum number of samples on the 	*/
	/* input buffers and iterate that many times 	*/
	
	for(no_samples=(MIN_AVAIL());no_samples >0; --no_samples) 

	{
		if(numInBuffers == 1) {
			/*
			 * only one input buffer connected 
			 * get the sample and set imaginary part to zero
			 */
			IT_IN(0);	
			a = INF(0,0);
			b=0.0;

		} else {
			/*
			 * two input  buffers  connected 
			 */
			IT_IN(0);	
			a = INF(0,0);
			IT_IN(1);	
			b = INF(1,0);
		}

               for(i=0; i<numOutBuffers; i++) {
			/*
			 * form complex sample and output on all connected
			 * output buffers
			 */
                        if(IT_OUT(i)) {
				KrnOverflow("cxmakecx",i);
				return(99);
			}
			calc.re = a;
			calc.im = b;
                        OUTCX(i,0) = calc;
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

