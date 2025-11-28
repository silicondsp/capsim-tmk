 
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

This star writes the input data on the screen in hex form

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 
#include <string.h>


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      FILE*  __fp;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define fp (state_P->__fp)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define x(DELAY) (*((int  *)PIN(0,DELAY)))

/*         
 *    PARAMETER DEFINES 
 */ 
#define flag (param_P[0]->value.d)
#define file_name (param_P[1]->value.s)
/*-------------- BLOCK CODE ---------------*/
 int  

pri 

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


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Format: 0=Hex, 1=Decimal";
     char   *ptype0 = "int";
     char   *pval0 = "0";
     char   *pname0 = "flag";
     char   *pdef1 = "Name of output file";
     char   *ptype1 = "file";
     char   *pval1 = "stdout";
     char   *pname1 = "file_name";
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
     char   *ptypeIn0 = "int";
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

   SET_CELL_SIZE_IN(0,sizeof(int));

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

	if(strcmp(file_name,"stdout") == 0) fp=stdout;
	else {
           if((fp = fopen(file_name,"w")) == NULL) {
                fprintf(stdout,"pri: can't open output file '%s'\n",
                        file_name);
                return(3);
           }
	}


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


	for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) {
		IT_IN(0);
		switch(flag) {
		  case 0:
                      fprintf(fp,"%x\n", x(0));
		      break;
		  case 1:
                      fprintf(fp,"%d\n", x(0));
		      break;
		}
	}




break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

                fclose(fp);


break;
}
return(0);
}
