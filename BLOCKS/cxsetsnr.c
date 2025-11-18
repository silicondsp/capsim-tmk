 
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

This block adds white gaussian noise to the input data stream based on SNR.

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 

#include <math.h>
#include "random.h"


 

#define m 0x7fffffff
#define STATE_SILENCE 0
#define STATE_PREAMBLE 1
#define STATE_SYMBOLS  2


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      char  __rand_state[256];
      double  __max;
      float  __dev;
      float  __variance;
      complex*  __buffer_P;
      complex*  __wbuffer_P;
      int  __windowCount;
      int  __preambleCount;
      int  __theState;
      int  __dumpPreamble;
      int  __dumpWindow;
      int  __windowFull;
      float  __snrRatio;
      int  __totalCount;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define rand_state (state_P->__rand_state)
#define max (state_P->__max)
#define dev (state_P->__dev)
#define variance (state_P->__variance)
#define buffer_P (state_P->__buffer_P)
#define wbuffer_P (state_P->__wbuffer_P)
#define windowCount (state_P->__windowCount)
#define preambleCount (state_P->__preambleCount)
#define theState (state_P->__theState)
#define dumpPreamble (state_P->__dumpPreamble)
#define dumpWindow (state_P->__dumpWindow)
#define windowFull (state_P->__windowFull)
#define snrRatio (state_P->__snrRatio)
#define totalCount (state_P->__totalCount)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define inp(DELAY) (*((complex  *)PIN(0,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define out(delay) *(complex  *)POUT(0,delay)

/*         
 *    PARAMETER DEFINES 
 */ 
#define snr (param_P[0]->value.f)
#define preambleSize (param_P[1]->value.d)
#define windowSize (param_P[2]->value.d)
#define silenceThreshold (param_P[3]->value.f)
#define seed (param_P[4]->value.d)
#define verbose (param_P[5]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  cxsetsnr(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int i,j,ok;
	int numin;
	int count = 0;
	int trouble;
	double s,t,u,v,k,w,x;
	float y1,y2;
	// long random();
        complex val;
      float sum;
      float x1;
      float noisePower;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "SNR, dB";
     char   *ptype0 = "float";
     char   *pval0 = "20";
     char   *pname0 = "snr";
     char   *pdef1 = "Preamble Size";
     char   *ptype1 = "int";
     char   *pval1 = "100";
     char   *pname1 = "preambleSize";
     char   *pdef2 = "Window Size";
     char   *ptype2 = "int";
     char   *pval2 = "50";
     char   *pname2 = "windowSize";
     char   *pdef3 = "Silence Threshold";
     char   *ptype3 = "float";
     char   *pval3 = "0.000001";
     char   *pname3 = "silenceThreshold";
     char   *pdef4 = "Seed for random number generator";
     char   *ptype4 = "int";
     char   *pval4 = "333";
     char   *pname4 = "seed";
     char   *pdef5 = "Verbose";
     char   *ptype5 = "int";
     char   *pval5 = "0";
     char   *pname5 = "verbose";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);
KrnModelParam(indexModel88,3 ,pdef3,ptype3,pval3,pname3);
KrnModelParam(indexModel88,4 ,pdef4,ptype4,pval4,pname4);
KrnModelParam(indexModel88,5 ,pdef5,ptype5,pval5,pname5);

      }
break;
   


/*         
 *    OUTPUT BUFFER SYSTEM  INITS 
 */ 
 case OUTPUT_BUFFER_INIT: 
 {
 int indexOC = block_P->model_index;
     char   *ptypeOut0 = "complex";
     char   *pnameOut0 = "out";
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
     char   *pnameIn0 = "inp";
KrnModelConnectionInput(indexIC,0 ,pnameIn0,ptypeIn0);
}
 break;

/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            windowCount=0;
       preambleCount=0;
       theState=STATE_SILENCE;
       dumpPreamble=1;
       dumpWindow=0;
       windowFull=0;
       totalCount=0;



         
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

 


#ifdef RANDOM_64_BIT	
	init_genrand64((unsigned long long) seed);
#endif

#ifdef RANDOM_32_BIT	
	init_genrand((unsigned long long) seed);
#endif

        
	//srandom(seed);
	max = m;
	if (windowSize > preambleSize) {
		fprintf(stderr,"cxsetsnr.s: windowSize cant be larger than preamble\n");
		return(4);
	}
      buffer_P=(complex*)calloc(preambleSize, sizeof(complex));
	if (!buffer_P) {
		fprintf(stderr,"cxsetsnr.s: could not allocate space\n");
		return(3);
	}
      wbuffer_P=(complex*)calloc(windowSize, sizeof(complex));
	if (!wbuffer_P) {
		fprintf(stderr,"cxsetsnr.s: could not allocate space\n");
		return(3);
	}
      preambleCount= windowSize;
      x1  = (snr)/ 10.0;
      snrRatio = pow(10.0,x1);


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 

    if ((numin = AVAIL(0)) > 0) {
      while(count < numin) {
         IT_IN(0);
         totalCount++;
         val=inp(0);
         if(val.re==0.0 && val.im==0.0 && theState== STATE_SILENCE) {
		       if(IT_OUT(0)) {
			              fprintf(stderr,"cxsetsnr.s buffer 0 overflow\n");
			               return(99);
		       }
                           
                   out(0)=val;


         }else {
           wbuffer_P[windowCount]=val;
           windowCount++;
           if(theState == STATE_PREAMBLE ) {
                 
                 // store samples into preamble buffer
                 buffer_P[preambleCount]=val;
                 
                 preambleCount++;
                 if(preambleCount == preambleSize) {
                    if(verbose) fprintf(stderr,"STATE= STATE_SYMBOLS count=%d\n",totalCount);

                    theState= STATE_SYMBOLS;
                    preambleCount=0;

                 }
                 windowCount=0;

           }
           if(windowCount== windowSize) {
               windowFull=1;
               
               sum=0;
               for(i=0; i<windowSize; i++) {
                  sum += wbuffer_P[i].re*wbuffer_P[i].re + wbuffer_P[i].im*wbuffer_P[i].im;


               }
               sum= sum/(float)windowSize;
               
               if(sum >silenceThreshold && theState==STATE_SILENCE) {
                    if(verbose)fprintf(stderr,"STATE= STATE_PREAMBLE count=%d sum=%f \n",totalCount,sum);
                    theState=STATE_PREAMBLE;
                    for(i=0; i<windowSize; i++) {
                       buffer_P[i]=wbuffer_P[i];
                    }
                    
               }else if (theState==STATE_SYMBOLS) {
                  // calculate the noise power
                  dumpWindow=1;
                  noisePower= sum/snrRatio;
                  dev = sqrt(fabs(noisePower));
                  if(verbose)fprintf(stderr,"Window count=%d snrRation=%f Power=%f noisePower=%f dev=%f\n",totalCount,snrRatio,sum,noisePower,dev);

                     


               } 
    //           if(theState == STATE_SILENCE)
    //                    dumpWindow=1;
               
               windowCount=0;

             

           }
    

		switch (theState) {

               case STATE_SILENCE:
                    if(dumpWindow) {
                         if(verbose)fprintf(stderr,"DUMPING WINDOW DURING SILENCE\n");
                         for(i=0; i< windowSize; i++) {
		                if(IT_OUT(0)) {
			              fprintf(stderr,"cxsetsnr.s buffer 0 overflow\n");
			               return(99);
		                }
                            //val=wbuffer_P[i];
                            val.re=0.0;
                            val.im=0.0;
                            out(0)=val;

                            
                         }
                         dumpWindow=0;
                   }



                  break;
               case STATE_PREAMBLE:
                  break;
               case STATE_SYMBOLS:
                  if(dumpPreamble && dumpWindow) {
                     if(verbose) fprintf(stderr,"DUMPING PREAMBLE\n");

                     dumpPreamble=0;
                     for(i=0; i<preambleSize; i++) {

/****************************************************************/
/* 		gauss						*/
/* code written by Prayson Pate					*/
/* This code generates two random variables that are normally 	*/
/* distributed with mean 0 and variance 1 i.e N(0,1).	 	*/
/* The polar method is used to generate normally distributed    */
/* samples from a sequence that is uniform on (-1,1).  The      */
/* resulting distribution is described exactly by N(0,1).       */
/* This method is based	on the inverse distribution function.   */
/****************************************************************/
	trouble = 0;
	do {
		if(++trouble > 100) {
			fprintf(stderr,"cxsetsnr.s: problem with random number generator\n");
			return(2);
		}
		/* get two random numbers in the interval (-1,1) */
	//	s = random();
	//	u = -1.0 + 2.0*(s/max);
		
#ifdef RANDOM_64_BIT
		 s=genrand64_real1();
#endif
#ifdef RANDOM_32_BIT
		 s=genrand_real1();
#endif
		 u = -1.0 + 2.0*(s);
		 
		// t = random();
		// v = -1.0 + 2.0*(t/max);
#ifdef RANDOM_64_BIT		
		 t=genrand64_real1();
#endif
#ifdef RANDOM_32_BIT
		 t=genrand_real1();
#endif	       
                v = -1.0 + 2.0*(t);
	
		w = u*u + v*v;
		/* is point (u,v) in the unit circle? */
	} while (w >= 1.0 || w == 0.0);

	x = sqrt((-2.0 * log(w))/w);
	/* find two independent values of y	*/
	y1 = dev * u * x;
	y2 = dev * v * x;
	
/****************** End of Gauss Code ****************************/

                      
		             if(IT_OUT(0)) {
			           fprintf(stderr,"cxsetsnr.s buffer 0 overflow\n");
			           return(99);
		             }
                         val=buffer_P[preambleCount];
                         val.re += y1;
                         val.im += y2;
                         out(0)=val;
//printf("DUMPING PREAMBLE y1=%f y2=%f val.re=%f val.im=%f %f:%f:%f:%f\n",y1,y2,val.re,val.im,dev,u,v,x);                      
                         preambleCount++;
                     }
                  } 
                  if(dumpWindow && windowFull) {
                     // output window buffer
                     dumpWindow=0;
                     windowFull=0;
                     if(verbose) fprintf(stderr,"DUMPING WINDOW\n");
                     for(i=0; i< windowSize; i++) {
		             if(IT_OUT(0)) {
			           fprintf(stderr,"cxsetsnr.s buffer 0 overflow\n");
			           return(99);
		             }

/****************************************************************/
/* 		gauss						*/
/* code written by Prayson Pate					*/
/* This code generates two random variables that are normally 	*/
/* distributed with mean 0 and variance 1 i.e N(0,1).	 	*/
/* The polar method is used to generate normally distributed    */
/* samples from a sequence that is uniform on (-1,1).  The      */
/* resulting distribution is described exactly by N(0,1).       */
/* This method is based	on the inverse distribution function.   */
/****************************************************************/
	trouble = 0;
	do {
		if(++trouble > 100) {
			fprintf(stderr,"cxsetsnr.s: problem with random number generator\n");
			return(2);
		}
		/* get two random numbers in the interval (-1,1) */
	//	s = random();
	//	u = -1.0 + 2.0*(s/max);
		
#ifdef RANDOM_64_BIT
		 s=genrand64_real1();
#endif
#ifdef RANDOM_32_BIT
		 s=genrand_real1();
#endif
		 u = -1.0 + 2.0*(s);
		 
		// t = random();
		// v = -1.0 + 2.0*(t/max);
#ifdef RANDOM_64_BIT		
		 t=genrand64_real1();
#endif
#ifdef RANDOM_32_BIT
		 t=genrand_real1();
#endif
		 v = -1.0 + 2.0*(t);
		
		w = u*u + v*v;
		/* is point (u,v) in the unit circle? */
	} while (w >= 1.0 || w == 0.0);

	x = sqrt((-2.0 * log(w))/w);
	/* find two independent values of y	*/
	y1 = dev * u * x;
	y2 = dev * v * x;
	
/****************** End of Gauss Code ****************************/

                         val=wbuffer_P[i];
                         val.re += y1;
                         val.im += y2;
                         out(0)=val;
//printf("DUMPING WINDOW y1=%f y2=%f val.re=%f val.im=%f \n",y1,y2,val.re,val.im);                      


                    } // end for loop

                  } // end else
                  break;
            }

            }


		++count;

	}
      
	}

	return(0);


break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 



break;
}
return(0);
}
