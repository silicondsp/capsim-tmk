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

integrate 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/************************************************************************
 *									*
 *	integrate.s:		integrator 				*
 *									*
 *	parameters:	leakage factor   	 			*
 *									*
 *	inputs:		in, the signal to be integrated			*
 *									*
 *	outputs:	out, the integrated signal			*
 *									*
 *	description:	This block implements aleacky integrator  	*
 *			recursive equation:				*
 *			y(n)=factor*y(n-1)+x(n)			*
 *									*
 *									*
<NAME>
integrate
</NAME>
<DESCRIPTION>
This block implements aleacky integrator recursive equation:				
			y(n)=factor*y(n-1)+x(n)
</DESCRIPTION>
<PROGRAMMERS>
</PROGRAMMERS> 
 ************************************************************************/

]]>
</COMMENTS> 

<DESC_SHORT>
This block implements aleacky integrator recursive equation:	y(n)=factor*y(n-1)+x(n)
</DESC_SHORT>

<DECLARATIONS> 


</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF><![CDATA[leakage factor  <= 1.0]]></DEF>
	<TYPE>float</TYPE>
	<NAME>factor</NAME>
	<VALUE> 1.0</VALUE>
</PARAM>
</PARAMETERS>

    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>in</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
     

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>out</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 


]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

	while(IT_IN(0))
	{
		if(IT_OUT(0)) {
			KrnOverflow("integrate",0);
			return(99);
		}
		out(0)=factor*out(1)+in(0);
	}

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

