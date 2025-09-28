 
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

This star implements an alpha-beta tracking filter.

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
      int  __npts;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define npts (state_P->__npts)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define xm(DELAY) (*((float  *)PIN(0,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define ys(delay) *(float  *)POUT(0,delay)
#define yp(delay) *(float  *)POUT(1,delay)
#define ysd(delay) *(float  *)POUT(2,delay)
#define ypd(delay) *(float  *)POUT(3,delay)

/*         
 *    PARAMETER DEFINES 
 */ 
#define alpha (param_P[0]->value.f)
#define beta (param_P[1]->value.f)
#define ts (param_P[2]->value.f)
#define figuess (param_P[3]->value.f)
/*-------------- BLOCK CODE ---------------*/


radar 

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
 

	float dv;
	float tdel;
	float tmp;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "alpha";
     char   *ptype0 = "float";
     char   *pval0 = "0.5";
     char   *pname0 = "alpha";
     char   *pdef1 = "beta";
     char   *ptype1 = "float";
     char   *pval1 = "0.5";
     char   *pname1 = "beta";
     char   *pdef2 = "scan time (msec)";
     char   *ptype2 = "float";
     char   *pval2 = "10.0";
     char   *pname2 = "ts";
     char   *pdef3 = "initial velocity (-knots)";
     char   *ptype3 = "float";
     char   *pval3 = "-400.0";
     char   *pname3 = "figuess";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);
KrnModelParam(indexModel88,3 ,pdef3,ptype3,pval3,pname3);

      }
break;
   


/*         
 *    OUTPUT BUFFER SYSTEM  INITS 
 */ 
 case OUTPUT_BUFFER_INIT: 
 {
 int indexOC = block_P->model_index;
     char   *ptypeOut0 = "float";
     char   *pnameOut0 = "ys";
     char   *ptypeOut1 = "float";
     char   *pnameOut1 = "yp";
     char   *ptypeOut2 = "float";
     char   *pnameOut2 = "ysd";
     char   *ptypeOut3 = "float";
     char   *pnameOut3 = "ypd";
KrnModelConnectionOutput(indexOC,0 ,pnameOut0,ptypeOut0);
KrnModelConnectionOutput(indexOC,1 ,pnameOut1,ptypeOut1);
KrnModelConnectionOutput(indexOC,2 ,pnameOut2,ptypeOut2);
KrnModelConnectionOutput(indexOC,3 ,pnameOut3,ptypeOut3);
}
 break;

/*         
 *    INPUT BUFFER SYSTEM  INITS 
 */ 
 case INPUT_BUFFER_INIT:
 {
 int indexIC = block_P->model_index;
     char   *ptypeIn0 = "float";
     char   *pnameIn0 = "xm";
KrnModelConnectionInput(indexIC,0 ,pnameIn0,ptypeIn0);
}
 break;

/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            npts=0;


  delay_max(star_P->inBuffer_P[0],1);

         
   if(NO_OUTPUT_BUFFERS() != 4 ){
       fprintf(stdout,"%s:4 outputs expected; %d connected\n",
              STAR_NAME,NO_OUTPUT_BUFFERS());
	      return(201);
   }

   SET_CELL_SIZE_OUT(0,sizeof(float));

   SET_CELL_SIZE_OUT(1,sizeof(float));

   SET_CELL_SIZE_OUT(2,sizeof(float));

   SET_CELL_SIZE_OUT(3,sizeof(float));

         
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

 


	tdel=ts/1000.0;
	dv=1.0;
	tmp=0.0;

	while(IT_IN(0))  {
		if(npts < 2)  {
			if(IT_OUT(0)) {
				KrnOverflow("radar",0);
				return(99);
			}
			ys(0) = xm(0);
			if(IT_OUT(1)) {
				KrnOverflow("radar",1);
				return(99);
			}
			yp(0) = xm(0);
			if(IT_OUT(2)) {
				KrnOverflow("radar",2);
				return(99);
			}

			if(npts == 1)
				ysd(0) = 3600.0*xm(1)/tdel-3600.0*xm(0)/tdel;
			else
				ysd(0) = figuess; 

			if(IT_OUT(3)) {
				KrnOverflow("radar",1);
				return(99);
			}
			ypd(0) = ysd(0);
		}
		else  {
			if(xm(0) == 0.0)
				dv = 0.0;
			else
				dv = 1.0;
			if(IT_OUT(1)) {
				KrnOverflow("radar",1);
				return(99);
			}
			if(IT_OUT(2)) {
				KrnOverflow("radar",2);
				return(99);
			}
			if(IT_OUT(3)) {
				KrnOverflow("radar",3);
				return(99);
			}
			if(IT_OUT(0)) {
				KrnOverflow("radar",0);
				return(99);
			}
			yp(0) = ys(1)+ysd(1)*tdel/3600.0;
			ypd(0) = ysd(1);
			ys(0) = yp(0)+dv*alpha*xm(0)-dv*alpha*yp(0);
			tmp = dv*beta*3600.0/tdel;
			ysd(0) = ypd(0)+tmp*xm(0)-tmp*yp(0);
		}
		npts++;
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
