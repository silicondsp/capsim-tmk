<BLOCK>
<LICENSE>
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
</LICENSE>

<BLOCK_NAME>setsnr</BLOCK_NAME> 


<COMMENTS>
<![CDATA[ 
Author: Sasan Ardalan
Date: February 2003

]]>
</COMMENTS> 

<DESC_SHORT>
Set the Signal to Noise Raio (SNR) by calculating power over window of complex input samples and adding noise.
</DESC_SHORT>

<INCLUDES>
<![CDATA[ 

#include <math.h>
#include "random.h"

]]>
</INCLUDES> 

<DEFINES> 

#define m 0x7fffffff
#define STATE_SILENCE 0
#define STATE_PREAMBLE 1
#define STATE_SYMBOLS  2

</DEFINES> 

                

<STATES>
	<STATE>
		<TYPE>char</TYPE>
		<NAME>rand_state[256]</NAME>
	</STATE>
	<STATE>
		<TYPE>double</TYPE>
		<NAME>max</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>dev</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>variance</NAME>
	</STATE>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>buffer_P</NAME>
	</STATE>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>wbuffer_P</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>windowCount</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>preambleCount</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>theState</NAME>
		<VALUE>STATE_SILENCE</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>dumpPreamble</NAME>
		<VALUE>1</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>dumpWindow</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>windowFull</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>snrRatio</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>totalCount</NAME>
		<VALUE>0</VALUE>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i,j,ok;
	int numin;
	int count = 0;
	int trouble;
	double s,t,u,v,k,w,x;
	float y1,y2;
	// long random();
        float val;
      float sum;
      float x1;
      float noisePower;

</DECLARATIONS> 

               

<PARAMETERS>
<PARAM>
	<DEF>SNR, dB</DEF>
	<TYPE>float</TYPE>
	<NAME>snr</NAME>
	<VALUE>20</VALUE>
</PARAM>
<PARAM>
	<DEF>Preamble Size</DEF>
	<TYPE>int</TYPE>
	<NAME>preambleSize</NAME>
	<VALUE>100</VALUE>
</PARAM>
<PARAM>
	<DEF>Window Size</DEF>
	<TYPE>int</TYPE>
	<NAME>windowSize</NAME>
	<VALUE>50</VALUE>
</PARAM>
<PARAM>
	<DEF>Silence Threshold</DEF>
	<TYPE>float</TYPE>
	<NAME>silenceThreshold</NAME>
	<VALUE>0.000001</VALUE>
</PARAM>
<PARAM>
	<DEF>Seed for random number generator</DEF>
	<TYPE>int</TYPE>
	<NAME>seed</NAME>
	<VALUE>333</VALUE>
</PARAM>
<PARAM>
	<DEF>Verbose</DEF>
	<TYPE>int</TYPE>
	<NAME>verbose</NAME>
	<VALUE>0</VALUE>
</PARAM>
</PARAMETERS>

    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>inp</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
    

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>out</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

//	srandom(seed);

#ifdef RANDOM_64_BIT
        init_genrand64((unsigned long long) seed);
#endif
#ifdef RANDOM_32_BIT
        init_genrand((unsigned  long) seed);
#endif


	max = m;
	if (windowSize > preambleSize) {
		fprintf(stderr,"setsnr.s: windowSize cant be larger than preamble\n");
		return(4);
	}
      buffer_P=(float*)calloc(preambleSize, sizeof(float));
	if (!buffer_P) {
		fprintf(stderr,"setsnr.s: could not allocate space\n");
		return(3);
	}
      wbuffer_P=(float*)calloc(windowSize, sizeof(float));
	if (!wbuffer_P) {
		fprintf(stderr,"setsnr.s: could not allocate space\n");
		return(3);
	}
      preambleCount= windowSize;
      x1  = (snr)/ 10.0;
      snrRatio = pow(10.0,x1);

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

    if ((numin = AVAIL(0)) > 0) {
      while(count < numin) {
         IT_IN(0);
         totalCount++;
         val=inp(0);
         if(val==0.0  && theState== STATE_SILENCE) {
		       if(IT_OUT(0)) {
			              fprintf(stderr,"setsnr.s buffer 0 overflow\n");
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
                  sum += wbuffer_P[i]*wbuffer_P[i];


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
			              fprintf(stderr,"setsnr.s buffer 0 overflow\n");
			               return(99);
		                }
                            //val=wbuffer_P[i];
                            val=0.0;
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
			fprintf(stderr,"setsnr.s: problem with random number generator\n");
			return(2);
		}
		/* get two random numbers in the interval (-1,1) */
		// s = random();
		// u = -1.0 + 2.0*(s/max);
		
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
			           fprintf(stderr,"setsnr.s buffer 0 overflow\n");
			           return(99);
		             }
                         val=buffer_P[preambleCount];
                         val += y1;
                         out(0)=val;
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
			           fprintf(stderr,"setsnr.s buffer 0 overflow\n");
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
			fprintf(stderr,"setsnr.s: problem with random number generator\n");
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
                         val += y1;
                         out(0)=val;


                    } // end for loop

                  } // end else
                  break;
            }

            }


		++count;

	}
      
	}

	return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

