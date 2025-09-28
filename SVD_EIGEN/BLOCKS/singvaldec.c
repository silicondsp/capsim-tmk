 
#ifdef LICENSE

/*  
    Capsim (r) Text Mode Kernel (TMK) 
    Copyright (C) 1989-2017  Silicon DSP  Corporation 

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

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 

#include <f2c.h>
#include <clapack.h>



/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define x(DELAY) (*((image_t  *)PIN(0,DELAY)))

/*         
 *    PARAMETER DEFINES 
 */ 
#define fileName (param_P[0]->value.s)
/*-------------- BLOCK CODE ---------------*/
singvaldec(run_state,block_P)

	int run_state;
	block_Pt block_P;
{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
/*
 *              Declarations 
 */
 

   	int i,j;
   	image_t img;
   	int fpixel;
   	integer M ;
    integer N ;
    integer LDA;
    integer LDU ;
    integer LDVT;
    integer LWORK;
    integer INFO;
	int workLength;
    double* aa_P;
    double* uu_P;
    double* vv_P;
    double* work_P;
    double* s_P;
    FILE*  fp;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "File to store results";
     char   *ptype0 = "file";
     char   *pval0 = "svd.dat";
     char   *pname0 = "fileName";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);

      }
break;
   


/*         
 *    INPUT BUFFER SYSTEM  INITS 
 */ 
 case INPUT_BUFFER_INIT:
 {
 int indexIC = block_P->model_index;
     char   *ptypeIn0 = "image_t";
     char   *pnameIn0 = "x";
KrnModelConnectionInput(indexIC,0 ,pnameIn0,ptypeIn0);
}
 break;

/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
         
   if(NO_INPUT_BUFFERS() != 1 ){
       fprintf(stdout,"%s:1 inputs expected; %d connected\n",
              STAR_NAME,NO_INPUT_BUFFERS());
	      return(200);
   }

   SET_CELL_SIZE_IN(0,sizeof(image_t));

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

  /*
   * set the input buffer cell size to size of image
   */	
  SET_CELL_SIZE_IN(0,sizeof(image_t));


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 




while(IT_IN(0)) {
       img=x(0);
   
   
       /*
        * allocate space for arrays
        */

       s_P=(double*)calloc(img.height,sizeof(double));
       
       aa_P=(double*)calloc(img.width*img.height,sizeof(double));
       uu_P=(double*)calloc(img.width*img.height,sizeof(double));
       vv_P=(double*)calloc(img.width*img.height,sizeof(double));
	   if(img.width*img.height*2 < 8000)
		     workLength=8000;
	   else
		    workLength = img.width*img.height*2;

       work_P=(double*)calloc(workLength,sizeof(double));

       if(!aa_P || !uu_P || !vv_P || !work_P || !s_P ) {
            fprintf(stderr,"singvaldec: Could not allocate space\n"); 
            return(3);
       
       }
       
       M = img.width;
       N=img.height;
       
      
    
       LDA = M;
       LDU = M;
       LDVT = N;

	   LWORK=workLength;

    
       for ( i= 0; i< img.height; i++ ) {
	      for(j= 0; j< img.width; j++) {
		     aa_P[j*img.width+i]=img.image_PP[i][j];
	      }
       }


       /*     Subroutine int dgesvd_(char *jobu, char *jobvt, integer *m, integer *n, 
        *  doublereal *a, integer *lda, doublereal *s, doublereal *u, integer *
        *  ldu, doublereal *vt, integer *ldvt, doublereal *work, integer *lwork, 
        *   integer *info)
        */

       dgesvd_( "A", "A", &M, &N, aa_P, &LDA, s_P, uu_P, 
          &LDU, vv_P, &LDVT, work_P, &LWORK, &INFO);



       printf("INFO=%d\n",INFO);
       for(i=0; i< img.height; i++) {
           printf("%d\t%f\n",i,s_P[i]);
       
       }


       /*
        * store results
        */
        
       fp=fopen(fileName,"w");
       if(!fp) {
            fprintf(stderr,"sigvaldec: could not open:%s to write\n",fileName);
            return(5);
       }


       fprintf(stderr,"Storing computed resulte in:%s\n",fileName); 


       for(i=0; i< img.height; i++) {
           fprintf(fp,"%d\t%f\n",i,s_P[i]);
       
       }
       
       fclose(fp);
       
       
       free(aa_P);
       free(uu_P);
       free(vv_P);
       free(work_P);
       free(s_P);
      
       

}
    


break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 



break;
}
return(0);
}
