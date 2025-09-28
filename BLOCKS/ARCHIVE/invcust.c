 
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

This star generates  inventory customers. 

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


 

#define DIST_EXPONENTIAL 0
#define DIST_GAMMA 1


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
      float*  __demandProb_P;
      int  __numberDemandProb;
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
#define demandProb_P (state_P->__demandProb_P)
#define numberDemandProb (state_P->__numberDemandProb)

/*         
 *    PARAMETER DEFINES 
 */ 
#define num_of_samples (param_P[0]->value.d)
#define type (param_P[1]->value.d)
#define meanArrival (param_P[2]->value.f)
#define expression (param_P[3]->value.s)
#define demandProbDist (param_P[4]->value.s)
#define pace_rate (param_P[5]->value.f)
#define samples_first_time (param_P[6]->value.d)
/*-------------- BLOCK CODE ---------------*/


invcust 

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
     float	x;
     FILE*	demand_F;
     complex	outSamp;
     int	demand;
     float	u;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "total number of customers";
     char   *ptype0 = "int";
     char   *pval0 = "128";
     char   *pname0 = "num_of_samples";
     char   *pdef1 = "Type:0=exp,1=gamma";
     char   *ptype1 = "int";
     char   *pval1 = "0";
     char   *pname1 = "type";
     char   *pdef2 = "Inter Arrival Time";
     char   *ptype2 = "float";
     char   *pval2 = "1.0";
     char   *pname2 = "meanArrival";
     char   *pdef3 = "Expression for random number generator";
     char   *ptype3 = "file";
     char   *pval3 = "anyexpresssion";
     char   *pname3 = "expression";
     char   *pdef4 = "File with demand probabilities";
     char   *ptype4 = "file";
     char   *pval4 = "demand_dist.dat";
     char   *pname4 = "demandProbDist";
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

 

	demand_F= fopen(demandProbDist,"r");
	if(demand_F == NULL) {
                fprintf(stderr,"invcust: could not open demand prob. file\n");
                return(1); 
	}
	fscanf(demand_F,"%d",&numberDemandProb);
	demandProb_P = (float*)calloc(numberDemandProb,sizeof(float));	
	if(demandProb_P == NULL) {
                fprintf(stderr,"invcust: could not allocate space\n");
                return(2); 
	}
	for(i=0; i< numberDemandProb; i++) {
		fscanf(demand_F,"%f",&demandProb_P[i]);
	}
	fclose(demand_F);
	if((obufs = NO_OUTPUT_BUFFERS() ) <= 0) {
                fprintf(stderr,"invcust: no output buffers\n");
                return(3); /* no output buffers */
        }
	for(i=0; i<obufs; i++) 
		SET_CELL_SIZE_OUT(i,sizeof(complex));
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
	*  generate NUMBER_SAMPLES samples, then return 
	*/
        while(samples_out_total < output_target) {

                /* 
		 * return if all samples have been output 
		 */
                if((i += 1) > NUMBER_SAMPLES_PER_VISIT) return(0);
  		/*
		 * generate random inter arrival time 
		 */ 
	        switch(type) {
		   case DIST_GAMMA:
			x=gengam(meanArrival,0);
			break;
		   case DIST_EXPONENTIAL:
			x=genexp(meanArrival);
			break;
		}

		/*
		 * generate demand
		 */

		demand=0;
		u=genunf(0.0,1.0);
		for(i=0; i<numberDemandProb;++i)
			if(u>= demandProb_P[i])
				demand=i+1;

		


		samples_out_total += 1;
		
		outSamp.re=x;
		outSamp.im = demand+1;

		/*
		 * output sample auto fan-out
		 */
		for(j=0; j<obufs; j++) {
		   if(IT_OUT(j)) {
			KrnOverflow("invcust",j);
			return(99);	
		   }
		   OUTCX(j,0) = outSamp;
		}
       }     

      return(0);



break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

	fprintf(stderr,"\n\nInventory Customer Mean Arrival Time = %f \n",
					meanArrival);
	fprintf(stderr,"Number of demand sizes = %d \n",
					numberDemandProb);
	fprintf(stderr,"Distribution function of demand sizes\n");
	for(i=0; i< numberDemandProb; i++)
		fprintf(stderr,"%f \n",demandProb_P[i]);


break;
}
return(0);
}
