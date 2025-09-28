 
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

This star is a self-contained third order delta sigma modulator. 

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
      float  __y;
      float  __a;
      float  __b;
      float  __c;
      float  __olda;
      float  __oldc;
      float  __olda1;
      float  __oldc1;
      float  __d;
      float  __e;
      float  __g;
      int  __numberOutputBuffers;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define y (state_P->__y)
#define a (state_P->__a)
#define b (state_P->__b)
#define c (state_P->__c)
#define olda (state_P->__olda)
#define oldc (state_P->__oldc)
#define olda1 (state_P->__olda1)
#define oldc1 (state_P->__oldc1)
#define d (state_P->__d)
#define e (state_P->__e)
#define g (state_P->__g)
#define numberOutputBuffers (state_P->__numberOutputBuffers)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define in(DELAY) (*((float  *)PIN(0,DELAY)))

/*         
 *    PARAMETER DEFINES 
 */ 
#define g1 (param_P[0]->value.f)
#define g2 (param_P[1]->value.f)
#define g3 (param_P[2]->value.f)
#define delta (param_P[3]->value.f)
/*-------------- BLOCK CODE ---------------*/
 int  

ds3 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int i;
	float x;
	float dd;
	float aa;
	float cc;
	float bb;
	float ee;
	float gg;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Gain of first integrator";
     char   *ptype0 = "float";
     char   *pval0 = "1.0";
     char   *pname0 = "g1";
     char   *pdef1 = "Gain of second integrator";
     char   *ptype1 = "float";
     char   *pval1 = "1.0";
     char   *pname1 = "g2";
     char   *pdef2 = "Gain of third integrator";
     char   *ptype2 = "float";
     char   *pval2 = "1.0";
     char   *pname2 = "g3";
     char   *pdef3 = "Binary Quantizer Level";
     char   *ptype3 = "float";
     char   *pval3 = "1.0";
     char   *pname3 = "delta";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);
KrnModelParam(indexModel88,3 ,pdef3,ptype3,pval3,pname3);

      }
break;
   


/*         
 *    INPUT BUFFER SYSTEM  INITS 
 */ 
 case INPUT_BUFFER_INIT:
 {
 int indexIC = block_P->model_index;
     char   *ptypeIn0 = "float";
     char   *pnameIn0 = "in";
KrnModelConnectionInput(indexIC,0 ,pnameIn0,ptypeIn0);
}
 break;

/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            y=1.0;
       a=0.0;
       b=0.0;
       c=0.0;
       olda=0.0;
       oldc=0.0;
       olda1=0.0;
       oldc1=0.0;
       d=0.0;
       e=0.0;
       g=0.0;


         
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

 

       /* note and store the number of output buffers */
        if((numberOutputBuffers = NO_OUTPUT_BUFFERS() ) <= 0) {
                fprintf(stderr,"ds3: no output buffers\n");
                return(1); /* no output buffers */
        }
	if(numberOutputBuffers > 2) {
                fprintf(stderr,"ds3: more than two outputs\n");
                return(2); 
	}


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 

while(IT_IN(0)) {

	x = in(0);
	g = x - y;
	gg = g1 * g;
	aa = a;
	a = aa + gg;
	b = aa - y;
	bb = g2 * b;
	cc = c;
	c = cc + bb;
	d = cc - y;
	dd = g3 * d;
	ee = e;
	e = ee + dd;
	y = delta;
	if(e < 0.0) y = 0.0 - delta;

	
	if(numberOutputBuffers==1) {
		if(IT_OUT(0) ) {
			KrnOverflow("ds3",0);
			return(99);
		}
		OUTF(0,0)=y;
	} else {
		if(IT_OUT(0) ) {
			KrnOverflow("ds3",0);
			return(99);
		}
		OUTF(0,0)=y;
		if(IT_OUT(1) ) {
			KrnOverflow("ds3",1);
			return(99);
		}
		OUTF(0,0)=e;

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
