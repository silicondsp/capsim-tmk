 
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

This block sends out a number of zero samples. The only parameter tells how many zero samples to send out.

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int  __samples_out;
      int  __no_obuf;
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
#define samples_out (state_P->__samples_out)
#define no_obuf (state_P->__no_obuf)
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
#define pace_rate (param_P[1]->value.f)
#define samples_first_time (param_P[2]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

zero 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int i,j;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Number of samples to generate";
     char   *ptype0 = "int";
     char   *pval0 = "128";
     char   *pname0 = "num_of_samples";
     char   *pdef1 = "pace rate to determine how many samples to output";
     char   *ptype1 = "float";
     char   *pval1 = "1.0";
     char   *pname1 = "pace_rate";
     char   *pdef2 = "number of samples on the first call if paced";
     char   *ptype2 = "int";
     char   *pval2 = "128";
     char   *pname2 = "samples_first_time";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);

      }
break;
   


/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            samples_out=0;
       samples_out_total=0;
       pace_in_total=0.0;
       output_target=NUMBER_SAMPLES_PER_VISIT;
       pass=0;

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

	/* note and store the number of output buffers */
	if((no_obuf = NO_OUTPUT_BUFFERS() ) <= 0) {
		fprintf(stderr,"add: no output buffers\n");
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

		for(j=0; j<no_obuf; j++) {
			if(IT_OUT(j)) {
				KrnOverflow("zero",j);
				return(99);
			}
			OUTF(j,0) = 0;
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
