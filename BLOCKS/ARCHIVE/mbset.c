 
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

Gives one outputs for Mandelbrot Set

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
      float  __differ_x;
      float  __differ_y;
      float  __increment_x;
      float  __increment_y;
      float  __x_val;
      float  __y_val;
      int  __samples_out;
      double  __pace_in_total;
      int  __output_target;
      int  __no_inbuf;
      int  __no_outbuf;
      int  __pass;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define differ_x (state_P->__differ_x)
#define differ_y (state_P->__differ_y)
#define increment_x (state_P->__increment_x)
#define increment_y (state_P->__increment_y)
#define x_val (state_P->__x_val)
#define y_val (state_P->__y_val)
#define samples_out (state_P->__samples_out)
#define pace_in_total (state_P->__pace_in_total)
#define output_target (state_P->__output_target)
#define no_inbuf (state_P->__no_inbuf)
#define no_outbuf (state_P->__no_outbuf)
#define pass (state_P->__pass)

/*         
 *    PARAMETER DEFINES 
 */ 
#define num_of_points (param_P[0]->value.d)
#define num_of_samples (param_P[1]->value.d)
#define min_x (param_P[2]->value.f)
#define max_x (param_P[3]->value.f)
#define min_y (param_P[4]->value.f)
#define max_y (param_P[5]->value.f)
#define max_iterate (param_P[6]->value.d)
#define pace_rate (param_P[7]->value.f)
#define samples_first_time (param_P[8]->value.d)
/*-------------- BLOCK CODE ---------------*/


mbset 

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
 

	int i,j,k,k2;
	float temp_x;
	float temp_y;
	float sqr_temp_x;
	float sqr_temp_y;
	float cutoff;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "number of points in each direction";
     char   *ptype0 = "int";
     char   *pval0 = "100";
     char   *pname0 = "num_of_points";
     char   *pdef1 = "total number of samples";
     char   *ptype1 = "int";
     char   *pval1 = "10000";
     char   *pname1 = "num_of_samples";
     char   *pdef2 = "minimum x value";
     char   *ptype2 = "float";
     char   *pval2 = "-2.0";
     char   *pname2 = "min_x";
     char   *pdef3 = "maximum x value";
     char   *ptype3 = "float";
     char   *pval3 = "2.0";
     char   *pname3 = "max_x";
     char   *pdef4 = "minimum y value";
     char   *ptype4 = "float";
     char   *pval4 = "-2.0";
     char   *pname4 = "min_y";
     char   *pdef5 = "maximum y value";
     char   *ptype5 = "float";
     char   *pval5 = "2.0";
     char   *pname5 = "max_y";
     char   *pdef6 = "maximum number of iterations";
     char   *ptype6 = "int";
     char   *pval6 = "100";
     char   *pname6 = "max_iterate";
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
	differ_x = max_x - min_x;
	differ_y = max_y - min_y;
	increment_x = differ_x/(float)(num_of_points);
	increment_y = differ_y/(float)(num_of_points);


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
	while(samples_out < output_target) {

		/* return if all samples have been output */
		if(++i > NUMBER_SAMPLES_PER_VISIT) return(0);

		y_val = min_y;

		for(k=0; k<num_of_points; k++)
		{
			x_val = min_x;
			for(j=0; j<num_of_points; j++)
			{
				temp_x = 0.0;
				temp_y = 0.0;
				cutoff = 0.0;
				for(k2=0; k2<max_iterate; k2++)
				{
				if(temp_x*temp_x < 4.0 && temp_y*temp_y < 4.0)
				{
				sqr_temp_x = temp_x*temp_x-temp_y*temp_y;
				sqr_temp_y = 2.0*temp_x*temp_y;
				temp_x = sqr_temp_x + x_val;
				temp_y = sqr_temp_y + y_val;
				cutoff = (float)k2;
				}
				}

				if(IT_OUT(0)) {
					KrnOverflow("mbset",0);
					return(99);
				}
				OUTF(0,0) = cutoff;

				x_val += increment_x;
				samples_out += 1;
			}
			y_val += increment_y;
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
