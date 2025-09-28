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

avrow 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* avrow.s */
/***********************************************************************
                             avrow()
************************************************************************
<NAME>
avrow
</NAME>
<DESCRIPTION>
Average rows of a matrix
</DESCRIPTION>
<PROGRAMMERS>
Programmer: 	Sasan Ardalan
</PROGRAMMERS>	
*/

]]>
</COMMENTS> 

<DESC_SHORT>
Average rows of a matrix
</DESC_SHORT>
<INCLUDES>
<![CDATA[ 

#include <math.h>

]]>
</INCLUDES> 

      

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>fftl</NAME>
	</STATE>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>buffer</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>pointCount</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>rowCount</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int numberSamples;
	int i,j;

</DECLARATIONS> 

       

<PARAMETERS>
<PARAM>
	<DEF>Size of row </DEF>
	<TYPE>int</TYPE>
	<NAME>row</NAME>
	<VALUE>144</VALUE>
</PARAM>
<PARAM>
	<DEF>Number of rows to average</DEF>
	<TYPE>int</TYPE>
	<NAME>numberRows</NAME>
	<VALUE>1</VALUE>
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

	if ((buffer = (float*)calloc(row,sizeof(float))) == NULL)
	{
		fprintf(stderr,"avrow: can't allocate work space \n");
		return(2);
	}

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

	for (numberSamples = MIN_AVAIL(); numberSamples > 0; --numberSamples)
	{
		{
			/*
			 * real input buffer
			 */
			IT_IN(0);
			buffer[pointCount] += x(0);
			pointCount++;

		}	

			

		/* 
		 * Get enough points				
		 */
		if(pointCount >= row)
		{
		 	if(rowCount >= numberRows) {	
			   /* 
			    * now, output complex pairs		
			    */
			    for (i=0; i<row; i++) {
				if(IT_OUT(0)) {
					KrnOverflow("avrow",0);
					return(99);
				}
				y(0) = buffer[i]/numberRows;
			    }
			    rowCount = 0;
			    for (i=0; i<row; i++) buffer[i]=0.0; 
			}
			rowCount++;
			pointCount = 0;
		}
	}
	return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

	/* free up allocated space	*/
	free((char*)buffer);

]]>
</WRAPUP_CODE> 



</BLOCK> 

