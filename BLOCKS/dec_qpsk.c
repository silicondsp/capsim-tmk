 
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

This star inputs constellation points and decods them into a bit stream. It is assumed that the constellation was produced by qpsk.s.

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define id(DELAY) (*((float  *)PIN(0,DELAY)))
#define qd(DELAY) (*((float  *)PIN(1,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define bits(delay) *(float  *)POUT(0,delay)

/*         
 *    PARAMETER DEFINES 
 */ 
#define gain (param_P[0]->value.f)
/*-------------- BLOCK CODE ---------------*/
 int  

dec_qpsk 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
/*
 *              Declarations 
 */
 

	int	i,k,j,jj;
	static float a_A[4]= {1,1,-1,-1};
	static float b_A[4]= {1,-1,1,-1};
	float x,y;
        float d,dmin;
        int index;
        float b0,b1;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Normalizing Gain";
     char   *ptype0 = "float";
     char   *pval0 = "1.0";
     char   *pname0 = "gain";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);

      }
break;
   


/*         
 *    OUTPUT BUFFER SYSTEM  INITS 
 */ 
 case OUTPUT_BUFFER_INIT: 
 {
 int indexOC = block_P->model_index;
     char   *ptypeOut0 = "float";
     char   *pnameOut0 = "bits";
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
     char   *pnameIn0 = "id";
     char   *ptypeIn1 = "float";
     char   *pnameIn1 = "qd";
KrnModelConnectionInput(indexIC,0 ,pnameIn0,ptypeIn0);
KrnModelConnectionInput(indexIC,1 ,pnameIn1,ptypeIn1);
}
 break;

/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     

         
   if(NO_OUTPUT_BUFFERS() != 1 ){
       fprintf(stdout,"%s:1 outputs expected; %d connected\n",
              STAR_NAME,NO_OUTPUT_BUFFERS());
	      return(201);
   }

   SET_CELL_SIZE_OUT(0,sizeof(float));

         
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

 



break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


       for(jj=(MIN_AVAIL());jj >0; --jj)
       {
                IT_IN(0);
                IT_IN(1);
		x=id(0)*gain;
                y=qd(0)*gain;
                dmin=10000.0;
                index=0;
                for(i=0; i<4; i++) {
                    d=sqrt((x-a_A[i])*(x-a_A[i])+(y-b_A[i])*(y-b_A[i]));
                    if ( d <dmin) {
                            dmin=d;
                            index=i;
                    }
                }
                switch (index) {
                    case 0:
                       b0=0;
                       b1=0;
                       break;
                    case 1:
                       b0=1;
                       b1=0;
                       break;
                    case 2:
                       b0=0;
                       b1=1;
                       break;
                    case 3:
                       b0=1;
                       b1=1;
                       break;
                }

  		if(IT_OUT(0)) {
				KrnOverflow("dec_qpsk",0) ;
				return(99);
		}
                bits(0)=b1;

  		if(IT_OUT(0)) {
				KrnOverflow("dec_qpsk",0) ;
				return(99);
		}
                bits(0)=b0;


		
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
