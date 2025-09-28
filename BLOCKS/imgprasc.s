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

imgprasc 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/**********************************************************************
			imgprasc()
***********************************************************************
Programmer:  Sasan Ardalan 
Date: May 31, 2002
<NAME>
imgprasc
</NAME>
<DESCRIPTION>
Input image and store as ASCII in a file
</DESCRIPTION>
<PROGRAMMERS>
Programmer:  Sasan Ardalan 
Date: May 31, 2002
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

          
<DESC_SHORT>
Input image and store as ASCII in a file
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>FILE*</TYPE>
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

     

<PARAMETERS>
<PARAM>
	<DEF>Name of output file</DEF>
	<TYPE>file</TYPE>
	<NAME>fileName</NAME>
	<VALUE>output-asc.img</VALUE>
</PARAM>
</PARAMETERS>

    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>image_t</TYPE>
		<NAME>x</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

	if((ibufs = NO_INPUT_BUFFERS()) != 1) {
		fprintf(stdout,"imgprasc: no input buffer\n");
		return(1);
	}
	if((obufs = NO_OUTPUT_BUFFERS()) > ibufs) {
		fprintf(stdout,"imgprasc: more output than input buffers\n");
		return(2);
	}
	for(j=0; j<obufs; j++)
                SET_CELL_SIZE_OUT(j,sizeof(image_t));
	if(strcmp(fileName,"stdout") == 0) {
		fp = stdout;
		displayFlag = 1;
	}
	else if(strcmp(fileName,"stderr") == 0) {
		fp = stderr;
		displayFlag = 1;
	}
	else if((fp = fopen(fileName,"w")) == NULL) {
		fprintf(stdout,"primage: can't open output file '%s'\n",
			fileName);
		return(3);
	}
	for(i=0; i<ibufs; i++)
        	SET_CELL_SIZE_IN(i,sizeof(image_t));
	for(i=0; i<obufs; i++)
        	SET_CELL_SIZE_OUT(i,sizeof(image_t));

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

for(ii = MIN_AVAIL(); ii>0; ii--) {
    IT_IN(0);
	img=x(0);
	pheight=img.height;
	pwidth=img.width;
	mat_PP=img.image_PP;
	fprintf(stderr,"imgprasc to produce %d x  %d image file\n",pwidth,pheight);

	if(obufs==1) {
        if(IT_OUT(0)) {
			KrnOverflow("imgprbin",0);
			return(99);
		}
        OUTIMAGE(0,0) = img;
    }
	fprintf(fp,"%d %d\n",pwidth,pheight);
	for(i=0; i<pheight; i++) {
		for(j=0; j<pwidth; j++) {
			fpixel = mat_PP[i][j];
			fprintf(fp,"%f\n",fpixel);

		}
	}
}
	
return(0);


]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

	fclose(fp);

]]>
</WRAPUP_CODE> 



</BLOCK> 

