 
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

This star implements a fixed point normalized lattice filter. 

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>


 

#define FLOAT_BUFFER 0
#define INTEGER_BUFFER 1


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int*  __k;
      int*  __c;
      int*  __nu;
      int*  __xb;
      int  __n;
      int  __numberInputBuffers;
      int  __numberOutputBuffers;
      float  __wsc;
      float  __wnorm;
      float  __fs;
      int  __bitPrec;
      int  __quant;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define k (state_P->__k)
#define c (state_P->__c)
#define nu (state_P->__nu)
#define xb (state_P->__xb)
#define n (state_P->__n)
#define numberInputBuffers (state_P->__numberInputBuffers)
#define numberOutputBuffers (state_P->__numberOutputBuffers)
#define wsc (state_P->__wsc)
#define wnorm (state_P->__wnorm)
#define fs (state_P->__fs)
#define bitPrec (state_P->__bitPrec)
#define quant (state_P->__quant)

/*         
 *    PARAMETER DEFINES 
 */ 
#define file_name (param_P[0]->value.s)
#define regBits (param_P[1]->value.d)
#define quantBits (param_P[2]->value.d)
#define quantRange (param_P[3]->value.d)
#define bufferType (param_P[4]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

fxnl 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int buffer_no;
        float xf,tmp;
	int	xq;
	int	sum,ysum;
	float	val;
	int	xfq,yq;
        int n1,n2,i,j,m;
	int	noSamples;
	FILE* fp;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "File with normalized lattice filter parameters";
     char   *ptype0 = "file";
     char   *pval0 = "tmp.lat";
     char   *pname0 = "file_name";
     char   *pdef1 = "Fixed point precision for coefficients, bits";
     char   *ptype1 = "int";
     char   *pval1 = "16";
     char   *pname1 = "regBits";
     char   *pdef2 = "Input/output quantization bits";
     char   *ptype2 = "int";
     char   *pval2 = "16";
     char   *pname2 = "quantBits";
     char   *pdef3 = "Input/output Range e.g. +- 5 volts";
     char   *ptype3 = "int";
     char   *pval3 = "10.0";
     char   *pname3 = "quantRange";
     char   *pdef4 = "0=Float Buffers,1=Integer Buffer";
     char   *ptype4 = "int";
     char   *pval4 = "0";
     char   *pname4 = "bufferType";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);
KrnModelParam(indexModel88,3 ,pdef3,ptype3,pval3,pname3);
KrnModelParam(indexModel88,4 ,pdef4,ptype4,pval4,pname4);

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

 

if((numberInputBuffers = NO_INPUT_BUFFERS()) <= 0) {
        fprintf(stderr,"fxn1: no inputs connected\n");
        return(1);
}
if(numberInputBuffers > 1) {
        fprintf(stderr,"fxnl: only one  input allowed \n");
        return(2);
}
if((numberOutputBuffers = NO_OUTPUT_BUFFERS()) > numberInputBuffers) {
        fprintf(stderr,"fxnl: too many outputs connected\n");
        return(3);
}
if(numberOutputBuffers == 0) {
        fprintf(stderr,"fxnl: no output connected\n");
        return(4);
}
if(strcmp(file_name,"stdin") == 0)
			fp = stdin;
else if((fp = fopen(file_name,"r")) == NULL) {
		fprintf(stderr,"fxnl():can't open file \n");
		return(1); /* nl() file cannot be opened */
}
/*****************************************************
   read lattice filter parameters from file
****************************************************/
fscanf(fp,"%d",&n);
n1=n+1;
/*   allocate work space      */
if(((k=(int*)calloc(n,sizeof(int))) == NULL) ||
		((c=(int*)calloc(n,sizeof(int))) == NULL) ||
		((nu=(int*)calloc(n1,sizeof(int))) == NULL) ||
		((xb=(int*)calloc(n1,sizeof(int))) == NULL )) {
		fprintf(stderr,"fxnl(): can't allocate work space \n");
		return(1);
}
bitPrec=1;
bitPrec = bitPrec<< regBits;
quant=1;
quant = quant<< quantBits;
for (i=0; i<n; i++) {
		/*
		 * Read k parameters
		 */
    	     	fscanf(fp,"%f ",&val);
		k[i]=val*bitPrec;
    	     	tmp=val*val;
    	     	tmp=1.0-tmp;
	     	val=sqrt(tmp);
		c[i]=val*bitPrec;
}
n1=n+1;
for (i=0; i<n1; i++) {
                   fscanf(fp,"%f ",&val);
		   nu[i]=val*bitPrec;
}
fscanf(fp,"%f",&wsc);
fscanf(fp,"%f",&fs);
fscanf(fp,"%f",&wnorm);
/*    
 * initial conditions   
 */
for (i=0; i<n1; i++) xb[i]=0.0; 
fclose(fp);
switch (bufferType) {
	case FLOAT_BUFFER:
		SET_CELL_SIZE_IN(0,sizeof(float));
		SET_CELL_SIZE_OUT(0,sizeof(float));
		break;
	case INTEGER_BUFFER:
		SET_CELL_SIZE_IN(0,sizeof(int));
		SET_CELL_SIZE_OUT(0,sizeof(int));
		break;
}


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


     for(noSamples=MIN_AVAIL();noSamples >0; --noSamples) {
     	  IT_IN(0);
	switch (bufferType) {
		case FLOAT_BUFFER:
			/*
			 * input floating point sample and quantize
			 */
			xf=INF(0,0);
	  		xfq = (int) xf*quant/(2.0 * quantRange);
			break;
		case INTEGER_BUFFER:
			xq=INI(0,0);
			break;
	}
             

        for (m=0; m<n; m++) {
             i=n-m;
             xb[i]=xb[i-1]*c[i-1]+k[i-1]*xfq;
	     xb[i] = xb[i] >> regBits;
             xfq=xfq*c[i-1]-k[i-1]*xb[i-1];    
	     xfq = xfq >> regBits;
        }
        xb[0]=xfq;
        sum=0;
        for (m=0; m<n+1; m++)  sum=sum+xb[m]*nu[m];
        ysum=sum >> regBits;
     	  if(IT_OUT(0)) {
		KrnOverflow("fxnl",0);
		return(99);
	  }
	switch (bufferType) {
		case FLOAT_BUFFER:
			/*
			 * convert to float and output floating point sample
			 */
          		OUTF(0,0)=ysum*wsc/wnorm*quantRange*2.0/quant;
			break;
		case INTEGER_BUFFER:
          		OUTI(0,0)=(int) ysum*wsc/wnorm;
			break;
	}
             

     }



break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

	free(k);
	free(nu);
	free(c);
	free(xb);


break;
}
return(0);
}
