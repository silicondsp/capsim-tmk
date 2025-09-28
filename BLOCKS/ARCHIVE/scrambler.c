 
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

The scrambler and descrambler implemented here,which are self-synchronizing, are given in the CCITT recommendation V35.

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
      long  __shift_reg;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define shift_reg (state_P->__shift_reg)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define bitin(DELAY) (*((float  *)PIN(0,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define bitout(delay) *(float  *)POUT(0,delay)

/*         
 *    PARAMETER DEFINES 
 */ 
#define mode (param_P[0]->value.d)
#define seed (param_P[1]->value.d)
/*-------------- BLOCK CODE ---------------*/


scrambler 

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
 

	long output_bit;
	int	no_samples;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "mode: The operation done on the input sequence is either scrambling,mode = 0,or descrambling,mode = 1.";
     char   *ptype0 = "int";
     char   *pval0 = "";
     char   *pname0 = "mode";
     char   *pdef1 = "seed: Can be used to force two scramblers out of phase by choosing two values for the seed.";
     char   *ptype1 = "int";
     char   *pval1 = "12";
     char   *pname1 = "seed";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);

      }
break;
   


/*         
 *    OUTPUT BUFFER SYSTEM  INITS 
 */ 
 case OUTPUT_BUFFER_INIT: 
 {
 int indexOC = block_P->model_index;
     char   *ptypeOut0 = "float";
     char   *pnameOut0 = "bitout";
KrnModelConnectionOutput(indexOC,0 ,pnameOut0,ptypeOut0);
}
 break;

/*         
 *    INPUT BUFFER SYSTEM  INITS 
 */ 
 case INPUT_BUFFER_INIT:
 {
 int indexIC = block_P->model_index;
     char   *ptypeIn0 = "float";
     char   *pnameIn0 = "bitin";
KrnModelConnectionInput(indexIC,0 ,pnameIn0,ptypeIn0);
}
 break;

/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            shift_reg=seed;



         
   if(NO_OUTPUT_BUFFERS() != 1 ){
       fprintf(stdout,"%s:1 outputs expected; %d connected\n",
              STAR_NAME,NO_OUTPUT_BUFFERS());
	      return(201);
   }

   SET_CELL_SIZE_OUT(0,sizeof(float));

         
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

 

		/* error if mode not zero or one */
		if(mode != 0 && mode != 1)
			return(1);


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


	for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) {

		IT_IN(0);
		/* error if bitin(0) not zero or one */
		if((bitin(0) != (float) 0) && (bitin(0) != (float) 1))
			return(2);

		/* algorithms are slightly different for scrambling
		   and descrambling */
		if(mode == 0) { /* scrambling desired */
			
			/* generate next output bit */
			output_bit = (((shift_reg>>2)&1) +
			 	((shift_reg>>19)&1) + 1 + (long) bitin(0));
			output_bit = output_bit & 1;

			/* generate next shift register state */
			shift_reg = (shift_reg << 1) | output_bit;
			}

		else {  /* descrambling desired */

			/* generate next shift register state */
			shift_reg = (shift_reg<<1)|(long) bitin(0);

			/* generate next output bit */
			output_bit = (((shift_reg >> 3) & 1) + 1 +
		  	  ((shift_reg>>20)&1) + (shift_reg&1))%2;
			}

		if(IT_OUT(0)) {
			KrnOverflow("scrambler",0);
			return(99);
		}
		bitout(0) = (float) (output_bit == 0);
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
