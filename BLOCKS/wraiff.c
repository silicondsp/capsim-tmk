 
#ifdef LICENSE

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

#endif
 
#ifdef SHORT_DESCRIPTION

Writes  samples from an arbitrary number of input buffers to an AIFF file, which is named as a parameter.

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 
#include <stdlib.h>

#include "dsp.h"
#include "types.h"
#include "aiff.h"


 

#define FLOAT_BUFFER 0
#define INTEGER_BUFFER 1


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      FILE*  __fp;
      int  __numberInputBuffers;
      int  __numberOutputBuffers;
      int  __wordSize;
      LONG  __totalSamples;
      LONG  __numberFrames;
      LONG  __formSizeOffset;
      LONG  __formBaseSize;
      LONG  __numberFramesOffset;
      LONG  __sndSizeOffset;
      LONG  __samplesOffset;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define fp (state_P->__fp)
#define numberInputBuffers (state_P->__numberInputBuffers)
#define numberOutputBuffers (state_P->__numberOutputBuffers)
#define wordSize (state_P->__wordSize)
#define totalSamples (state_P->__totalSamples)
#define numberFrames (state_P->__numberFrames)
#define formSizeOffset (state_P->__formSizeOffset)
#define formBaseSize (state_P->__formBaseSize)
#define numberFramesOffset (state_P->__numberFramesOffset)
#define sndSizeOffset (state_P->__sndSizeOffset)
#define samplesOffset (state_P->__samplesOffset)

/*         
 *    PARAMETER DEFINES 
 */ 
#define fileName (param_P[0]->value.s)
#define bits (param_P[1]->value.d)
#define samplingRate (param_P[2]->value.f)
#define range (param_P[3]->value.f)
#define dcOffset (param_P[4]->value.f)
#define scale (param_P[5]->value.f)
#define bufferType (param_P[6]->value.d)
#define playFlag (param_P[7]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

wraiff 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

        char    sample;
        float   sampf;
        long int        i;
        long int        j;
        char buffer[100];
        unsigned char   *samples_P;
       
			
			
			



switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Name of output file";
     char   *ptype0 = "file";
     char   *pval0 = "aiff.aif";
     char   *pname0 = "fileName";
     char   *pdef1 = "Number of bits";
     char   *ptype1 = "int";
     char   *pval1 = "8";
     char   *pname1 = "bits";
     char   *pdef2 = "Sampling Rate Hz";
     char   *ptype2 = "float";
     char   *pval2 = "8";
     char   *pname2 = "samplingRate";
     char   *pdef3 = "Range";
     char   *ptype3 = "float";
     char   *pval3 = "1.0";
     char   *pname3 = "range";
     char   *pdef4 = "Add Constant";
     char   *ptype4 = "float";
     char   *pval4 = "0";
     char   *pname4 = "dcOffset";
     char   *pdef5 = "Multiplication Factor";
     char   *ptype5 = "float";
     char   *pval5 = "1.0";
     char   *pname5 = "scale";
     char   *pdef6 = "Buffer type:0= Float, 1=Integer";
     char   *ptype6 = "int";
     char   *pval6 = "0";
     char   *pname6 = "bufferType";
     char   *pdef7 = "Play AIFF File:0=No,1=Yes";
     char   *ptype7 = "int";
     char   *pval7 = "0";
     char   *pname7 = "playFlag";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);
KrnModelParam(indexModel88,3 ,pdef3,ptype3,pval3,pname3);
KrnModelParam(indexModel88,4 ,pdef4,ptype4,pval4,pname4);
KrnModelParam(indexModel88,5 ,pdef5,ptype5,pval5,pname5);
KrnModelParam(indexModel88,6 ,pdef6,ptype6,pval6,pname6);
KrnModelParam(indexModel88,7 ,pdef7,ptype7,pval7,pname7);

      }
break;
   


/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            totalSamples=0;

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

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
if(IIP_WriteAIFF((char*)fileName,NULL,NULL,(int)NULL,(int)bits,
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


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


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



break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

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


break;
}
return(0);
}
