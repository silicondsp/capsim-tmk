 
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

Gives two outputs for bifurcation diagram

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>


 

#define OUT_SAMPLES NUMBER_SAMPLES_PER_VISIT 


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      float  __increment_val;
      float  __differ;
      float  __temp_param;
      float  __temp_val;
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
#define increment_val (state_P->__increment_val)
#define differ (state_P->__differ)
#define temp_param (state_P->__temp_param)
#define temp_val (state_P->__temp_val)
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
#define min_param (param_P[1]->value.f)
#define max_param (param_P[2]->value.f)
#define length_iterate (param_P[3]->value.d)
#define pace_rate (param_P[4]->value.f)
#define samples_first_time (param_P[5]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

nonlin 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int i,j,k,k2;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "total number of samples to output";
     char   *ptype0 = "int";
     char   *pval0 = "100";
     char   *pname0 = "num_of_samples";
     char   *pdef1 = "minimum parameter value";
     char   *ptype1 = "float";
     char   *pval1 = "0.0";
     char   *pname1 = "min_param";
     char   *pdef2 = "maximum parameter value";
     char   *ptype2 = "float";
     char   *pval2 = "5.0";
     char   *pname2 = "max_param";
     char   *pdef3 = "length of iteration";
     char   *ptype3 = "int";
     char   *pval3 = "100";
     char   *pname3 = "length_iterate";
     char   *pdef4 = "pace rate to determine how many samples to output";
     char   *ptype4 = "float";
     char   *pval4 = "1.0";
     char   *pname4 = "pace_rate";
     char   *pdef5 = "number of samples on the first call if paced";
     char   *ptype5 = "int";
     char   *pval5 = "128";
     char   *pname5 = "samples_first_time";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);
KrnModelParam(indexModel88,3 ,pdef3,ptype3,pval3,pname3);
KrnModelParam(indexModel88,4 ,pdef4,ptype4,pval4,pname4);
KrnModelParam(indexModel88,5 ,pdef5,ptype5,pval5,pname5);

      }
break;
   


/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            increment_val=0;
       differ=0;
       temp_val=0.5;
       samples_out_total=0;
       pace_in_total=0.0;
       output_target=NUMBER_SAMPLES_PER_VISIT;
       pass=0;

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

	if((no_outbuf = NO_OUTPUT_BUFFERS() ) <= 0) {
		fprintf(stderr,"seqgen: no output buffers\n");
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
	temp_param = min_param;
	differ = (float)(max_param - min_param);
	increment_val = differ/(float)(num_of_samples);


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

	/* generate NUMBER_SAMPLES_PER_VISIT samples, then return */
	while(samples_out_total < output_target) {

		/* return if all samples have been output */
		if(++i > NUMBER_SAMPLES_PER_VISIT) return(0);

		for(k=0; k<num_of_samples; k++)
		{
			temp_param += increment_val;
			for(j=0; j<length_iterate; j++)
			{
				temp_val = temp_param*temp_val*
					(1.0-temp_val);
			}
			for(k2=0; k2<num_of_samples; k2++)
			{
				temp_val = temp_param*temp_val*
					(1.0-temp_val);
				if(IT_OUT(0)) {
					KrnOverflow("nonlin",0);
					return(99);
				}
				OUTF(0,0) = temp_param;
				if(IT_OUT(1) ) {
					KrnOverflow("nonlin",0);
					return(99);
				}
				OUTF(1,0) = temp_val;
			}
			samples_out_total ++;
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
