 
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

Star implements cascade form IIR digital filter.

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
      float  __ycas_A[20];
      float  __xs_A[3];
      float  __ys_A[3];
      float  __poleSec1_A[35];
      float  __poleSec2_A[35];
      float  __zeroSec_A[35];
      float  __zeroSec2_A[35];
      float  __fs;
      float  __wnorm;
      int  __ns;
      int  __n;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define ycas_A (state_P->__ycas_A)
#define xs_A (state_P->__xs_A)
#define ys_A (state_P->__ys_A)
#define poleSec1_A (state_P->__poleSec1_A)
#define poleSec2_A (state_P->__poleSec2_A)
#define zeroSec_A (state_P->__zeroSec_A)
#define zeroSec2_A (state_P->__zeroSec2_A)
#define fs (state_P->__fs)
#define wnorm (state_P->__wnorm)
#define ns (state_P->__ns)
#define n (state_P->__n)

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
 int  

casfil 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

   	int i,j,jj,jt;
        FILE *ird_F;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "File with cascade filter parameters";
     char   *ptype0 = "file";
     char   *pval0 = "tmp.cas";
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
		fprintf(stderr,"Casfil: File could not be opened  \n");
		return(4);
	}
	/*
	 * Read in the filter coefficients and filter parameters.
	 *
	 */
         fscanf(ird_F,"%d",&ns);
      	 for (i=0; i<ns; i++) 
             {
              fscanf(ird_F,"%f %f",&zeroSec_A[i],&zeroSec2_A[i]); 
	     }
      	 for (i=0; i<ns; i++) 
             {
              fscanf(ird_F,"%f %f",&poleSec1_A[i],&poleSec2_A[i]); 
	     }
         fscanf(ird_F,"%f",&fs);  
         fscanf(ird_F,"%f",&wnorm); 
	 for (i=0; i<3; i++)
         {
              xs_A[i] = 0.0;
              ys_A[i] = 0.0;
         }
         for (i=0; i<20; i++){ ycas_A[i]=0.0;}   
              n = 0;


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


        while (IT_IN(0))
        {
               for (j=0; j< ns; j++){
                    if (j==0){
                              xs_A[1]=0.0;
                              xs_A[2]=0.0;
                              xs_A[0]=x(0);
                              if (n>0) xs_A[1]=x(1);
                              if (n>1) xs_A[2]=x(2);
                    }
                    if (j>0) { 
                             for (jj=0; jj<3; jj++)
                                           xs_A[jj] = ys_A[jj];
                    }

                    jt = j*3;
                    for (jj=0; jj<2; jj++)  
                        ys_A[jj+1] = ycas_A[jt+jj];

                    ys_A[0]=xs_A[0]+(zeroSec_A[j]*xs_A[1])+(zeroSec2_A[j]*xs_A[2])-(poleSec1_A[j]*ys_A[1])-(poleSec2_A[j]*ys_A[2]);

                    for (jj=0; jj<2; jj++)   
                          ycas_A[jt+jj] = ys_A[jj];
               }

               if(IT_OUT(0)) {
			               KrnOverflow("casfil",0);
			               return(99);
	           }
               y(0) = ys_A[0]/wnorm;
               n = n+1;
        }

        return(0);


break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 



break;
}
return(0);
}
