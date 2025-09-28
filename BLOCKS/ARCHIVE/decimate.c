 
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

Decimation filter for weights in Delta Sigma Modulation

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>


 

#define UNIFORM 1
#define TRIANGULAR 2
#define PARABOLIC 3


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int*  __weights_P;
      int*  __x_P;
      float  __wnorm;
      int  __k;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define weights_P (state_P->__weights_P)
#define x_P (state_P->__x_P)
#define wnorm (state_P->__wnorm)
#define k (state_P->__k)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define xx(DELAY) (*((float  *)PIN(0,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define y(delay) *(float  *)POUT(0,delay)

/*         
 *    PARAMETER DEFINES 
 */ 
#define iw (param_P[0]->value.d)
#define nf (param_P[1]->value.d)
#define idec (param_P[2]->value.d)
/*-------------- BLOCK CODE ---------------*/


decimate 

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
 

	int buffer_no,no_samples;
        float xf,ysum,sum,tmp;
        int n1,n2,i,j,m;
	int nf1,nfd2,nfd3;
	float	tmp2,tmp1;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Weighting: 1-Uniform 2-Triangular 3-Parabolic";
     char   *ptype0 = "int";
     char   *pval0 = "3";
     char   *pname0 = "iw";
     char   *pdef1 = "Number of taps for FIR decimation filter";
     char   *ptype1 = "int";
     char   *pval1 = "128";
     char   *pname1 = "nf";
     char   *pdef2 = "Decimation factor";
     char   *ptype2 = "int";
     char   *pval2 = "32";
     char   *pname2 = "idec";
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
     char   *pnameIn0 = "xx";
KrnModelConnectionInput(indexIC,0 ,pnameIn0,ptypeIn0);
}
 break;

/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
     


         
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

 

/*   
 * allocate work space      
 */
if(((weights_P=(int*)calloc(nf,sizeof(int))) == NULL) ||
		(x_P =(int*)calloc(nf,sizeof(int))) == NULL) { 
		fprintf(stderr,"decimate(): can't allocate work space \n");
		return(1);
}
nf1=nf-1;
nfd2=(int)(nf/2);
nfd3=(int)(nf/3.)+1;
/*
 * setup weights for decimation filters
 */
wnorm=0.0;
for(i=0; i<nf; i++) {
	switch(iw) {
		   case UNIFORM:
			weights_P[i]=1;
		        break;
		   case PARABOLIC:
	   		if(i <= nfd3)  {
	      		   weights_P[i]=(int)(i*(i+1)/2);
	      		   weights_P[nf-i-1]=weights_P[i];
			} else  if(i <= nfd2) {
	      		   weights_P[i]=(int)(nfd3*(nfd3+1)/2+(i-nfd3)*(2*nfd3-1-i));
	      		   weights_P[nf-i-1]=weights_P[i];
			} 
			break;
		   case TRIANGULAR:
	   	      if(i <=  nfd2-1)  
	      			weights_P[i]=i;
	   	      else
	      			weights_P[i]=nf-i;
		      break;
		   default:
			fprintf(stderr,"decimate invalid window type\n");
			return(2);
			break;
	}
	/*
	 * Initialized Tapped Delay Line to Zero
	 */
	x_P[i]=0;
    	wnorm=wnorm+weights_P[i];
}
k=0;


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


while(IT_IN(0)) {
	/*
         * Shift input sample into tapped delay line
         */
         tmp2=xx(0);
         for(i=0; i<nf; i++) {
                tmp1=x_P[i];
                x_P[i]=tmp2;
                tmp2=tmp1;
         }
         /*
          * Compute inner product
          */
         sum = 0.0;
         for (i=0; i<nf; i++) {
                     sum += x_P[i]*weights_P[i];
         }
	 k++;
	 if(k==idec) {
	 	if(IT_OUT(0)) {
			KrnOverflow("decimate",0);
			return(99);
		}
	 	y(0)=sum/wnorm;
		k=0;
	 }

}



break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

	free(x_P);
	free(weights_P);


break;
}
return(0);
}
