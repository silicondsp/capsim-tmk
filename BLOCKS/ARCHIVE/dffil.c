 
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

Star implements direct form IIR digital filter.

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
      float*  __b_A;
      float*  __x_A;
      int  __m;
      int  __n;
      float  __fs;
      float  __wnorm;
      int  __nt;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define b_A (state_P->__b_A)
#define x_A (state_P->__x_A)
#define m (state_P->__m)
#define n (state_P->__n)
#define fs (state_P->__fs)
#define wnorm (state_P->__wnorm)
#define nt (state_P->__nt)

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
#define filename (param_P[0]->value.s)
/*-------------- BLOCK CODE ---------------*/


dffil 

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
 

	float 	temp1,temp2;
	double 	sum;
	int 	i,j,np1;
	float 	x1,yr;
        FILE *ird_F;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "File with direct form  filter parameters";
     char   *ptype0 = "file";
     char   *pval0 = "tmp.df";
     char   *pname0 = "filename";
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

 

	/*
	 * open file containing filter coefficients. Check 
	 * to see if it exists.
	 *
	 */
        if( (ird_F = fopen(filename,"r")) == NULL) {
		fprintf(stderr,"dffil: File could not be opened  \n");
		return(4);
	}
	/*
	 * Read in the filter coefficients and filter parameters.
	 *
	 */
         fscanf(ird_F,"%d %d",&m,&n);
	 nt=m+n;
	 b_A = (float *)malloc((nt+5)*sizeof(float));
	 if(b_A == NULL) {
		fprintf(stderr,"dffil: could not allocate space \n");
		return(5);
	 } 
	 x_A = (float *)malloc((nt+5)*sizeof(float));
	 if(x_A == NULL) {
		fprintf(stderr,"dffil: could not allocate space \n");
		return(6);
	 } 
	 for(i=0; i<nt-1; i++)
		fscanf(ird_F,"%e",&b_A[i]);
for(i=0; i<nt; i++)
	fprintf(stderr,"%e \n",b_A[i]);
         fscanf(ird_F,"%f",&fs);  
         fscanf(ird_F,"%f",&wnorm); 
	 fclose(ird_F);
	/*   ***                                                     ***
	 *   *** initialize input vector x and coefficient vector b  ***
	 *   ***                                                     ***
	 */
	for(i=0; i<nt-1; i++) 
        	x_A[i]=0.0;


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 

while (IT_IN(0)) {
	x1 = x(0);
	/*   ***                                                     ***
	 *   ***  the following loop calculates the filter  response  ***
	 *   ***                                                     ***
	 */
fprintf(stderr,"yr= %e x1= %e\n",yr,x1);
        yr= - y(1);
    
	/*   ***                                                     ***
	 *   ***  shift    the new value of x(0) into the vector x    ***
	 *   ***                                                     ***
	 */
        temp2=x1;
	for(i=0; i< m; i++) {
        	temp1=x_A[i];
        	x_A[i]=temp2;
        	temp2=temp1;
	}
	/*   ***                                                     ***
	 *   ***  shift -y into vector x                              ***
	 *   ***                                                     ***
	 */
	if ( n != 0) { 
        	temp2=yr;
		for(i=m; i<nt-1; i++) { 
        		temp1=x_A[i];
        		x_A[i]=temp2;
        		temp2=temp1;
		}
	}
	/*   ***                                                     ***
	 *   *** calculate  value of y.                              ***
	 *   *** yest= x(transpose)*b                                ***
	 *   ***                                                     ***
	 */
        sum=0.0;
	for(i=0; i<nt-1; i++) 
		sum=sum+x_A[i]*b_A[i];
        if(IT_OUT(0)) {
		KrnOverflow("dffil",0);
		return(99);
	}
        y(0) = sum/(double)wnorm;
}

        return(0);


break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

	free(b_A);
	free(x_A);


break;
}
return(0);
}
