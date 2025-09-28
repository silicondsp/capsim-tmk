 
#ifdef LICENSE

/*  Capsim (r) Text Mode Kernel (TMK) Star Library (Blocks)
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
    Raleigh, North Carolina */

#endif
 
#ifdef SHORT_DESCRIPTION

This star reads a file and computes its FFT during the initialization phase.  (This produces H(k)).  During execution, the star performs a complex multiplication of the FFT of the file with the input complex data blocks (The input fft, X(k)).  It then outputs the complex result.

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
      cap_fft_cpx*  __cxinBuff;
      cap_fft_cpx*  __cxoutBuff;
      cap_fft_cfg  __cfg;
      int  __sample;
      FILE*  __fp;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define fftl (state_P->__fftl)
#define cxinBuff (state_P->__cxinBuff)
#define cxoutBuff (state_P->__cxoutBuff)
#define cfg (state_P->__cfg)
#define sample (state_P->__sample)
#define fp (state_P->__fp)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define x1(DELAY) (*((complex  *)PIN(0,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define y(delay) *(complex  *)POUT(0,delay)

/*         
 *    PARAMETER DEFINES 
 */ 
#define fftexp (param_P[0]->value.d)
#define file_name (param_P[1]->value.s)
/*-------------- BLOCK CODE ---------------*/
cmxfftfile(run_state,block_P)

	int run_state;
	block_Pt block_P;
{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int no_samples;
	int i,j;
	FILE *fopen();
	float a,b,c,d;
	complex val;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "log2 [ length of FFT ]";
     char   *ptype0 = "int";
     char   *pval0 = "";
     char   *pname0 = "fftexp";
     char   *pdef1 = "File with impulse response";
     char   *ptype1 = "file";
     char   *pval1 = "imp.dat";
     char   *pname1 = "file_name";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);

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
     char   *pnameIn0 = "x1";
KrnModelConnectionInput(indexIC,0 ,pnameIn0,ptypeIn0);
}
 break;

/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
     


         
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

 

	fftl = 1 << fftexp;
	if (fftl < 8)
	{
		fprintf(stderr,"fftfile: fft length is too short \n");
		return(1);
	}
        cfg=cap_fft_alloc(fftl,0,NULL,NULL);
        if ((cxinBuff = (cap_fft_cpx*)calloc(fftl,sizeof(cap_fft_cpx))) == NULL)
        {
                fprintf(stderr,"cmxfft: can't allocate work space \n");
                return(2);
        }
        if ((cxoutBuff = (cap_fft_cpx*)calloc(fftl,sizeof(cap_fft_cpx))) == NULL)
        {
                fprintf(stderr,"cmxfft: can't allocate work space \n");
                return(3);
        }


	if(strcmp(file_name,"stdin") == 0)
		fp = stdin;
	else if((fp = fopen(file_name,"r")) == NULL) {
		fprintf(stderr,"fftfile: cannot open file\n");
		return(1); /* file cannot be opened */
	}
	i=0;
	/* Read input lines until EOF */
	while((fscanf(fp,"%f",&cxinBuff[i].r) != EOF) && i<(fftl)) i++;
        for(i=0; i< fftl; i++) {
                  cxinBuff[i].i=0.0;

        }
	/* perform fft calculation		*/
	cap_fft(cfg,cxinBuff,cxoutBuff);
	sample = 0;
	SET_CELL_SIZE_IN(0,sizeof(complex));
	SET_CELL_SIZE_OUT(0,sizeof(complex));


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


	/* note the minimum number of samples on the 	*/
	/* input buffers and iterate that many times 	*/
	
	{
	for(no_samples=(MIN_AVAIL());no_samples >0; --no_samples) 

	{
		/*  get samples	*/
		IT_IN(0);	
		a = x1(0).re;
		c = cxoutBuff[sample].r;

		/* now get imaginary samples	*/
		b = x1(0).im;
		d = cxoutBuff[sample].i;

		/* output 		*/
		if(IT_OUT(0)) {
			KrnOverflow("cmxfftfile",0);
			return(0);
		}
		val.re = a*c - b*d;

		val.im = b*c + a*d;
		y(0)=val;
		
		sample++;	
		if (sample == fftl) sample = 0;

	}
	return(0);
	}


break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

	/* free up allocated space	*/
        free((cap_fft_cpx*)cxinBuff);
        free((cap_fft_cpx*)cxoutBuff);
                                                                                



break;
}
return(0);
}
