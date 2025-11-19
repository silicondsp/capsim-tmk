 
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

This block adds white gaussian noise to the input complex data stream.

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


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      char  __rand_state[256];
      double  __max;
      float  __dev;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define rand_state (state_P->__rand_state)
#define max (state_P->__max)
#define dev (state_P->__dev)

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
#define power (param_P[0]->value.f)
#define seed (param_P[1]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

cxaddnoise 

(int run_state,block_Pt block_P)

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
        complex val;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Noise power";
     char   *ptype0 = "float";
     char   *pval0 = "1.0";
     char   *pname0 = "power";
     char   *pdef1 = "Seed for random number generator";
     char   *ptype1 = "int";
     char   *pval1 = "333";
     char   *pname1 = "seed";
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
            dev=sqrt(fabs(power));



         
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

 

	if (power < 0.0) {
		fprintf(stderr,"cxaddnoise: improper parameter\n");
		return(2);
	}
	//srandom(seed);
#ifdef RANDOM_64_BIT	
	init_genrand64((unsigned long long) seed);
#endif
#ifdef RANDOM_32_BIT	
	init_genrand((unsigned long long) seed);
#endif

	max = m;


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 

	if ((numin = AVAIL(0)) > 0) {
		while(count < numin) {

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
			fprintf(stderr,"cxaddnoise: problem with random number generator\n");
			return(2);
		}
		/* get two random numbers in the interval (-1,1) */
		   
		//   s = random();
		//   u = -1.0 + 2.0*(s/max);
#ifdef RANDOM_64_BIT			   
		   s=genrand64_real1();
#endif
#ifdef RANDOM_32_BIT			   
		   s=genrand_real1();
#endif

		      u = -1.0 + 2.0*(s);
		   
		//   t = random();
		//   v = -1.0 + 2.0*(t/max);
		   
		     
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

		IT_IN(0);
		if(IT_OUT(0)) {
			fprintf(stderr,"cxaddnoise buffer 0 overflow\n");
			return(99);
		}
                val=inp(0);
                val.re += y1;
                val.im += y2;

                out(0)=val;

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
