 
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

Average rows of a matrix

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
      int  __fftl;
      float*  __buffer;
      int  __pointCount;
      int  __rowCount;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define fftl (state_P->__fftl)
#define buffer (state_P->__buffer)
#define pointCount (state_P->__pointCount)
#define rowCount (state_P->__rowCount)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define x(DELAY) (*((float  *)PIN(0,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define y(delay) *(float  *)POUT(0,delay)

/*         
 *    PARAMETER DEFINES 
 */ 
#define row (param_P[0]->value.d)
#define numberRows (param_P[1]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

avrow 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int numberSamples;
	int i,j;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Size of row ";
     char   *ptype0 = "int";
     char   *pval0 = "144";
     char   *pname0 = "row";
     char   *pdef1 = "Number of rows to average";
     char   *ptype1 = "int";
     char   *pval1 = "1";
     char   *pname1 = "numberRows";
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
     char   *pnameOut0 = "y";
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
            pointCount=0;



         
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

 

	if ((buffer = (float*)calloc(row,sizeof(float))) == NULL)
	{
		fprintf(stderr,"avrow: can't allocate work space \n");
		return(2);
	}


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 

	for (numberSamples = MIN_AVAIL(); numberSamples > 0; --numberSamples)
	{
		{
			/*
			 * real input buffer
			 */
			IT_IN(0);
			buffer[pointCount] += x(0);
			pointCount++;

		}	

			

		/* 
		 * Get enough points				
		 */
		if(pointCount >= row)
		{
		 	if(rowCount >= numberRows) {	
			   /* 
			    * now, output complex pairs		
			    */
			    for (i=0; i<row; i++) {
				if(IT_OUT(0)) {
					KrnOverflow("avrow",0);
					return(99);
				}
				y(0) = buffer[i]/numberRows;
			    }
			    rowCount = 0;
			    for (i=0; i<row; i++) buffer[i]=0.0; 
			}
			rowCount++;
			pointCount = 0;
		}
	}
	return(0);


break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

	/* free up allocated space	*/
	free((char*)buffer);


break;
}
return(0);
}
