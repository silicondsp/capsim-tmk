 
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

This star implements a multichannel input/output FIR predictor, which is adapted using the power normalized LMS algorithm.

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>


 

#define Mch  	10	/* maximum i or o channels */


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int*  __orders;
      float*  __W;
      int  __N;
      int  __p;
      int  __q;
      float*  __Z;
      FILE*  __fp;
      float*  __xpower;
      float*  __epower;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define orders (state_P->__orders)
#define W (state_P->__W)
#define N (state_P->__N)
#define p (state_P->__p)
#define q (state_P->__q)
#define Z (state_P->__Z)
#define fp (state_P->__fp)
#define xpower (state_P->__xpower)
#define epower (state_P->__epower)

/*         
 *    PARAMETER DEFINES 
 */ 
#define ifile_name (param_P[0]->value.s)
#define ofile_name (param_P[1]->value.s)
#define lambda (param_P[2]->value.f)
#define delta (param_P[3]->value.f)
#define wait (param_P[4]->value.d)
#define adapt (param_P[5]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

predlms 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int i,j,k,jj;
	float xdata;
	float error[Mch];
	float z[Mch];
	int index;
	float estimate;		/* prediction to output */
	float xalpha;		/* lms adaptation variable */


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = " Name of ASCII input specification file.";
     char   *ptype0 = "file";
     char   *pval0 = "prfile";
     char   *pname0 = "ifile_name";
     char   *pdef1 = " Name of ASCII output specification file.";
     char   *ptype1 = "file";
     char   *pval1 = "prfileo";
     char   *pname1 = "ofile_name";
     char   *pdef2 = " LMS loop gain";
     char   *ptype2 = "float";
     char   *pval2 = "1.0";
     char   *pname2 = "lambda";
     char   *pdef3 = " LMS tap leakage factor ";
     char   *ptype3 = "float";
     char   *pval3 = "1.0";
     char   *pname3 = "delta";
     char   *pdef4 = " Number of samples to skip before starting adaptation";
     char   *ptype4 = "int";
     char   *pval4 = "0";
     char   *pname4 = "wait";
     char   *pdef5 = " Number of samples to adapt. Freeze after this number of  iterations";
     char   *ptype5 = "int";
     char   *pval5 = "-1";
     char   *pname5 = "adapt";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);
KrnModelParam(indexModel88,3 ,pdef3,ptype3,pval3,pname3);
KrnModelParam(indexModel88,4 ,pdef4,ptype4,pval4,pname4);
KrnModelParam(indexModel88,5 ,pdef5,ptype5,pval5,pname5);

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

 

	if(NO_OUTPUT_BUFFERS() < 1) {
		fprintf(stderr,"pred: no output data channels\n");
		return(1);
	}
	if(NO_INPUT_BUFFERS() < NO_OUTPUT_BUFFERS() +1) {
		fprintf(stderr,"pred: not enough input buffers\n");
		return(2);
	}
	if((fp = fopen(ifile_name, "r")) == NULL) {
		fprintf(stderr,"pred: can't open spec file %s\n",
			ifile_name);
		return(3);
	}
	fscanf(fp, "%d", &q);
	fscanf(fp, "%d", &p);
	if(p > Mch || q > Mch) {
		fprintf(stderr,"pred: more than %d i/o channels\n",Mch);
		return(4);
	}
	if( q != NO_OUTPUT_BUFFERS() ||
	    p != NO_INPUT_BUFFERS() - q ) {
		fprintf(stderr,
		"pred: spec file %s does not agree with topology\n",
			ifile_name);
		return(5);
	}
	if(   (orders = (int*)calloc(p,sizeof(float))) == NULL
	   || (xpower = (float*)calloc(p,sizeof(float))) == NULL
	   || (epower = (float*)calloc(q,sizeof(float))) == NULL  ) {
		fprintf(stderr,"pred: can't allocate filter space\n");
		return(6);
	}
	N = 0;
	for(j=0; j<p; j++) {
		if((fscanf(fp,"%d",&orders[j])) != 1) {
			fprintf(stderr,"pred: improper input file %s\n",
					ifile_name);
			return(7);
		}
		N += orders[j];
	}
	if(  (W = (float*)calloc(N*q,sizeof(float))) == NULL
	   ||(Z = (float*)calloc(N,sizeof(float))) == NULL  ) {
		fprintf(stderr,"pred: can't allocate filter space\n");
		return(8);
	}
	for(k=0; k<q; k++) {
		for(i=0; i<N; i++) {
			if((fscanf(fp,"%f",&W[i*q+k])) != 1) {
				fprintf(stderr,"pred: improper input file %s\n",
					ifile_name);
				return(7);
			}
		}
	}
	fclose(fp);
	/* set up unit delay in error channels */
	for(k=0; k<q; k++)
		SET_DMIN_IN(k,1);
	/* initialize input power variables */
	for(j=0; j<p; j++)
		xpower[j] = 1e-1;


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 

#if 0
if(MIN_AVAIL() == 0) return(0);
#endif

for(jj = MIN_AVAIL(); jj>0; jj--) {

if(wait > 0) {
	wait--;
	for(k=0; k<q; k++) {
		IT_IN(k);
		if(IT_OUT(k)) {
			KrnOverflow("predlms",k);
			return(99);
		}
		OUTF(k,0) = 0;
	}
	for(j=0; j<p; j++)
		IT_IN(q+j);
	return(0);
}

/*** Normal Operation ***/
/* input new data and update power state */
for(j=0; j<p; j++) {
	IT_IN(q+j);
	z[j] = INF(q+j,0);
	xpower[j] *= .96;
	xpower[j] += .04 * z[j] * z[j];
}
/* input unit-delayed error(s) */
for(k=0; k<q; k++) {
	IT_IN(k);
	error[k] = INF(k,1);
	/* update error power state */
	epower[k] *= .96;
	epower[k] += .04 * error[k] * error[k];
}
if(adapt == 0) goto resume;

/**** lms algorithm *****/
for(k=0; k<q; k++) {
	/* update filter taps */
	index = 0;
	for(j=0; j<p; j++) {
		xalpha = error[k]/(2 * (1+orders[j]) * xpower[j]);
		xalpha *= lambda;
		/* LMS update taps */
		for(i=0; i<orders[j]; i++) {
			W[index*q+k] += xalpha * Z[index];
			W[index*q+k] *= delta;
			index++;
		}
	}
}

resume:

/* update data array */
for(i=N-1; i>0; i--)
	Z[i] = Z[i-1];
index = 0;
for(j=0; j<p; j++) {
	Z[index] = z[j];
	index += orders[j];
}
/* Compute, output estimate for each output channel */
for(k=0; k<q; k++) {
	estimate = 0;
	for(i=0; i<N; i++)
		estimate += W[i*q+k] * Z[i];
	if(IT_OUT(k)) {
			KrnOverflow("predlms",k);
			return(99);
	}
	OUTF(k,0) = estimate;
}
		
if(adapt > 0) adapt--;

}
return(0);



break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

for(k=0; k<q; k++) {
	if(epower[k] <= 0) epower[k] = 1e-30;
	fprintf(stderr,"predlms: pred error power(%d) = %#g = %#.3g dB\n",
	       k,epower[k],10*log10(epower[k]));
}
if((fp = fopen(ofile_name, "w")) == NULL) {
	fprintf(stderr,"pred: can't open output file %s\n", ofile_name);
	return(1);
}
fprintf(fp, "%d\n", q);
fprintf(fp, "%d\n", p);
for(j=0; j<p; j++) {
	fprintf(fp, "%d \t", orders[j]);
}
fprintf(fp, "\n");
for(k=0; k<q; k++) {
	index = 0;
	for(j=0; j<p; j++) {
		fprintf(fp, "\n");
		for(i=0; i<orders[j]; i++) {
			fprintf(fp, "%g   \t", W[index*q+k]);
			if((i+1)%5 == 0) fprintf(fp, "\n");
			index++;
		}
		fprintf(fp, "\n");
	}
	fprintf(fp, "\n");
}
fclose(fp);
free((char*)orders);free((char*)W);
free((char*)xpower);free((char*)epower);


break;
}
return(0);
}
