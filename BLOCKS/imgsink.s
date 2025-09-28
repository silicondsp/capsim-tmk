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

imgsink 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/**********************************************************************
			imgsink()
***********************************************************************
<NAME>
imgsink
</NAME>
<DESCRIPTION>
Input an image and devour it.
</DESCRIPTION>
<PROGRAMMERS>
Programmer:  Sasan Ardalan 
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
Input an image and devour it.
</DESC_SHORT>


<DEFINES> 

#define PMODE 0644

</DEFINES> 

            

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>fp</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>ibufs</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>obufs</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>displayFlag</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberColumnsPrinted</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>char*</TYPE>
		<NAME>buff</NAME>
	</STATE>
	<STATE>
		<TYPE>image_t</TYPE>
		<NAME>img</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>pwidth</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>pheight</NAME>
	</STATE>
	<STATE>
		<TYPE>float**</TYPE>
		<NAME>mat_PP</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i,j,k,ii;
	unsigned short pixel;
	float	fpixel;

</DECLARATIONS> 

   
    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>image_t</TYPE>
		<NAME>x</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

	if((ibufs = NO_INPUT_BUFFERS()) != 1) {
		fprintf(stderr,"imgsink: no input buffer\n");
		return(1);
	}
     SET_CELL_SIZE_IN(0,sizeof(image_t));

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

        /* This mode synchronizes all input buffers */
for(ii = MIN_AVAIL(); ii>0; ii--) {
    IT_IN(0);
	img=x(0);

}
	
return(0);


]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

