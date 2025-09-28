 
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

This simulates target range measurements from a track-while-scan radar

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
#define pi 3.1415926


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int  __samples_out;
      double  __pace_in_total;
      int  __output_target;
      int  __no_inbuf;
      int  __no_outbuf;
      int  __pass;
      float  __xm[10000];
      char  __rand_state[256];
      double  __max;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define samples_out (state_P->__samples_out)
#define pace_in_total (state_P->__pace_in_total)
#define output_target (state_P->__output_target)
#define no_inbuf (state_P->__no_inbuf)
#define no_outbuf (state_P->__no_outbuf)
#define pass (state_P->__pass)
#define xm (state_P->__xm)
#define rand_state (state_P->__rand_state)
#define max (state_P->__max)

/*         
 *    PARAMETER DEFINES 
 */ 
#define cv (param_P[0]->value.f)
#define initial_range (param_P[1]->value.f)
#define sdf (param_P[2]->value.f)
#define num_of_samples (param_P[3]->value.d)
#define ts (param_P[4]->value.f)
#define pd (param_P[5]->value.f)
#define seed (param_P[6]->value.d)
#define pace_rate (param_P[7]->value.f)
#define samples_first_time (param_P[8]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

target 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int i,j,k;
	float tdel;
	double sd,yn,zn,ynr,znc,zns,u;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "closing velocity (knots)";
     char   *ptype0 = "float";
     char   *pval0 = "-600.0";
     char   *pname0 = "cv";
     char   *pdef1 = "initial range (nautical miles)";
     char   *ptype1 = "float";
     char   *pval1 = "1.0";
     char   *pname1 = "initial_range";
     char   *pdef2 = "standard deviation (feet)";
     char   *ptype2 = "float";
     char   *pval2 = "1.0";
     char   *pname2 = "sdf";
     char   *pdef3 = "number of samples";
     char   *ptype3 = "int";
     char   *pval3 = "128";
     char   *pname3 = "num_of_samples";
     char   *pdef4 = "interval (msec)";
     char   *ptype4 = "float";
     char   *pval4 = "10.0";
     char   *pname4 = "ts";
     char   *pdef5 = "data probability";
     char   *ptype5 = "float";
     char   *pval5 = "1.0";
     char   *pname5 = "pd";
     char   *pdef6 = "random number seed";
     char   *ptype6 = "int";
     char   *pval6 = "1287";
     char   *pname6 = "seed";
     char   *pdef7 = "pace rate to determine how many samples to output";
     char   *ptype7 = "float";
     char   *pval7 = "1.0";
     char   *pname7 = "pace_rate";
     char   *pdef8 = "number of samples on the first call if paced";
     char   *ptype8 = "int";
     char   *pval8 = "128";
     char   *pname8 = "samples_first_time";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);
KrnModelParam(indexModel88,3 ,pdef3,ptype3,pval3,pname3);
KrnModelParam(indexModel88,4 ,pdef4,ptype4,pval4,pname4);
KrnModelParam(indexModel88,5 ,pdef5,ptype5,pval5,pname5);
KrnModelParam(indexModel88,6 ,pdef6,ptype6,pval6,pname6);
KrnModelParam(indexModel88,7 ,pdef7,ptype7,pval7,pname7);
KrnModelParam(indexModel88,8 ,pdef8,ptype8,pval8,pname8);

      }
break;
   


/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            samples_out=0;
       pace_in_total=0;
       output_target=NUMBER_SAMPLES_PER_VISIT;
       pass=0;

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

	if((no_outbuf = NO_OUTPUT_BUFFERS() ) <= 0)  {
		fprintf(stderr,"target: no output buffers\n");
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
	tdel = ts*0.001;
	xm[0] = initial_range;
	sd = sdf/6076.0;
#ifdef RANDOM_64_BIT
	init_genrand64((unsigned long long) seed);
#endif

#ifdef RANDOM_32_BIT
	init_genrand32((unsigned long long) seed);
#endif
//	srandom(seed);
	max = m;
	
	
	
	for(k=1; k<num_of_samples; k++)  xm[k] = xm[k-1] + cv*tdel/3600.0;
	for(k=0; k<num_of_samples-2; k=k+2)  {
	
	
	//	yn = random()/max;
	//	zn = random()/max;
#ifdef RANDOM_64_BIT		
		 yn=genrand64_real1();
		 zn=genrand64_real1();
#endif
#ifdef RANDOM_32_BIT		
		 yn=genrand_real1();
		 zn=genrand_real1();
#endif

		
		ynr = -2.0*log(yn);
		znc = cos(2.0*pi*zn);
		zns = sin(2.0*pi*zn);
		xm[k] += sd*sqrt(ynr)*znc;
		xm[k+1] += sd*sqrt(ynr)*zns;
	}
	for(k=0; k<num_of_samples; k++)  {
	//	u = random()/max;
	
#ifdef RANDOM_64_BIT		
		 u=genrand64_real1();
#endif
#ifdef RANDOM_32_BIT		
		 u=genrand_real1();
#endif	
	
	//	u=genrand64_real1();
		
		
		if(u > pd)  xm[k] = 0.0;
	}


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 

	if(no_inbuf == 1)  {
		while(IT_IN(0))
			pace_in_total += 1.0;
		if(pass == 1)  {
			output_target = samples_first_time + (int) (pace_rate *
					pace_in_total + 0.5);
			if(output_target > num_of_samples && num_of_samples > 0)
				output_target = num_of_samples;
		}
	}
	pass = 1;
	i = 0;

	while(samples_out < output_target)  {

		if(++i > NUMBER_SAMPLES_PER_VISIT) return(0);

		for(j=0; j<no_outbuf; j++)  {

				if(IT_OUT(j)) {
					KrnOverflow("target",j);
					return(99);
				}
				OUTF(j,0) = xm[samples_out];
		}
		samples_out += 1;
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
