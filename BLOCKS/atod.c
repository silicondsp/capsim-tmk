 
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

This star simulates a uniform analog to digital converter.

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
      int  __levels;
      int  __numberOutputBuffers;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define levels (state_P->__levels)
#define numberOutputBuffers (state_P->__numberOutputBuffers)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define x(DELAY) (*((float  *)PIN(0,DELAY)))

/*         
 *    PARAMETER DEFINES 
 */ 
#define bits (param_P[0]->value.d)
#define maxLevel (param_P[1]->value.f)
/*-------------- BLOCK CODE ---------------*/
 int  

atod 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int no_samples;
	int i;
	float sample,sin,sout;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Number of bits";
     char   *ptype0 = "int";
     char   *pval0 = "13";
     char   *pname0 = "bits";
     char   *pdef1 = "Maximum analog level";
     char   *ptype1 = "float";
     char   *pval1 = "2.0";
     char   *pname1 = "maxLevel";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);

      }
break;
   


/*         
 *    INPUT BUFFER SYSTEM  INITS 
 */ 
 case INPUT_BUFFER_INIT:
 {
 int indexIC = block_P->model_index;
     char   *ptypeIn0 = "float";
     char   *pnameIn0 = "x";
KrnModelConnectionInput(indexIC,0 ,pnameIn0,ptypeIn0);
}
 break;

/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
     

         
   if(NO_INPUT_BUFFERS() != 1 ){
       fprintf(stdout,"%s:1 inputs expected; %d connected\n",
              STAR_NAME,NO_INPUT_BUFFERS());
	      return(200);
   }

   SET_CELL_SIZE_IN(0,sizeof(float));

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

	levels = 1;
	levels <<= bits-1;
	numberOutputBuffers = NO_OUTPUT_BUFFERS();
	if(numberOutputBuffers == 0) {
		fprintf(stderr,"atod: no output buffers connected \n");
		return(1);
	}


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 

 
	/* note the minimum number of samples on the input 	*/
	/* buffers and iterate that many times 			*/
 
	for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) 
 
	{
		IT_IN(0);	
		sample = x(0);
		sin = sample;
		sample = sample/maxLevel;
		if (sample > 1.0 ) sample = 1.0;
		if (sample < -1.0 ) sample = -1.0; 
		sample += 1.0;
		sample = (int) (sample*(levels) +0.5);
		sout =  sample - (float)(levels);  
		if(IT_OUT(0)) {
			KrnOverflow("atod",0);
			return(99);
		}
		OUTF(0,0) = sout;
		/*
	 	 * if buffer 1 connected, output the A/D error
		 */
		if( numberOutputBuffers == 2 ) { 
			if(IT_OUT(1)) {
				KrnOverflow("atod",1);
				return(99);
			}
			OUTF(1,0) = sout/(float)levels-sin;
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
