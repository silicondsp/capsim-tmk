 
#ifdef LICENSE

/*  Capsim (r) Text Mode Kernel (TMK) Star Library (Blocks)
    Copyright (C) 1989-2017  Silicon DSP Corporation

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

#endif
 
#ifdef SHORT_DESCRIPTION

This block computes the ONE-SIDED FFT of a complex stream which is overlapped by an amount of (fftl-M) samples for each FFT computation.  It outputs ((int)((totalNumberofPoints - fftl)/M)+1)*fftl/2 points. The totalNumberofPoints denotes the number of points in the complex input 

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 

#include <cap_fft.h>


 

#define PI 3.141592654


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int  __fftexp;
      int  __fftl;
      cap_fft_cpx*  __fftBuffer;
      complex*  __dataBuffer;
      complex*  __tempBuffer;
      cap_fft_cpx*  __cxoutBuff;
      cap_fft_cfg  __cfg;
      float  __norm;
      int  __pointCount;
      int  __checkFlag;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define fftexp (state_P->__fftexp)
#define fftl (state_P->__fftl)
#define fftBuffer (state_P->__fftBuffer)
#define dataBuffer (state_P->__dataBuffer)
#define tempBuffer (state_P->__tempBuffer)
#define cxoutBuff (state_P->__cxoutBuff)
#define cfg (state_P->__cfg)
#define norm (state_P->__norm)
#define pointCount (state_P->__pointCount)
#define checkFlag (state_P->__checkFlag)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define x(DELAY) (*((complex  *)PIN(0,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define y(delay) *(complex  *)POUT(0,delay)

/*         
 *    PARAMETER DEFINES 
 */ 
#define npts (param_P[0]->value.d)
#define M (param_P[1]->value.d)
#define windowType (param_P[2]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  slidefft(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int no_samples;
	complex calc;
	int i,j;
	float w;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Size of FFT";
     char   *ptype0 = "int";
     char   *pval0 = "128";
     char   *pname0 = "npts";
     char   *pdef1 = "Delay between Windows";
     char   *ptype1 = "int";
     char   *pval1 = "10";
     char   *pname1 = "M";
     char   *pdef2 = "Window Type: 0 = Rectangular, 1 = Hanning";
     char   *ptype2 = "int";
     char   *pval2 = "0";
     char   *pname2 = "windowType";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);

      }
break;
   


/*         
 *    OUTPUT BUFFER SYSTEM  INITS 
 */ 
 case OUTPUT_BUFFER_INIT: 
 {
 int indexOC = block_P->model_index;
     char   *ptypeOut0 = "complex";
     char   *pnameOut0 = "y";
KrnModelConnectionOutput(indexOC,0 ,pnameOut0,ptypeOut0);
}
 break;

/*         
 *    INPUT BUFFER SYSTEM  INITS 
 */ 
 case INPUT_BUFFER_INIT:
 {
 int indexIC = block_P->model_index;
     char   *ptypeIn0 = "complex";
     char   *pnameIn0 = "x";
KrnModelConnectionInput(indexIC,0 ,pnameIn0,ptypeIn0);
}
 break;

/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            pointCount=0;
       checkFlag=0;



         
   if(NO_OUTPUT_BUFFERS() != 1 ){
       fprintf(stdout,"%s:1 outputs expected; %d connected\n",
              STAR_NAME,NO_OUTPUT_BUFFERS());
	      return(201);
   }

   SET_CELL_SIZE_OUT(0,sizeof(complex));

         
   if(NO_INPUT_BUFFERS() != 1 ){
       fprintf(stdout,"%s:1 inputs expected; %d connected\n",
              STAR_NAME,NO_INPUT_BUFFERS());
	      return(200);
   }

   SET_CELL_SIZE_IN(0,sizeof(complex));

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

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
		fprintf(stderr,"fft: fft length is too short \n");
		return(1);
}
norm=1.0/(float)fftl;
if ((fftBuffer = (cap_fft_cpx*)calloc(fftl,sizeof(cap_fft_cpx))) == NULL)
{
	fprintf(stderr,"slidefft: can't allocate work space \n");
	return(2);
}
if ((cxoutBuff = (cap_fft_cpx*)calloc(fftl,sizeof(cap_fft_cpx))) == NULL)
{
	fprintf(stderr,"slidefft: can't allocate work space \n");
	return(3);
}
cfg=cap_fft_alloc(fftl,0,NULL,NULL);

if ((dataBuffer = (complex*)calloc(fftl,sizeof(complex))) == NULL)
{
        fprintf(stderr,"fft: can't allocate work space \n");
        return(4);
}
if ((tempBuffer = (complex*)calloc(fftl,sizeof(complex))) == NULL)
{
        fprintf(stderr,"fft: can't allocate work space \n");
        return(5);
}
SET_CELL_SIZE_IN(0,sizeof(complex));
SET_CELL_SIZE_OUT(0,sizeof(complex));


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 

	for (no_samples = MIN_AVAIL(); no_samples > 0; --no_samples)
	{
		/*
		 * real input buffer
		 */
		j=pointCount;
		IT_IN(0);
		dataBuffer[j]=x(0);
		pointCount++;

			
		if(checkFlag == 0)
		{
		/* 
		 * Get enough points				
		 */
			if(pointCount >= fftl)
			{
				for (i=0; i<fftl; i++)
				{
					if (windowType == 1)
					{
						w = (1.0/2.0)*(1.0-cos(2.0*PI*(float)i/((float)fftl-1.0)));
						fftBuffer[i].r = w*dataBuffer[i].re;
						fftBuffer[i].i = dataBuffer[i].im;
					}
					else
					{
                                                fftBuffer[i].r = dataBuffer[i].re;
                                                fftBuffer[i].i = dataBuffer[i].im;
					}
					 
				}
				/* 
		 		* perform fft calculation		
		 		*/
				cap_fft(cfg,fftBuffer,cxoutBuff);

		
				/* 
		 		* now, output complex pairs		
		 		*/
				for (i=0; i<fftl/2; i++)
				{
					if(IT_OUT(0)) {
						KrnOverflow("slidefft",0);
						return(99);
					}
					calc.re = cxoutBuff[i].r*norm;
					calc.im = cxoutBuff[i].i*norm;
					y(0) = calc;
				}
				for (i=0; i<fftl-M; i++)
					tempBuffer[i] = dataBuffer[i+M];
				pointCount = 0;
				checkFlag = 1;
			 }
		}
		else
		{
			if(pointCount >= M)
			{
				for (i=0; i<M; i++)
					tempBuffer[i+fftl-M]=dataBuffer[i];
				for (i=0; i<fftl; i++)
                                {
					if (windowType == 1)
                                        {
                                                w = (1.0/2.0)*(1.0-cos(2.0*PI*(float)i/((float)fftl-1.0)));
                                                fftBuffer[i].r = w*tempBuffer[i].re;
                                                fftBuffer[i].i = tempBuffer[i].im;
                                        }
					else
                                        {
                                                fftBuffer[i].r = tempBuffer[i].re;
                                                fftBuffer[i].i = tempBuffer[i].im;
                                        }
                                }
			        /*
                                * perform fft calculation
                                */
				cap_fft(cfg,fftBuffer,cxoutBuff);



                                /*
                                * now, output complex pairs
                                */
                                for (i=0; i<fftl/2; i++)
                                {
                                        if(IT_OUT(0) ) {
						KrnOverflow("slidefft",0);
						return(99);
					}
                                        calc.re = fftBuffer[i].r*norm;
                                        calc.im = fftBuffer[i].i*norm;
                                        y(0) = calc;
                                }
                                for (i=0; i<fftl-M; i++)
                                        tempBuffer[i] = tempBuffer[i+M];
				pointCount = 0;
			 }
		 }

	}
	return(0);


break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

	/* 
	 * free up allocated space	
	 */
	free((cap_fft_cpx*)fftBuffer);
	free((cap_fft_cpx*)cxoutBuff);
        free((char*)tempBuffer);
        free((char*)dataBuffer);


break;
}
return(0);
}
