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

imgmux 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* imgmux.s.s */
/**********************************************************************
			imgmux.s()
***********************************************************************
Multiplex N input image channels to one output channel. 
The multiplexing order is from input channel 0 to N-1 for N input channels.
Auto-fanout is supported.
There are no parameters.
<NAME>
imgmux
</NAME>
<DESCRIPTION>
Multiplex N input image channels to one output channel. 
The multiplexing order is from input channel 0 to N-1 for N input channels.
Auto-fanout is supported.
There are no parameters.
</DESCRIPTION>
<PROGRAMMERS>
Programmer: L.J. Faber
Date: April, 1988.
Extended to images by Sasan Ardalan, June 2, 1993
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

    
<DESC_SHORT>
Multiplex N input image channels to one output channel. The multiplexing order is from input channel 0 to N-1 for N input channels.
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>inbufs</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>outbufs</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i,j,k;
	int buffer_id;
	image_t	img;

</DECLARATIONS> 

   
<INIT_CODE>
<![CDATA[ 

	if((inbufs = NO_INPUT_BUFFERS()) < 2
		|| (outbufs = NO_OUTPUT_BUFFERS()) < 1) {
		fprintf(stderr,"imgmux.s: i/o buffers connect problem\n");
		return(1);
	}
	for(i=0; i<inbufs; i++)
                SET_CELL_SIZE_IN(i,sizeof(image_t));
        for(i=0; i<outbufs; i++)
                SET_CELL_SIZE_OUT(i,sizeof(image_t));

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	for(i=MIN_AVAIL(); i>0; i--) {
		for(j=0; j<inbufs; j++) {
		    IT_IN(j);
		    img= INIMAGE(j,0);
		    for(k=0; k<outbufs; k++) {
				if(IT_OUT(k)) {
					KrnOverflow("imgmux.s",k);
					return(99);
				}
				OUTIMAGE(k,0) = img;
		    }
		}
	}

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

