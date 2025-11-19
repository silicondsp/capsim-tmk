 
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

Perform operations on input buffer.

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 

#include <math.h>



/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int  __count;
      int  __wait;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define count (state_P->__count)
#define wait (state_P->__wait)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define x(DELAY) (*((float  *)PIN(0,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define xmod(delay) *(float  *)POUT(0,delay)

/*         
 *    PARAMETER DEFINES 
 */ 
#define N (param_P[0]->value.d)
#define first (param_P[1]->value.d)
#define gain (param_P[2]->value.f)
#define offset (param_P[3]->value.f)
#define operation (param_P[4]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

operate 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int i,j;
	float xval;
	float tmp;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Number of samples to output";
     char   *ptype0 = "int";
     char   *pval0 = "30000";
     char   *pname0 = "N";
     char   *pdef1 = "First sample to blockt from";
     char   *ptype1 = "int";
     char   *pval1 = "0";
     char   *pname1 = "first";
     char   *pdef2 = "Gain";
     char   *ptype2 = "float";
     char   *pval2 = "1.";
     char   *pname2 = "gain";
     char   *pdef3 = "DC Offset";
     char   *ptype3 = "float";
     char   *pval3 = "0.";
     char   *pname3 = "offset";
     char   *pdef4 = "Operation:0=none,1=abs,2=square,3=sqrt,4=dB";
     char   *ptype4 = "int";
     char   *pval4 = "0";
     char   *pname4 = "operation";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);
KrnModelParam(indexModel88,3 ,pdef3,ptype3,pval3,pname3);
KrnModelParam(indexModel88,4 ,pdef4,ptype4,pval4,pname4);

      }
break;
   


/*         
 *    OUTPUT BUFFER SYSTEM  INITS 
 */ 
 case OUTPUT_BUFFER_INIT: 
 {
 int indexOC = block_P->model_index;
     char   *ptypeOut0 = "float";
     char   *pnameOut0 = "xmod";
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
            count=N;
       wait=first;



         
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

 



break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


	for(i=MIN_AVAIL();i>0; --i) {
		IT_IN(0);
		xval = x(0);
		if(wait-- <= 0 ) {
			if(count-- > 0) {
				if(IT_OUT(0)) {
					KrnOverflow("operate",0);
					return(99);
				}
				tmp = gain * xval + offset;
				switch ( operation) {
				  case 0:
					xmod(0) = tmp;
					break;
				  case 1:
					xmod(0) = fabs(tmp);
					break;
				  case 2:
					xmod(0) = tmp*tmp;
					break;
				  case 3:
					xmod(0) = sqrt(tmp);
					break;
				  case 4:
					if(tmp)
					   xmod(0) = 10*log10(tmp*tmp);
					else 
					   xmod(0)= -200.0;
					break;
				}
			}
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
