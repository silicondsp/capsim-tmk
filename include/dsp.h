/*
 * dsp.h
 *
 * global declarations for dsp library
 *
 * Authors:
 * Dr. Sasan H. Ardalan
 *
 * Copyright 1988 by Sasan H. Ardalan.
 * All rights reserved.  Do not remove this notice.
 */
 /*
     Capsim (r) Text Mode Kernel (TMK)
     Copyright (C) 1988-2017  Sasan Ardalan

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

 #include "cap_fft.h"

 #define PI 3.14159265358979323846

#define DSP_LPC_ORDER 256

#define         FILTER_TYPES 5
#define FILTER_NONE  1
#define FILTER_NONLINEAR_MAX  1
#define FILTER_NONLINEAR_MIN 2
#define FILTER_NONLINEAR_MEDIAN 3
#define FILTER_LINEAR  4

#define NONLINEAR_FILTER_MAX  1
#define NONLINEAR_FILTER_MIN 2
#define NONLINEAR_FILTER_MEDIAN 3



#define NOISE_NONE  0
#define NOISE_UNIFORM 1
#define NOISE_GAUSSIAN 2
#define NOISE_SPIKE  3
#define         NOISE_TYPES 4

#define OPER_NONE 0
#define OPER_TRANSPOSE  1
#define OPER_FLIP_VERT 2
#define OPER_FLIP_HORZ 4
#define OPER_INVERSE 3
#define OPER_TYPES 5

#define DSP_MATRIX_MULTIPLY 0
#define DSP_MATRIX_ADD 1
#define DSP_MATRIX_SUBTRACT 2
#define DSP_MATRIX_DIVIDE 3
#define DSP_MATRIX_AND 4
#define DSP_MATRIX_OR 5
#define DSP_MATRIX_EXCLUSIVE_OR 6
#define DSP_MATRIX_COMPLEMENT 7
#define DSP_MATRIX_COPY 8


#define KRN_TCL_TYPE_SHORT_VECTOR 0
#define KRN_TCL_TYPE_BYTE_VECTOR 1
#define KRN_TCL_TYPE_REAL_VECTOR 2
#define KRN_TCL_TYPE_COMPLEX_VECTOR 3
#define KRN_TCL_TYPE_REAL_MATRIX  4
#define KRN_TCL_TYPE_COMPLEX_MATRIX  5
#define KRN_TCL_TYPE_COMPLEX_SCALAR  6
#define KRN_TCL_TYPE_CAP_CPX_MATRIX 7

/*
 * KISS FFT MATRIX
 */
typedef struct {
                short   type;
                int     width;
                int     height;

                cap_fft_cpx   **matrix_PP;
} dsp_cpxMatrix_t, *dsp_cpxMatrix_Pt;



typedef struct {
                double   re, im;
} cx_t;


typedef struct {
                float   re, im;
} cxFloat_t;


//typedef struct {
//                double   re, im;
//} complex;



typedef struct short_type {
        short   type;
        int     length;
        short   *vector_P;
} shortVector_t, *shortVector_Pt;

typedef struct short_vector {
        short   type;
} short_t, *short_Pt;

typedef struct byte_vector {
        short   type;
        int     length;
        unsigned char   *vector_P;
} byteVector_t, *byteVector_Pt;

typedef struct double_vector {
        short   type;
	short   transpose;
        int     length;
        double   *vector_P;
} doubleVector_t, *doubleVector_Pt;

typedef struct doublecx_vector {
        short   type;
	short   transpose;
        int     length;
        cx_t   *vector_P;
} cxVector_t, *cxVector_Pt;



typedef struct {
                short   type;
                int     width;
                int     height;

                double   **matrix_PP;
} dsp_Matrix_t, *dsp_Matrix_Pt;


typedef struct {
                int     width;
                int     height;

                float   **matrix_PP;
} dsp_floatMatrix_t, *dsp_floatMatrix_Pt;


typedef struct {
                short   type;
                int     width;
                int     height;

                cx_t   **matrix_PP;
} dsp_cxMatrix_t, *dsp_cxMatrix_Pt;


typedef struct complex_scalar {
        short   type;
        cx_t   value;
} cxScalar_t, *cxScalar_Pt;



typedef unsigned short UNSIGNEDINT16;

#define MIN(x, y) (((x) < (y)) ? (x) : (y))
#define MAX(x, y) (((x) > (y)) ? (x) : (y))



 dsp_floatMatrix_Pt  IIP_ReadFloatTIFFMatrix(char *);
 float  bessi0();
  void  Dsp_MatrixNormalizeDB(dsp_floatMatrix_Pt        matrix_P,int    level,float     dBFloor,float *min_P, float *max_P);
void Dsp_MatrixAddNoise(dsp_floatMatrix_Pt matrix_P,int type,char* expression,float param1,float param2) ;
dsp_floatMatrix_Pt       Dsp_GenMatrix(int width,int height,int rectWidth,
      int rectHeight, int widthOffset,int heightOffset,
                        float pixel,int complexFlag,int complementFlag);

dsp_floatMatrix_Pt  Dsp_MatrixFFT(dsp_floatMatrix_Pt matrix_P,float* window_P,int length,int fftType,int centerFlag);

dsp_floatMatrix_Pt Dsp_AllocateMatrix(int width,int height);
dsp_floatMatrix_Pt  Dsp_ReadAsciiMatrix(char *fileName);
dsp_floatMatrix_Pt  Dsp_ConvolveMatrices(dsp_floatMatrix_Pt	 matrix_P,dsp_floatMatrix_Pt	kernel_P);
void  Dsp_PrintMatrix(dsp_floatMatrix_Pt	matrix_P);
void  Dsp_StoreMatrix(dsp_floatMatrix_Pt	 matrix_P,char*	 fileName);
void  Dsp_FreeMatrix(dsp_floatMatrix_Pt	 matrix_P);
dsp_floatMatrix_Pt  Dsp_EdgeDetection(dsp_floatMatrix_Pt	 matrix_P);
dsp_floatMatrix_Pt  Dsp_MatrixInterpolate(dsp_floatMatrix_Pt matrix_P,int intWidth,int intHeight);
dsp_floatMatrix_Pt  Dsp_MatrixDecimate(dsp_floatMatrix_Pt	 matrix_P,int decWidth,int decHeight);
dsp_floatMatrix_Pt  Dsp_SubMatrix(dsp_floatMatrix_Pt	 matrix_P,int	subWidth,int	subHeight,
		int	widthOffset,int	heightOffset);
dsp_floatMatrix_Pt  Dsp_NonlinearFilter(dsp_floatMatrix_Pt	matrix_P,int	type, int	order);
dsp_floatMatrix_Pt  Dsp_DuplicateMatrix(dsp_floatMatrix_Pt	 matrix_P);
void  Dsp_MatrixStats(dsp_floatMatrix_Pt	matrix_P,float	*mmin_P,float	*mmax_P,float	*mmean_P,float	*mvariance_P);
void  Dsp_MatrixNormalize(dsp_floatMatrix_Pt	 matrix_P,int level);
void  Dsp_MatrixNormalizeDBInverse(dsp_floatMatrix_Pt	matrix_P,int	level,float	dBFloor,float *min_P, float *max_P);
int  Dsp_MatrixHistogram(dsp_floatMatrix_Pt	 matrix_P,int level,float	**hist_PP);
int  Dsp_MatrixHistogramEq(dsp_floatMatrix_Pt	matrix_P,int level);
void Dsp_MatrixAddNoise(dsp_floatMatrix_Pt	matrix_P,int type,char*	expression,float	param1,float	param2);
dsp_floatMatrix_Pt Dsp_MatrixOperate(dsp_floatMatrix_Pt	matrix_P,int operation,int level);
int Dsp_CalculateMatrix(dsp_floatMatrix_Pt	matrix1_P,dsp_floatMatrix_Pt	matrix2_P,
		int operation,int wOffset,int hOffset,int level);
void  Dsp_FillMatrix(dsp_floatMatrix_Pt	 matrix_P,float value);
int Dsp_Covar(int n,float* x_P,int m,float* a_P,float* alpha_P,float* grc_P);
int Dsp_Auto(int n,float* x_P,int m,float* a_P,float* alpha_P,float* rc_P);
float *vector(int nn);
int mulawq(int xx,int flag);
float sinc(float x);


int max0(int x, int y);
void calsdr(float xx_A[],float *sdr_P,int points,char* file);
void cmultfft(float array1[], float array2[], int npoints);
void cmultfftcap(cap_fft_cpx *array1, cap_fft_cpx * array2, int npoints, float conjugate);
void cmultfftr(cap_fft_scalar array1[], cap_fft_scalar array2[], int npoints);
void copymatf(float  arr1[1][1],int  n,int m, float arr2[1][1]);
void diagmatf(float arr1[1][1], float factor, int n);
void ccoef(float zzr[],float zzi[],float pzr[],float pzi[],int nz,int np,float zc[2][100],float pc[2][100],int *ns);
int IIRDesign(char*modelName,float fs,float fpb,float fsb,float fpl,float fpu,float fsl,float fsu,float pbdb,float sbdb,int filterType,int desType);
void bwlpf(float f1,float db1,float f2,float db2,int *n,float *fc,float sr[],float si[]);
int dcel1(double *res,double ak);
void deli1(double * res,double x,double ck);
void djelf(double *sn,double *cn,double *dn,double x,double sck);
double prwrp(float f,float fs);
void sztran(float zsr[],float zsi[],float psr[],float psi[],float zzr[],float zzi[],float pzr[],float pzi[],int *nz,int *np,float fs);
void cbylpf(float f1,float db1,float f2,float db2,int *n,float *fc,float sr[],float si[]);
void elplpf(float f1,float db1,float f2,float db2,float *fc,float psr[],float psi[],int *np,float zsr[],float zsi[],int *nz);
void lphp(float zzr[],float zzi[],float pzr[],float pzi[],int nz,int np,float zpr[],float zpi[],float ppr[],float ppi[],float fl,float fh,float fs);
void lpbp(float zzr[],float zzi[],float pzr[],float pzi[],int *nz,int *np,float zpr[],float zpi[],float ppr[],float ppi[],float fl,float f1,float f2,float fs);
void lpbs(float zzr[],float zzi[],float pzr[],float pzi[],int *nz,int *np,float zpr[],float zpi[],float ppr[],float ppi[],float fl,float f1,float f2,float fs);
void norcon(float zr[],float zi[],float pr[],float pi[],int nz,int np,int npt,double *gmax);
void Ripple(int NR,float RIDEAL,float FLOW,float FHI,float RESP[],float *FA,float *FB,float *DB);
void FilterCharact(int NF,int WTYPE,int FTYPE,float FC,float FL,float FH,int N,int IEO,float G[],FILE *fp1);
void Cheby (int NF,float W[],int N,int IEO,float DP,float DF,float X0,float XN);
void Chebc (int *NF,float *DP,float *DF,int *N,float *X0,float *XN);
float Ino(float X);
void Kaiser (int NF,float W[],int N,int IEO,float BETA);
void Parzen(int NF,float W[],int N,int IEO);

void Hammin(int NF,float W[],int N,int IEO,float ALPHA,float BETA);
void Triang(int NF,float W[],int N,int IEO);
float COSHIN(float X);
float ABS(float X);

void cxfft(float *x,int *mfft);
void ccoef(float zzr[],float zzi[],float pzr[],float pzi[],int nz,int np,float zc[2][100],float pc[2][100],int *ns);



dsp_floatMatrix_Pt IIP_ReadTIFFMatrixText(char *tiffFile);
int FIRDesign(float fc,float fl,float fh,float alphag,float dbripple,float twidth,float att,
 int ntapin,int windType,int filterType, char *fileNamePrefix);

 doubleVector_t* Dsp_AllocateVector(int length);


 dsp_floatMatrix_t   *Dsp_Spectrogram(doubleVector_t *vec_P,int windowLength,int overlap,int zeropad,float samplingRate,
	int windowType,float threshold,int surfaceFlag,int imageFlag,int indBFlag,int fileFlag,char *fileName);


   int IIP_WriteMatrixTIFFText(float**	matrix_PP,unsigned int	width,unsigned int	height, char*, char*	);
dsp_floatMatrix_Pt Dsp_AllocateRealFloatMatrix(int height ,int width);
