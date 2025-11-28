

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
 * Author: Sasan H. Ardalan
 *
 */




/************************************************************

			IIP_ReadAIFF()

***************************************************************

Programmer: Sasan H. Ardalan
Date: August 4, 1993

This function performs the  task of reading
sample values in from an aiff file, and then placing them on
it's output buffer.



*/


#define LONG int
#define LONG_INT   int

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "types.h"
#include "aiff.h"

#define MIN(x, y) (((x) < (y)) ? (x) : (y))
#define MAX(x, y) (((x) > (y)) ? (x) : (y))




#define NUMBER_SAMPLES 128

static  double ReadExtended(FILE *fp)

{
static unsigned char    exph,expl;
static unsigned char    man_A[8];
double mantissa;
double x,xx,byteBoundry;
int     exponent;
int     i,j;
//unsigned long   one;
unsigned int   one;  //64bit fix
double a;
int	expc;

fread(&exph,sizeof(unsigned char),1,fp);
fread(&expl,sizeof(unsigned char),1,fp);
for(i=0; i<8; i++) {

	fread(&man_A[i],sizeof(unsigned char),1,fp);
}
one=1;
x=1.0;
byteBoundry=1.0;
mantissa=0.0;
for(j=0; j<8; j++) {
        for(i=0; i<8; i++) {
                x=1.0/((double)(one << i))*byteBoundry;
#ifdef DEBUG_EXTENDED
		printf("READ: man_A = %x mantissa=%e x=%e\n",man_A[j],mantissa,x);
#endif
		if((man_A[j] & (one << (7-i)))) {
			mantissa += x;

		}

	}
	byteBoundry= byteBoundry/256.0;
}
a=ldexp(mantissa,(int)(expl+2));

#ifdef DEBUG_EXTENDED
printf("READ: explow = %x mantissa=%e a=%e\n",expl,mantissa,a);
#endif

expc=expl+1;
a=mantissa;
while(expc--)
	a *= 2.0;

return(a);
}




//PRIVATE unsigned long ReadLong(fp)
unsigned LONG ReadLong(FILE *fp) //64bit fix
{
unsigned char x0,x1,x2,x3;
//unsigned long  xc0,xc1,xc2,xc3;
unsigned  LONG  xc0,xc1,xc2,xc3;  //64bit fix
//unsigned long x;
unsigned LONG x; //64bit fix

fread(&x3,sizeof(unsigned char),1,fp);
fread(&x2,sizeof(unsigned char),1,fp);
fread(&x1,sizeof(unsigned char),1,fp);
fread(&x0,sizeof(unsigned char),1,fp);


xc0= (unsigned LONG)x0;
xc1= (unsigned LONG)x1;
xc2= (unsigned LONG)x2;
xc3= (unsigned LONG)x3;


x=(unsigned LONG)(xc0 +(xc1<<8 )+ (xc2 << 16) +(xc3<<24));

#if 0
fprintf(stderr,"xc0 xc1 xc2 xc3 xc4 x %d %d %d %d %d \n",
	xc0,xc1,xc2,xc3,x);
#endif
return(x);

}


  short ReadShort(FILE *fp)
{
unsigned char x0,x1;
unsigned LONG  xc0,xc1;
unsigned short x;

fread(&x1,sizeof(unsigned char),1,fp);
fread(&x0,sizeof(unsigned char),1,fp);

xc0= (unsigned LONG)x0;
xc1= (unsigned LONG)x1;

x=(short)(xc0 +(xc1<<8));

return(x);

}


static void Align(unsigned LONG *id_P)

{
unsigned short a;
unsigned short b;
unsigned LONG	id;

id= *id_P;
#ifdef DEC

a= id >> 16;
b= id & 0x0000ffff;
id= (b << 16)+a;

#endif

*id_P =  id;


return;
}

static void Align2(unsigned LONG *id_P)

{
unsigned short a;
unsigned short b;
unsigned LONG	id;

id= *id_P;

a= id >> 16;
b= id & 0x0000ffff;
id= (b << 16)+a;


*id_P =  id;


return;
}

int	IIP_ReadAIFF(char* fileName,float	**x_PP,float	**y_PP,int	*points_P,float	*samplingRate_P,
				int	*bits_P,iip_MarkerHdr_Pt	hdr_P,int	*channels_P,FILE* fpIn,float	***multiChannel_PPP)


{
int	j=0;
char* sample_P;
signed char	samp8;
short	sample;
FILE* fp;

int i,k,n;
float x;
OSType compressionType;
OSType	formType;
OSType	theChunkID;
char *type;
ContainerChunk *formChunk_P;
FormatVersionChunkPtr formatChunk_P;
ExtCommonChunkPtr		commonChunk_P;
SoundDataChunkPtr		soundDataChunk_P;
MarkerChunkPtr		markerChunk_P;
ID	chunkID;
static char *formID="FORM";
static char *formatID="FVER";
static char *commonID="COMM";
static char *soundID="SSND";
static char *markerID="MARK";

ID	formCkID;
ID	formatCkID;
ID  commonCkID;
ID	soundCkID;
ID	markerCkID;

ID	ckID;

LONG_INT	timeStamp;
LONG_INT	ckSize;
short int	bitsSample;
EXTENDED	sampleRate;
float	samplingRate;
LONG_INT numberSampleFrames;
LONG_INT offset;
short int  numberChannels;
float	**multiChannel_PP;


float	sampf;
char buffer[100];
unsigned char	*samples_P;
LONG_INT	bytesRead;

OSErr	errorFlag;
int	getOut;

float	*y_P;
float	*x_P;
LONG_INT	blockSize,offsetSound;
unsigned LONG timestamp;

unsigned int	position;
MarkerIdType	id;
int	numberMarkers;
char	markerName[256];
unsigned char	c;

/*
 *  AIFC File Read
 *  We use bits  bits per sample single channel
 */


/*
 * setup ID's
 */
sscanf(formID,"%4c",&formCkID);
sscanf(formatID,"%4c",&formatCkID);
sscanf(commonID,"%4c",&commonCkID);
sscanf(soundID,"%4c",&soundCkID);
sscanf(markerID,"%4c",&markerCkID);

ckID=FORM;
#if 0000
printf("FORM %x ID %x\n",formCkID,ckID);
printf("FVER %x\n",formatCkID);
printf("COMM %x\n",commonCkID);
printf("SSND %x\n",soundCkID);
#endif
/*
 * Open the file as a binary file
 */
if(fileName) {
	fp=fopen(fileName,"rb");
	if(fp == NULL) {
		fprintf(stderr,"Error opening AIFF file\n");
		return(2);
	}
} else
	fp=fpIn;
/*
 * Setup Form Chunk
 */

formChunk_P = (ContainerChunk *)calloc(1,sizeof(ContainerChunk));

/*
 * read in form chunk
 */

#if 0
fread(formChunk_P,sizeof(ContainerChunk),1,fp);
#endif
fread(&formChunk_P->ckID,sizeof(ID),1,fp);
formChunk_P->ckSize=ReadLong(fp);

if(formChunk_P->ckID != formCkID) {
	printf("Beginning chunk not a FORM chunk\n");
	return(4);
}
printf("Container Size = %ld\n",formChunk_P->ckSize);
printf("Type = %x\n",formChunk_P->formType);

/*
 * Keep track of bytes read.
 * start from 4 since form chunks type is 4 bytes and has already
 * been read
 */
bytesRead=4;
i=0;
getOut=0;
while(bytesRead <formChunk_P->ckSize && !feof(fp)  && !getOut) {
	/*
	 * Get next Chunk
	 */
	fread(&chunkID,sizeof(ID),1,fp);
	bytesRead += sizeof(ID);

	if(chunkID == formatCkID ) {
			printf("Found a format chunk\n");
			ckSize=ReadLong(fp);
			bytesRead += sizeof(LONG_INT);
			printf("Size of format chunk is: %ld\n",ckSize);
			timestamp=ReadLong(fp);
			bytesRead += sizeof(LONG_INT);
			printf("Format time stamp  is: %lx\n",timeStamp);

	} else if(chunkID == soundCkID) {
			printf("Found a sound chunk\n");
			ckSize=ReadLong(fp);
			printf("Chunk size is %ld\n",ckSize);
			offsetSound=ReadLong(fp);

			blockSize=ReadLong(fp);
			bytesRead += ckSize;
			/*
			 * Read samples during run time
			 * We are right at where samples are.
			 * So get the hell out of the loop!
			 */
			getOut=1;
	} else if(chunkID == commonCkID) {
			printf("Found a common chunk\n");
#if 0
			fread(&ckSize,sizeof(long int),1,fp);
#endif
			ckSize=ReadLong(fp);
			printf("COMM chunk size=%d \n",ckSize);
			offset =bytesRead;
			bytesRead += sizeof(LONG_INT);
			numberChannels=ReadShort(fp);
			bytesRead += sizeof(short int);
			numberSampleFrames=ReadLong(fp);
			bytesRead += sizeof(LONG_INT);
			bitsSample=ReadShort(fp);
			bytesRead += sizeof(short int);
			samplingRate=(float)ReadExtended(fp);
			bytesRead += sizeof(EXTENDED);
#if 000
			num2str(&f, sampleRate, buffer);
			printf("Extended to string %s\n",PtoCstr(buffer));
#endif

			printf("Bits/Sample=%d Sampling Rate=%f, Channels=%d\n",
					bitsSample,samplingRate,numberChannels);
			printf("Total number of frames = %ld\n",numberSampleFrames);
			/*
			 * Skip over compression type
			 * We assume NONE
			 */
			offset=ckSize-(bytesRead-offset);
			fseek(fp,offset,SEEK_CUR);

	} else if(chunkID == markerCkID) {
			printf("Found a marker chunk\n");
			ckSize=ReadLong(fp);
			bytesRead += sizeof(LONG_INT);
			printf("MARK chunk size=%d \n",ckSize);
			numberMarkers=ReadShort(fp);
			bytesRead += sizeof(short);
			printf("MARK number of markers=%d \n",numberMarkers);
			for(i=0; i<numberMarkers; i++) {
				id=ReadShort(fp);
				bytesRead += sizeof(short);
				position=ReadLong(fp);
				bytesRead += sizeof(unsigned LONG);
				fread(&c,sizeof(unsigned char),1,fp);
				n=c;
				for(j=0; j<n; j++) {
					fread(&c,sizeof(unsigned char),1,fp);
					markerName[j]=c;
				}
				markerName[n]=(char )NULL;
				bytesRead += n;
				if(!(n%2)) {
					/*
					 * Read pad
					 */
					fread(&c,sizeof(unsigned char),1,fp);
					bytesRead += 1;
				}
	//xxxxx			if(hdr_P)
	//xxxxx				   IIPMarkerAdd(markerName,position,id,hdr_P);
			}
//xxxxx				if(hdr_P)
//xxxxx					IIPMarkerPrint(hdr_P);



	} else {
			printf("Could not understand chunk ID\n");
	}
}
/*
 * set the parameters to be returned
 */
*points_P = numberSampleFrames;
*samplingRate_P = samplingRate;
*bits_P = bitsSample;
*channels_P=numberChannels;
/*
 * We are ready to read samples now that all chunks have been
 * processed and we are right at the Sound Chunk
 *
 * First check if we want this routine to read the samples or
 * the user is. This is done by checking fp_P. If it is NULL then
 * The user wants this routine to allocate arrays and read in the samples
 * Otherwise just return the file pointer fp so that the user can read
 * the samples.
 */

if(fileName==NULL) {
	*y_PP=NULL;
	*x_PP=NULL;
	fprintf(stderr,"AIFF Read Setup Complete\n");
	return(0);
}
/*
 * setup  multichannel if numberChannels > 1
 */
if(numberChannels >1 && multiChannel_PPP) {
	multiChannel_PP=(float**)calloc(numberChannels,sizeof(float*));
	for(i=0; i<numberChannels; i++) {
		multiChannel_PP[i]=(float*)calloc(numberSampleFrames,
						sizeof(float));
	}
	/*
 	 *  we assume floating point for multichannel for now
	 */
	for(i=0; i< numberSampleFrames; i++) {
		for(j=0; j<numberChannels; j++) {
			fread(&sampf,sizeof(float),1,fp);
			multiChannel_PP[j][i]=sampf;
		}
	}
	*multiChannel_PPP=multiChannel_PP;
	fclose(fp);
	return(0);



}

y_P=(float*)calloc(numberSampleFrames,sizeof(float));
if(y_P == NULL) {
	fprintf(stderr,"AIFF read could not allocate floating point array\n");
	return((int)NULL);
}
x_P=NULL;
if(numberChannels == 2) {
	x_P=(float*)calloc(numberSampleFrames,sizeof(float));
	if(x_P == NULL) {
		fprintf(stderr,"AIFF read could not allocate floating point array\n");
		return((int)NULL);
	}
}

if( bitsSample <= 8) {
	/*
	 * allocate array to store samples
	 */
	sample_P=(char*)calloc(numberChannels*numberSampleFrames,sizeof(char));
	if(sample_P == NULL) {
		fprintf(stderr,"Could not allocate space in rdaiff\n");
		return(3);
	}
	/*
	 * Read numberSampleFrames into sample_P
	 */
#if 0
	if(fread(sample_P,sizeof(char),numberChannels*numberSampleFrames,fp)==(int)NULL)
					return(5);
#endif
	for(i=0; i< numberSampleFrames; i++) {
		if(numberChannels == 1) {
			if(fread(&samp8,sizeof(signed char),1,fp)==(int)NULL)
					return(5);
			y_P[i]=(float)samp8;
		}
		else {
			if(fread(&samp8,sizeof(signed char),1,fp)==(int)NULL)
					return(5);
			y_P[i]=(float)samp8;
			if(fread(&samp8,sizeof(signed char),1,fp)==(int)NULL)
					return(5);
			x_P[i]=(float)samp8;

		}


	}
	free(sample_P);
} else if(bitsSample <= 16) {
	/*
	 * For 16 bits if this is an SGI machine or one that
	 * reads Motorola format then the following way is very
	 * inefficient. Use the method for 8 bits but with short instead.
	 * The method below is for portability
	 */
	for(i=0; i< numberSampleFrames; i++) {
		sample=ReadShort(fp);
		y_P[i]=(float)sample;
		if(numberChannels ==2) {
			sample=ReadShort(fp);
			x_P[i]=(float)sample;

		}

	}

} else if(bitsSample == 32) {
	/*
 	 * floating point
	 */
	for(i=0; i< numberSampleFrames; i++) {
		fread(&sampf,sizeof(float),1,fp);
		y_P[i]=(float)sampf;
		if(numberChannels ==2) {
			fread(&sampf,sizeof(float),1,fp);
			x_P[i]=(float)sampf;

		}

	}



}


*y_PP= y_P;
*x_PP= x_P;

fclose(fp);

return(0);
}


int	IIP_CreateVectorFromAIFF(char *fileName,float **vector_P, int *length_P, float *samplingRate_P,char *info)
{

float *y_P;
float *x_P;
int	points;
int	bits;
float	samplingRate;
//char 	strBuf[80];
int	i;
float	dx;

iip_MarkerHdr_Pt        hdr_P;
iip_Marker_Pt	current_P;
float	xb,xe,yb,ye;
int	numberChannels;

x_P=NULL;

/*
 * Header for markers
 */
//xxxxx hdr_P=IIPCreateMarkerHeader();

if(IIP_ReadAIFF(fileName,&x_P,&y_P,&points,&samplingRate,&bits,hdr_P,
		&numberChannels,NULL,NULL)) {
	fprintf(stdout,"Could not read AIFF file\n");
	return((int)NULL);

}

if(x_P)
	numberChannels=2;
else
	numberChannels=1;
#if 00000
if(numberChannels==1) {
	x_P = (float*)calloc(points,sizeof(float));

	if(x_P == NULL) {
		IIPInfo("Could not allocate memory in Open AIFF file");
		return(NULL);
	}
}
if(samplingRate==0.0)
	dx=1.0;
else
	dx=1.0/samplingRate;

if(numberChannels == 2)
	dx=x_P[1]-x_P[0];

#endif

if(info)
     sprintf(info,"Bits:%d Sampling Rate:%f Samples:%d",bits,samplingRate,points);
#if 000
if(numberChannels==1)
	for(i=0; i<points; i++)
		x_P[i]=i*dx;
#endif


#if 0000
curve_P=IIP_PlotCurve( x_P,y_P,points,fileName,strBuf,"Samples",
                "",IIP_PLOT_LINE);

if(curve_P==NULL)
	return(NULL);


#endif
if (hdr_P->head_P != NULL) {
     for ( current_P = hdr_P->head_P; current_P;
                                current_P = current_P->next_P) {
		xb=current_P->position*dx+x_P[0];
		xe=xb;
#if 0000
		yb=curve_P->minMax_A[3]*0.9;
		ye=curve_P->minMax_A[3]*0.8;
#endif

		fprintf(stdout,"%s \n",current_P->name);

//		IIP_SetInfoItem(curve_P,current_P->name,TRUE,
//				xb,yb,xe,ye);
     }
}

*samplingRate_P=samplingRate;
*vector_P=y_P;
*length_P=points;

return(1);
}
