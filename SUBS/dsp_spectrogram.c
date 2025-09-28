
/*  Capsim (r) Text Mode Kernel (TMK) DSP Library  
 *    Copyright (C) 1989-2017  Silicon DSP Corporation 
 *
 *    This library is free software; you can redistribute it and/or
 *    modify it under the terms of the GNU Lesser General Public
 *    License as published by the Free Software Foundation; either
 *    version 2.1 of the License, or (at your option) any later version.
 *
 *    This library is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *    Lesser General Public License for more details.
 *
 *    You should have received a copy of the GNU Lesser General Public
 *    License along with this library; if not, write to the Free Software
 *    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 *    http://www.silicondsp.com
 *    Las Vegas, Nevada
 */
/*
 * This routine produces the spectrogram 
 * of the input buffer.
 * Programmer: 	Sasan Ardalan
 * Date: 		Dec. 4, 1993
 */

#include <stdio.h>
#include <math.h>
#include "dsp.h"
#include "cap_fft.h"
#include "cap_fftr.h"
 
#define RESULTS_SURFACE_PLOT 1
#define RESULTS_SPECTROGRAM 2
#define RESULTS_DB 4
#define RESULTS_FILE 5

#define         IIP_WINDOW_TYPES 2
#define WINDOW_RECTANGULAR 0
#define WINDOW_HAMMING 1
#define WINDOW_HANNING 2






dsp_floatMatrix_Pt *Dsp_Spectrogram(doubleVector_t *vec_P,int windowLength,int overlap,int zeropad,float samplingRate,
	int windowType,float threshold,int surfaceFlag,int imageFlag,int indBFlag,int fileFlag,char *fileName)
{

dsp_floatMatrix_Pt *image_P;
int	i,j;
int n;
int state;
float tmp;
int numberOfSamples;
int totalCount=0;
int total=0;
float x;
int ii;
int skip;
float tmp1,tmp2;
int result;
float realAz,imgAz,Az;
float theta,dtheta;
int flag;
int windowSize;
int npts;
int m;
float*  x_P;
float*  xx_P;
float* spect_P;
float	spectrum;
int segment;
int spectPoints;
int	windowNumber,numberWindows;
float** refl_PP;
float*	alpha_P;
float*	seg_P;
float	**image_PP;
char* reflTitle;
float	ymin,ymax;
float	time;
float	min,max,variance,mean;
char	strBuf[100];

	int fftexp;
	int fftl;
//	float* fftBuffer;
	float* dataBuffer;
	float* tempBuffer;
	int	checkFlag;
	int	fftld2;
	int	pointCount=0;
	float	w;
	float	mag;
	int	windowLength1;
        int     grayScale;
        dsp_floatMatrix_t   *matrix_P;
        dsp_floatMatrix_t   *matrixInterp_P;
        float minn,maxx;
        float maxxx,maxy,minx,miny;

cap_fftr_cfg pforward;
cap_fft_scalar* temp;
cap_fft_cpx* fftBuffer;





FILE* fp;
#if 1
fprintf(stderr,"Spectrogram windowLength=%d,overlap=%d,samplingRate=%f, windowType=%d,threshold=%f surfaceFlag=%d,imageFlag=%d,indBFlag=%d,fileFlag=%d,fileName=%s \n",windowLength,overlap,samplingRate, windowType,threshold,surfaceFlag,imageFlag,indBFlag,fileFlag,fileName);
#endif

if(vec_P == NULL) {
        fprintf(stderr,"spectrogram: null vector \n");
        return(NULL);
}

fp=fopen("imageprefs.dat","r");
if(fp) {
        fscanf(fp,"%#s%d",&grayScale);
        fclose(fp);

} else {
        grayScale=0;

}




/*
 * This segment of code  computes the ONE-SIDED FFT of a real stream which is
 * overlapped by an amount of (fftl-M) samples for each FFT computation.
 * It outputs ((int)((totalNumberofPoints - fftl)/M)+1)*fftl/2 points. The
 * totalNumberofPoints denotes the number of points in the real input
 * data stream.

 * Programmer: 	Jeyhan Karaoguz,Sasan Ardalan
 * Date: 		June 5, 1992
 */

npts=windowLength;
windowLength1=0;
if(zeropad > npts) {
	npts=zeropad;
	windowLength1=windowLength;
}
else {
	npts=windowLength;
}

/*
 * compute the power of 2 number of fft points
 */
fftexp = (int) (log((float)npts)/log(2.0)+0.5);
fftl = 1 << fftexp;
if (fftl > npts ) {
	fftl = fftl/2;
	fftexp -= 1;
}


if (fftl < 2)
{
		fprintf(stderr,"Spectrogram: fft length is too short\n");
		return(NULL);
}


pforward = cap_fftr_alloc(fftl, FORWARD_FFT, NULL,NULL);
temp = (cap_fft_scalar*)calloc(fftl,sizeof(cap_fft_scalar));
fftBuffer = (cap_fft_cpx*)calloc(fftl,sizeof(cap_fft_cpx));
if(temp==NULL) {
       fprintf(stderr,"fft: can't allocate work space \n");
     	return(NULL);
}
if(fftBuffer==NULL) {
       fprintf(stderr,"fft: can't allocate work space \n");
     	return(NULL);
}
/*
 * if no zero padding window length is fft length
 */
if(!windowLength1) windowLength1=fftl;

//if ((fftBuffer = (float*)calloc(fftl,sizeof(float))) == NULL)
//{
//	fprintf(stderr,"fft: can't allocate work space \n");
//	return(NULL);
//}


if ((dataBuffer = (float*)calloc(fftl,sizeof(float))) == NULL)
{
        fprintf(stderr,"spectrogram fft: can't allocate work space \n");
        return(NULL);
}

if ((tempBuffer = (float*)calloc(fftl,sizeof(float))) == NULL)
{
        fprintf(stderr,"spectrogram: can't allocate work space \n");
        return(NULL);
}

if(fftl == overlap) {
	fprintf(stderr,"Spectrogram: Overlap cannot equal FFT Length \n");
	return(NULL);
}

numberWindows=(int)((float)(vec_P->length - windowLength1)/(float)(windowLength1-overlap)+4);


fprintf(stderr,"Number of Windows=%d\n",numberWindows);
fftld2=fftl/2;
if(numberWindows < 0 || numberWindows == 0) {
	fprintf(stderr,"Not enough columns in Spectrogram \n");
	return(NULL);
}


printf("Spectrogram numberWindows=%d fftld2=%d\n",numberWindows,fftld2);


matrix_P= Dsp_AllocateRealFloatMatrix(fftld2,numberWindows);

if(!matrix_P) return(NULL);



#if 0 /*SHA*/
image_PP=(float**)calloc(fftld2,sizeof(float));
if(image_PP == NULL) {
	     IIPInfo("Spectrogram could not allocate space for image");
	     return(NULL);
}
for(i=0; i<fftld2; i++) {
     image_PP[i]=(float*)calloc(numberWindows,sizeof(float));
     if(image_PP[i] == NULL) {
	     IIPInfo("Spectrogram could not allocate space for image");
	     return(NULL);
     }
}
#endif

segment=0;
windowNumber=0;
pointCount=0;
for(ii=0; ii<vec_P->length; ii++) {
	/*
	 * real input buffer
	 */
	j=pointCount;
	dataBuffer[j]=vec_P->vector_P[ii];
	pointCount++;


	if(checkFlag == 0) {
	/*
	 * Get enough points
	 */
	if(pointCount >= windowLength1) {
		for (i=0; i<windowLength1; i++) {
			switch (windowType) {
			    case  WINDOW_HAMMING:
				w=0.54-0.46*cos(2.*PI*(float)i/(float)(windowLength1-1));

				break;
			    default :
				w=1.0;
				break;
			}
		 
			temp[i]=w*dataBuffer[i];
			printf("SPECTROGRAM ii=%d j=%d i=%d  temp=    %f \n",ii,j,i,temp[i]);

		}
		
		/*
 		* perform fft calculation
 		*/
 		printf("SPECTROGRAM 11111 windowNumber=%d\n",windowNumber);
 		cap_fftr(pforward, temp,fftBuffer);
 		printf("SPECTROGRAM 22222 fftld2=%d\n",fftld2);
 		
	//	rfft(fftBuffer,fftl);


		/*
		 *
 		 * now, output complex pairs
	 	 */
		for (i=0; i<fftld2; i++) {
			mag=sqrt(fftBuffer->r*fftBuffer->r+
				fftBuffer->i*fftBuffer->i);
			if(indBFlag)
				mag=20*log10(MAX(mag,1.0e-14));
			//	printf("SPECTROGRAM 3030303030\n");
			matrix_P->matrix_PP[fftld2-i-1][windowNumber]=mag;
		}
		printf("SPECTROGRAM 3333\n");
		for (i=0; i<overlap; i++)
			tempBuffer[i] = dataBuffer[i+fftl-overlap];
		printf("SPECTROGRAM 44444\n");
		pointCount = 0;
		checkFlag = 1;
		windowNumber++;
	}
	}
	else
	{
		if(pointCount >= windowLength1-overlap)
		{
			for (i=0; i<windowLength1-overlap; i++)
				tempBuffer[i+overlap]=dataBuffer[i];
			for (i=0; i<fftl; i++) {
			  switch (windowType) {
			    case  WINDOW_HANNING:
				w=0.54-0.46*cos(2.*PI*(float)i/(float)(windowLength1-1));
				break;
			    default:
				w=1.0;
				break;
			  }
                          temp[i] = w*tempBuffer[i];
 //                         printf("SPECTROGRAM2 ii=%d j=%d i=%d  temp=    %f \n",ii,j,i,temp[i]);
			}
			
		                  /*
                         * perform fft calculation
                         */
                         
                        cap_fftr(pforward, temp,fftBuffer); 
                       // rfft(fftBuffer,fftl);

//for (i=0; i<fftld2; i++){
  //    printf("SPECTROGRAM4 windowNumber=%d temp=%f    i=%d  fftBuffer.r=    %f  fftBuffer.i=    %f \n",windowNumber,temp[i],i,fftBuffer[i].r,fftBuffer[i].i );
//}
                        /*
                         * now, output complex pairs
                         */
                        for (i=0; i<fftld2; i++)
                        {
			   mag=sqrt(fftBuffer[i].r*fftBuffer[i].r+
				fftBuffer[i].i*fftBuffer[i].i);
			   if(indBFlag)
				mag=20*log10(MAX(mag,1.0e-14));
			   matrix_P->matrix_PP[fftld2-i-1][windowNumber]=mag;
	//		   printf("SPECTROGRAM3 windowNumber=%d   i=%d  temp=    %f \n",windowNumber,i,mag );
                         }
			 windowNumber++;
                         for (i=0; i<overlap; i++)
                                 tempBuffer[i] = tempBuffer[i+windowLength1-overlap];
			pointCount = 0;
		}
	 }

}


fprintf(stderr,"Spectrogram Counted windows=%d\n",windowNumber);

if(grayScale)
        Dsp_MatrixNormalizeDB(matrix_P,256,threshold,&minn,&maxxx);

else {
        Dsp_MatrixNormalizeDB(matrix_P,16,threshold,&minn,&maxxx);
        Dsp_MatrixNormalize(matrix_P,256);
}

if(samplingRate)
        maxx=vec_P->length/(float)samplingRate;
else
        maxx=windowNumber;

if(samplingRate)
        maxy=samplingRate/2.0;
else
        maxy=fftld2;


#if 0
if(grayScale)  {
        IIP_PlotMatrix(matrix_P,0.0,maxx,0.0,maxy,"Spectrogram");
}else {
        IIP_PlotMatrixClut(matrix_P,0.0,maxx,0.0,maxy,"Spectrogram",minn,maxxx,128,1);
}
#else
        matrixInterp_P=  Dsp_MatrixInterpolate(  matrix_P,2,1);
//#ifdef IIP_SUPPORT
 //XXXXXX        IIP_DisplayMatrix(matrixInterp_P,0.0,maxx,0.0,maxy,"Spectrogram");
//#endif
#endif





if(fileFlag) {
	fp=fopen(fileName,"w");
	if(fp==NULL) {
		fprintf(stderr,"Spectrogram could not open file:%s to write \n",fileName);
	} else {
		fprintf(fp,"%d %d\n",numberWindows,fftld2);
	  	for(j=0; j<fftld2; j++)
			for(i=0; i<numberWindows; i++)
				fprintf(fp,"%f\n",matrix_P->matrix_PP[j][i]);
	}
	fclose(fp);
}



#if 0
free(dataBuffer);
free(fftBuffer);
free(tempBuffer);
#endif

return(matrix_P);

}
