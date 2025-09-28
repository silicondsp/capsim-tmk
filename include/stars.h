
/*
    Capsim (r) Text Mode Kernel (TMK)
    Copyright (C) 1989-2017  Silicon DSP  Corporation

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

/* stars.h */
/**********************************************************************

		INCLUDE FILE FOR STARS

**********************************************************************

This file should be included in all CAPSIM user star routines --
It defines macro substitutions
*/

#define IN 0
#define OUT 1



#define COMPLEX

typedef struct {
	float	re;
	float	im;
} complex;

typedef struct {
	long int	lowWord;
	long int	highWord;
} doublePrecInt;

typedef struct {
	int		width;
	int		height;
	float** 	image_PP;
} image_t, *image_Pt;

POINTER BufferAdd(),BufferAccess();

#define AVAIL(BUFFER_NO) \
	BufferLength((buffer_Pt)star_P->inBuffer_P[BUFFER_NO])

#define MIN_AVAIL() MinimumSamples(star_P)

#define IT_IN(BUFFER_NO) \
	 IncRdPtr( (buffer_Pt)star_P->inBuffer_P[BUFFER_NO])

#define PIN(BUFFER_NO,DELAY) \
	 BufferAccess((buffer_Pt)star_P->inBuffer_P[BUFFER_NO],1,DELAY)

#define INF(BUFFER_NO,DELAY) \
	 *(float *)BufferAccess((buffer_Pt)star_P->inBuffer_P[BUFFER_NO],1,DELAY)

#define INI(BUFFER_NO,DELAY) \
	 *(int *)BufferAccess((buffer_Pt)star_P->inBuffer_P[BUFFER_NO],1,DELAY)

#define INC(BUFFER_NO,DELAY) \
	 *(char *)BufferAccess((buffer_Pt)star_P->inBuffer_P[BUFFER_NO],1,DELAY)

#define IND(BUFFER_NO,DELAY) \
	 *(double *)BufferAccess((buffer_Pt)star_P->inBuffer_P[BUFFER_NO],1,DELAY)

#define INCX(BUFFER_NO,DELAY) \
	 *(complex *)BufferAccess((buffer_Pt)star_P->inBuffer_P[BUFFER_NO],1,DELAY)

#define INDI(BUFFER_NO,DELAY) \
	 *(doublePrecInt *)BufferAccess((buffer_Pt) star_P->inBuffer_P[BUFFER_NO],1,DELAY)

#define INIMAGE(BUFFER_NO,DELAY) \
	 *(image_t *)BufferAccess((buffer_Pt)star_P->inBuffer_P[BUFFER_NO],1,DELAY)

#define IT_OUT(BUFFER_NO) \
	IncWrPtr((buffer_Pt)star_P->outBuffer_P[BUFFER_NO])

#define POUT(BUFFER_NO,DELAY) \
	 BufferAccess((buffer_Pt)star_P->outBuffer_P[BUFFER_NO],0,DELAY)


#define OUTF(BUFFER_NO,DELAY) \
	 *(float *)BufferAccess((buffer_Pt)star_P->outBuffer_P[BUFFER_NO],0,DELAY)

#define OUTI(BUFFER_NO,DELAY) \
	 *(int *)BufferAccess((buffer_Pt)star_P->outBuffer_P[BUFFER_NO],0,DELAY)

#define OUTC(BUFFER_NO,DELAY) \
	 *(char *)BufferAccess((buffer_Pt)star_P->outBuffer_P[BUFFER_NO],0,DELAY)

#define OUTD(BUFFER_NO,DELAY) \
	 *(double *)BufferAccess((buffer_Pt)star_P->outBuffer_P[BUFFER_NO],0,DELAY)

#define OUTCX(BUFFER_NO,DELAY) \
	 *(complex *)BufferAccess((buffer_Pt)star_P->outBuffer_P[BUFFER_NO],0,DELAY)

#define OUTDI(BUFFER_NO,DELAY) \
	 *(doublePrecInt *)BufferAccess((buffer_Pt)star_P->outBuffer_P[BUFFER_NO],0,DELAY)

#define OUTIMAGE(BUFFER_NO,DELAY) \
	 *(image_t *)BufferAccess((buffer_Pt)star_P->outBuffer_P[BUFFER_NO],0,DELAY)

#define SNAME(BUFFER_NO)  (star_P->signalName[BUFFER_NO])

#define STAR_NAME  (block_P->name)
#define BLOCK_NAME  (block_P->name)

#define PBLOCK  (block_P)

#define SET_DMIN_IN(BUFFER_NO,DELAY) \
	 delay_min((buffer_Pt)star_P->inBuffer_P[BUFFER_NO],DELAY)

#define SET_DMAX_IN(BUFFER_NO,DELAY) \
	 delay_max((buffer_Pt)star_P->inBuffer_P[BUFFER_NO],DELAY)

#define SET_DMAX_OUT(BUFFER_NO,DELAY) \
	 delay_max((buffer_Pt)star_P->outBuffer_P[BUFFER_NO],DELAY)

#define SET_CELL_SIZE_IN(BUFFER_NO,SIZE) \
	 CellSize((buffer_Pt)star_P->inBuffer_P[BUFFER_NO],SIZE)

#define SET_CELL_SIZE_OUT(BUFFER_NO,SIZE) \
	 CellSize((buffer_Pt)star_P->outBuffer_P[BUFFER_NO],SIZE)

#define NO_OUTPUT_BUFFERS()	(star_P->numberOutBuffers)

#define NO_INPUT_BUFFERS()	(star_P->numberInBuffers)


/* the following are for examination of the buffers during debugging */
#define LOOK_OUT(BUFFER_NO) \
	ExamineBuffer((buffer_Pt)star_P->outBuffer_P[BUFFER_NO])

#define LOOK_IN(BUFFER_NO) \
	ExamineBuffer((buffer_Pt)star_P->inBuffer_P[BUFFER_NO])

extern double drand48();


void KrnOverflow(char *star,int	 buffer);
int KrnModelParam(int mt_index,int pp_index,char *def,char *stype,char *sval,char *sname);
int CellSize(buffer_Pt  pbuffer,int cellsize);
int MinimumSamples(star_Pt pstar);
int IncRdPtr(buffer_Pt pbuffer);
int IncWrPtr(buffer_Pt pbuffer);
int BufferLength(buffer_Pt pbuffer);
void delay_max(buffer_Pt  pbuffer,int dmax);
void delay_min(buffer_Pt pbuffer,int dmin);
void init_buffer(buffer_Pt  pbuffer);



void Fx_AddVar(int size,int saturationMode,int x1,int x0,int y1,int y0,int *ow1_P,int *ow0_P);
void Fx_MultVar(int less_flag1, int less_flag2, int size, int x1, int x0, int y1, int y0, int* ow1_P, int* ow0_P);
void Fx_Part(int size,int input,int* x1_P,int* x0_P,int* lessFlag_P);
void Fx_RoundVar(int size,int outputSize,int roundOffBits,int x1,int x0,int* out_P);

