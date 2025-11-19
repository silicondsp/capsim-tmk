 
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

This block calculates the statistics of the incoming signal.  The parameter is a filename for storage of the results.

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
#include <TCL/tcl.h>



/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      FILE*  __file_ptr;
      int  __obufs;
      int  __count;
      int  __totalCount;
      float  __sum_x;
      float  __sum_x2;
      float  __max;
      float  __min;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define file_ptr (state_P->__file_ptr)
#define obufs (state_P->__obufs)
#define count (state_P->__count)
#define totalCount (state_P->__totalCount)
#define sum_x (state_P->__sum_x)
#define sum_x2 (state_P->__sum_x2)
#define max (state_P->__max)
#define min (state_P->__min)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define x(DELAY) (*((float  *)PIN(0,DELAY)))

/*         
 *    PARAMETER DEFINES 
 */ 
#define skip (param_P[0]->value.d)
#define stat_file (param_P[1]->value.s)
/*-------------- BLOCK CODE ---------------*/
 int  

stats 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int i,j;
	float xSample;	/* current sample of input signal	*/
	float mu;	/* mean = sum_x/count			*/
	float var;	/* variance = (sum_x2/count - mu**2)	*/
	float sigma;	/* std dev  = square root of variance	*/
	double sqrt();
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
     char   *pdef0 = "Points to skip";
     char   *ptype0 = "int";
     char   *pval0 = "";
     char   *pname0 = "skip";
     char   *pdef1 = "File to store results";
     char   *ptype1 = "file";
     char   *pval1 = "stat.dat";
     char   *pname1 = "stat_file";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);

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
            count=0;
       totalCount=0;
       sum_x=0.0;
       sum_x2=0.0;
       max=-1e30;
       min=1e30;


         
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

 

	if( (obufs = NO_OUTPUT_BUFFERS()) > 1) {
		fprintf(stderr,"stats: only one output allowed\n");
		return(2);
	}


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


	/* note the minimum number of samples on the input 	*/
	/* buffers and iterate that many times 			*/
	for(i=MIN_AVAIL();i>0; --i) {
    	     IT_IN(0);
	     for(j=0; j<obufs; j++) {
			if(IT_OUT(j)) {
				KrnOverflow("stats",j);
				return(99);
			}
			OUTF(j,0) = x(0);
	     }
	     if(++totalCount > skip) {
		count++;
		xSample = x(0);
		if (xSample > max)
			max = xSample;
		if (xSample < min)
			min = xSample;

		sum_x += xSample;
		sum_x2 += xSample * xSample;
	     }
	}
	return(0);


break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

	mu = sum_x/count;
	var = (sum_x2/count) - (mu*mu);
	sigma = sqrt(var);
	fprintf(stderr,"samples   \t%d       \tmean    \t%g\n",count,mu);
	fprintf(stderr,"maximum   \t%g  \tminimum \t%g\n",max,min);
	fprintf(stderr,"variance  \t%g  \tsigma   \t%g\n",var,sigma);
	fprintf(stderr,"samples   \t%d       \tmean    \t%g\n",count,mu); 
	fprintf(stderr,"maximum   \t%g  \tminimum \t%g\n",max,min);
	fprintf(stderr,"variance  \t%g  \tsigma   \t%g\n",var,sigma);
	{
		if( (file_ptr = fopen(stat_file,"w")) == NULL) {
			fprintf(stderr,"stats: can't open results file %s \n",
				stat_file);
			return(3);
	}
	{
		fprintf(file_ptr,"samples   %d  mean      %e \n",count,mu);
		fprintf(file_ptr,"maximum   %e  minimum %e \n",max,min);
		fprintf(file_ptr,"variance  %e  sigma   %e \n",var,sigma);
	}
	
#ifdef TCL_SUPPORT
       if(!krn_TCL_Interp) {
          
	  return(0);
       }
       
       sprintf(theName,"%s_sigma",STAR_NAME);

	varNameObj_P=Tcl_NewStringObj(theName, strlen(theName));
	objVar_P=Tcl_NewObj();
	Tcl_SetDoubleObj(objVar_P,sigma);
	Tcl_ObjSetVar2(krn_TCL_Interp,varNameObj_P,NULL,objVar_P,TCL_NAMESPACE_ONLY);
        
       
       sprintf(theName,"%s_mean",STAR_NAME);
	varNameObj_P=Tcl_NewStringObj(theName, strlen(theName));
	objVar_P=Tcl_NewObj();
	Tcl_SetDoubleObj(objVar_P,mu);
	Tcl_ObjSetVar2(krn_TCL_Interp,varNameObj_P,NULL,objVar_P,TCL_NAMESPACE_ONLY);
       
       
       
        sprintf(theName,"%s_max",STAR_NAME);
	varNameObj_P=Tcl_NewStringObj(theName, strlen(theName));
	objVar_P=Tcl_NewObj();
	Tcl_SetDoubleObj(objVar_P,max);
	Tcl_ObjSetVar2(krn_TCL_Interp,varNameObj_P,NULL,objVar_P,TCL_NAMESPACE_ONLY);
        
      
       
       sprintf(theName,"%s_min",STAR_NAME);
	varNameObj_P=Tcl_NewStringObj(theName, strlen(theName));
	objVar_P=Tcl_NewObj();
	Tcl_SetDoubleObj(objVar_P,min);
	Tcl_ObjSetVar2(krn_TCL_Interp,varNameObj_P,NULL,objVar_P,TCL_NAMESPACE_ONLY);
 
     

       
       
       
       
       sprintf(theName,"%s_var",STAR_NAME);
	varNameObj_P=Tcl_NewStringObj(theName, strlen(theName));
	objVar_P=Tcl_NewObj();
	Tcl_SetDoubleObj(objVar_P,var);
	Tcl_ObjSetVar2(krn_TCL_Interp,varNameObj_P,NULL,objVar_P,TCL_NAMESPACE_ONLY);


       
              
#endif

}
fclose(file_ptr);


break;
}
return(0);
}
