 
#ifdef LICENSE

/*  Capsim (r) Text Mode Kernel (TMK) Block Library (Blocks)
    Copyright (C) 1989-2018  Silicon DSP  Corporation 

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
 */

#endif
 
#ifdef SHORT_DESCRIPTION

Stores vector in a file.

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>





#include "buffer_types.h"




/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      FILE*  __fp;
      int  __ibufs;
      int  __obufs;
      int  __displayFlag;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define fp (state_P->__fp)
#define ibufs (state_P->__ibufs)
#define obufs (state_P->__obufs)
#define displayFlag (state_P->__displayFlag)

/*         
 *    PARAMETER DEFINES 
 */ 
#define file_name (param_P[0]->value.s)
#define display (param_P[1]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

prvec 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int i,j,k;
	doubleVector_t  theVector ;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Name of output file";
     char   *ptype0 = "file";
     char   *pval0 = "stdout";
     char   *pname0 = "file_name";
     char   *pdef1 = "Display Block Name";
     char   *ptype1 = "int";
     char   *pval1 = "0";
     char   *pname1 = "display";
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
            displayFlag=0;

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

	if((ibufs = NO_INPUT_BUFFERS()) <= 0) {
		fprintf(stdout,"prvec: no input buffers\n");
		return(1);
	}
	if((obufs = NO_OUTPUT_BUFFERS()) > ibufs) {
		fprintf(stdout,"prvec: more output than input buffers\n");
		return(2);
	}
	if(strcmp(file_name,"stdout") == 0) {
		fp = stdout;
		 
	}
	else if(strcmp(file_name,"stderr") == 0) {
		fp = stderr;
		 
	}
	else if((fp = fopen(file_name,"w")) == NULL) {
		fprintf(stdout,"prvec: can't open output file '%s'\n",
			file_name);
		return(3);
	}
	 
	for(k=0; k< ibufs; k++)
	     SET_CELL_SIZE_IN(k,sizeof(doubleVector_t));
	     
	for(k=0; k< obufs; k++)
	     SET_CELL_SIZE_OUT(k,sizeof(doubleVector_t));	     
	     

break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 

       if(  MIN_AVAIL() > 0) {
                if(display) {  
                     fprintf(fp,"\n");
                
                     fprintf(fp,"Output From prvec '%s'\n",block_P->name);
                
                    // for(j=0; j<ibufs; ++j)
                    //       fprintf(fp,"%-10s  ", SNAME(j));
                     fprintf(fp,"\n");
                }
	    }
        /* This mode synchronizes all input buffers */
        for(i = MIN_AVAIL(); i>0; i--) {
                for(j=0; j<ibufs; ++j) {
                        IT_IN(j);
                        if(j < obufs) {
                                if(IT_OUT(j)) {
					                 KrnOverflow("prvec",j);
					                 return(99);
				                }
				        }
				        //fprintf(fp,"Getting Vector\n");
				        
				        
                     //   OUTVEC(j,0) = INVEC(j,0);
                         
                        theVector=INVEC(j,0);
                        
                       // fprintf(fp,"Got Vector\n");
                        
                        
                        for(k=0; k< theVector.length; k++) {
                            fprintf(fp,"%-10g  ",theVector.vector_P[k]);
                        //      fprintf(fp,"Got Vector k=%d",k);
                        }
                        
                        fprintf(fp,"\n");
                        if(obufs>0 && j < obufs) {
                        
                               if(IT_OUT(j)) {
					                KrnOverflow("prvec",j);
					                return(99);
				               }
				               OUTVEC(j,0) = INVEC(j,0);
				        }
			 
                }
        }
	
	/* This mode empties all input buffers */
	for(j=0; j<ibufs; ++j) {
		if(j < obufs) {
			while(IT_IN(j)) {
				if(IT_OUT(j)) {
					KrnOverflow("prvec",j);
					return(99);
				}
				OUTVEC(j,0) = INVEC(j,0);
			}
		}
		else
			while(IT_IN(j));
	}
return(0);



break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

	if(fp != stdout && fp != stderr)
		fclose(fp);


break;
}
return(0);
}
