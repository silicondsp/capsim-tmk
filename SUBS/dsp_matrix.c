

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
 * dsp_matrix.c
 *
 */

#include <stdio.h>
#include <math.h>
#include <assert.h>
#include <stdlib.h>

#include "dsp.h"

#define FFT_FORWARD     0
#define FFT_INVERSE     1

 void cxfft(float *x,int *mfft);
 void cxifft(float *x,int *mfft);

dsp_floatMatrix_Pt Dsp_AllocateMatrix(int width,int height)

{
int	i,j;
dsp_floatMatrix_Pt	matrix_P;
float	**matrix_PP;

matrix_P=(dsp_floatMatrix_Pt)calloc(1,sizeof(dsp_floatMatrix_t));

matrix_PP=(float**)calloc(height,sizeof(float*));
if(matrix_PP == NULL) {
             fprintf(stderr,"Allocate Image could not allocate space for image\n");
             return(NULL);
}
for(i=0; i<height; i++) {
     matrix_PP[i]=(float*)calloc(width,sizeof(float));
     if(matrix_PP[i] == NULL) {
             fprintf(stderr,"Allocate Image could not allocate space for image\n");
             return(NULL);
     }
}

matrix_P->width=width;
matrix_P->height=height;
matrix_P->matrix_PP=matrix_PP;

return(matrix_P);
}


dsp_floatMatrix_Pt  Dsp_ReadAsciiMatrix(char *fileName)

{
        FILE            *input_F;
	int		i,j;
	unsigned int		width,height;
	float 	fpixel;
	dsp_floatMatrix_Pt	matrix_P;


        input_F = fopen(fileName, "r");


        if (!input_F) {
		fprintf(stderr,"Could not open Ascii Matrix\n");
                return(NULL);
	}

	/*
	 * get matrix width and height
	 */
	fscanf(input_F,"%d %d", &width,&height);


	matrix_P=Dsp_AllocateMatrix(width,height);
	if(matrix_P == NULL) {
		fprintf(stderr,"Could not allocate in Read ASCII Matrix\n");
		return(NULL);
	}
	for(i=0; i< height; i++)
		for(j=0; j<width; j++) {

			fscanf(input_F,"%f",&fpixel);
			/*
			 * store in matrix_PP for later manipulation
			 */
			matrix_P->matrix_PP[i][j]=fpixel;
		}
return(matrix_P);

}



dsp_floatMatrix_Pt  Dsp_ConvolveMatrices(dsp_floatMatrix_Pt	 matrix_P,dsp_floatMatrix_Pt	kernel_P)

{
dsp_floatMatrix_Pt	filtered_P;
int	row,column,i,j;
float	sumval,normalFactor;
int	deadRows,deadColumns;
int	kernelRows,kernelColumns;

filtered_P=Dsp_AllocateMatrix(matrix_P->width,matrix_P->height);

kernelRows=kernel_P->height;
kernelColumns=kernel_P->width;

deadRows=kernelRows/2;
deadColumns=kernelColumns/2;

normalFactor=0.0;
for(row=0; row<kernelRows; row++)
	for(column=0; column<kernelColumns; column++)
		normalFactor += fabs(kernel_P->matrix_PP[row][column]);
if(normalFactor< 0.000001)
	normalFactor=1.0;

for(row=0; row<matrix_P->height-kernelRows+1; row++) {
   for(column=0; column<matrix_P->width-kernelColumns+1; column++) {
	sumval=0.0;
	for(i=0; i<kernelRows; i++) {
  	   for(j=0; j<kernelColumns; j++)
		sumval += matrix_P->matrix_PP[row+i][column+j]*
					kernel_P->matrix_PP[i][j];
	}
	filtered_P->matrix_PP[row+deadRows][column+deadColumns]=
						sumval/normalFactor;
   }
}


return(filtered_P);
}


void  Dsp_PrintMatrix(dsp_floatMatrix_Pt	matrix_P)

{
FILE            *out_F;
int		i,j;



printf("%d %d\n",matrix_P->width,matrix_P->height);
for(i=0; i< matrix_P->height; i++) {
	for(j=0; j<matrix_P->width; j++)
		printf("%f ",matrix_P->matrix_PP[i][j]);
	printf("\n");
}


return;
}



void  Dsp_StoreMatrix(dsp_floatMatrix_Pt	 matrix_P,char*	 fileName)

{
FILE            *out_F;
int		i,j;
unsigned int		width,height;

out_F=fopen(fileName,"w");
if(out_F==NULL) {
	fprintf(stderr,"Store Matrix could not open file to write\n");
	return;
}

fprintf(out_F,"%d %d\n",matrix_P->width,matrix_P->height);
for(i=0; i< height; i++) {
	for(j=0; j<width; j++)
		fprintf(out_F,"%f ",matrix_P->matrix_PP[i][j]);
	fprintf(out_F,"\n");
}

fclose(out_F);
return;
}


/*
 * Free the matrix
 * Only the matrix is in the data structure is freed
 */

void  Dsp_FreeMatrix(dsp_floatMatrix_Pt	 matrix_P)

{
int		i,j;



for(i=0; i< matrix_P->height; i++)
	free(matrix_P->matrix_PP[i]);

free(matrix_P->matrix_PP);



return;
}




/*
 * Sobel Edge Detection
 */

dsp_floatMatrix_Pt  Dsp_EdgeDetection(dsp_floatMatrix_Pt	 matrix_P)

{
int i,j;
float tmp;
float	xx,yy;
float	temp1,temp2;
dsp_floatMatrix_Pt	filtered_P;
dsp_floatMatrix_Pt	horzFiltered_P;
dsp_floatMatrix_Pt	vertFiltered_P;

dsp_floatMatrix_Pt	g_P;
dsp_floatMatrix_Pt	v_P;
dsp_floatMatrix_Pt	h_P;


v_P=Dsp_AllocateMatrix(3,3);
h_P=Dsp_AllocateMatrix(3,3);
g_P=Dsp_AllocateMatrix(3,3);

v_P->matrix_PP[0][0]=1; v_P->matrix_PP[0][1] = 0; v_P->matrix_PP[0][2]= -1;
v_P->matrix_PP[1][0]=2; v_P->matrix_PP[1][1] = 0; v_P->matrix_PP[1][2]= -2;
v_P->matrix_PP[2][0]=1; v_P->matrix_PP[2][1] = 0; v_P->matrix_PP[2][2]= -1;


h_P->matrix_PP[0][0]=1; h_P->matrix_PP[0][1] = 2; h_P->matrix_PP[0][2]= 1;
h_P->matrix_PP[1][0]=0; h_P->matrix_PP[1][1] = 0; h_P->matrix_PP[1][2]= 0;
h_P->matrix_PP[2][0]= -1; h_P->matrix_PP[2][1] =  -2; h_P->matrix_PP[2][2]= -1;


g_P->matrix_PP[0][0]=1; g_P->matrix_PP[0][1] = 2; g_P->matrix_PP[0][2]= 1;
g_P->matrix_PP[1][0]=2; g_P->matrix_PP[1][1] = 4; g_P->matrix_PP[1][2]= 2;
g_P->matrix_PP[2][0]=1; g_P->matrix_PP[2][1] = 2; g_P->matrix_PP[2][2]= 1;





/*
 * Gaussian Blur
 */

filtered_P=Dsp_ConvolveMatrices(matrix_P,g_P);

/*
 * Vertical edge filter
 */

vertFiltered_P=Dsp_ConvolveMatrices(filtered_P,v_P);

/*
 * Horizontal edge filter
 */

horzFiltered_P=Dsp_ConvolveMatrices(filtered_P,h_P);


/*
 * Take the larger of the magnitudes of the two matrices
 * overwrite the filtered_P matrix
 */
for(i=0; i<matrix_P->height; i++) {
	for(j=0; j<matrix_P->width; j++) {
		temp1=fabs(horzFiltered_P->matrix_PP[i][j]);
		temp2=fabs(vertFiltered_P->matrix_PP[i][j]);
		temp1= temp1 >temp2 ? temp1:temp2;
		filtered_P->matrix_PP[i][j]=temp1;

	}
}

Dsp_FreeMatrix(vertFiltered_P);
Dsp_FreeMatrix(horzFiltered_P);

return(filtered_P);;
}






#if 1111 // NEED TO CHANGE FFT's to FFTW
/*
 * 2D FFT
 */
dsp_floatMatrix_Pt  Dsp_MatrixFFT(dsp_floatMatrix_Pt	 matrix_P,float* window_P,int length,int fftType,int centerFlag)

{

float	*x_A,*y_A;
int i,j;
float tmp;
float	xx,yy;
float	temp1,temp2;
dsp_floatMatrix_Pt	image_P;
dsp_floatMatrix_Pt	cximage_P;
dsp_floatMatrix_Pt	fft_P;


float**		mat_PP;
float**		matTrans_PP;
int	pwidth;
int	pheight;

int k;
int	factor;
float	temp;
float	tempReal;
float	tempImag;
int fftexp;
int fftl;
int fftwidth;
float	norm;
float	real,imag,mag;


if(fftType == FFT_FORWARD) {
	if(matrix_P->width  != matrix_P->height) {
		fprintf(stderr,"2-D FFT of Square images only. Sorry!\n");
		return(NULL);
	}

	/*
	 * create a matrix with twice the columns for
	 * complex FFT
	 */
	cximage_P=Dsp_AllocateMatrix(2*length,length);
	/*
	 * Set real part to input matrix
	 */
	for(i=0; i<length; i++)
		for(j=0; j<length; j++) {
			real=matrix_P->matrix_PP[i][j]*window_P[j];
			if(centerFlag)
				real=real*( ((i+j+1)%2)*2 -1);
			cximage_P->matrix_PP[i][2*j]=real;
		}

} else {
	if(matrix_P->width  != 2*matrix_P->height) {
		fprintf(stderr,"2-D FFT of Complex square images only. Sorry!\n");
		return(NULL);
	}
	cximage_P=matrix_P;


}

	pheight=cximage_P->height;
	pwidth=cximage_P->width;
	mat_PP=cximage_P->matrix_PP;
	fftwidth=pwidth/2;
	/*
	 * compute the power of 2 number of fft points
	 */
	fftexp = (int) (log((float)fftwidth)/log(2.0)+0.5);
	fftl = 1 << fftexp;
	if (fftl > fftwidth ) {
        	fftl = fftl/2;
        	fftexp -= 1;
	}
	if(fftType == FFT_INVERSE) {
		norm=fftl*fftl;
		norm=1.0/norm;
	} else
		norm=1.0;

fprintf(stderr,"fft width and height op %d %d %d \n",pwidth,pheight,fftType);
fprintf(stderr,"fft fftl and exp   %d %d \n",fftl,fftexp);
	      /*
               * perform fft calculation
	       * on rows
               */
	        for(i=0; i<pheight; i++) {
	     	   if(fftType==FFT_FORWARD)
        //              Dsp_Cxfft(mat_PP[i],&fftexp);
                  cxfft(mat_PP[i],&fftexp);
		   else
         //             Dsp_Cxifft(mat_PP[i],&fftexp);
                cxifft(mat_PP[i],&fftexp);
	        }

	     /*
 	      * Transpose
	      */
             for(k=0; k<pheight; k++) {
                      for(j=k; j<pwidth/2; j++) {
                           tempReal=mat_PP[k][2*j];
                           tempImag=mat_PP[k][2*j+1];
                           mat_PP[k][2*j]=mat_PP[j][2*k];
                           mat_PP[k][2*j+1]=mat_PP[j][2*k+1];
                           mat_PP[j][2*k]=tempReal;
                           mat_PP[j][2*k+1]=tempImag;
                      }
             }
	      /*
               * perform fft calculation
	       * on rows again
               */
	     for(i=0; i<pheight; i++) {
		if(fftType==FFT_FORWARD)
//                      Dsp_Cxfft(mat_PP[i],&fftexp);
                  cxfft(mat_PP[i],&fftexp);
		else
//                      Dsp_Cxifft(mat_PP[i],&fftexp);
                   cxifft(mat_PP[i],&fftexp);
	     }
	     /*
 	      * Transpose again
	      */
             for(k=0; k<pheight; k++) {
                      for(j=k; j<pwidth/2; j++) {
                           tempReal=mat_PP[k][2*j];
                           tempImag=mat_PP[k][2*j+1];
                           mat_PP[k][2*j]=mat_PP[j][2*k]*norm;
                           mat_PP[k][2*j+1]=mat_PP[j][2*k+1]*norm;
                           mat_PP[j][2*k]=tempReal*norm;
                           mat_PP[j][2*k+1]=tempImag*norm;
                      }
             }

image_P=Dsp_AllocateMatrix(cximage_P->width,cximage_P->height);
for(i=0; i<image_P->height; i++)
	for(j=0; j<image_P->width/2; j++) {
		real=mat_PP[i][2*j];
		imag=mat_PP[i][2*j+1];
		image_P->matrix_PP[i][2*j]=real;
		image_P->matrix_PP[i][2*j+1]=imag;
	}





return(image_P);
}
#endif



dsp_floatMatrix_Pt  Dsp_MatrixInterpolate(dsp_floatMatrix_Pt matrix_P,int intWidth,int intHeight)

{

dsp_floatMatrix_Pt	intMatrix_P;
int	i,j,k,kk;
int	width,height;
int	newWidth,newHeight;
float	temp;
int	row,column;

width=matrix_P->width;
height=matrix_P->height;

newWidth=width*intWidth;
newHeight=height*intHeight;

intMatrix_P= Dsp_AllocateMatrix(newWidth,newHeight);

fprintf(stderr,"Matrix Interpolation\nwidth=%d,height=%d,widthFactor=%d,heightFactor=%d\n",width,height,intWidth,intHeight);

if(intMatrix_P == NULL) {
	fprintf(stderr,"Dsp_Interpolate could not allocate space\n");
	return(NULL);
}

for(i=0; i<height; i++) {
              for(j=0; j<width; j++) {
                temp=matrix_P->matrix_PP[i][j];
                for(k=0; k<intHeight; k++) {
                    for(kk=0; kk<intWidth; kk++)
                        intMatrix_P->matrix_PP[i*intHeight+k][j*intWidth+kk]=temp;
                }
              }
}



return(intMatrix_P);
}


dsp_floatMatrix_Pt  Dsp_MatrixDecimate(dsp_floatMatrix_Pt	 matrix_P,int decWidth,int decHeight)

{

dsp_floatMatrix_Pt	decMatrix_P;
int	i,j,k,kk;
int	width,height;
int	newWidth,newHeight;
float	temp;
int	row,column;

width=matrix_P->width;
height=matrix_P->height;

newWidth=width/decWidth;
newHeight=height/decHeight;

if(newWidth == 0) newWidth=1;
if(newHeight == 0) newHeight=1;

decMatrix_P= Dsp_AllocateMatrix(newWidth,newHeight);

if(decMatrix_P == NULL) {
	fprintf(stderr,"Dsp_Decimate could not allocate space\n");
	return(NULL);
}

for(i=0; i<newWidth; i++) {
              for(j=0; j<newHeight; j++) {
                temp=matrix_P->matrix_PP[i*decWidth][j*decHeight];
                        decMatrix_P->matrix_PP[i][j]=temp;
              }
}



return(decMatrix_P);
}






dsp_floatMatrix_Pt  Dsp_SubMatrix(dsp_floatMatrix_Pt	 matrix_P,int	subWidth,int	subHeight,
		int	widthOffset,int	heightOffset)

{

dsp_floatMatrix_Pt	subMatrix_P;
int	i,j,k,kk;
int	width,height;
int	newWidth,newHeight;
float	temp;
int	row,column;

width=matrix_P->width;
height=matrix_P->height;

if(subHeight+heightOffset>height) {
	fprintf(stderr,"Dsp_SubMatrix: subheight + heightOffset > input image height.\n");
	return(NULL);
}
if(subWidth + widthOffset >width) {
	fprintf(stderr,"Dsp_SubMatrix: subwidth + widthOffset> input image width.\n");
	return(NULL);
}


subMatrix_P= Dsp_AllocateMatrix(subWidth,subHeight);

if(subMatrix_P == NULL) {
	fprintf(stderr,"Dsp_SubMatrix could not allocate space\n");
	return(NULL);
}

for(k=heightOffset; k<subHeight+heightOffset; k++) {
              for(j=widthOffset; j<subWidth+widthOffset; j++) {
                subMatrix_P->matrix_PP[k-heightOffset][j-widthOffset]=
			matrix_P->matrix_PP[k][j];
              }
}


return(subMatrix_P);
}


static int FloatCompare(const void 	*a_P,const void 	*b_P)

{

float	c;
c=(*(float*)a_P) - (*(float *)b_P);
if(c==0)
	return(0);
else if(c>0)
	return(1);
else
	return(-1);

}



dsp_floatMatrix_Pt  Dsp_NonlinearFilter(dsp_floatMatrix_Pt	matrix_P,int type, int order)

{

dsp_floatMatrix_Pt	filtered_P;
int	row,column,i,j;
float	sumval,normalFactor;
int	deadRows,deadColumns;
int	kernelRows,kernelColumns;

float	*kernel_P;
int	kernelLength,kk;
float	value;

if(!(order%2)) {
	fprintf(stderr,"Nonlinear filter order must be odd\n");
	return(NULL);
}
filtered_P=Dsp_AllocateMatrix(matrix_P->width,matrix_P->height);
if(filtered_P == NULL) {
	fprintf(stderr,"Nonlinear filter could not allocate space\n");
	return(NULL);
}


deadRows=order/2;
deadColumns=order/2;
kernelLength=order*order;
/*
 * allocate space for kernel array
 */
kernel_P=(float*)calloc(kernelLength,sizeof(float));
if(kernel_P == NULL) {
	fprintf(stderr,"Nonlinear filter could not allocate space\n");
	return(NULL);
}



for(row=0; row<matrix_P->height-order+1; row++) {
   for(column=0; column<matrix_P->width-order+1; column++) {
	kk=0;
	for(i=0; i<order; i++) {
  	   for(j=0; j<order; j++) {
			kernel_P[kk]= matrix_P->matrix_PP[row+i][column+j];

			kk++;
	   }
	}
	qsort(kernel_P,kernelLength,sizeof(float),FloatCompare);
	switch(type) {
		case NONLINEAR_FILTER_MEDIAN:
			value=kernel_P[kernelLength/2];
			break;
		case NONLINEAR_FILTER_MIN:
			value=kernel_P[0];
			break;
		case NONLINEAR_FILTER_MAX:
			value=kernel_P[kernelLength-1];
			break;
	}
	filtered_P->matrix_PP[row+deadRows][column+deadColumns]=
						value;
   }
}


return(filtered_P);

}




dsp_floatMatrix_Pt  Dsp_DuplicateMatrix(dsp_floatMatrix_Pt	matrix_P)

{
dsp_floatMatrix_Pt	newMatrix_P;
int	i,j,k,kk;
int	width,height;
float	temp;
int	row,column;

width=matrix_P->width;
height=matrix_P->height;



newMatrix_P= Dsp_AllocateMatrix(width,height);

if(newMatrix_P == NULL) {
	fprintf(stderr,"Dsp_DuplicateMatrix could not allocate space\n");
	return(NULL);
}

for(k=0; k<height; k++) {
              for(j=0; j<width; j++) {
                newMatrix_P->matrix_PP[k][j]=
			matrix_P->matrix_PP[k][j];
              }
}


return(newMatrix_P);

}
