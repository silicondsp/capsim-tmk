
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
 * Date: 		Dec. 4, 1993 Modified October 2017
 */

#include <stdio.h>
#include <math.h>
#include "dsp.h"


doubleVector_t* Dsp_AllocateVector(int length)
{
int	i,j;
doubleVector_t	*theVec_P;
double *vec_P;


     theVec_P=(doubleVector_t *)calloc(1,sizeof(doubleVector_t));
     vec_P=(double*)calloc(length,sizeof(double));
     if(vec_P== NULL || theVec_P==NULL) {
             fprintf(stderr,"Allocate complex vector could not allocate space \n");
             return(NULL);
     }


theVec_P->length=length;
theVec_P->transpose=0;
theVec_P->vector_P=vec_P;
theVec_P->type=KRN_TCL_TYPE_REAL_VECTOR;

return(theVec_P);
}




cxVector_t* Dsp_AllocateCxVector(int length)

{
int	i,j;
cxVector_t	*theVec_P;
cx_t *vec_P;


     theVec_P=(cxVector_t *)calloc(1,sizeof(cxVector_t));
     vec_P=(cx_t*)calloc(length,sizeof(cx_t));
     if(vec_P== NULL || theVec_P==NULL) {
             fprintf(stderr,"Allocate complex vector could not allocate space \n");
             return(NULL);
     }


theVec_P->length=length;
theVec_P->transpose=0;
theVec_P->vector_P=vec_P;
theVec_P->type=KRN_TCL_TYPE_COMPLEX_VECTOR;

return(theVec_P);
}


dsp_Matrix_Pt Dsp_AllocateRealMatrix(int height ,int width)
{
int	i,j;
dsp_Matrix_Pt	matrix_P;
double	**matrix_PP;

matrix_P=(dsp_Matrix_Pt)calloc(1,sizeof(dsp_Matrix_t));

matrix_PP=(double**)calloc(height,sizeof(double*));
if(matrix_PP == NULL) {
             fprintf(stderr,"Allocate matrix could not allocate space \n");
             return(NULL);
}
for(i=0; i<height; i++) {
     matrix_PP[i]=(double*)calloc(width,sizeof(double));
     if(matrix_PP[i] == NULL) {
             fprintf(stderr,"Allocate matrix could not allocate space \n");
             return(NULL);
     }
}

matrix_P->width=width;
matrix_P->height=height;
matrix_P->matrix_PP=matrix_PP;
matrix_P->type=KRN_TCL_TYPE_REAL_MATRIX;
return(matrix_P);
}



dsp_floatMatrix_Pt Dsp_AllocateRealFloatMatrix(int height ,int width)
{
int	i,j;
dsp_floatMatrix_Pt	matrix_P;
float	**matrix_PP;

matrix_P=(dsp_floatMatrix_Pt)calloc(1,sizeof(dsp_floatMatrix_t));

matrix_PP=(float**)calloc(height,sizeof(float*));
if(matrix_PP == NULL) {
             fprintf(stderr,"Allocate matrix could not allocate space \n");
             return(NULL);
}
for(i=0; i<height; i++) {
     matrix_PP[i]=(float*)calloc(width,sizeof(float));
     if(matrix_PP[i] == NULL) {
             fprintf(stderr,"Allocate matrix could not allocate space \n");
             return(NULL);
     }
}

matrix_P->width=width;
matrix_P->height=height;
matrix_P->matrix_PP=matrix_PP;
//matrix_P->type=KRN_TCL_TYPE_REAL_MATRIX;
return(matrix_P);
}


#if 11111 //XXXXXX FIX THIS
dsp_cpxMatrix_t	* Dsp_AllocateCapFFTMatrix(int height ,int width)
{
int	i,j;
dsp_cpxMatrix_t	*matrix_P;
cap_fft_cpx	**matrix_PP;

matrix_P=(dsp_cpxMatrix_Pt)calloc(1,sizeof(dsp_cpxMatrix_t));

matrix_PP=(cap_fft_cpx**)calloc(height,sizeof(cap_fft_cpx*));
if(matrix_PP == NULL) {
             fprintf(stderr,"Allocate cpx matrix could not allocate space \n");
             return(NULL);
}
for(i=0; i<height; i++) {
     matrix_PP[i]=(cap_fft_cpx*)calloc(width,sizeof(cap_fft_cpx));
     if(matrix_PP[i] == NULL) {
             fprintf(stderr,"Allocate matrix could not allocate space \n");
             return(NULL);
     }
}

matrix_P->width=width;
matrix_P->height=height;
matrix_P->matrix_PP=matrix_PP;
matrix_P->type=KRN_TCL_TYPE_CAP_CPX_MATRIX;
return(matrix_P);
}
#endif

#if 000
dsp_Matrix_t *Dsp_AllocateMatrix(int width,int height)
{
int	i,j;
dsp_Matrix_Pt	matrix_P;
double	**matrix_PP;

matrix_P=(dsp_Matrix_Pt)calloc(1,sizeof(dsp_Matrix_t));

matrix_PP=(double**)calloc(height,sizeof(double*));
if(matrix_PP == NULL) {
             fprintf(stderr,"Allocate matrix could not allocate space \n");
             return(NULL);
}
for(i=0; i<height; i++) {
     matrix_PP[i]=(double*)calloc(width,sizeof(double));
     if(matrix_PP[i] == NULL) {
             fprintf(stderr,"Allocate matrix could not allocate space \n");
             return(NULL);
     }
}

matrix_P->width=width;
matrix_P->height=height;
matrix_P->matrix_PP=matrix_PP;

return(matrix_P);
}
#endif

dsp_cxMatrix_Pt Dsp_AllocateCxMatrix(int height,int width)
{
int	i,j;
dsp_cxMatrix_Pt	matrix_P;
cx_t	**matrix_PP;

matrix_P=(dsp_cxMatrix_Pt)calloc(1,sizeof(dsp_cxMatrix_t));

matrix_PP=(cx_t**)calloc(height,sizeof(cx_t*));
if(matrix_PP == NULL) {
             fprintf(stderr,"Allocate matrix could not allocate space \n");
             return(NULL);
}
for(i=0; i<height; i++) {
     matrix_PP[i]=(cx_t*)calloc(width,sizeof(cx_t));
     if(matrix_PP[i] == NULL) {
             fprintf(stderr,"Allocate matrix could not allocate space \n");
             return(NULL);
     }
}

matrix_P->width=width;
matrix_P->height=height;
matrix_P->matrix_PP=matrix_PP;
matrix_P->type=KRN_TCL_TYPE_COMPLEX_MATRIX;

return(matrix_P);
}

#if 111
doubleVector_t* Dsp_AllocateDoubleVector(int n)
{
	doubleVector_t *vector;
	double   *vec;



	vec=(double *)calloc(n,sizeof(double));
	vector=(doubleVector_t *)calloc(1,sizeof(doubleVector_t));
	if(!vec || !vector) {fprintf(stderr,"Could not allocate Double Vector \n"); return(NULL);}
	vector->length=n;
	vector->vector_P=vec;
	vector->type=KRN_TCL_TYPE_REAL_VECTOR;

	return(vector);

}
#endif


