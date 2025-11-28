 
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

This star generates a sinusoid ( cosine for zero phase). If a second buffer is connected, the quadrature signal is output.

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 



 

#define PI 3.141592654


#define PIDIV2  1.570796327


#define PI2  6.283185307


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      float  __dt;
      float  __phaseRad;
      long  __samples_out;
      double  __pace_in_total;
      long  __output_target;
      int  __no_inbuf;
      int  __no_outbuf;
      int  __pass;
      double  __angle;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define dt (state_P->__dt)
#define phaseRad (state_P->__phaseRad)
#define samples_out (state_P->__samples_out)
#define pace_in_total (state_P->__pace_in_total)
#define output_target (state_P->__output_target)
#define no_inbuf (state_P->__no_inbuf)
#define no_outbuf (state_P->__no_outbuf)
#define pass (state_P->__pass)
#define angle (state_P->__angle)

/*         
 *    PARAMETER DEFINES 
 */ 
#define num_of_samples (param_P[0]->value.d)
#define magnitude (param_P[1]->value.f)
#define fs (param_P[2]->value.f)
#define freq (param_P[3]->value.f)
#define phase (param_P[4]->value.f)
#define pace_rate (param_P[5]->value.f)
#define samples_first_time (param_P[6]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

sine 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

     long  i,j;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "total number of samples to output";
     char   *ptype0 = "int";
     char   *pval0 = "128";
     char   *pname0 = "num_of_samples";
     char   *pdef1 = "Enter Magnitude";
     char   *ptype1 = "float";
     char   *pval1 = "1.0";
     char   *pname1 = "magnitude";
     char   *pdef2 = "Enter Sampling Rate";
     char   *ptype2 = "float";
     char   *pval2 = "32000.0";
     char   *pname2 = "fs";
     char   *pdef3 = "Enter Frequency";
     char   *ptype3 = "float";
     char   *pval3 = "1000.0";
     char   *pname3 = "freq";
     char   *pdef4 = "Enter Phase";
     char   *ptype4 = "float";
     char   *pval4 = "0.0";
     char   *pname4 = "phase";
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
            samples_out=0;
       pace_in_total=0.0;
       output_target=NUMBER_SAMPLES_PER_VISIT;
       pass=0;
       angle=0;

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

	phaseRad = phase *PI/180.0;
	dt = 2.*PI*freq/fs;
	angle= -dt;
        /* note and store the number of output buffers */
        if((no_outbuf = NO_OUTPUT_BUFFERS() ) <= 0) {
                fprintf(stdout,"sine: no output buffers\n");
                return(1); /* no output buffers */
        }
        if(no_outbuf > 2) {
                fprintf(stdout,"sine: too many output buffers\n");
                return(1); /*  */
        }
        no_inbuf = NO_INPUT_BUFFERS();
        if(no_inbuf == 1)
           output_target = samples_first_time;
        else
           output_target = num_of_samples;
        if(output_target > num_of_samples)
           output_target = num_of_samples;
        if(pace_rate < 0) pace_rate = -pace_rate;


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
     
		if(IT_OUT(0)) {
			KrnOverflow("sine",0);
			return(99);
		}

	
		angle= angle +dt;
		angle=fmod(angle,PI2);
		
		
		OUTF(0,0) = magnitude*cos(angle+phaseRad);
		
		
		
		if(no_outbuf == 2) {
			if(IT_OUT(1)){
				KrnOverflow("sine",1);
				return(99);
			}
			OUTF(1,0) = magnitude*cos(PIDIV2- angle-phaseRad);
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
