 
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

Blind adaptive equalization

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 

#include <stdio.h>


 

#define EE 2.7182818
#define big 21474836480.0


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      float**  __x_P;
      float**  __w_P;
      int  __mucounter;
      int  __varcounter;
      float  __tmpvar;
      float  __tmpmu;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define x_P (state_P->__x_P)
#define w_P (state_P->__w_P)
#define mucounter (state_P->__mucounter)
#define varcounter (state_P->__varcounter)
#define tmpvar (state_P->__tmpvar)
#define tmpmu (state_P->__tmpmu)

/*         
 *    PARAMETER DEFINES 
 */ 
#define N (param_P[0]->value.d)
#define mu (param_P[1]->value.f)
#define muratio (param_P[2]->value.f)
#define murate (param_P[3]->value.d)
#define varratio (param_P[4]->value.f)
#define varrate (param_P[5]->value.d)
#define mean (param_P[6]->value.f)
#define var (param_P[7]->value.f)
#define outputFlag (param_P[8]->value.d)
#define init (param_P[9]->value.f)
/*-------------- BLOCK CODE ---------------*/
 int  

blindadapt 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

   	int i;
   	int j, k;
        float register1[2];
        float register2[2];
        float output[2];
        float lambda11=0.0, lambda21=0.0, lambda22=0.0, lambda12=0.0;
        float xtemp=0.0, ytemp=0.0;
	FILE *fopen();
	FILE *imp_F;
	FILE *imp;
	FILE *imp_W;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Filter order";
     char   *ptype0 = "int";
     char   *pval0 = "8";
     char   *pname0 = "N";
     char   *pdef1 = "Initial step size";
     char   *ptype1 = "float";
     char   *pval1 = "0.009";
     char   *pname1 = "mu";
     char   *pdef2 = "step size update ratio";
     char   *ptype2 = "float";
     char   *pval2 = "1.0";
     char   *pname2 = "muratio";
     char   *pdef3 = "step size update rate (in samples)";
     char   *ptype3 = "int";
     char   *pval3 = "4000";
     char   *pname3 = "murate";
     char   *pdef4 = "variance update ratio";
     char   *ptype4 = "float";
     char   *pval4 = "1.0";
     char   *pname4 = "varratio";
     char   *pdef5 = "variance update rate (in samples)";
     char   *ptype5 = "int";
     char   *pval5 = "4000";
     char   *pname5 = "varrate";
     char   *pdef6 = "mean";
     char   *ptype6 = "float";
     char   *pval6 = "1.0";
     char   *pname6 = "mean";
     char   *pdef7 = "variance";
     char   *ptype7 = "float";
     char   *pval7 = "0.14";
     char   *pname7 = "var";
     char   *pdef8 = "Flag: 0=estimate, 1=error";
     char   *ptype8 = "int";
     char   *pval8 = "0";
     char   *pname8 = "outputFlag";
     char   *pdef9 = "initilization";
     char   *ptype9 = "float";
     char   *pval9 = "1.0";
     char   *pname9 = "init";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);
KrnModelParam(indexModel88,3 ,pdef3,ptype3,pval3,pname3);
KrnModelParam(indexModel88,4 ,pdef4,ptype4,pval4,pname4);
KrnModelParam(indexModel88,5 ,pdef5,ptype5,pval5,pname5);
KrnModelParam(indexModel88,6 ,pdef6,ptype6,pval6,pname6);
KrnModelParam(indexModel88,7 ,pdef7,ptype7,pval7,pname7);
KrnModelParam(indexModel88,8 ,pdef8,ptype8,pval8,pname8);
KrnModelParam(indexModel88,9 ,pdef9,ptype9,pval9,pname9);

      }
break;
   


/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
     
break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

	/*
	 * Allocate memory and return pointers for tapped delay line x_P and
	 * array containing impulse response samples, h_P.
	 *
	 */
	if( (x_P = (float**)calloc(2,sizeof(float*))) == NULL ||
	    (w_P = (float**)calloc(2,sizeof(float*))) == NULL ) {
	   	fprintf(stderr,"convolve: can't allocate work space\n");
		return(4);
	}
        for(i=0; i<2; i++)
	if( (x_P[i] = (float*)calloc(N,sizeof(float))) == NULL ||
	    (w_P[i] = (float*)calloc(N,sizeof(float))) == NULL ) {
	   	fprintf(stderr,"convolve: can't allocate work space\n");
		return(4);
	}
	/*
	 * Read in the impulse response samples into the array
	 * and initialize the tapped delay line to zero.
         * According to this for loop the impulse data is assumed to be
         * in the order of first real then imaginary value for each tap
         *
         */
	tmpvar = var;
	tmpmu = mu;
	mucounter = 0;
	varcounter = 0;
	    w_P[0][0] = init;
      for(j=1;j<N;j++)
	    w_P[0][j] = 0.0;
      for(j=0;j<N;j++)
	    w_P[1][j] = 0.0; 
      for(j=0;j<N;j++)
         for(i=0;i<2;i++){
            x_P[i][j] = 0.0; } 


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 




	while(IT_IN(0) && IT_IN(1)){
		/*
		 * Shift input samples into tapped delay line
		 */  
		mucounter++ ; 
		varcounter++ ; 
                for( i=0 ; i<2 ; i++)
		register2[i] = INF(i,0);

		for(i=0; i<N; i++) 
                    for(j=0; j<2; j++){
			register1[j] = x_P[j][i];
			x_P[j][i] = register2[j];
			register2[j] = register1[j];
		}
		/*
		 * Compute inner product 
		 */
                output[0] = 0.0;
                output[1] = 0.0;
		for (i=0; i<N; i++) { 
		     output[0] += ( x_P[0][i]*w_P[0][i] -
                                          x_P[1][i]*w_P[1][i]);
		     output[1] += ( x_P[0][i]*w_P[1][i] +
                                          x_P[1][i]*w_P[0][i]);
		}

                for(i=0; i<2; i++) {
                        if(IT_OUT(i)) {
				KrnOverflow("blindadapt",i);
				return(99);
			}
                        OUTF(i,0) = output[i];
                }



	 	xtemp = 2.0*mean*output[0]/tmpvar;
		ytemp = 2.0*mean*output[1]/tmpvar; 
		lambda11 = 1.0/((1.0+pow(EE,-xtemp))*(1.0+pow(EE,-ytemp)));
		lambda21 = 1.0/((1.0+pow(EE,xtemp))*(1.0+pow(EE,-ytemp)));
		lambda22 = 1.0/((1.0+pow(EE,xtemp))*(1.0+pow(EE,ytemp)));
		lambda12 = 1.0/((1.0+pow(EE,-xtemp))*(1.0+pow(EE,ytemp)));

		if(mucounter == murate) {
			tmpmu = muratio*tmpmu;
			mucounter = 0;
					}
		if(varcounter == varrate) {
			tmpvar = varratio*tmpvar;
			varcounter = 0;
					}

                for (i=0;i<N;i++) { 

		 w_P[0][i] += tmpmu*(1.0/tmpvar)*(lambda11*((mean-output[0])*x_P[0][i]+(mean - output[1])*x_P[1][i])+lambda21*((-mean-output[0])*x_P[0][i]+(mean-output[1])*x_P[1][i])+lambda22*((-mean-output[0])*x_P[0][i]+(-mean-output[1])*x_P[1][i])+lambda12*((mean-output[0])*x_P[0][i]+(-mean-output[1])*x_P[1][i]));

                 w_P[1][i] += tmpmu*(1.0/tmpvar)*(lambda11*((output[0]-mean)*x_P[1][i]+(mean-output[1])*x_P[0][i])+lambda21*((output[0]+mean)*x_P[1][i]+(mean-output[1])*x_P[0][i])+lambda22*((output[0]+mean)*x_P[1][i]+(-mean-output[1])*x_P[0][i])+lambda12*((output[0]-mean)*x_P[1][i]+(-mean-output[1])*x_P[0][i]));
                                     } 

}
imp_W = fopen("taps","w");
      for(j=0;j<N;j++)
         for(i=0;i<2;i++){
            fprintf(imp_W,"%f\n", w_P[i][j]);
                           } 
fclose(imp_W);
              


break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

	free(x_P); free(w_P);


break;
}
return(0);
}
