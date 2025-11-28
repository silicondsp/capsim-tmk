 
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

This star compares two data streams for "equality" (use for BER). Appends to file.

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
#include <TCL/tcl.h>


 

#define GBAND 0.001	/* guard band for equality */


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int  __samples;
      int  __error_count;
      int  __hits;
      int  __obufs;
      FILE*  __fp;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define samples (state_P->__samples)
#define error_count (state_P->__error_count)
#define hits (state_P->__hits)
#define obufs (state_P->__obufs)
#define fp (state_P->__fp)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define w(DELAY) (*((float  *)PIN(0,DELAY)))
#define x(DELAY) (*((float  *)PIN(1,DELAY)))

/*         
 *    PARAMETER DEFINES 
 */ 
#define ignore (param_P[0]->value.d)
#define err_msg (param_P[1]->value.d)
#define fileName (param_P[2]->value.s)
/*-------------- BLOCK CODE ---------------*/
 int  ecountfap(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int i,j;
	int numin;
	int err_out;
	char theVar[100];
	char theName[100];
#ifdef TCL_SUPPORT
        Tcl_Obj *varNameObj_P;
        Tcl_Obj *objVar_P;
#endif	


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Number of samples to ignore for final error tally";
     char   *ptype0 = "int";
     char   *pval0 = "0";
     char   *pname0 = "ignore";
     char   *pdef1 = "Index after which each error is printed to terminal";
     char   *ptype1 = "int";
     char   *pval1 = "30000";
     char   *pname1 = "err_msg";
     char   *pdef2 = "File name to append results";
     char   *ptype2 = "file";
     char   *pval2 = "ecount.dat";
     char   *pname2 = "fileName";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);

      }
break;
   


/*         
 *    INPUT BUFFER SYSTEM  INITS 
 */ 
 case INPUT_BUFFER_INIT:
 {
 int indexIC = block_P->model_index;
     char   *ptypeIn0 = "float";
     char   *pnameIn0 = "w";
     char   *ptypeIn1 = "float";
     char   *pnameIn1 = "x";
KrnModelConnectionInput(indexIC,0 ,pnameIn0,ptypeIn0);
KrnModelConnectionInput(indexIC,1 ,pnameIn1,ptypeIn1);
}
 break;

/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            samples=0;
       error_count=0;
       hits=0;


         
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

 

        fp=fopen(fileName,"a");
       if(!fp) {
          fprintf(stderr, "ecountfap: could not open file : %s for append\n",fileName);
          return(2);
       }
	obufs = NO_OUTPUT_BUFFERS();


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


	numin = MIN_AVAIL();
	for(i=0; i<numin; i++) {
		IT_IN(0);
		IT_IN(1);
		err_out = 0;
		if(w(0) > x(0) + GBAND || w(0) < x(0) - GBAND ) {
			hits++;
			if(samples >= ignore) {
				err_out = 1.;
				error_count++;
				if(samples >= err_msg)
	fprintf(stderr, "ecount: symbol error @%d\n",samples);

			}
			else {
				if(samples >= err_msg)
	fprintf(stderr, "ecount: symbol error @%d  (ignore)\n",samples);
			}
		}
		samples++;

		for(j=0; j<obufs; j++) {
			if(IT_OUT(j)) {
				KrnOverflow("ecount",j);
				return(99);
			}
			OUTF(j,0) = err_out;
		}
	}


break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

	fprintf(stderr,"ecount: hits/samples = %d/%d  (ignore %d)  BER = %d/%d = %.4g\n",
		hits, samples, samples>ignore? ignore:samples,
		error_count, samples>ignore? samples-ignore:0,
		samples>ignore? (float)error_count/(samples-ignore):0);
	fprintf(fp,"%d  %d   %d  %d %d  %.4g \n",
		hits, samples, samples>ignore? ignore:samples,
		error_count, samples>ignore? samples-ignore:0,
		samples>ignore? (float)error_count/(samples-ignore):0);
       fclose(fp);
       
#ifdef TCL_SUPPORT
       if(!krn_TCL_Interp) {
          
	  return(0);
       }
       sprintf(theVar,"%.4g",samples>ignore? (float)error_count/(samples-ignore):0);
       sprintf(theName,"%s_ber",STAR_NAME);
       
	
	varNameObj_P=Tcl_NewStringObj(theName, strlen(theName));
	objVar_P=Tcl_NewObj();
		   
	Tcl_SetDoubleObj(objVar_P,samples>ignore? (float)error_count/(samples-ignore):0);
	Tcl_ObjSetVar2(krn_TCL_Interp,varNameObj_P,NULL,objVar_P,TCL_NAMESPACE_ONLY);
       
       
#endif       
  


break;
}
return(0);
}
