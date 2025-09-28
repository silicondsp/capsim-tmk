 
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

This star performs interpolation or decimation on an input data stream, in order to change the output data rate.  Polynomial or sinc interpol- ation is used to create output values that occur "between" input points.  An initial time offset between the input/output streams can be entered.

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
       long   __incount;
       long   __outcount;
       float   __phase;
       double   __outaccum;
       float   __Q;
       float   __R;
       float   __S;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define  incount  (state_P->__incount)
#define  outcount  (state_P->__outcount)
#define  phase  (state_P->__phase)
#define  outaccum  (state_P->__outaccum)
#define  Q  (state_P->__Q)
#define  R  (state_P->__R)
#define  S  (state_P->__S)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define x(DELAY) (*(( float   *)PIN(0,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define y(delay) *( float   *)POUT(0,delay)

/*         
 *    PARAMETER DEFINES 
 */ 
#define ratio (param_P[0]->value.f)
#define phi (param_P[1]->value.f)
#define intype (param_P[2]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  
resmpl
(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int i,j;
	float beta;	/* interpolation fraction */
	float beta2;
	float sinc ();	/* custom function in SUBS library */
	int  no_samples;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = " ratio:  output data rate/input data rate. ";
     char   *ptype0 = "float";
     char   *pval0 = "1.";
     char   *pname0 = "ratio";
     char   *pdef1 = " delay of first output sample, rel. to first sample.Expressed in units of input data period. ";
     char   *ptype1 = "float";
     char   *pval1 = "0";
     char   *pname1 = "phi";
     char   *pdef2 = " Type of interpolation: 0: sinc (3 point) 1: 1rst order (line) (default) 2: 2nd order (parbola) 3: 3rd order polynomial ";
     char   *ptype2 = "int";
     char   *pval2 = "1";
     char   *pname2 = "intype";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);

      }
break;
   


/*         
 *    OUTPUT BUFFER SYSTEM  INITS 
 */ 
 case OUTPUT_BUFFER_INIT: 
 {
 int indexOC = block_P->model_index;
     char   *ptypeOut0 = " float ";
     char   *pnameOut0 = " y ";
KrnModelConnectionOutput(indexOC,0 ,pnameOut0,ptypeOut0);
}
 break;

/*         
 *    INPUT BUFFER SYSTEM  INITS 
 */ 
 case INPUT_BUFFER_INIT:
 {
 int indexIC = block_P->model_index;
     char   *ptypeIn0 = " float ";
     char   *pnameIn0 = " x ";
KrnModelConnectionInput(indexIC,0 ,pnameIn0,ptypeIn0);
}
 break;

/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
             incount = 0 ;
        outcount = 0 ;
        phase = phi ;
        outaccum = phase ;
        Q = 0 ;
        R = 0 ;
        S = 0 ;



         
   if(NO_OUTPUT_BUFFERS() != 1 ){
       fprintf(stdout,"%s:1 outputs expected; %d connected\n",
              STAR_NAME,NO_OUTPUT_BUFFERS());
	      return(201);
   }

   SET_CELL_SIZE_OUT(0,sizeof( float ));

         
   if(NO_INPUT_BUFFERS() != 1 ){
       fprintf(stdout,"%s:1 inputs expected; %d connected\n",
              STAR_NAME,NO_INPUT_BUFFERS());
	      return(200);
   }

   SET_CELL_SIZE_IN(0,sizeof( float ));

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

	if( ratio <= 0) {
		fprintf(stderr,"resmpl: improper ratio parameter\n");
		return(1);
	}
	if( intype < 0 || intype > 3) {
		fprintf(stderr,"resmpl: unknown interpolation type\n");
		return(2);
	}


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 

	for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) {
		IT_IN(0);
		incount++;
		if(intype == 0) ;
		else if(intype == 1) {
			Q = x(1) - x(0);
			R = S = 0;
		}
		else if(intype == 2) {
			Q = -1.5*x(0) + 2*x(1) - .5*x(2);
			R = .5*x(0) - x(1) + .5*x(2);
			S = 0;
		}
		else if(intype == 3) {
			Q = -11*x(0)/6 + 3*x(1) - 1.5*x(2) + x(3)/3;
			R = x(0) - 2.5*x(1) + 2*x(2) - .5*x(3);
			S = -x(0)/6 + .5*x(1) - .5*x(2) + x(3)/6;
		}

		while( (int)outaccum <= incount - 1) { //ST_DBG
			if(IT_OUT(0)) {
				KrnOverflow("resmpl",0);
				return(99);
			}
			outcount++;
			beta = incount- outaccum;
			if(intype == 0) {
				y(0) = x(0)*sinc (beta)
					+ x(1)*sinc (1-beta)
					+ x(2)*sinc (2-beta);
			}
			else {
				beta2 = beta*beta;
				y(0) = x(0) + Q*beta
					+ R*beta2 + S*beta2*beta;
			}
			/*this method prevents accumulation of error*/
			outaccum = phase + outcount / ratio;
		}
	}


break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 



break;
}
return(0);
}
