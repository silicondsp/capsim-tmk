 
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

Generate xy sweep

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 

#include <math.h>


 

#define PI 3.1415926


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int  __numberOfRows;
      int  __samplesOut;
      int  __no_inbuf;
      int  __no_outbuf;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define numberOfRows (state_P->__numberOfRows)
#define samplesOut (state_P->__samplesOut)
#define no_inbuf (state_P->__no_inbuf)
#define no_outbuf (state_P->__no_outbuf)

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define x(delay) *(float  *)POUT(0,delay)
#define y(delay) *(float  *)POUT(1,delay)

/*         
 *    PARAMETER DEFINES 
 */ 
#define matrixDim (param_P[0]->value.d)
#define xMin (param_P[1]->value.f)
#define xStep (param_P[2]->value.f)
#define yMin (param_P[3]->value.f)
#define yStep (param_P[4]->value.f)
/*-------------- BLOCK CODE ---------------*/
 int  

xygen 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

     int i,j;
     float step,ramp;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Matrix Dimension";
     char   *ptype0 = "int";
     char   *pval0 = "32";
     char   *pname0 = "matrixDim";
     char   *pdef1 = "Minimum x";
     char   *ptype1 = "float";
     char   *pval1 = "0.0";
     char   *pname1 = "xMin";
     char   *pdef2 = "x step";
     char   *ptype2 = "float";
     char   *pval2 = "1.0";
     char   *pname2 = "xStep";
     char   *pdef3 = "Minimum y";
     char   *ptype3 = "float";
     char   *pval3 = "0.0";
     char   *pname3 = "yMin";
     char   *pdef4 = "y step";
     char   *ptype4 = "float";
     char   *pval4 = "1.0";
     char   *pname4 = "yStep";
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
     char   *pnameOut0 = "x";
     char   *ptypeOut1 = "float";
     char   *pnameOut1 = "y";
KrnModelConnectionOutput(indexOC,0 ,pnameOut0,ptypeOut0);
KrnModelConnectionOutput(indexOC,1 ,pnameOut1,ptypeOut1);
}
 break;

/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            samplesOut=0;


         
   if(NO_OUTPUT_BUFFERS() != 2 ){
       fprintf(stdout,"%s:2 outputs expected; %d connected\n",
              STAR_NAME,NO_OUTPUT_BUFFERS());
	      return(201);
   }

   SET_CELL_SIZE_OUT(0,sizeof(float));

   SET_CELL_SIZE_OUT(1,sizeof(float));

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

numberOfRows=0;


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


if (numberOfRows >= matrixDim) return(0);

for(i=0; i< matrixDim; i++) {

	if(IT_OUT(0)) {
			KrnOverflow("xygen",0);
			return(99);
	}
	ramp = i*xStep+xMin;
	x(0) = ramp; 
	if(IT_OUT(1)) {
			KrnOverflow("xygen",1);
			return(99);
	}
	step= numberOfRows*yStep + yMin;
	y(0)=step;
}
numberOfRows++;
	
         
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
