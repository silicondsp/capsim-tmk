 
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

This star implements a multichannel input/output FIR predictor, which is adapted using the least squares Fast Transversal Filter algorithm.

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>


 

#define Mch     10      /* maximum i or o channels */


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int  __counter;
      float*  __inpower;
      float*  __epower;
      int  __p;
      int  __q;
      FILE*  __fp;
      int*  __orders;
      int  __N;
      float*  __z;
      float*  __Z;
      float*  __F;
      float*  __B;
      float*  __C;
      float*  __Cp;
      float*  __W;
      float*  __Efi;
      float*  __Eb;
      float  __gamma;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define counter (state_P->__counter)
#define inpower (state_P->__inpower)
#define epower (state_P->__epower)
#define p (state_P->__p)
#define q (state_P->__q)
#define fp (state_P->__fp)
#define orders (state_P->__orders)
#define N (state_P->__N)
#define z (state_P->__z)
#define Z (state_P->__Z)
#define F (state_P->__F)
#define B (state_P->__B)
#define C (state_P->__C)
#define Cp (state_P->__Cp)
#define W (state_P->__W)
#define Efi (state_P->__Efi)
#define Eb (state_P->__Eb)
#define gamma (state_P->__gamma)

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

predftf 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

        int i,j,k,jj;
        float error[Mch];
        int index;              /* convenience counter */
        float estimate;
        float cb[Mch];          /* last p elements of Cp[ ] */
        float a[Mch];           /* auxilliary (temp) vector */
        float temp[Mch+1];      /* small working vector */
        float sum;              /* working accumulator */
        float ef[Mch];          /* forward est. error */
        float efp[Mch];         /* forward pred. error */
        float eb[Mch];          /* backward est. err. */
        float ebp[Mch];         /* b. prediction error */
        float gmp;              /* extended gain estimation error */


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = " Name of ASCII input specification file";
     char   *ptype0 = "file";
     char   *pval0 = "prfile";
     char   *pname0 = "ifile_name";
     char   *pdef1 = " Name of ASCII output specification file";
     char   *ptype1 = "file";
     char   *pval1 = "prfileo";
     char   *pname1 = "ofile_name";
     char   *pdef2 = "Forgetting factor <= 1.0";
     char   *ptype2 = "float";
     char   *pval2 = "1.0";
     char   *pname2 = "lambda";
     char   *pdef3 = "Initial value: forward prediction energy value";
     char   *ptype3 = "float";
     char   *pval3 = "1e-4";
     char   *pname3 = "delta";
     char   *pdef4 = " Number of samples to skip before starting adaptation";
     char   *ptype4 = "int";
     char   *pval4 = "0";
     char   *pname4 = "wait";
     char   *pdef5 = " Number of samples to adapt.Freeze after this number of iterations";
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
                fprintf(stderr,"pred: can't find filter specification file\n");
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
        if(   (orders = (int*)calloc(p,sizeof(int))) == NULL
           || (z = (float*)calloc(p,sizeof(float))) == NULL
           || (inpower = (float*)calloc(p,sizeof(float))) == NULL
           || (epower = (float*)calloc(q,sizeof(float))) == NULL
           || (Efi = (float*)calloc(p*p,sizeof(float))) == NULL
           || (Eb = (float*)calloc(p*p,sizeof(float))) == NULL) {
                fprintf(stderr,"pred: can't allocate space\n");
                return(6);
        }
        N = 0;
        for(j=0; j<p; j++) {
                if((fscanf(fp, "%d", &orders[j])) != 1) {
                        fprintf(stderr,"pred: problem in input file %s\n",
                                ifile_name);
                        return(7);
                }
                N += orders[j];
        }
        if(   (W = (float*)calloc(N*q,sizeof(float))) == NULL
           || (Z = (float*)calloc(N,sizeof(float))) == NULL
           || (F = (float*)calloc(p*N,sizeof(float))) == NULL
           || (B = (float*)calloc(p*N,sizeof(float))) == NULL
           || (C = (float*)calloc(N,sizeof(float))) == NULL
           || (Cp = (float*)calloc(N+p,sizeof(float))) == NULL) {
                fprintf(stderr,"pred: can't allocate space\n");
                return(6);
        }
        for(k=0; k<q; k++) {
                for(i=0; i<N; i++) {
                        if((fscanf(fp,"%f",&W[i*q+k])) != 1) {
                                fprintf(stderr,"pred: problem in input file %s\n",
                                        ifile_name);
                                return(7);
                        }
                }
        }
        fclose(fp);
        /* set up unit delay in error channels */
        for(k=0; k<q; k++)
                SET_DMIN_IN(k,1);
        gamma = 1.0;
        for (i=0; i<p; i++) {
                Efi[i*p+i] = 1./delta;
                Eb[i*p+i] = delta;
                inpower[i] = delta;
                for (j=0; j<i; j++) {
                        Efi[i*p+j] = Efi[j*p+i] = 0.0;
                        Eb[i*p+j] = Eb[j*p+i] = 0.0;
                }
        }


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
                        KrnOverflow("prftf",k);
                        return(99);
                }
                OUTF(k,0) = 0;
        }
        for(j=0; j<p; j++)
                IT_IN(q+j);
        return(0);
}

/*** Normal Operation ***/
/* input new data and create vector */
for(j=0; j<p; j++) {
        IT_IN(q+j);
        z[j] = INF(q+j,0);
        /* update input power state */
        inpower[j] *= .96;
        inpower[j] += .04 * z[j] *z[j];
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

/********* ftf predictor ********************************************/

/**** Joint Process ****/
for(k=0; k<q; k++) {
        /* e(n-1|n-2) is computed externally */
        /* find e(n-1|n-1) (14) */
        /* update W(n-2) -> W(n-1)  (15) */
        for(i=0; i<N; i++)
                W[i*q+k] += C[i] * error[k] * gamma;
}

/* calculate e sub f (n|n-1)  (1) */
/* calculate e sub f (n|n)  (2) */
for(j=0; j<p; j++) {
        sum = 0;
        for(i=0; i<N; i++)
                sum += F[i*p+j] * Z[i];
        efp[j] = z[j] - sum;
        ef[j] = efp[j] * gamma;
}

/* Update auxilliary vector a(n) (3a) */
for(j=0; j<p; j++) {
        sum = 0;
        for(i=0; i<p; i++) {
                sum += Efi[j*p+i] * efp[i];
        }
        a[j] = sum / lambda;
}
/* update gamma sub + (n)  (3b) */
sum = 0;
for(j=0; j<p; j++)
        sum += ef[j] * a[j];
gmp = gamma / (1.+ sum);
/* update epsilon sub f sup -1 (n) (4) */
for(j=0; j<p; j++) {
        Efi[j*p+j] /= lambda;
        temp[j] = gmp * a[j];
        Efi[j*p+j] -= temp[j] * a[j];
        for(i=0; i<j; i++) {
                Efi[i*p+j] /= lambda;
                Efi[i*p+j] -= temp[j] * a[i];
                Efi[j*p+i] = Efi[i*p+j];
        }
}
/* update C sub N+p sup f (n)  (5a) */
for(j=0; j<p; j++)
        Cp[j] = a[j];
for(i=0; i<N; i++) {
        sum = 0;
        for(j=0; j<p; j++)
                sum += F[i*p+j] * a[j];
        Cp[i+p] =  C[i] - sum;
}
/* form Cbp = Sb*Sf'*Cfp (re-arrange Cp)  (5b) */
index = p-1;
for(j=0; j<p-1; j++) {
        index += orders[j];
        temp[j] = Cp[index];
        Cp[index] = Cp[j+1];
}
for(i=1; i<N; i++)
        Cp[i] = Cp[i+p-1];
for(j=0; j<p-1; j++)
        Cp[N+j] = temp[j];
/* define c sub + sup b (n)  (5b) */
for(j=0; j<p; j++)
        cb[j] = Cp[N+j];
/* update F(n)  (6) */
for(i=0; i<N; i++) {
        for(j=0; j<p; j++)
                F[i*p+j] += C[i] * ef[j];
}
/* calculate e sub b (n|n-1) (7*) */
for(j=0; j<p; j++) {
        sum = 0;
        for(i=0; i<p; i++)
                sum += Eb[j*p+i] * cb[i];
        ebp[j] = lambda * sum;
}
/* update gamma (n)  (8) */
sum = 0;
for(j=0; j<p; j++)
        sum += ebp[j] * cb[j];
sum = 1. - sum * gmp;

if(sum < 0 ) {
        /* Rescue: restart algorithm kernel */
        fprintf(stderr,"predftf: rescue @%d\n",counter);
        gamma = 1.0;
        for (i=0; i<N; i++) {
                C[i] = 0;
                for(j=0; j<p; j++)
                        F[i*p+j] = B[i*p+j] = 0;
        }
        for (i=0; i<p; i++) {
                Efi[i*p+i] = 1./inpower[i];
                Eb[i*p+i] = inpower[i];
                for (j=0; j<i; j++) {
                        Efi[i*p+j] = Efi[j*p+i] = 0.0;
                        Eb[i*p+j] = Eb[j*p+i] = 0.0;
                }
        }
        goto resume;
}

gamma = gmp / sum;
/* calculate e sub b (n|n)  (9) */
for(j=0; j<p; j++)
        eb[j] = gamma * ebp[j];
/* update epsilon sub b (10) */
for(i=0; i<p; i++) {
        Eb[i*p+i] *= lambda;
        Eb[i*p+i] += ebp[i] * eb[i];
        for(j=0; j<i; j++) {
                Eb[i*p+j] *= lambda;
                Eb[i*p+j] += ebp[i] * eb[j];
                Eb[j*p+i] = Eb[i*p+j];
        }
}
/* update C sub N   (11) */
for (i=0; i<N; i++) {
        sum = 0;
        for(j=0; j<p; j++)
                sum += B[i*p+j] * cb[j];
        C[i] = Cp[i] + sum;
}
/* update B sub N  (12) */
for(i=0; i<N; i++)
        for(j=0; j<p; j++)
                B[i*p+j] += C[i] * eb[j];

/********************************************************************/
resume:

/* create z sub N (n) by shifting z sub N (n-1) */
for(i=N-1; i>0; i--)
        Z[i] = Z[i-1];
index = 0;
for(j=0; j<p; j++) {
        Z[index] = z[j];
        index += orders[j];
}

for(k=0; k<q; k++) {
        /* compute estimate with old filter */
        estimate = 0;
        for(i=0; i<N; i++)
                estimate += W[i*q+k] * Z[i];

        /* output estimate and wait for error */
        if(IT_OUT(k) ) {
                        KrnOverflow("prftf",k);
                        return(99);
        }
        OUTF(k,0) = estimate;
}

counter++;
if(adapt > 0) adapt--;

}
return(0);



break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

for(j=0; j<p; j++)
        fprintf(stderr,"predftf: input power(%d) = %#g\n",j,inpower[j]);
for(k=0; k<q; k++) {
        if(epower[k] <= 0) epower[k] = 1e-30;
        fprintf(stderr,"predftf: pred error power(%d) = %#g = %#.3g dB\n",
               k,epower[k],10*log10(epower[k]));
}
if((fp = fopen(ofile_name, "w")) == NULL) {
        fprintf(stderr,"pred: can't open output file\n");
        return(1);
}
fprintf(fp, "%d\n", q);
fprintf(fp, "%d\n", p);
for(j=0; j<p; j++)
        fprintf(fp, "%d \t", orders[j]);
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
free(inpower);free(epower);
free(orders);free(z);free(Z);
free(F);free(B);free(C);free(W);
free(Cp);free(Efi);free(Eb);


break;
}
return(0);
}
