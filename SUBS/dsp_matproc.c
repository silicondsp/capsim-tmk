

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
 * dsp_matproc.c
 *
 * (c)Copyright 1992, XCAD Corporation, Raleigh, NC 27650
 *  All Rights Reserved
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <assert.h>

#include "dsp.h"
#include "ranlib.h"

#define MIN(x, y) (((x) < (y)) ? (x) : (y))
#define MAX(x, y) (((x) > (y)) ? (x) : (y))


/*
 * compute matrix statistics
 *
 * Usage:
 * float min,max,mean,variance;
 * ...
 *
 * Dsp_MatrixStats(matrix_P,&min,&max,&mean,&variance);
 * ...
 */

void  Dsp_MatrixStats(dsp_floatMatrix_Pt	matrix_P,float	*min_P,float	*max_P,float	*mean_P,float	*variance_P)

{

int	width,height;
int	i,j;
float	fpixel;
float	min,max;
float	mean,variance;

width=matrix_P->width;
height=matrix_P->height;

min=max=matrix_P->matrix_PP[0][0];
mean=0.0;
for(i=0; i< height; i++)
	for(j=0; j<width; j++) {
			fpixel=matrix_P->matrix_PP[i][j];
			min=MIN(min,fpixel);
			max=MAX(max,fpixel);
			mean += fpixel;
	}
mean=mean/(float)(height*width);
variance=0;
for(i=0; i< height; i++)
        for(j=0; j<width; j++) {
                        fpixel=matrix_P->matrix_PP[i][j];
			variance += (fpixel-mean)*(fpixel-mean);
        }
variance=variance/(float)(height*width);

*min_P=min;
*max_P=max;
*mean_P=mean;
*variance_P=variance;

}




void  Dsp_MatrixNormalize(dsp_floatMatrix_Pt	 matrix_P,int level)


{

int	width,height;
int	i,j;
float	fpixel;
float	min,max;
float	scale;

width=matrix_P->width;
height=matrix_P->height;

min=max=matrix_P->matrix_PP[0][0];
for(i=0; i< height; i++)
	for(j=0; j<width; j++) {
			fpixel=matrix_P->matrix_PP[i][j];
			min=MIN(min,fpixel);
			max=MAX(max,fpixel);
	}

scale=(float)(level-1)/(max-min);
for(i=0; i< height; i++)
        for(j=0; j<width; j++) {
                        fpixel=matrix_P->matrix_PP[i][j];
                        matrix_P->matrix_PP[i][j]=(fpixel-min)*scale;
        }

}


void  Dsp_MatrixNormalizeDB(dsp_floatMatrix_Pt	matrix_P,int	level,float	dBFloor,float *min_P, float *max_P)


{

int	width,height;
int	i,j;
float	fpixel;
float	min,max;
float	scale;

width=matrix_P->width;
height=matrix_P->height;

//min=1.e+22;
//max=-1.e+22;
min=max=matrix_P->matrix_PP[0][0];
for(i=0; i< height; i++)
	for(j=0; j<width; j++) {
			fpixel=matrix_P->matrix_PP[i][j];
			if(min >fpixel) min=fpixel;
			if(max <fpixel) max=fpixel;
//			min=MIN(min,fpixel);
//			max=MAX(max,fpixel);
	}
if(dBFloor != 0)min=max-dBFloor;
scale=(float)(level-1)/(max-min);
fprintf(stderr,"min=%f max=%f level=%d scale=%f\n",min,max,level,scale);
for(i=0; i< height; i++)
        for(j=0; j<width; j++) {
                        fpixel=matrix_P->matrix_PP[i][j];
                        if(fpixel < min) fpixel=min;
                        matrix_P->matrix_PP[i][j]=(fpixel-min)*scale;

        }

*min_P=min;
*max_P=max;

}


void  Dsp_MatrixNormalizeDBInverse(dsp_floatMatrix_Pt	matrix_P,int	level,float	dBFloor,float *min_P, float *max_P)


{
int	width,height;
int	i,j;
float	fpixel;
float	min,max;
float	scale;

width=matrix_P->width;
height=matrix_P->height;

//min=1.e+22;
//max=-1.e+22;
min=max=matrix_P->matrix_PP[0][0];
for(i=0; i< height; i++)
	for(j=0; j<width; j++) {
			fpixel=matrix_P->matrix_PP[i][j];
			if(min >fpixel) min=fpixel;
			if(max <fpixel) max=fpixel;
//			min=MIN(min,fpixel);
//			max=MAX(max,fpixel);
	}
if(dBFloor != 0)max=min+dBFloor;
scale=(float)(level-1)/(max-min);
fprintf(stderr,"min=%f max=%f level=%d scale=%f\n",min,max,level,scale);
for(i=0; i< height; i++)
        for(j=0; j<width; j++) {
                        fpixel=matrix_P->matrix_PP[i][j];
                        if(fpixel > max) fpixel=max;
                        matrix_P->matrix_PP[i][j]=(float)(level-1) -(fpixel-min)*scale;

        }
*min_P=min;
*max_P=max;

}



/*
 * compute histogram of matrix
 * results are stored in the array *hist_PP
 * returns a 1 if an error is encountered.
 *
 * Usage:
 *
 * float *h_P;
 * dsp_floatMatrix_Pt matrix_P;
 * ...
 *
 * if(Dsp_MatrixHistogram(matrix_P,256,&h_P)) {
 * 	Error();
 * 	return;
 * }
 * ...
 *
 */

int  Dsp_MatrixHistogram(dsp_floatMatrix_Pt	 matrix_P,int level,float	**hist_PP)


{

int	width,height;
int	i,j;
float	fpixel;
float	min,max;
float	scale;
unsigned int pixel;
float	total;
int* histPixel_P;
float	*hist_P;

hist_P=(float*)calloc(level,sizeof(float));
if(hist_P == NULL) {
	fprintf(stderr,"Could not allocate space in Dsp_MatrixHistogram\n");
	return(1);
}
histPixel_P=(int*)calloc(level,sizeof(int));
if(histPixel_P == NULL) {
	fprintf(stderr,"Could not allocate space in Dsp_MatrixHistogram\n");
	return(1);
}
width=matrix_P->width;
height=matrix_P->height;

total=width*height;

for(i=0; i< height; i++)
	for(j=0; j<width; j++) {
			pixel=(unsigned int)matrix_P->matrix_PP[i][j];
			if(pixel <0 )
				pixel=0;
			if(pixel > level-1)
				pixel =level-1;
			histPixel_P[pixel] += 1;
	}

for(i=0; i<level; i++)
	hist_P[i]=(float)histPixel_P[i]/(float)total;

*hist_PP = hist_P;
free(histPixel_P);
return(0);
}



/*
 * Histogram equalization
 *
 * Histogram Equalization of a matrix
 * Matrix is overwritten
 *
 *
 * level is the number of levels. For example for an 8 bit image
 * it is 256.
 * returns a 1 if an error is encountered.
 *
 * Usage:
 *
 * dsp_floatMatrix_Pt matrix_P;
 * ...
 *
 * if(Dsp_MatrixHistogramEq(matrix_P,256)) {
 * 	Error();
 * 	return;
 * }
 * ...
 *
 */
int  Dsp_MatrixHistogramEq(dsp_floatMatrix_Pt	matrix_P,int level)

{

int	width,height;
int	i,j;
float	fpixel;
float	min,max;
float	scale;
unsigned int pixel;
float	total,sum;
float	*hist_P;
int	*histEq_P;

histEq_P=(int*)calloc(level,sizeof(int));
if(histEq_P == NULL) {
	fprintf(stderr,"Could not allocate space in Dsp_MatrixHistogramEq\n");
	return(1);
}
Dsp_MatrixNormalize(matrix_P,level);
if(Dsp_MatrixHistogram(matrix_P,level,&hist_P)) return(1);

width=matrix_P->width;
height=matrix_P->height;

total=width*height;

for(i=0; i< level; i++) {
	sum=0;
	for(j=0; j<=i; j++)
		sum += hist_P[j];
	histEq_P[i]=(int)(((level-1) * sum) +0.5);
}
for(i=0; i< height; i++) {
	for(j=0; j<width; j++) {
			pixel=(unsigned int)matrix_P->matrix_PP[i][j];
			matrix_P->matrix_PP[i][j]=(float)histEq_P[pixel];


	}
}


free(histEq_P);

return(0);
}

/*
 * Dsp_MatrixAddNoise()
 *
 * Add noise to a matrix
 *
 * type specifies the type of noise:
 * type = NOISE_UNIFORM
 *	param1=a, param2=b where the uniform noise is distributed between
 *	a and b
 *
 * type= NOISE_GAUSSIAN
 *	Add Normal Gaussian Random Variable with
 * 	param1=mean and param2=standard deviation
 *
 * type= NOISE_SPIKE
 * 	Add spike noise. This noise is generated as follows:
 *	a Normal distribution is generated. If its level exceeds
 *	param1, then its value is assigned to x.
 *	Next x is multiplied by param2 to obtain the spike.
 *	The spike value is then added to the matrix.
 *
 * The expression determines the seeds. To get different outcomes
 * change the expression.
 *
 */
void Dsp_MatrixAddNoise(dsp_floatMatrix_Pt	matrix_P,int type,char*	expression,float	param1,float	param2)

{
long int	seed1,seed2;
float	a,b;
float	mean,std;
float	spikeEvent;
float	spikeAmp;
float	temp;
int	i,j;
/*
 * Get seeds from expression
 */
phrtsd(expression,&seed1,&seed2);
#ifdef DEBUG
fprintf(stderr,"seed1=%d seed2=%d\n",seed1,seed2);
#endif

switch (type) {
	case NOISE_NONE:
		return;
	case NOISE_UNIFORM:
		a=param1;
		b=param2;
		setall(seed1,seed2);
		for(i=0; i<matrix_P->height; i++)
		   for(j=0; j<matrix_P->width; j++)
			matrix_P->matrix_PP[i][j] += genunf((float)a,(float)b);
		break;
	case NOISE_GAUSSIAN:
		mean=param1;
		std=param2;
		setall(seed1,seed2);
		for(i=0; i<matrix_P->height; i++)
		   for(j=0; j<matrix_P->width; j++) {
			matrix_P->matrix_PP[i][j] += gennor((float)mean,(float)std);
		  }
		break;
	case NOISE_SPIKE:
		setall(seed1,seed2);
		spikeEvent=param1;
		spikeAmp=param2;
		for(i=0; i<matrix_P->height; i++)
		   for(j=0; j<matrix_P->width; j++) {
			temp = gennor((float)0.0,(float)1.0);
			if(temp < spikeEvent)
				temp=0.0;
			else
				temp = temp*spikeAmp;
			matrix_P->matrix_PP[i][j] += temp;
		}
		break;
}
}


/*
 * Dsp_MatrixOperate()
 *
 * Performs various operations on a matrix
 *
 * operation= OPER_TRANSPOSE
 *	return a new matrix which is the transpose of the input matrix.
 *
 * operation= OPER_FLIP_VERT
 *	flip the matrix about the vertical axis
 *	return the input matrix
 *
 * operation= OPER_FLIP_HORZ
 *	flip the matrix about the horizontal axis
 *	return the input matrix
 *
 * operation= OPER_INVERSE
 *	inverse of the matrix (the image negative so to speak) :
 * 	level must be specified. For example for 8 bit
 *	level = 256.
 *	return the input matrix
 *
 */

dsp_floatMatrix_Pt Dsp_MatrixOperate(dsp_floatMatrix_Pt	matrix_P,int operation,int level)

{

dsp_floatMatrix_Pt	newMatrix_P;
dsp_floatMatrix_Pt	matTrans_P;
int	i,j,k;
float	temp;

if(matrix_P == NULL) {
	return(NULL);
}

switch(operation) {
    case OPER_TRANSPOSE:
	matTrans_P=Dsp_AllocateMatrix(matrix_P->height,matrix_P->width);
	for(k=0; k<matrix_P->height; k++) {
               for(j=0; j<matrix_P->width; j++) {
                        matTrans_P->matrix_PP[j][k]=matrix_P->matrix_PP[k][j];
              }
        }
	return(matTrans_P);
	break;
    case OPER_FLIP_VERT:
	for(k=0; k<matrix_P->height; k++) {
            for(j=0; j<matrix_P->width/2; j++) {
                  temp=matrix_P->matrix_PP[k][j];
                  matrix_P->matrix_PP[k][j]=
			matrix_P->matrix_PP[k][matrix_P->width -j-1];
                  matrix_P->matrix_PP[k][matrix_P->width-j-1]=temp;
            }
        }
	break;
    case OPER_FLIP_HORZ:
	for(k=0; k<matrix_P->height/2; k++) {
            for(j=0; j<matrix_P->width; j++) {
                  temp=matrix_P->matrix_PP[k][j];
                  matrix_P->matrix_PP[k][j]=
				matrix_P->matrix_PP[matrix_P->height-k-1][j];
                  matrix_P->matrix_PP[matrix_P->height-k-1][j]=temp;
            }
        }
	break;
    case OPER_INVERSE:
	for(k=0; k<matrix_P->height; k++) {
            for(j=0; j<matrix_P->width; j++) {
                  matrix_P->matrix_PP[k][j] = level-1 -matrix_P->matrix_PP[k][j];

            }
        }
	break;

}
return(matrix_P);
}


/*
 * Dsp_CalculateMatrix(matrix1_P,matrix2_P,
 *              operation,wOffset,hOffset,level)
 *
 * Perform various calculations and logical operations on
 * matrix1_P using matrix2_P
 * Operations are performed on a sub matrix of matrix1_P.
 * matrix2_P can be translated by specifying a width and height
 * offset.
 * If offsets are zero and the dimensions of both matrices are
 * the same then the operation is carried out over the whole image.
 * even if the dimensions of both matrices are the same, a sub matrix
 * of matrix1_P can be operated on by specifying the width and height
 * offset.
 *
 * level is used to for complement ( same as negation of an image).
 *
 * If everything went well a 0 is returned. Otherwise a 1 is returned.
 *
 */

int Dsp_CalculateMatrix(dsp_floatMatrix_Pt	matrix1_P,dsp_floatMatrix_Pt	matrix2_P,
		int operation,int wOffset,int hOffset,int level)

{

dsp_floatMatrix_Pt     curve_P;
float   *x_P,*y_P;
int i,j;
float tmp;
float	dx,x;
int	points;
dsp_floatMatrix_Pt 	image_P;
int	width2,height2;
unsigned int	ipix1,ipix2;
float	pixel,pixel1,pixel2;
int	maxWidth,maxHeight;


if(matrix1_P == NULL) return(1);

if(wOffset > matrix1_P->width) return(0);
if(hOffset > matrix1_P->height) return(0);

if(matrix2_P) {
	width2=matrix2_P->width;
	height2=matrix2_P->height;
} else {
	width2=matrix1_P->width;
	height2=matrix1_P->height;

}


maxWidth=MIN(matrix1_P->width,width2);
maxHeight=MIN(matrix1_P->height,height2);

for(i=hOffset; i<maxHeight; i++) {
   for(j=wOffset; j<maxWidth; j++) {
	pixel1=matrix1_P->matrix_PP[i][j];
	if(matrix2_P ) {
		pixel2=matrix2_P->matrix_PP[i-hOffset][j-wOffset];
	}
	switch(operation) {
	   case DSP_MATRIX_MULTIPLY:
		pixel=pixel1*pixel2;
		break;
	   case DSP_MATRIX_ADD:
		pixel=pixel1+pixel2;
		break;
	   case DSP_MATRIX_SUBTRACT:
		pixel=pixel1-pixel2;
		break;
	   case DSP_MATRIX_DIVIDE:
		if(pixel2 == 0.0) {
			fprintf(stderr,"Divide Overflow in image calculator\n");
			pixel=1.e22;
			break;
		}
		pixel=pixel1/pixel2;
		break;
	   case DSP_MATRIX_AND:
		ipix1=(unsigned int)pixel1;
		ipix2=(unsigned int)pixel2;
		pixel=(float)(ipix1&ipix2);
		break;
	   case DSP_MATRIX_OR:
		ipix1=(unsigned int)pixel1;
		ipix2=(unsigned int)pixel2;
		pixel=(float)(ipix1 | ipix2);
		break;
	   case DSP_MATRIX_EXCLUSIVE_OR:
		ipix1=(unsigned int)pixel1;
		ipix2=(unsigned int)pixel2;
		pixel=(float)(ipix1 ^ ipix2);
		break;
	   case DSP_MATRIX_COPY:
		pixel=pixel2;
		break;
	   case DSP_MATRIX_COMPLEMENT:
		ipix1=(unsigned int)pixel1;
		pixel=(float)(level-1-(ipix1));
		break;
	}
        /*
	 *
         */
	matrix1_P->matrix_PP[i][j]=pixel;
    }
}


return(0);
}




void    Dsp_FillMatrix(dsp_floatMatrix_Pt	 matrix_P,float value)

{

int	i,j;

if(matrix_P==NULL)return;

for(i=0; i<matrix_P->height; i++)
	for(j=0; j<matrix_P->width; j++)
		matrix_P->matrix_PP[i][j]=value;


}



dsp_floatMatrix_Pt	 Dsp_GenMatrix(int	width,int	height,int	rectWidth,int	rectHeight,
			int	widthOffset,int	heightOffset,
			float pixel,int	complexFlag,int	complementFlag)

{

int	i, j;
int	rowIndex,columnIndex;
dsp_floatMatrix_Pt	matrix_P;


if(width == 0 || height==0) return(NULL);
if(!complexFlag) {
	matrix_P=Dsp_AllocateMatrix(width,height);
} else
	matrix_P=Dsp_AllocateMatrix(2*width,height);


if(matrix_P == NULL) {
	fprintf(stderr,"GenMatrix could not allocate memeory\n");
	return(NULL);
}

if(complementFlag)
	Dsp_FillMatrix(matrix_P,pixel);

for(i=0; i<rectHeight; i++) {
	for(j=0; j<rectWidth; j++)
		if(!complexFlag) {
			rowIndex=i+heightOffset;
			columnIndex=j+widthOffset;
			if(rowIndex < height &&
				columnIndex < width)
			   matrix_P->matrix_PP[rowIndex][columnIndex]=
				complementFlag ? 0:pixel;
		}
		else {
			rowIndex=i+heightOffset;
			columnIndex=j+widthOffset;
			if(rowIndex < height &&
				columnIndex < width) {
			   matrix_P->matrix_PP[rowIndex][2*columnIndex]=
				complementFlag ? 0:pixel;
			   matrix_P->matrix_PP[rowIndex][2*columnIndex+1]=
				complementFlag ? 0:pixel;
			}
		}
}


return(matrix_P);
}



