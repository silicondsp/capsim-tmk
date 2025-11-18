 
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

This block simulates a wave generator.  

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 

#include <math.h>


 

#define 	PI 		3.141592653589793
#define 	WAVE_SINE 	0
#define 	WAVE_COSINE 	1
#define 	WAVE_SQUARE 	2
#define 	WAVE_TRIANGLE 	3
#define 	WAVE_SAWTOOTH 	4


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      float  __count;
      float  __halfPeriod;
      float  __radFreq;
      float  __slope;
      int  __samplesOutput;
      float  __paceInTotal;
      int  __outputTarget;
      int  __numberInputBuffers;
      int  __numberOutputBuffers;
      int  __pass;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define count (state_P->__count)
#define halfPeriod (state_P->__halfPeriod)
#define radFreq (state_P->__radFreq)
#define slope (state_P->__slope)
#define samplesOutput (state_P->__samplesOutput)
#define paceInTotal (state_P->__paceInTotal)
#define outputTarget (state_P->__outputTarget)
#define numberInputBuffers (state_P->__numberInputBuffers)
#define numberOutputBuffers (state_P->__numberOutputBuffers)
#define pass (state_P->__pass)

/*         
 *    PARAMETER DEFINES 
 */ 
#define numberOfSamples (param_P[0]->value.d)
#define waveType (param_P[1]->value.d)
#define period (param_P[2]->value.f)
#define peak (param_P[3]->value.f)
#define paceRate (param_P[4]->value.f)
#define samplesFirstTime (param_P[5]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

wave 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int i,j;
	float waveValue;
	float theta;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "total number of samples to output";
     char   *ptype0 = "int";
     char   *pval0 = "128";
     char   *pname0 = "numberOfSamples";
     char   *pdef1 = "Wave type:0=sine,1=cos,2=sqr,3=triangle,4=sawtooth";
     char   *ptype1 = "int";
     char   *pval1 = "0";
     char   *pname1 = "waveType";
     char   *pdef2 = "Samples per period.";
     char   *ptype2 = "float";
     char   *pval2 = "1.0";
     char   *pname2 = "period";
     char   *pdef3 = "Peak value.";
     char   *ptype3 = "float";
     char   *pval3 = "1.0";
     char   *pname3 = "peak";
     char   *pdef4 = "pace rate to determine how many samples to output";
     char   *ptype4 = "float";
     char   *pval4 = "1.0";
     char   *pname4 = "paceRate";
     char   *pdef5 = "number of samples on the first call if paced";
     char   *ptype5 = "int";
     char   *pval5 = "128";
     char   *pname5 = "samplesFirstTime";
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
            samplesOutput=0;
       paceInTotal=0.0;
       outputTarget=NUMBER_SAMPLES_PER_VISIT;
       pass=0;

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

        /* 
	 * note and store the number of output buffers 
	 */
        if((numberOutputBuffers = NO_OUTPUT_BUFFERS() ) <= 0) {
                fprintf(stdout,"wave: no output buffers\n");
                return(1); /* no output buffers */
        }
	if ((waveType >= 0) && (waveType <= 4))
		;
	else
	{
		fprintf(stderr,"Error in wave (2) \n");
		return(2);
	}
	if (period <= 0.0)
	{
		fprintf(stderr,"Error in wave (3) \n");
		return(3);
	}
	radFreq = (2*PI)/period;
	count = 0.0;
	halfPeriod = period/2.0;
	slope = 0.0;
	if (waveType == 3)
		slope = 4*peak/period;
	if (waveType == 4)
		slope = 2*peak/period;
	/*
	 * pacer code
	 */
        numberInputBuffers = NO_INPUT_BUFFERS();
        if(numberInputBuffers == 1)
           outputTarget = samplesFirstTime;
        else
           outputTarget = numberOfSamples;
        if(outputTarget > numberOfSamples)
           outputTarget = numberOfSamples;
        if(paceRate < 0) paceRate = -paceRate;


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 

	/*
	 * check pacer
	 */
        if(numberInputBuffers == 1) {
           while(IT_IN(0))
                paceInTotal += 1.0;
           if(pass == 1) {
                outputTarget = samplesFirstTime + (int) (paceRate *
                                paceInTotal + 0.5);
                if(outputTarget > numberOfSamples && numberOfSamples > 0)
                       outputTarget = numberOfSamples;
	   }
	}
        pass = 1;
        i = 0;
 
	/* generate NUMBER_SAMPLES_PER_VISIT samples, then return */
        while(samplesOutput < outputTarget) {
                /* 
		 * return if all samples have been output 
		 */
                if(++i > NUMBER_SAMPLES_PER_VISIT) return(0);

			
		count = count + 1.0;
		if(count > period)
			count = count - period;
 
		switch(waveType) {
			     case  WAVE_SINE:	
				theta = count * radFreq;
				waveValue = peak*sin(theta);
				break;
			     case WAVE_COSINE:
				theta = count * radFreq;
				waveValue = peak*cos(theta);
				break;
			     case WAVE_SQUARE:
				if (count < halfPeriod)
					waveValue = peak;
				else
					waveValue = -1.0*peak;
				break;
			     case WAVE_TRIANGLE:
				if (count < halfPeriod)
					waveValue = slope*count - peak;
				else
					waveValue = peak-slope
						*(count-halfPeriod);
				break;
			      case WAVE_SAWTOOTH: 
				waveValue = slope*count - peak;
				break;
		}
		for(j=0; j<numberOutputBuffers; j++) {
			if(IT_OUT(0)) {
				KrnOverflow("wave",0);
				return(99);
			}
			OUTF(j,0)=waveValue;
		}
		samplesOutput += 1;
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
