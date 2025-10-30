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

sink 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* sink.s */
/*********************************************************************
			sink()
**********************************************************************
This block absorbs data from an arbitrary number of input buffers.
It is useful to terminate temporarily unconnected outputs.
<NAME>
sink
</NAME>
<DESCRIPTION>
This block absorbs data from an arbitrary number of input buffers.
It is useful to terminate temporarily unconnected outputs.
</DESCRIPTION>
<PROGRAMMERS>
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

   
<DESC_SHORT>
This block absorbs data from an arbitrary number of input buffers.
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>no_ibuf</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int j;
	int no_samples;

</DECLARATIONS> 

   
<INIT_CODE>
<![CDATA[ 

	if((no_ibuf = NO_INPUT_BUFFERS()) <= 0) {
		fprintf(stderr,"sink: no input buffers\n");
		return(1); /* no input buffers */
	}

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	for(j=0; j<no_ibuf; j++)
        	for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) 
			IT_IN(j);

	return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

