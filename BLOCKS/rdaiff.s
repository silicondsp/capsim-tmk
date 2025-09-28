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

rdaiff 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*
                        rdaiff()
***************************************************************
This function performs the  task of reading
sample values in from an aiff file, and then placing them on
it's output buffer.
If more than one output buffer is connected, then the samples are
routed to each buffer in sequence mod the number of buffers.
<NAME>
rdaiff
</NAME>
<DESCRIPTION>
This function performs the  task of reading
sample values in from an aiff file, and then placing them on
it's output buffer.
If more than one output buffer is connected, then the samples are
routed to each buffer in sequence mod the number of buffers.
</DESCRIPTION>
<PROGRAMMERS>
Programmer: Sasan H. Ardalan
Date: August 4, 1993
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

            
<DESC_SHORT>
This function performs the  task of reading sample values in from an aiff file, and then placing them on its output buffer.
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 
#include <stdlib.h>

#include "dsp.h"
#include "types.h"
#include "aiff.h"

]]>
</INCLUDES> 




<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>obufs</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>j</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>FILE*</TYPE>
		<NAME>fp</NAME>
	</STATE>
	<STATE>
		<TYPE>char*</TYPE>
		<NAME>sample_P</NAME>
	</STATE>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>x_P</NAME>
	</STATE>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>y_P</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>points</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>samplingRate</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberChannels</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>bits</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

        int i,k,k1;
	float	x,y;
	short xsamp;
	unsigned char x0,x1;
	unsigned long  xc0,xc1;
	int	IIP_ReadAIFF(char* fileName1,float **x1_PP,float	**y1_PP,int *points1_P,float *samplingRate1_P,
	    int	*bits1_P,iip_MarkerHdr_Pt hdr1_P,int *channels1_P,FILE* fpIn1,float	***multiChannel1_PPP);
					
	


</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF>Name of AIFF File</DEF>
	<TYPE>file</TYPE>
	<NAME>fileName</NAME>
	<VALUE>aiff.aif</VALUE>
</PARAM>
</PARAMETERS>

<INIT_CODE>
<![CDATA[ 

if( (obufs = NO_OUTPUT_BUFFERS()) < 1 ) {
                fprintf(stderr,"rdaiff: no output buffers\n");
                return(1);
}
fp=fopen(fileName,"rb");
if(fp == NULL) {
                fprintf(stderr,"Error opening AIFF file\n");
                return(2);
}
if(IIP_ReadAIFF(NULL,&x_P,&y_P,&points,&samplingRate,
                                &bits,NULL,&numberChannels,fp,NULL)) {
                fprintf(stderr,"rdaiff: Trouble reading AIFF File\n");
                return(3);
}
fprintf(stderr,"AIFF: Points=%d\n",points);
fprintf(stderr,"AIFF: Sampling Rate=%f\n",samplingRate);
fprintf(stderr,"AIFF: Bits=%d\n",bits);
fprintf(stderr,"AIFF: Channels=%d\n",numberChannels);
if(numberChannels > 2) {
        fprintf(stderr,"rdaiff: Only two channels supported\n");
        fclose(fp);
        return(6);
}
if(bits <= 8) {
        /*
         * allocate array to store samples
         */
        sample_P=(char*)calloc(numberChannels*NUMBER_SAMPLES_PER_VISIT,sizeof(char));
        if(sample_P == NULL) {
                fprintf(stderr,"Could not allocate space in rdaiff\n");
                return(4);
        }
} else {
	x_P=(float*)calloc(NUMBER_SAMPLES_PER_VISIT*numberChannels,sizeof(float));
	if(x_P==NULL) {
                fprintf(stderr,"rdaiff: Could not allocate space\n");
                return(5);
	}
}

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


if(bits <= 8) {

  if(fread(sample_P,sizeof(char),numberChannels*NUMBER_SAMPLES_PER_VISIT,fp)==(int)NULL) 
                                        return(0);


} else if(bits <= 16) {
   for(i=0; i<NUMBER_SAMPLES_PER_VISIT*numberChannels; i++) {
	if(fread(&x1,sizeof(unsigned char),1,fp)==(int)NULL) return(0);
	if(fread(&x0,sizeof(unsigned char),1,fp)==(int)NULL) return(0);

	xc0= (unsigned long)x0;
	xc1= (unsigned long)x1;

	xsamp=(xc0 +(xc1<<8));

	x_P[i]=(float)xsamp;
   }

} else if(bits ==32) {
   /*
    * Floating point
    */

   for(i=0; i<NUMBER_SAMPLES_PER_VISIT*numberChannels; i++) {
   	if(fread(&x,sizeof(float),1,fp)==(int)NULL) return(0);
   	x_P[i]=x;
   }

}


/*
 * output a maximum of NUMBER_SAMPLES samples to output buffer(s)
 */
for(i=0; i < NUMBER_SAMPLES_PER_VISIT; ++i) {
    if(numberChannels ==2 ) {
		k=2*i;
		k1=k+1;
    }
    else {
		k=i;
		k1=k;
    }
    if(bits <=8) {
	x=(float)sample_P[k];
	y=(float)sample_P[k1];
    }
    else if(bits <=16) { 
	x=x_P[k];
	y=x_P[k1];
    }
    else  {
	x=x_P[k];
	y=x_P[k1];
    }

    /* input sample available: */
    /* increment time on output buffer(s) */
    /* and output a sample */
    if(IT_OUT(0)) {
                 KrnOverflow("rdaiff",0);

                 return(99);
    }
    OUTF(0,0) = x;
    if(obufs==2) {
    	if(IT_OUT(1)) {
                 KrnOverflow("rdaiff",1);

                 return(99);
    	}
    	OUTF(1,0) = y;
	
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

