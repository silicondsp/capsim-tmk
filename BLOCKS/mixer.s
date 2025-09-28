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

mixer 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/************************************************************************
 *									*
 *	mixer.s:	mixer (multiplier)				*
 *									*
 *	parameters:	none						*
 *									*
 *	inputs:		x, one of the two inputs to be multiplied	*
 *			y, one of the two inputs to be multiplied	*
 *									*
 *	outputs:	z, the product of x and y			*
 *									*
 *	description:	This star takes two inputs and produces 	*
 *			their product.					*
 *									*
 *			written by John T. Stonick			*
 *									*
<NAME>
mixer
</NAME>
<DESCRIPTION>
 *	inputs:		x, one of the two inputs to be multiplied	*
 *			y, one of the two inputs to be multiplied	*
 *									*
 *	outputs:	z, the product of x and y			*
 *									*
 *	description:	This star takes two inputs and produces 	*
 *			their product.					*
</DESCRIPTION>
<PROGRAMMERS>
 John T. Stonick	
</PROGRAMMERS>
 ************************************************************************/

]]>
</COMMENTS> 

<DESC_SHORT>
  This star takes two inputs and produces their product.	
</DESC_SHORT>

<DECLARATIONS> 

	int no_samples;

</DECLARATIONS> 

   
     

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>x</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>y</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
    

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>z</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 


]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

	for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) {
		IT_IN(0);
		IT_IN(1);
		if(IT_OUT(0)) {
			KrnOverflow("mixer",0);
			return(99);
		}
		z(0)=x(0)*y(0);
	}

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

