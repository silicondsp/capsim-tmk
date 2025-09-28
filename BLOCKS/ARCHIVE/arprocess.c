 
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

This star generates a selectable number of samples from an AR process represented as an IIR filter driven by Gaussian noise

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 

#include <math.h>



/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int  __outbufs;
      int  __countout;
      float  __dev;
      int  __samples_out_total;
      double  __pace_in_total;
      int  __output_target;
      int  __no_inbuf;
      int  __no_outbuf;
      int  __pass;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define outbufs (state_P->__outbufs)
#define countout (state_P->__countout)
#define dev (state_P->__dev)
#define samples_out_total (state_P->__samples_out_total)
#define pace_in_total (state_P->__pace_in_total)
#define output_target (state_P->__output_target)
#define no_inbuf (state_P->__no_inbuf)
#define no_outbuf (state_P->__no_outbuf)
#define pass (state_P->__pass)

/*         
 *    PARAMETER DEFINES 
 */ 
#define num_of_samples (param_P[0]->value.d)
#define weights ((float*)param_P[1]->value.s)
#define n_weights  (param_P[1]->array_size)
#define variance (param_P[2]->value.f)
#define pace_rate (param_P[3]->value.f)
#define samples_first_time (param_P[4]->value.d)
/*-------------- BLOCK CODE ---------------*/


arprocess 

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
 

	int i,j;
	float sum;
	int max = 0x7fffffff;
	double s,t,u,v,k,w,x;
	float y1,y2;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Number of samples to generate";
     char   *ptype0 = "int";
     char   *pval0 = "128";
     char   *pname0 = "num_of_samples";
     char   *pdef1 = "Array of weights";
     char   *ptype1 = "array";
     char   *pval1 = "";
     char   *pname1 = "weights";
     char   *pdef2 = "Variance of innovations process";
     char   *ptype2 = "float";
     char   *pval2 = "1.0";
     char   *pname2 = "variance";
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
            countout=0;
       samples_out_total=0;
       pace_in_total=0.0;
       output_target=NUMBER_SAMPLES_PER_VISIT;
       pass=0;

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

	if((outbufs = NO_OUTPUT_BUFFERS()) < 1 ) {
		fprintf(stderr,"arprocess: no output buffers connected\n");
		return(3);
	}
	if (variance < 0.0 ) {
		fprintf(stderr,"arprocess: improper parameter\n");
		return(1);
	}
	/*
	 * pacer code
	 */
        no_inbuf = NO_INPUT_BUFFERS();
        if(no_inbuf == 1)
           output_target = samples_first_time;
        else
           output_target = num_of_samples;
        if(output_target > num_of_samples)
           output_target = num_of_samples;
        if(pace_rate < 0) pace_rate = -pace_rate;
	/*
	 * end pacer code
	 */
fprintf(stderr,"var = %f\n",variance);
 	dev = sqrt(variance);
	SET_DMAX_OUT(0,n_weights);
fprintf(stderr,"dev = %f\n",dev);


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

        while(samples_out_total < output_target) {

                /* return if all samples have been output */
                if(++i > NUMBER_SAMPLES_PER_VISIT) return(0);

		sum = 0;
		for(j=0; j<n_weights; j++)
			sum += weights[j] * OUTF(0,j);
		/* generate driving noise */
	       do {
		   /* get two random numbers in the interval (-1,1) */
		   s = random();
		   u = -1.0 + 2.0*(s/max);
		   t = random();
		   v = -1.0 + 2.0*(t/max);
		   w = u*u + v*v;
		   /* is point (u,v) in the unit circle? */
		} while (w >= 1.0 || w == 0.0);

		x = sqrt((-2.0 * log(w))/w);
		/* find two independent values of y	*/
		y1 = dev * u * x;
		y2 = dev * v * x;
/****************** End of Gauss Code ****************************/
	
		sum += y1;

		for(j=0; j<outbufs; j++) {
			if(IT_OUT(j)) {
				KrnOverflow("arprocess",j);
				return(99);
			}
			OUTF(j,0) = sum;
		}
                samples_out_total += 1;
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
