 
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

Normalized Lattice Filter

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 


#include <string.h>



/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      FILE*  __fp;
      float*  __k;
      float*  __c;
      float*  __nu;
      float*  __xb;
      int  __n;
      float  __wsc;
      float  __wnorm;
      float  __fs;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define fp (state_P->__fp)
#define k (state_P->__k)
#define c (state_P->__c)
#define nu (state_P->__nu)
#define xb (state_P->__xb)
#define n (state_P->__n)
#define wsc (state_P->__wsc)
#define wnorm (state_P->__wnorm)
#define fs (state_P->__fs)

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
#define file_name (param_P[0]->value.s)
/*-------------- BLOCK CODE ---------------*/
 int  

nl 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int buffer_no;
        float xf,ysum,sum,tmp;
        int n1,n2,i,j,m;
	int	noSamples;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "File with normalized lattice filter parameters";
     char   *ptype0 = "file";
     char   *pval0 = "tmp.lat";
     char   *pname0 = "file_name";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);

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

 

		if(strcmp(file_name,"stdin") == 0)
			fp = stdin;
		else if((fp = fopen(file_name,"r")) == NULL)
			return(1); /* nl() file cannot be opened */
	     /*****************************************************
		   read lattice filter parameters from file
	      ****************************************************/
	     fscanf(fp,"%d",&n);
	     n1=n+1;
	     /*   allocate work space      */
	     if(((k=(float*)calloc(n,sizeof(float))) == NULL) ||
		((c=(float*)calloc(n,sizeof(float))) == NULL) ||
		((nu=(float*)calloc(n1,sizeof(float))) == NULL) ||
		((xb=(float*)calloc(n1,sizeof(float))) == NULL )) {
		fprintf(stderr,"nl(): can't allocate work space \n");
		return(1);
    	     }
 	     for (i=0; i<n; i++) {
    	     fscanf(fp,"%f ",&k[i]);
    	     tmp=k[i]*k[i];
    	     tmp=1.0-tmp;
	     c[i]=sqrt(tmp);
             }
             n1=n+1;
             for (i=0; i<n1; i++) {
                   fscanf(fp,"%f ",&nu[i]);
             }
             fscanf(fp,"%f",&wsc);
             fscanf(fp,"%f",&fs);
             fscanf(fp,"%f",&wnorm);
      	     /*    initial conditions   */
             for (i=0; i<n1; i++) xb[i]=0.0; 
             fclose(fp);


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


     for(noSamples=MIN_AVAIL();noSamples >0; --noSamples) {
     	  IT_IN(0);
	  xf=x(0);
          for (m=0; m<n; m++) {
             i=n-m;
             xb[i]=xb[i-1]*c[i-1]+k[i-1]*xf;
             xf=xf*c[i-1]-k[i-1]*xb[i-1];    
          }
          xb[0]=xf;
          sum=0.0;
          for (m=0; m<n+1; m++)  sum=sum+xb[m]*nu[m];
          ysum=sum;
	  if(IT_OUT(0)) {
		KrnOverflow("nl",0);
		return(99);
	  }
          y(0)=ysum*wsc/wnorm;
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
