 
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

Plot probe.

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>


 

#define BLOCK_SIZE 1024
#define MAX_NUMBER_OF_PLOTS 10
#define STATIC 0
#define DYNAMIC 1


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int  __ibufs;
      int  __obufs;
      float*  __xpts;
      float*  __ypts[MAX_NUMBER_OF_PLOTS];
      char*  __legends[100];
      int  __count;
      int  __totalCount;
      int  __displayed;
      float  __dt;
      int  __blockOff;
      int  __bufi;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define ibufs (state_P->__ibufs)
#define obufs (state_P->__obufs)
#define xpts (state_P->__xpts)
#define ypts (state_P->__ypts)
#define legends (state_P->__legends)
#define count (state_P->__count)
#define totalCount (state_P->__totalCount)
#define displayed (state_P->__displayed)
#define dt (state_P->__dt)
#define blockOff (state_P->__blockOff)
#define bufi (state_P->__bufi)

/*         
 *    PARAMETER DEFINES 
 */ 
#define npts (param_P[0]->value.d)
#define skip (param_P[1]->value.d)
#define title (param_P[2]->value.s)
#define x_axis (param_P[3]->value.s)
#define y_axis (param_P[4]->value.s)
#define plotStyleParam (param_P[5]->value.d)
#define control (param_P[6]->value.d)
#define mode (param_P[7]->value.d)
#define samplingRate (param_P[8]->value.d)
/*-------------- BLOCK CODE ---------------*/
plottxt(run_state,block_P)

	int run_state;
	block_Pt block_P;
{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	int samples;
    	int i,j,k,ii;
	int	operState;
	char curveTitle[80];
	char curveSubTitle[80];
	char	fname[100];
	FILE *time_F;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Number of points in each plot (dynamic window size)";
     char   *ptype0 = "int";
     char   *pval0 = "128";
     char   *pname0 = "npts";
     char   *pdef1 = "Points to skip before first plot";
     char   *ptype1 = "int";
     char   *pval1 = "0";
     char   *pname1 = "skip";
     char   *pdef2 = "Plot title";
     char   *ptype2 = "file";
     char   *pval2 = "plot";
     char   *pname2 = "title";
     char   *pdef3 = "X Axis label";
     char   *ptype3 = "file";
     char   *pval3 = "Samples";
     char   *pname3 = "x_axis";
     char   *pdef4 = "Y-Axis label";
     char   *ptype4 = "file";
     char   *pval4 = "Y";
     char   *pname4 = "y_axis";
     char   *pdef5 = "Plot Style: 1=Line,2=Points,5=Bar Chart";
     char   *ptype5 = "int";
     char   *pval5 = "1";
     char   *pname5 = "plotStyleParam";
     char   *pdef6 = "Control: 1=On, 0=Off";
     char   *ptype6 = "int";
     char   *pval6 = "1";
     char   *pname6 = "control";
     char   *pdef7 = "0=Static,1=Dynamic";
     char   *ptype7 = "int";
     char   *pval7 = "0";
     char   *pname7 = "mode";
     char   *pdef8 = "Sampling Rate";
     char   *ptype8 = "int";
     char   *pval8 = "1";
     char   *pname8 = "samplingRate";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);
KrnModelParam(indexModel88,3 ,pdef3,ptype3,pval3,pname3);
KrnModelParam(indexModel88,4 ,pdef4,ptype4,pval4,pname4);
KrnModelParam(indexModel88,5 ,pdef5,ptype5,pval5,pname5);
KrnModelParam(indexModel88,6 ,pdef6,ptype6,pval6,pname6);
KrnModelParam(indexModel88,7 ,pdef7,ptype7,pval7,pname7);
KrnModelParam(indexModel88,8 ,pdef8,ptype8,pval8,pname8);

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
       displayed=FALSE;
       blockOff=0;
       bufi=0;

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

/* 
 * store as state the number of input/output buffers 
 */
if((ibufs = NO_INPUT_BUFFERS()) <= 0) {
	fprintf(stderr,"plot: no inputs connected\n");
	return(2);
}
if((obufs = NO_OUTPUT_BUFFERS()) > ibufs) {
	fprintf(stderr,"plot: too many outputs connected\n");
	return(3);
}
if(ibufs > MAX_NUMBER_OF_PLOTS) {
	fprintf(stderr,"plot: too many plots requested.  \n");
	return(4);
}
if(control && mode == DYNAMIC) {
	/*
	 * allocate arrays
	 */
	xpts = (float* )calloc(npts,sizeof(float));
	if(xpts==NULL) {
		fprintf(stderr,"Could not allocate space in plot \n");
		return(5);
	}
	for(i=0; i<ibufs; i++) {
	    ypts[i] = (float* )calloc(npts,sizeof(float));
	    if(ypts[i]==NULL) {
		fprintf(stderr,"Could not allocate space in plot \n");
		return(6);
	    }
	}
} else if(control && mode == STATIC) {
	/*
	 * allocate arrays
	 */
	xpts = (float* )calloc(BLOCK_SIZE,sizeof(float));
	if(xpts==NULL) {
		fprintf(stderr,"Could not allocate space in plot \n");
		return(5);
	}
	for(i=0; i<ibufs; i++) {
	    ypts[i] = (float* )calloc(BLOCK_SIZE,sizeof(float));
	    if(ypts[i]==NULL) {
		fprintf(stderr,"Could not allocate space in plot \n");
		return(6);
	    }
	}
 }
/* 
 * set up the legend first 
 */
for(i=0; i<ibufs; i++) 
	legends[i] = SNAME(i);
legends[ibufs] = NULL;
count = 0;
totalCount = 0;
dt=1.0/samplingRate;


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


for(samples = MIN_AVAIL(); samples > 0; --samples) {

    


    for(i=0; i<ibufs; ++i) {
	   		IT_IN(i);
			if(obufs > i) {
				if(IT_OUT(i)) {
					KrnOverflow("plot",i);
					return(99);
				}
	 			OUTF(i,0) = INF(i,0);
			}
    }
    if(++totalCount > skip && control ) {
	if(mode == STATIC)
		count=blockOff + bufi;
	bufi++;

	if (bufi == BLOCK_SIZE && mode==STATIC) {
		blockOff += BLOCK_SIZE;
		xpts = (float *)realloc((char *) xpts,
			sizeof(float) * (blockOff + BLOCK_SIZE));
	        if(xpts==NULL) {
		         fprintf(stderr,"Could not allocate space in plot \n");
		         return(7);
	        }
		for(i=0; i<ibufs; i++) {
	    	     ypts[i] = (float* )realloc((char*)ypts[i],
				(blockOff+BLOCK_SIZE)*sizeof(float));
	             if(ypts[i]==NULL) {
		         fprintf(stderr,"Could not allocate space in plot \n");
		         return(8);
	             }
		}	
		bufi=0;

	}

	

	for(i=0; i<ibufs; ++i) 
       			ypts[i][count] = INF(i,0);


	xpts[count] = count*dt;
	if(mode == DYNAMIC) count++;
    }
}

return(0);



break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

if(control == 0) return(0);
if((totalCount - skip) > 0 ) {
   {
        	strcpy(fname,title);
       	 	strcat(fname,".tim");
        	time_F = fopen(fname,"w");
			for(k=0; k<ibufs; ++k) 
			   for(i=0; i<count; i++)
                	fprintf(time_F,"%e %e\n",xpts[i],ypts[k][i]);
		fclose(time_F);
		fprintf(stderr,"plot created file: %s \n",fname);
		free(xpts);
//		free(ypts);
	}
}


break;
}
return(0);
}
