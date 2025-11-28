 
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

This star produces the fft of the input signal.  The points are output as complex numbers.  

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 

#include <cap_fft.h>



/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int  __fftl;
      cap_fft_cpx*  __fftBuffer;
      cap_fft_cpx*  __outBuffer;
      cap_fft_cfg  __cfg;
      int  __pointCount;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define fftl (state_P->__fftl)
#define fftBuffer (state_P->__fftBuffer)
#define outBuffer (state_P->__outBuffer)
#define cfg (state_P->__cfg)
#define pointCount (state_P->__pointCount)

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
/*-------------- BLOCK CODE ---------------*/
 int  cmplxfft(int run_state,block_Pt block_P)

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


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Size of FFT";
     char   *ptype0 = "int";
     char   *pval0 = "128";
     char   *pname0 = "npts";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);

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

 

fftl=npts;
if (fftl < 2)
{
		fprintf(stderr,"fft: fft length is too short \n");
		return(1);
}
if ((fftBuffer = (cap_fft_cpx*)calloc((fftl),sizeof(cap_fft_cpx))) == NULL) 
{
	fprintf(stderr,"cmplxfft: can't allocate work space \n");
	return(2);
}
if ((outBuffer = (cap_fft_cpx*)calloc((fftl),sizeof(cap_fft_cpx))) == NULL) 
{
	fprintf(stderr,"cmplxfft: can't allocate work space \n");
	return(3);
}
cfg=cap_fft_alloc(fftl,0,NULL,NULL);

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
		fftBuffer[j].r=x(0).re;
		fftBuffer[j].i=x(0).im;
		pointCount++;

			

		/* 
		 * Get enough points				
		 */
		if(pointCount >= fftl )
		{
			/* 
			 * perform fft calculation		
			 */
                        cap_fft(cfg,fftBuffer,outBuffer); 

			
			/* 
			 * now, output complex pairs		
			 */
			for (i=0; i<fftl; i++)
			{
				if(IT_OUT(0)) {
					KrnOverflow("cmplxfft",0);
					return(99);
				}
				calc.re = outBuffer[i].r;
				calc.im = outBuffer[i].i;
				y(0) = calc;
			}


			pointCount = 0;
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
	free((cap_fft_cpx*)outBuffer);


break;
}
return(0);
}
