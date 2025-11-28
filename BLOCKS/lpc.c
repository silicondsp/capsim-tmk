 
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

This star computes the LPC parameters of the input samples.

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 

#include <math.h>
#include <stdio.h>
#include <string.h>


 

#define PI 3.1415926
#define AUTO 0
#define COVAR 1


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int  __n;
      int  __numberOfOutputs;
      float*  __x_P;
      FILE*  __fp;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define n (state_P->__n)
#define numberOfOutputs (state_P->__numberOfOutputs)
#define x_P (state_P->__x_P)
#define fp (state_P->__fp)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define x(DELAY) (*((float  *)PIN(0,DELAY)))

/*         
 *    PARAMETER DEFINES 
 */ 
#define N (param_P[0]->value.d)
#define m (param_P[1]->value.d)
#define flag (param_P[2]->value.d)
#define fileName (param_P[3]->value.s)
#define npts (param_P[4]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

lpc 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

   	int i;
   	int j;
	int nrot;
	float tmp1,tmp2;
	float a_A[21];
	float rc_A[21];
	float alpha;
	float *vector(int nn);
	int result;
	float realAz,imgAz,Az;
	float theta,dtheta;
	int Dsp_Covar(int n1,float* x1_P,int m1,float* a1_P,float* alpha1_P,float* grc1_P);
	int Dsp_Auto(int n1,float* x1_P,int m1,float* a1_P,float* alpha1_P,float* rc1_P);


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "N :  Size of the input window ";
     char   *ptype0 = "int";
     char   *pval0 = "128";
     char   *pname0 = "N";
     char   *pdef1 = "m:  Order of the all-pole model <=20";
     char   *ptype1 = "int";
     char   *pval1 = "10";
     char   *pname1 = "m";
     char   *pdef2 = "0=Auto, 1=Covar Method";
     char   *ptype2 = "int";
     char   *pval2 = "0";
     char   *pname2 = "flag";
     char   *pdef3 = "File to store the AR coefficients and reflection coeff";
     char   *ptype3 = "file";
     char   *pval3 = "stdout";
     char   *pname3 = "fileName";
     char   *pdef4 = "Number of points for spectrum";
     char   *ptype4 = "int";
     char   *pval4 = "128";
     char   *pname4 = "npts";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);
KrnModelParam(indexModel88,3 ,pdef3,ptype3,pval3,pname3);
KrnModelParam(indexModel88,4 ,pdef4,ptype4,pval4,pname4);

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

 

       if(m > 20) {
		fprintf(stderr,"lpc: Order > 20 \n");
		return(2);
	}
       numberOfOutputs=NO_OUTPUT_BUFFERS();
       if(numberOfOutputs > 1) {
		fprintf(stderr,"lpc: Number of Outputs > 1 \n");
		return(1);
       }
	/*
	 * Initialize the tapped delay line  to zero.
	 *
	 */
	x_P=vector(N);
	for (i=0; i<N; i++) {
		x_P[i] = 0.0;
	}
       if(strcmp(fileName,"stdout") == 0) fp=stdout;
       else fp=fopen(fileName,"w");
       if(fp == NULL)  {
		fprintf(stderr,"lpc: could not open file! \n");
		return(3);
       }
       n = 0;


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 




while(IT_IN(0)) {
	n += 1 ;
	/*
	 * Shift input sample into tapped delay line
	 */
	tmp2=x(0);
	for(i=0; i<N; i++) {
		tmp1=x_P[i];
		x_P[i]=tmp2;
		tmp2=tmp1;
	}

        if(n== N){
		/*
		 * collected N samples. Perform LPC Analysis
		 */
		switch (flag) {
			case AUTO:
			   result=Dsp_Auto(n,x_P,m,a_A,&alpha,rc_A);
			   break;
			case COVAR:
			   result=Dsp_Covar(n,x_P,m,a_A,&alpha,rc_A);
			   break;
		}
      		for(i=0; i<=m; i++)
                        fprintf(fp,"%e  %e \n",a_A[i],rc_A[i]);
      		fprintf(fp,"%e \n",alpha);

		dtheta=PI/(float)npts;
		for(i=0; i<npts; i++) {
		   theta=i*dtheta;
		   realAz=0.0;
		   imgAz=0.0;
		   for(j=0; j<=m; j++) {

			realAz += a_A[j]*cos(j*theta);
			imgAz += a_A[j]*sin(j*theta);
		   }
		   Az= sqrt(realAz*realAz+imgAz*imgAz);
		   if(IT_OUT(0)) {
			KrnOverflow("lpc",0);
			return(99);
		   }
		   OUTF(0,0)=1.0/Az;
		   

		}	
		/*
		 * initialize
		 */
		for (i=0; i<N; i++) {
			x_P[i] = 0.0;
		}
      		for(i=0; i<=m; i++) {
			a_A[i]=0.0;
			rc_A[i]=0.0;
		}
		alpha=0.0;
		n=0;

        }

}
    


break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

/*
 * close the file
 */
if(strcmp(fileName,"stdout") != 0) fclose(fp);


break;
}
return(0);
}
