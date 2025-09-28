 
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

This star simulates a sampler circuit.  Triggering is on the positive edge of the clock. 

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
      FILE*  __fp;
      int  __count;
      int  __done;
      int  __inbufs;
      int  __outbufs;
      int  __stdflag;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define fp (state_P->__fp)
#define count (state_P->__count)
#define done (state_P->__done)
#define inbufs (state_P->__inbufs)
#define outbufs (state_P->__outbufs)
#define stdflag (state_P->__stdflag)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define x(DELAY) (*((float  *)PIN(0,DELAY)))
#define clock(DELAY) (*((float  *)PIN(1,DELAY)))

/*         
 *    PARAMETER DEFINES 
 */ 
#define phfile_name (param_P[0]->value.s)
#define frame (param_P[1]->value.d)
/*-------------- BLOCK CODE ---------------*/


sampler1 

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
 

	int phase;
	int no_samples;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Enter phase recording file, none if no recording";
     char   *ptype0 = "file";
     char   *pval0 = "phfile";
     char   *pname0 = "phfile_name";
     char   *pdef1 = "Enter frame number";
     char   *ptype1 = "int";
     char   *pval1 = "8";
     char   *pname1 = "frame";
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
     char   *ptypeIn1 = "float";
     char   *pnameIn1 = "clock";
KrnModelConnectionInput(indexIC,0 ,pnameIn0,ptypeIn0);
KrnModelConnectionInput(indexIC,1 ,pnameIn1,ptypeIn1);
}
 break;

/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            stdflag=0;


         
   if(NO_INPUT_BUFFERS() != 2 ){
       fprintf(stdout,"%s:2 inputs expected; %d connected\n",
              STAR_NAME,NO_INPUT_BUFFERS());
	      return(200);
   }

   SET_CELL_SIZE_IN(0,sizeof(float));

   SET_CELL_SIZE_IN(1,sizeof(float));

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

        if((inbufs = NO_INPUT_BUFFERS()) != 2
             || (outbufs = NO_OUTPUT_BUFFERS()) != 1) {
          fprintf(stderr,"sampler: i/o buffers connect problem\n");
          return(1);
  	}
        if(frame < 1) {
                fprintf(stderr,"sampler: improper frame number\n");
                return(2);
        }
        if(strncmp(phfile_name,"std",3) == 0) {
                fp = stdout;
                stdflag = 1;
        }
        else if(strncmp(phfile_name,"none",4) == 0) {
                stdflag = -1;
        }
        else if( (fp = fopen(phfile_name, "w")) == NULL ) {
                fprintf(stderr,"sampler: can't open output file\n");
                return(3);
        }


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 

 
	/* note the minimum number of samples on the input 	*/
	/* buffers and iterate that many times 			*/
	
	for(no_samples=MIN_AVAIL(); no_samples >0; --no_samples) 
	{
		IT_IN(0);	
		IT_IN(1);	
 		
		phase = count % frame;

		if (phase == 0) {
		   done = 0;
		}
		if ((done == 0) && (clock(0) > 0.5)) {
		   done = 1;
		   if(IT_OUT(0)) {
			KrnOverflow("sampler1",0);
			return(99);
		   }
		   OUTF(0,0) = x(0);
		   if (stdflag >= 0) fprintf(fp,"%d\n",phase);
		}
		if ((done == 0) && (phase == (frame - 1))) {
		   if(IT_OUT(0)) {
			KrnOverflow("sampler1",0);
			return(99);
		   }
		   OUTF(0,0) = x(0);
		   if (stdflag >= 0) fprintf(fp,"%d\n",phase);
		}
		count = phase + 1;
	}
	return(0);


break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

        if(!stdflag && stdflag > 0) fclose(fp);


break;
}
return(0);
}
