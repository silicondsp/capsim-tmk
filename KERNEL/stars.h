

/*  
    Capsim (r) Text Mode Kernel (TMK) 
    Copyright (C) 1989-2002  XCAD Corporation 

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

    http://www.xcad.com
    XCAD Corporation
    Raleigh, North Carolina 
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
	BufferLength(star_P->inBuffer_P[BUFFER_NO])

#define MIN_AVAIL() MinimumSamples(star_P)

#define IT_IN(BUFFER_NO) \
	 IncRdPtr(star_P->inBuffer_P[BUFFER_NO])

#define PIN(BUFFER_NO,DELAY) \
	 BufferAccess(star_P->inBuffer_P[BUFFER_NO],1,DELAY)

#define INF(BUFFER_NO,DELAY) \
	 *(float *)BufferAccess(star_P->inBuffer_P[BUFFER_NO],1,DELAY)

#define INI(BUFFER_NO,DELAY) \
	 *(int *)BufferAccess(star_P->inBuffer_P[BUFFER_NO],1,DELAY)

#define INC(BUFFER_NO,DELAY) \
	 *(char *)BufferAccess(star_P->inBuffer_P[BUFFER_NO],1,DELAY)

#define IND(BUFFER_NO,DELAY) \
	 *(double *)BufferAccess(star_P->inBuffer_P[BUFFER_NO],1,DELAY)

#define INCX(BUFFER_NO,DELAY) \
	 *(complex *)BufferAccess(star_P->inBuffer_P[BUFFER_NO],1,DELAY)

#define INDI(BUFFER_NO,DELAY) \
	 *(doublePrecInt *)BufferAccess(star_P->inBuffer_P[BUFFER_NO],1,DELAY)

#define INIMAGE(BUFFER_NO,DELAY) \
	 *(image_t *)BufferAccess(star_P->inBuffer_P[BUFFER_NO],1,DELAY)

#define IT_OUT(BUFFER_NO) \
	IncWrPtr(star_P->outBuffer_P[BUFFER_NO])

#define POUT(BUFFER_NO,DELAY) \
	 BufferAccess(star_P->outBuffer_P[BUFFER_NO],0,DELAY)


#define OUTF(BUFFER_NO,DELAY) \
	 *(float *)BufferAccess(star_P->outBuffer_P[BUFFER_NO],0,DELAY)

#define OUTI(BUFFER_NO,DELAY) \
	 *(int *)BufferAccess(star_P->outBuffer_P[BUFFER_NO],0,DELAY)

#define OUTC(BUFFER_NO,DELAY) \
	 *(char *)BufferAccess(star_P->outBuffer_P[BUFFER_NO],0,DELAY)

#define OUTD(BUFFER_NO,DELAY) \
	 *(double *)BufferAccess(star_P->outBuffer_P[BUFFER_NO],0,DELAY)

#define OUTCX(BUFFER_NO,DELAY) \
	 *(complex *)BufferAccess(star_P->outBuffer_P[BUFFER_NO],0,DELAY)

#define OUTDI(BUFFER_NO,DELAY) \
	 *(doublePrecInt *)BufferAccess(star_P->outBuffer_P[BUFFER_NO],0,DELAY)

#define OUTIMAGE(BUFFER_NO,DELAY) \
	 *(image_t *)BufferAccess(star_P->outBuffer_P[BUFFER_NO],0,DELAY)

#define SNAME(BUFFER_NO)  (star_P->signalName[BUFFER_NO])

#define SET_DMIN_IN(BUFFER_NO,DELAY) \
	 DelayMin(star_P->inBuffer_P[BUFFER_NO],DELAY)

#define SET_DMAX_IN(BUFFER_NO,DELAY) \
	 DelayMax(star_P->inBuffer_P[BUFFER_NO],DELAY)

#define SET_DMAX_OUT(BUFFER_NO,DELAY) \
	 DelayMax(star_P->outBuffer_P[BUFFER_NO],DELAY)

#define SET_CELL_SIZE_IN(BUFFER_NO,SIZE) \
	 CellSize(star_P->inBuffer_P[BUFFER_NO],SIZE)

#define SET_CELL_SIZE_OUT(BUFFER_NO,SIZE) \
	 CellSize(star_P->outBuffer_P[BUFFER_NO],SIZE)

#define NO_OUTPUT_BUFFERS()	(star_P->numberOutBuffers)

#define NO_INPUT_BUFFERS()	(star_P->numberInBuffers)


/* the following are for examination of the buffers during debugging */
#define LOOK_OUT(BUFFER_NO) \
	ExamineBuffer(star_P->outBuffer_P[BUFFER_NO])

#define LOOK_IN(BUFFER_NO) \
	ExamineBuffer(star_P->inBuffer_P[BUFFER_NO])

extern double drand48();
