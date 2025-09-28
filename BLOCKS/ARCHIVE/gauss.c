 
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

This star generates  gaussian samples. 

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 

#include <math.h>


 

#define m 0x7fffffff


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int  __samples_out_total;
      double  __pace_in_total;
      int  __output_target;
      int  __no_inbuf;
      int  __obufs;
      int  __pass;
      char  __rand_state[256];
      double  __max;
      int  __overFlowBuffer_A[25];
      float  __sample_A[25];
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define samples_out_total (state_P->__samples_out_total)
#define pace_in_total (state_P->__pace_in_total)
#define output_target (state_P->__output_target)
#define no_inbuf (state_P->__no_inbuf)
#define obufs (state_P->__obufs)
#define pass (state_P->__pass)
#define rand_state (state_P->__rand_state)
#define max (state_P->__max)
#define overFlowBuffer_A (state_P->__overFlowBuffer_A)
#define sample_A (state_P->__sample_A)

/*         
 *    PARAMETER DEFINES 
 */ 
#define num_of_samples (param_P[0]->value.d)
#define dev (param_P[1]->value.f)
#define seed (param_P[2]->value.d)
#define pace_rate (param_P[3]->value.f)
#define samples_first_time (param_P[4]->value.d)
/*-------------- BLOCK CODE ---------------*/


gauss 

(run_state,block_P)

	int run_state;
	block_Pt block_P;
{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

     int i,j,ok,n;
     int numin;
     int count = 0;
     int trouble;
     double s,t,u,v,w,x,sqrt(),log();
     float y1,y2;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "total number of samples to output";
     char   *ptype0 = "int";
     char   *pval0 = "128";
     char   *pname0 = "num_of_samples";
     char   *pdef1 = "Noise Standard Deviation";
     char   *ptype1 = "float";
     char   *pval1 = "1.0";
     char   *pname1 = "dev";
     char   *pdef2 = "Seed for random number generator";
     char   *ptype2 = "int";
     char   *pval2 = "333";
     char   *pname2 = "seed";
     char   *pdef3 = "pace rate to determine how many samples to output";
     char   *ptype3 = "float";
     char   *pval3 = "1.0";
     char   *pname3 = "pace_rate";
     char   *pdef4 = "number of samples on the first call if paced";
     char   *ptype4 = "int";
     char   *pval4 = "128";
     char   *pname4 = "samples_first_time";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);
KrnModelParam(indexModel88,3 ,pdef3,ptype3,pval3,pname3);
KrnModelParam(indexModel88,4 ,pdef4,ptype4,pval4,pname4);

      }
break;
   


/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            samples_out_total=0;
       pace_in_total=0.0;
       output_target=NUMBER_SAMPLES_PER_VISIT;
       pass=0;

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

	if((obufs = NO_OUTPUT_BUFFERS() ) <= 0) {
                fprintf(stderr,"bdata: no output buffers\n");
                return(1); /* no output buffers */
        }
        no_inbuf = NO_INPUT_BUFFERS();
        if(no_inbuf == 1)
           output_target = samples_first_time; 
        else
           output_target = num_of_samples;
        if(output_target > num_of_samples)
           output_target = num_of_samples;
   	if(pace_rate < 0) pace_rate = -pace_rate;
	if (dev < 0.0) {
		fprintf(stderr,"gauss: improper parameter\n");
		return(2);
	}
	srand48((long int)seed);
	max = m;
       for(j=0; j<obufs; j++)
                        overFlowBuffer_A[j] = FALSE;


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


        if(no_inbuf == 1) {
           while(IT_IN(0))
                pace_in_total += 1.0;
           if(pass == 1) {
                output_target = samples_first_time + (int) (pace_rate *
                                pace_in_total + 0.5);
                if(output_target > num_of_samples && num_of_samples > 0)
                       output_target = num_of_samples;
	   }
        }
        pass = 1;
 	i = 0;

       /*
	*  generate NUMBER_SAMPLES_PER_VISIT samples, then return 
	*/
        while(samples_out_total < output_target) {

                /* return if all samples have been output */
                if((i += 2) > NUMBER_SAMPLES_PER_VISIT) return(0);
   
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
				fprintf(stderr,"gauss: problem with random number\
					 generator\n");
				return(2);
			}
			/* 
		 	 * get two random numbers in the interval (-1,1) 
			 */
			s = drand48();
			u = -1.0 + 2.0*s;
			t = drand48();
			v = -1.0 + 2.0*t;
			w = u*u + v*v;
			/* 
			 * is point (u,v) in the unit circle? 
			 */
		} while (w >= 1.0 || w == 0.0);

		x = sqrt((-2.0 * log(w))/w);
		/* 
		 * find two independent values of y	
		 */
		y1 = dev * u * x;
		y2 = dev * v * x;
	
		/****************** End of Gauss Code ****************************/

		samples_out_total += 2;
		for(j=0; j<obufs; j++) {
		   if(IT_OUT(j)) {
			KrnOverflow("gauss",j);
			return(99);	
		   }
		   OUTF(j,0) = y1;
		}
		for(j=0; j<obufs; j++) {
		   if(IT_OUT(j)) {
			KrnOverflow("gauss",j);
			return(99);	
		   }
		   OUTF(j,0) = y2;
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
