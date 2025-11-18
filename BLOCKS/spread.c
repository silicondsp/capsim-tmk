 
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

This block inputs data  and spreads it with a sequence from a file.

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 

#include <stdio.h>



/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      float*  __template;
      int  __numberOutputBuffers;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define template (state_P->__template)
#define numberOutputBuffers (state_P->__numberOutputBuffers)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define bindata(DELAY) (*((float  *)PIN(0,DELAY)))

/*         
 *    PARAMETER DEFINES 
 */ 
#define chipsPerBit (param_P[0]->value.d)
#define spreadSeqFileName (param_P[1]->value.s)
/*-------------- BLOCK CODE ---------------*/
 int  

spread 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int i;
	float mag;
	float code_val;
	int no_samples;
        FILE *fp;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Chips per Bit";
     char   *ptype0 = "int";
     char   *pval0 = "8";
     char   *pname0 = "chipsPerBit";
     char   *pdef1 = "File name containing spreading sequence";
     char   *ptype1 = "file";
     char   *pval1 = "spread.dat";
     char   *pname1 = "spreadSeqFileName";
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
     char   *pnameIn0 = "bindata";
KrnModelConnectionInput(indexIC,0 ,pnameIn0,ptypeIn0);
}
 break;

/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
     
  delay_max((buffer_Pt)star_P->inBuffer_P[0],1);

         
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

 

	if((template = (float*)calloc(chipsPerBit, sizeof(float))) == NULL) {
		fprintf(stderr, "spread: cannot allocate space\n");
		return(1);
	}
        fp=fopen(spreadSeqFileName,"r");
	if(fp == NULL) {
		fprintf(stderr, "spread: cannot open file: %s \n",spreadSeqFileName);
		return(2);
	}
        for(i=0; i<chipsPerBit; i++) {
             fscanf(fp,"%f",&template[i]);
             if(feof(fp)) {
		fprintf(stderr, "spread: premature end of  file: %s \n",spreadSeqFileName);
		return(3);
             }
        }
        fclose(fp);
        numberOutputBuffers = NO_OUTPUT_BUFFERS();
        if(numberOutputBuffers == 0) {
                fprintf(stderr,"spread: no output buffers connected \n");
                return(3);
        }


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


 for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) {
		IT_IN(0);
		mag = bindata(0);
                if(mag==0.0)  code_val= -1;
                else
                         code_val=1;

		for(i=0; i<chipsPerBit; i++) {
			if(IT_OUT(0)) {
				KrnOverflow("stc",0);
				return(99);
			}
			OUTF(0,0) = code_val * template[i];
		}
	}


break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

	free(template);


break;
}
return(0);
}
