

/*  Capsim (r) Text Mode Kernel (TMK) Star Library (Blocks)
    Copyright (C) 1989-2017   Silicon DSP  Corporation

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
*/


/*
 * IIP
 * The Integrated Interactive Plotting Package
 *
 *
 *
 * Author: Sasan H. Ardalan
 * 1993
 */



#define SUN
#include <math.h>
#include <stdio.h>
#ifdef SUN
#include <unistd.h>
#endif
#include <stdlib.h>

#include <string.h>

#include "types.h"
#include "aiff.h"

#define MIN(x, y) (((x) < (y)) ? (x) : (y))
#define MAX(x, y) (((x) > (y)) ? (x) : (y))



#define FLOAT_BUFFER 0
#define INTEGER_BUFFER 1


//extern void IIP_WriteMultichannel();
void 	IIP_WriteMultichannel(FILE	*fp,float	**multiChannel_PP, int	numberChannels,int	frames,int	bits);




/**********************************************************************

			IIP_WriteAIFF()

***********************************************************************
writes  samples from an arbitrary number of input buffers to an AIFF file,
which is named as a parameter.

- Data "flow-through" is implemented: if any outputs are connected,
	their values come from the correspondingly numbered input.
	(This feature is not affected by the control parameter.)
	(There cannot be more outputs than inputs.)

Programmer:  Sasan H. Ardalan
*/

#define RATE_5_KHZ  0
#define RATE_7_KHZ  1
#define RATE_11_KHZ 2
#define RATE_22_KHZ 3
#define RATE_44_KHZ 4

void IIP_WriteFloat2Extended(fp,a)
FILE 	*fp;
float	a;
{
EXTENDED ext;
static unsigned char	exph,expl;
static unsigned char 	man_A[8];
double mantissa;
double x,xx,fourth;
int	exponent;
int	i,j;
unsigned LONG 	one;

exph=0x40;

mantissa=frexp(a,&exponent);
expl=(unsigned char)(exponent-2);

for(i=0; i<8; i++)
	man_A[i]=0;

mantissa= 2*mantissa;
#ifdef DEBUG_EXT
printf("a=%e exponent=%x and %d, mantissa=%e \n",a,exponent,exponent,mantissa);
#endif
one=1;
xx=0.0;
x=1.0;
fourth=1.0;
for(j=0; j<8; j++) {
	for(i=0; i<8; i++) {
		x=1.0/((double)(one << i))*fourth;
#ifdef DEBUG_EXT
		printf("mantissa =%e, x=%e \n",mantissa,x,xx);
#endif
		if((mantissa -x) >0.0) {
			man_A[j] |= (one << (7-i));
			mantissa -= x;
		}
	}
#ifdef DEBUG_EXT
	printf("j=%d man=%x \n",j,(unsigned int)man_A[j]);
#endif
	fourth= fourth/256.0;
}
/*
 * write it out
 */
fwrite(&exph,sizeof(char),1,fp);
fwrite(&expl,sizeof(char),1,fp);
for(j=0; j<8; j++) {
	fwrite(&man_A[j],sizeof(char),1,fp);
}

return;
}

void IIP_SplitLong(x,x0_P,x1_P,x2_P,x3_P)
unsigned LONG x;
unsigned char *x0_P;
unsigned char *x1_P;
unsigned char *x2_P;
unsigned char *x3_P;
{
unsigned char a;
unsigned char b;
unsigned char c;
unsigned char d;

*x0_P= (unsigned char)(x & 0x000000ff);
*x1_P=  (unsigned char)((x & 0x0000ff00) >> 8);
*x2_P=  (unsigned char)((x & 0x00ff0000) >> 16);
*x3_P=  (unsigned char)((x & 0xff000000) >> 24);



return;
}


void IIP_SplitShort(x,x0_P,x1_P)
LONG x;
unsigned char *x0_P;
unsigned char *x1_P;
{

*x0_P= (unsigned char)(x & 0x00ff);
*x1_P=  (unsigned char)((x & 0xff00) >> 8);

return;
}

static void WriteLong(fp,x)
FILE	*fp;
unsigned LONG x;
{
unsigned char x0;
unsigned char x1;
unsigned char x2;
unsigned char x3;

IIP_SplitLong(x,&x0,&x1,&x2,&x3);
fwrite(&x3,sizeof(unsigned char),1,fp);
fwrite(&x2,sizeof(unsigned char),1,fp);
fwrite(&x1,sizeof(unsigned char),1,fp);
fwrite(&x0,sizeof(unsigned char),1,fp);

return;
}

static void WriteShort(FILE* fp, unsigned LONG x)
{
unsigned char x0;
unsigned char x1;

IIP_SplitShort(x,&x0,&x1);
fwrite(&x1,sizeof(unsigned char),1,fp);
fwrite(&x0,sizeof(unsigned char),1,fp);

return;
}

void WriteSample( FILE	*fp, short bits, float	sample)
{
unsigned char x0;
unsigned char x1;
unsigned char x2;
unsigned char x3;
short  isamp;
char	csamp;
float	fsample;


if(bits <= 8) {
	csamp=(char)(sample);
	fwrite(&csamp,sizeof(char),1,fp);
	return;
}
if(bits <=16) {
	isamp=(short)sample;
	IIP_SplitShort(isamp,&x0,&x1);
	fwrite(&x1,sizeof(unsigned char),1,fp);
	fwrite(&x0,sizeof(unsigned char),1,fp);
	return;
}

if(bits ==32) {
	/*
	 * Note this is not portable between architectures
	 * Nor is it supported by AIFF. However AIFF should have
	 * defined something for floating point. Who the hell uses
	 * 32 bit fixed point samples. Since this is the case we
	 * will interprete 32 bits as meaning floating point
	 */
	fsample=sample;
	fwrite(&fsample,sizeof(float),1,fp);
	return;
}

return;
}

static void WriteMarker(fp,marker)
FILE	*fp;
Marker marker;
{
unsigned char x0;
unsigned char x1;
unsigned char x2;
unsigned char x3;
int	i,n;

WriteShort(fp,marker.id);
WriteLong(fp,marker.position);
n=marker.markerName[0];
x0=(unsigned char)n;
fwrite(&x0,sizeof(unsigned char),1,fp);
for(i=0; i<n; i++) {
	x0=marker.markerName[i+1];
	fwrite(&x0,sizeof(unsigned char),1,fp);
}
if(!(n%2)) {
	x0=(unsigned char)NULL;
	fwrite(&x0,sizeof(unsigned char),1,fp);

}

return;
}






int IIP_WriteAIFF(char *fileName,float	*x_P,float	*y_P,int npts,int bits,
			float samplingRate,int numberChannelsIn,
			float scale,float	constant,float	 range,int autoRange,
			iip_MarkerHdr_Pt	hdr_P,int writeHeaderFlag,
			unsigned LONG *formSizeOffset_P,unsigned LONG *formBaseSize_P,
			unsigned LONG *numberFramesOffset_P,
			unsigned LONG *sndSizeOffset_P,unsigned LONG *samplesOffset_P,float	**multiChannel_PP)


{

FILE* fp;
Marker	*marker_P;
int	numberMarkers;
int numberInputBuffers;
int numberOutputBuffers;
int	wordSize;
LONG totalSamples=0;

float	min,max;
float	calcRange;
float	mean;
float	calcDCOffset;

unsigned short xlow,xhigh;

int	n,size;

OSType compressionType;
OSType	formType;
OSType	theChunkID;
char *type;
ContainerChunk *formChunk_P;
FormatVersionChunkPtr formatChunk_P;
MarkerChunkPtr markerChunk_P;
CommonChunkPtr		commonChunk_P;
CommonChunk		commonChunk;
SoundDataChunkPtr		soundDataChunk_P;
ID	chunkID;

unsigned LONG	numberSampleFrames;

static char *formID="FORM";
static char *formatID="FVER";
static char *commonID="COMM";
static char *soundID="SSND";
static char *markerID="MARK";
static LONG   sampleRates_A[]={
	0x15bba2e8,
	0x1cfa2e8b,
	0x2b7745d1,
	0x56ee8ba3,
	0xac440000
};
int	index;
int	j;

ID	formCkID;
ID	formatCkID;
ID  commonCkID;
ID	soundCkID;
ID	markerCkID;

char	sample;
float	sampf;
LONG  	i;
char buffer[100];

OSErr	errorFlag;

short numberChannels=numberChannelsIn;
short cmbits=bits;
unsigned LONG cmnpts;
EXTENDED cmsampleRate;
static char *compressionName = "none:";
unsigned char	cmbyte;
unsigned LONG commonCkSize;

fprintf(stderr,"Number of channels=%d",numberChannels);

if(npts % 2)
	numberSampleFrames=npts-1;
else
	numberSampleFrames=npts;


/*
 *
 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 *  AIFC File Creation
 *  We use bits  bits per sample single channel
 */

sscanf(formID,"%4c",&formCkID);
sscanf(formatID,"%4c",&formatCkID);
sscanf(commonID,"%4c",&commonCkID);
sscanf(soundID,"%4c",&soundCkID);
sscanf(markerID,"%4c",&markerCkID);
/*
 * Setup Form Chunk
 */

formChunk_P = (ContainerChunk *)calloc(1,sizeof(ContainerChunk));
if(formChunk_P == NULL) {
	fprintf(stdout,"aiffw: could not allocate space\n");
	return(3);
}
#if 0
type="AIFC";
#else
type="AIFF";
#endif


sscanf(type,"%4c",&formType);
formChunk_P->formType=formType;


formChunk_P->ckID=formCkID;
/*
 * Form chunk size will be determined later
 */

/*
 * Setup Format Chunk
 */
formatChunk_P= ( FormatVersionChunkPtr)calloc(1,sizeof(FormatVersionChunk));

formatChunk_P->ckID=formatCkID;
formatChunk_P->ckSize=4;
formatChunk_P->timestamp=AIFCVersion1;

/*
 * Setup the Extended Common Chunk
 */
commonChunk_P= ( CommonChunkPtr)calloc(1,sizeof(CommonChunk));
if(commonChunk_P == NULL) {
	fprintf(stdout,"aiffw: could not allocate space\n");
	return(3);
}
commonChunk_P->ckID=commonCkID;

type="NONE";
sscanf(type,"%4c",&compressionType);
#if 000
commonChunk_P->compressionType=compressionType;
#if 0
commonChunk_P->compressionName=NoneName;
#else
commonChunk_P->compressionName[1]='\0';
#endif
#endif
if(x_P)
	commonChunk_P->numChannels=2;
else
	commonChunk_P->numChannels=1;

commonChunk_P->numSampleFrames=numberSampleFrames;
commonChunk_P->sampleSize=(short)bits;
#if 0
commonChunk_P->sampleRate=str2num("\p8000.0");;

num2str(&f, commonChunk_P->sampleRate, buffer);
printf("Extended to string %s\n",PtoCstr(buffer));
#endif
#if 000
/*
 * These are for Macintosh
 */
switch(samplingRateCode) {
	case RATE_5_KHZ:
		commonChunk_P->sampleRate=str2num("\p5563.6363");
		break;
	case RATE_7_KHZ:
		commonChunk_P->sampleRate=str2num("\p7418.1818");
		break;
	case RATE_11_KHZ:
		commonChunk_P->sampleRate=str2num("\p11127.2727");
		break;
	case RATE_22_KHZ:
		commonChunk_P->sampleRate=str2num("\p22254.5454");
		break;
	case RATE_44_KHZ:
		commonChunk_P->sampleRate=str2num("\p44100.0000");
		break;

}
#endif

/*
  commonChunk_P->ckSize=22+2;
*/

  commonChunk_P->ckSize=18;

/*
 * Setup Marker  Chunk
 */
if(hdr_P) {


	IIPMarkerArrayFromList(hdr_P, &numberMarkers, &marker_P);

	markerChunk_P= ( MarkerChunkPtr)calloc(1,sizeof(MarkerChunk));

	markerChunk_P->ckID=markerCkID;
	markerChunk_P->numMarkers=numberMarkers;
	size=0;
	for(i=0; i<numberMarkers; i++) {
		n=marker_P[i].markerName[0];
		if(!(n%2))
			n++;
		size += n;
	}
	markerChunk_P->ckSize=4+size+numberMarkers*(2+4);

}

/*
 * Setup the Sound Data Chunk
 */
soundDataChunk_P= ( SoundDataChunkPtr)calloc(1,sizeof(SoundDataChunk));
if(soundDataChunk_P == NULL) {
	fprintf(stdout,"aiffw: could not allocate space\n");
	return(3);
}
soundDataChunk_P->ckID=soundCkID;
soundDataChunk_P->offset=0;
soundDataChunk_P->blockSize=0;
if(bits <=8 )
	soundDataChunk_P->ckSize=numberSampleFrames*numberChannels+8;
else if(bits <=16)
	soundDataChunk_P->ckSize=numberSampleFrames*numberChannels*2+8;
else if(bits <=24)
	soundDataChunk_P->ckSize=numberSampleFrames*numberChannels*3+8;
else
	soundDataChunk_P->ckSize=numberSampleFrames*numberChannels*4+8;



/*
 * Determine the size for the form chunk
 */
formChunk_P->ckSize=4+formatChunk_P->ckSize+8+commonChunk_P->ckSize+
			8+soundDataChunk_P->ckSize+8;

if(formBaseSize_P)
	*formBaseSize_P=formChunk_P->ckSize;

if(hdr_P)
	formChunk_P->ckSize += markerChunk_P->ckSize+8;

/*
 * Create AIFF File
 */

fp=fopen(fileName,"wb");
if(fp == NULL){
	fprintf(stderr,"aiffw: Could not open aiff file for writting");
	return(4);
}


/*
 * Write out chunks.
 */
#if 0
fwrite(formChunk_P,sizeof(ContainerChunk),1,fp);
#endif

/*
 * First one must be Form Chunk
 */
fwrite(&formChunk_P->ckID,sizeof(ID),1,fp);
if(formSizeOffset_P)
	*formSizeOffset_P=ftell(fp);
WriteLong(fp,formChunk_P->ckSize);
fwrite(&formChunk_P->formType,sizeof(ID),1,fp);

/*
 * Format version chunk
 */

#if 0
fwrite(formatChunk_P,sizeof(FormatVersionChunk),1,fp);
#endif

fwrite(&formatChunk_P->ckID,sizeof(ID),1,fp);
WriteLong(fp,formatChunk_P->ckSize);
WriteLong(fp,formatChunk_P->timestamp);

/*
 * Common chunk
 */
/*
 * For some stupid reason both DEC and SGI stick an extra
 * 16 bits in the chunk for no reason, unless you write
 * each value out individually which is a pain. This happens
 * only for the common chunk after the numberChannels
 * your guess is as good as mine. I think that last bit of
 * character string after compression type in aiff.h is the culprit
 */
/*
commonCkSize=sizeof(ExtCommonChunk)-8;
*/
commonCkSize=18;


fwrite(&commonCkID,sizeof(ID),1,fp);

WriteLong(fp,commonCkSize);


WriteShort(fp,numberChannels);
if(numberFramesOffset_P)
	*numberFramesOffset_P=ftell(fp);
WriteLong(fp,numberSampleFrames);

WriteShort(fp,cmbits);
IIP_WriteFloat2Extended(fp,samplingRate);
#if 000
fwrite(&compressionType,sizeof(ID),1,fp);
#if 0
fwrite(&compressionName,6,1,fp);
#else
cmbyte=0;
fwrite(&cmbyte,1,1,fp);
fwrite(&cmbyte,1,1,fp);
#endif
#endif

/*
 * chunks should be on even boundries
 */
#if 0
sample='\0';
fwrite(&sample,sizeof(char),1,fp);
#endif
if(hdr_P) {
	/*
 	 * Write marker chunk
	 */

	fwrite(&markerCkID,sizeof(ID),1,fp);
	WriteLong(fp,markerChunk_P->ckSize);
	WriteShort(fp,markerChunk_P->numMarkers);
	for(i=0; i<numberMarkers; i++)
		WriteMarker(fp,marker_P[i]);



}
/*
 * write Sound Chunk
 * write id and size then later the samples
 */
#if 0
fwrite(soundDataChunk_P,sizeof(SoundDataChunk),1,fp);
#endif

fwrite(&soundCkID,sizeof(ID),1,fp);
/*
 * unsigned long always write MS word first
 */
if(sndSizeOffset_P)
	*sndSizeOffset_P=ftell(fp);
WriteLong(fp,soundDataChunk_P->ckSize);

WriteLong(fp,soundDataChunk_P->offset);

WriteLong(fp,soundDataChunk_P->blockSize);

if(writeHeaderFlag) {
	/*
	 * Only write header. Let user fill in
	 * number of frames and also write the sound samples
	 */

	if(samplesOffset_P)*samplesOffset_P=ftell(fp);
	fclose(fp);
	return(0);


}

/*
 * AT THIS POINT (FINALLY)
 * FILE POINTER IS POSITIONED TO WRITE BINARY SAMPLES
 */

if(numberChannels > 1 && multiChannel_PP) {

	IIP_WriteMultichannel(fp,multiChannel_PP, numberChannels,npts,bits);
	fclose(fp);
	return(0);

}

wordSize=1;
wordSize <<= (bits-1);

if(autoRange) {
        min = max = y_P[0];
	mean=y_P[0];

        for (i = 1; i < npts; i++) {
                min = MIN(min, y_P[i]);
                max = MAX(max, y_P[i]);
		mean += y_P[i];
        }
	mean= mean/(float)npts;
	calcDCOffset= - mean;
	if(max-min)
		calcRange=0.5*(max-min);
	else
		calcRange=1.0;
fprintf(stderr,"Max=%f Min=%f Mean=%f Range=%f \n",
	max,min,mean,calcRange);
} else {
	calcRange=range;
	calcDCOffset= constant;
}

for(i=0; i<npts; i++) {

	sampf=y_P[i];
	/*
         * Now we are ready to write out data
         * First Convert it to 8 bits
         */

	if(bits != 32) {
		sampf=(((sampf+calcDCOffset)*scale)/calcRange)*((float)wordSize);
		/*
		 * Saturate if necessary
		 */
		if(sampf < -wordSize)
			sampf= -wordSize;
		if(sampf > wordSize-1)
			sampf=wordSize-1;
	}

	WriteSample(fp,bits,sampf);

	if(x_P) {
		sampf=x_P[i];
		/*
        	 * Now we are ready to write out data
		 */
		if(bits != 32) {
			sampf=(((sampf+calcDCOffset)*scale)/calcRange)*((float)wordSize);
			/*
			 * Saturate if necessary
			 */
			if(sampf < -wordSize)
				sampf= -wordSize;
			if(sampf > wordSize-1)
				sampf=wordSize-1;
		}


		WriteSample(fp,bits,sampf);
	}

}



fclose(fp);
return(0);
}



int IIP_UpdateNumberFramesAIFF(FILE*	fp,int	bits,LONG	numberChannels,unsigned LONG numberFrames,unsigned LONG formSizeOffset,unsigned LONG formBaseSize,LONG numberFramesOffset,unsigned LONG sndSizeOffset,unsigned LONG samplesOffset)


{

unsigned LONG value;
unsigned LONG sndSize;




fseek(fp, numberFramesOffset,SEEK_SET);
WriteLong(fp,numberFrames);


if(bits <=8 )
	sndSize=numberFrames*numberChannels+8;
else if(bits <=16)
	sndSize=numberFrames*numberChannels*2+8;
else if(bits <=24)
	sndSize=numberFrames*numberChannels*3+8;
else
	sndSize=numberFrames*numberChannels*4+8;
fseek(fp,sndSizeOffset,SEEK_SET);
WriteLong(fp,sndSize);

value= formBaseSize+sndSize-8;
fseek(fp,formSizeOffset,SEEK_SET);
WriteLong(fp,value);
fclose(fp);



return(0);
}

void 	IIP_WriteMultichannel(FILE	*fp,float	**multiChannel_PP, int	numberChannels,int	frames,int	bits)

{
int	i,j;
float	sampf;

for(i=0; i<frames;i++) {


	for(j=0; j<numberChannels; j++) {
		sampf=multiChannel_PP[j][i];
		WriteSample(fp,bits,sampf);
	}


}



return;
}
