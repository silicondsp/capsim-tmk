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

wraiff 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/**********************************************************************
                        wraiff()
***********************************************************************
writes  samples from an arbitrary number of input buffers to an AIFF file,
which is named as a parameter.
- Data "flow-through" is implemented: if any outputs are connected,
        their values come from the correspondingly numbered input.
        (This feature is not affected by the control parameter.)
        (There cannot be more outputs than inputs.)
<NAME>
wraiff
</NAME>
<DESCRIPTION>
writes  samples from an arbitrary number of input buffers to an AIFF file,
which is named as a parameter.
- Data "flow-through" is implemented: if any outputs are connected,
        their values come from the correspondingly numbered input.
        (This feature is not affected by the control parameter.)
        (There cannot be more outputs than inputs.)
</DESCRIPTION>
<PROGRAMMERS>
Written by Sasan Ardalan
Date: June 15, 1993
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
Writes  samples from an arbitrary number of input buffers to an AIFF file, which is named as a parameter.
</DESC_SHORT>

<INCLUDES>
<![CDATA[ 
#include <stdlib.h>

#include "dsp.h"
#include "types.h"
#include "aiff.h"

]]>
</INCLUDES> 

<DEFINES> 

#define FLOAT_BUFFER 0
#define INTEGER_BUFFER 1

</DEFINES> 

             

<STATES>
	<STATE>
		<TYPE>FILE*</TYPE>
		<NAME>fp</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberInputBuffers</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberOutputBuffers</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>wordSize</NAME>
	</STATE>
	<STATE>
		<TYPE>long</TYPE>
		<NAME>totalSamples</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>long</TYPE>
		<NAME>numberFrames</NAME>
	</STATE>
	<STATE>
		<TYPE>long</TYPE>
		<NAME>formSizeOffset</NAME>
	</STATE>
	<STATE>
		<TYPE>long</TYPE>
		<NAME>formBaseSize</NAME>
	</STATE>
	<STATE>
		<TYPE>long</TYPE>
		<NAME>numberFramesOffset</NAME>
	</STATE>
	<STATE>
		<TYPE>long</TYPE>
		<NAME>sndSizeOffset</NAME>
	</STATE>
	<STATE>
		<TYPE>long</TYPE>
		<NAME>samplesOffset</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

        char    sample;
        float   sampf;
        long int        i;
        long int        j;
        char buffer[100];
        unsigned char   *samples_P;
        int IIP_WriteAIFF(char *fileName1,float	*x1_P,float	*y1_P,int npts1,int bits1,
			float samplingRate1,int numberChannelsIn1,
			float scale1,float	constant1,float	 range1,int autoRange1,
			iip_MarkerHdr_Pt	hdr1_P,int writeHeaderFlag1,
			unsigned long *formSizeOffset1_P,unsigned long *formBaseSize1_P,
			unsigned long *numberFramesOffset1_P,
			unsigned long *sndSizeOffset1_P,unsigned long *samplesOffset1_P,float	**multiChannel1_PP);


</DECLARATIONS> 

                   

<PARAMETERS>
<PARAM>
	<DEF>Name of output file</DEF>
	<TYPE>file</TYPE>
	<NAME>fileName</NAME>
	<VALUE>aiff.aif</VALUE>
</PARAM>
<PARAM>
	<DEF>Number of bits</DEF>
	<TYPE>int</TYPE>
	<NAME>bits</NAME>
	<VALUE>8</VALUE>
</PARAM>
<PARAM>
	<DEF>Sampling Rate Hz</DEF>
	<TYPE>float</TYPE>
	<NAME>samplingRate</NAME>
	<VALUE>8</VALUE>
</PARAM>
<PARAM>
	<DEF>Range</DEF>
	<TYPE>float</TYPE>
	<NAME>range</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Add Constant</DEF>
	<TYPE>float</TYPE>
	<NAME>dcOffset</NAME>
	<VALUE>0</VALUE>
</PARAM>
<PARAM>
	<DEF>Multiplication Factor</DEF>
	<TYPE>float</TYPE>
	<NAME>scale</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Buffer type:0= Float, 1=Integer</DEF>
	<TYPE>int</TYPE>
	<NAME>bufferType</NAME>
	<VALUE>0</VALUE>
</PARAM>
<PARAM>
	<DEF>Play AIFF File:0=No,1=Yes</DEF>
	<TYPE>int</TYPE>
	<NAME>playFlag</NAME>
	<VALUE>0</VALUE>
</PARAM>
</PARAMETERS>

<INIT_CODE>
<![CDATA[ 

if((numberInputBuffers = NO_INPUT_BUFFERS()) <= 0) {
        fprintf(stdout,"wraiff: no input buffers\n");
        return(1);
}
if((numberOutputBuffers = NO_OUTPUT_BUFFERS()) > numberInputBuffers) {
        fprintf(stdout,"wraiff: more output than input buffers\n");
        return(2);
}
switch(bufferType) {
        case FLOAT_BUFFER:
                for(i=0; i< numberInputBuffers; i++)
                        SET_CELL_SIZE_IN(i,sizeof(float));
                for(i=0; i< numberOutputBuffers; i++)
                        SET_CELL_SIZE_OUT(0,sizeof(float));
                break;
        case INTEGER_BUFFER:
                for(i=0; i< numberInputBuffers; i++)
                        SET_CELL_SIZE_IN(i,sizeof(int));
                for(i=0; i< numberOutputBuffers; i++)
                        SET_CELL_SIZE_OUT(0,sizeof(int));
                break;
        default:
                fprintf(stderr,"wraiff: Bad buffer type specified  \n");
                return(4);
                break;
}
wordSize = 1;
wordSize <<= bits-1;
/*
 *
 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 *  AIFC File Creation
 */
if(IIP_WriteAIFF((char*)fileName,NULL,NULL,NULL,(int)bits,
                        samplingRate,(int)1,
                        scale,dcOffset,range,0,
                        NULL,1,
                        &formSizeOffset,&formBaseSize,
                        &numberFramesOffset,
                        &sndSizeOffset,&samplesOffset,NULL)) {
	fprintf(stderr,"wraiff: problems writting aiff file\n");
	return(5);
}
fprintf(stderr,"formSizeOffset=%d,formBaseSize=%d,numberFramesOffset=%d,sndSizeOffset=%d,samplesOffset=%d\n",
                        formSizeOffset,formBaseSize,
                        numberFramesOffset,
                        sndSizeOffset,samplesOffset);
/*
 * Open AIFF file now that the chunks have been written 
 */
fp=fopen(fileName,"rb+");
if(fp==NULL) {
	fprintf(stderr,"wraiff: could not open aiff file to write samples\n");
	return(6);
}
/*
 * Position the file pointer where the samples should be written
 */ 
fseek(fp,samplesOffset,SEEK_SET);

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


/*
 * This mode synchronizes all input buffers
 */
for(i = MIN_AVAIL(); i>0; i--) {
                /*
                 * Calculate total number of samples inputted
                 * If more than samples return
                 */
                totalSamples++;

                for(j=0; j<numberInputBuffers; ++j) {
                        IT_IN(j);
                        if(j < numberOutputBuffers) {
                                if(IT_OUT(j)) {
                                        KrnOverflow("aiffw",j);
                                        return(99);
                                }
                                switch(bufferType) {
                                        case FLOAT_BUFFER:
                                           OUTF(j,0) = INF(j,0);
                                           break;
                                    case INTEGER_BUFFER:
                                           OUTI(j,0) = INI(j,0);
                                           break;
                                }

                        }

                        switch(bufferType) {
                                case FLOAT_BUFFER:

                                   sampf=INF(j,0);

                                   break;
                           case INTEGER_BUFFER:
                                   sampf=(float)INI(j,0);
                                   break;
                        }
            		/*
            		 * Now we are ready to write out data
            		 * First Convert it to 8 bits
            		 */

                        sampf=(((sampf+dcOffset)*scale)/range)*((
float)wordSize);

                        /*
                         * Saturate if necessary
                         */
                        if(sampf < -wordSize)
                                        sampf= -wordSize;
                        if(sampf > wordSize-1)
                                        sampf=wordSize;
			WriteSample((FILE*)fp,(int)bits,sampf);

                }

}
return(0);


]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

	if(totalSamples%2) totalSamples++;
	IIP_UpdateNumberFramesAIFF(fp,
                        bits,1,
                        totalSamples,
                        formSizeOffset,formBaseSize,
                        numberFramesOffset,
                        sndSizeOffset,samplesOffset);
        fclose(fp);
#if 0
        if(playFlag)
                Cs_PlayAIFF(fileName);
#endif

]]>
</WRAPUP_CODE> 



</BLOCK> 

