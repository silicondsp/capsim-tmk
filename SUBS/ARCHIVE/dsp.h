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


typedef struct {
	
		int	width;
		int	height;
	
		float   **matrix_PP;
} dsp_Matrix_t, *dsp_Matrix_Pt;

typedef unsigned short UNSIGNEDINT16;

extern dsp_Matrix_Pt  Dsp_AllocateMatrix();
extern dsp_Matrix_Pt  Dsp_ReadAsciiMatrix();
extern dsp_Matrix_Pt  Dsp_ConvolveMatrices();
extern dsp_Matrix_Pt  Dsp_EdgeDetection();
extern dsp_Matrix_Pt  Dsp_MatrixFFT();
extern dsp_Matrix_Pt  Dsp_MatrixInterpolate();
extern dsp_Matrix_Pt  Dsp_MatrixDecimate();
extern dsp_Matrix_Pt  Dsp_SubMatrix();
extern dsp_Matrix_Pt  Dsp_NonlinearFilter();
extern dsp_Matrix_Pt  Dsp_DuplicateMatrix();
extern dsp_Matrix_Pt  IIP_ReadFloatTIFFMatrix();
extern float  bessi0();
extern  void  Dsp_MatrixNormalizeDB(dsp_Matrix_Pt        matrix_P,int    level,float     dBFloor,float *min_P, float *max_P);

