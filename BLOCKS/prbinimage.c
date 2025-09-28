 
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

Inputs image and stores as binary to file.

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 

#include <sys/file.h>
#include <limits.h>     /* definition of OPEN_MAX */


 

#define PMODE 0644


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int  __fp;
      int  __ibufs;
      int  __obufs;
      int  __displayFlag;
      int  __numberColumnsPrinted;
      char*  __buff;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define fp (state_P->__fp)
#define ibufs (state_P->__ibufs)
#define obufs (state_P->__obufs)
#define displayFlag (state_P->__displayFlag)
#define numberColumnsPrinted (state_P->__numberColumnsPrinted)
#define buff (state_P->__buff)

/*         
 *    PARAMETER DEFINES 
 */ 
#define file_name (param_P[0]->value.s)
#define width (param_P[1]->value.d)
#define height (param_P[2]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  

prbinimage 

(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int i,j,k;
	unsigned short pixel;
	float	fpixel;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Name of output file";
     char   *ptype0 = "file";
     char   *pval0 = "output.img";
     char   *pname0 = "file_name";
     char   *pdef1 = "Image Width";
     char   *ptype1 = "int";
     char   *pval1 = "1";
     char   *pname1 = "width";
     char   *pdef2 = "Image Height";
     char   *ptype2 = "int";
     char   *pval2 = "1";
     char   *pname2 = "height";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);

      }
break;
   


/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            displayFlag=0;
       numberColumnsPrinted=0;

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

	if((ibufs = NO_INPUT_BUFFERS()) <= 0) {
		fprintf(stdout,"prbinimage: no input buffers\n");
		return(1);
	}
	if((obufs = NO_OUTPUT_BUFFERS()) > ibufs) {
		fprintf(stdout,"prbinimage: more output than input buffers\n");
		return(2);
	}
	if((fp = creat(file_name,PMODE)) == -1) {
		fprintf(stdout,"prbinimage: can't create output file '%s'\n",
			file_name);
		return(3);
	}
	fprintf(stderr,"prbinimage to produce %d x  %d image file\n",width,height);
        buff = (char *) calloc(width,sizeof(char));
        if(buff == NULL) {
                fprintf(stderr,"prbinimage: can't allocate space\n");
                return(4);
        }


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 

        /* This mode synchronizes all input buffers */
        for(i = MIN_AVAIL(); i>0; i--) {
                for(j=0; j<ibufs; ++j) {
                        IT_IN(j);
                        if(j < obufs) {
                                if(IT_OUT(j)) {
					KrnOverflow("prbinimage",j);
					return(99);
				}
                                OUTF(j,0) = INF(j,0);
                        }
			fpixel = INF(j,0);
			if(fpixel < 0 ) pixel = 0;
			   else if (fpixel > 255) pixel = 255;
			     else pixel = (unsigned short)fpixel;	
			buff[numberColumnsPrinted]= (char)pixel;
			numberColumnsPrinted++;
                	if(numberColumnsPrinted >= width) {
				write(fp,buff,width);
				numberColumnsPrinted = 0;
			}
                }
        }
	
	/* This mode empties all input buffers */
	for(j=0; j<ibufs; ++j) {
		if(j < obufs) {
			while(IT_IN(j)) {
				if(IT_OUT(j) ){
					KrnOverflow("prbinimage",j);
					return(99);
				}
				OUTF(j,0) = INF(j,0);
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

 

	free(buff);
	close(fp);


break;
}
return(0);
}
