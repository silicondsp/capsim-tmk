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

cubepoly 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* cubepoly.s */
/**********************************************************************
			cubepoly()
***********************************************************************
Implements a cubic polynomial nonlinearity of the form:
       output = a*x + b*x^2 + c*x^3,
         where x = input
       All signals and params are REAL.
      There are 3 parameters: a, b, c.
<NAME>
cubepoly
</NAME>
<DESCRIPTION>
Implements a cubic polynomial nonlinearity of the form:
       output = a*x + b*x^2 + c*x^3,
         where x = input
       All signals and params are REAL.
      There are 3 parameters: a, b, c.
</DESCRIPTION>
<PROGRAMMERS>
Programmer: R.A. Nobakht
Date:	    4/89
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
mplements a cubic polynomial nonlinearity of the form: output = a*x + b*x^2 + c*x^3, where x = input
</DESC_SHORT>


<DECLARATIONS> 

	float 	tmp,tmp2;

</DECLARATIONS> 

         

<PARAMETERS>
<PARAM>
	<DEF>linear coefficient</DEF>
	<TYPE>float</TYPE>
	<NAME>a</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF>quadratic coefficient</DEF>
	<TYPE>float</TYPE>
	<NAME>b</NAME>
	<VALUE>0.0</VALUE>
</PARAM>
<PARAM>
	<DEF>cubic coefficient</DEF>
	<TYPE>float</TYPE>
	<NAME>c</NAME>
	<VALUE>0.0</VALUE>
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
			KrnOverflow("cubepoly",0);
			return(99);
	    }
	    tmp = x(0);
	    tmp2=tmp*tmp;
            y(0) = a*tmp + b*tmp2 + c*tmp*tmp2;
        }
	return(0);


]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

