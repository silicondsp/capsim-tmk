 
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

This star generates  random samples. 

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 

#include <math.h>
#include <ranlib.h>


 
#define DIST_NORMAL 0
#define DIST_UNIFORM 1
#define DIST_EXPONENTIAL 2
#define DIST_GAMMA 3
#define DIST_SPIKE 12
#define DIST_RAYLEIGH 2
#define DIST_WEIBULL 3
#define DIST_BETA 7
#define DIST_CHI_SQUARE 8
#define DIST_F 9
#define DIST_BINOMIAL 10
#define DIST_POISSON 11

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
      long  __seed1;
      long  __seed2;
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
#define seed1 (state_P->__seed1)
#define seed2 (state_P->__seed2)

/*         
 *    PARAMETER DEFINES 
 */ 
#define num_of_samples (param_P[0]->value.d)
#define type (param_P[1]->value.d)
#define p1 (param_P[2]->value.f)
#define p2 (param_P[3]->value.f)
#define expression (param_P[4]->value.s)
#define pace_rate (param_P[5]->value.f)
#define samples_first_time (param_P[6]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

rangen 

(int run_state,block_Pt block_P)

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
     float	x;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "total number of samples to output";
     char   *ptype0 = "int";
     char   *pval0 = "128";
     char   *pname0 = "num_of_samples";
     char   *pdef1 = "Type:0=normal,1=uniform,2=exp,3=gamma";
     char   *ptype1 = "int";
     char   *pval1 = "0";
     char   *pname1 = "type";
     char   *pdef2 = "Parameter 1(mean,a,lambda)";
     char   *ptype2 = "float";
     char   *pval2 = "0.0";
     char   *pname2 = "p1";
     char   *pdef3 = "Parameter 2(std,b)";
     char   *ptype3 = "float";
     char   *pval3 = "0.0";
     char   *pname3 = "p2";
     char   *pdef4 = "Expression";
     char   *ptype4 = "file";
     char   *pval4 = "anyexpresssion";
     char   *pname4 = "expression";
     char   *pdef5 = "pace rate to determine how many samples to output";
     char   *ptype5 = "float";
     char   *pval5 = "1.0";
     char   *pname5 = "pace_rate";
     char   *pdef6 = "number of samples on the first call if paced";
     char   *ptype6 = "int";
     char   *pval6 = "128";
     char   *pname6 = "samples_first_time";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);
KrnModelParam(indexModel88,3 ,pdef3,ptype3,pval3,pname3);
KrnModelParam(indexModel88,4 ,pdef4,ptype4,pval4,pname4);
KrnModelParam(indexModel88,5 ,pdef5,ptype5,pval5,pname5);
KrnModelParam(indexModel88,6 ,pdef6,ptype6,pval6,pname6);

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
                fprintf(stderr,"rangen: no output buffers\n");
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
	/*
	 * Get seeds from expression
	 */
	phrtsd(expression,&seed1,&seed2);
	fprintf(stderr,"genrad: seed1=%d seed2=%d\n",seed1,seed2);
	setall(seed1,seed2);


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

                /* 
		 * return if all samples have been output 
		 */
                if((i += 1) > NUMBER_SAMPLES_PER_VISIT) return(0);
  		/*
		 * generate random deviate
		 */ 
	        switch(type) {
		   case DIST_GAMMA:
			x=gengam(p1,p2);
			break;
		   case DIST_NORMAL:
			x=gennor(p1,p2);
			break;
		   case DIST_UNIFORM:
			x=genunf(p1,p2);
			break;
		   case DIST_EXPONENTIAL:
			x=genexp(p1);
			break;
		}


		samples_out_total += 1;

		/*
		 * output sample auto fan-out
		 */
		for(j=0; j<obufs; j++) {
		   if(IT_OUT(j)) {
			KrnOverflow("rangen",j);
			return(99);	
		   }
		   OUTF(j,0) = x;
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
