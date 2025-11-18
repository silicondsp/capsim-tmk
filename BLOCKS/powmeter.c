 
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

This block is an averaging logarithmic power meter, which can be connected either in-line or terminating.

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
      FILE*  __fp;
      int  __count;
      int  __ibufs;
      int  __obufs;
      float  __sumxsq;
      float  __sumysq;
      int  __stdflag;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define fp (state_P->__fp)
#define count (state_P->__count)
#define ibufs (state_P->__ibufs)
#define obufs (state_P->__obufs)
#define sumxsq (state_P->__sumxsq)
#define sumysq (state_P->__sumysq)
#define stdflag (state_P->__stdflag)

/*         
 *    PARAMETER DEFINES 
 */ 
#define powfile_name (param_P[0]->value.s)
#define N (param_P[1]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

powmeter 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int i,j;
	float xval;
	float yval;
	float power;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "";
     char   *ptype0 = "file";
     char   *pval0 = "powfile";
     char   *pname0 = "powfile_name";
     char   *pdef1 = "";
     char   *ptype1 = "int";
     char   *pval1 = "1";
     char   *pname1 = "N";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);

      }
break;
   


/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            count=0;
       sumxsq=0.;
       sumysq=0.;
       stdflag=0;

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

	if( (ibufs = NO_INPUT_BUFFERS()) < 1 || ibufs > 2) {
		fprintf(stderr,"powmeter: input buffer count\n");
		return(1);
	}
	if( (obufs = NO_OUTPUT_BUFFERS()) > 1) {
		fprintf(stderr,"powmeter: output buffer count\n");
		return(2);
	}
	if(N < 1) {
		fprintf(stderr,"powmeter: improper parameter N\n");
		return(3);
	}
	if(strncmp(powfile_name,"std",3) == 0) {
		fp = stdout;
		stdflag = 1;
	}
	else if( (fp = fopen(powfile_name, "w")) == NULL ) {
		fprintf(stderr,"powmeter: can't open output file\n");
		return(4);
	}


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


	for(i=MIN_AVAIL();i>0; --i) {
		IT_IN(0);
		xval = INF(0,0);
		sumxsq += xval * xval;
		if(ibufs == 2) {
			IT_IN(1);
			yval = INF(1,0);
			sumysq += yval * yval;
		}
		else sumysq = N;
		if(++count == N) {
			count = 0;
			if(sumxsq <= 0) sumxsq = 1e-12;
			if(sumysq <= 0) sumysq = 1e-12;
			power = 10.*log10(sumxsq/sumysq);
			fprintf(fp,"%#.3g\n",power);
			sumxsq = sumysq = 0;
		}
		/* optional output */
		if(obufs) {
			if(IT_OUT(0)) {
				KrnOverflow("powmeter",0);
				return(99);
			}
			OUTF(0,0) = xval;
		}
	}
	return(0);


break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

	if(!stdflag) fclose(fp);


break;
}
return(0);
}
