 
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

Scatter Probe

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>


 

#define BLOCK_SIZE 1024
#define STATIC 0
#define DYNAMIC 1
#define FLOAT_BUFFER 0
#define COMPLEX_BUFFER 1
#define INTEGER_BUFFER 2


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int  __numberInputBuffers;
      int  __numberOutputBuffers;
      float*  __xx_P;
      float*  __yy_P;
      int  __count;
      int  __totalCount;
      int  __displayed;
      int  __blockOff;
      int  __bufi;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define numberInputBuffers (state_P->__numberInputBuffers)
#define numberOutputBuffers (state_P->__numberOutputBuffers)
#define xx_P (state_P->__xx_P)
#define yy_P (state_P->__yy_P)
#define count (state_P->__count)
#define totalCount (state_P->__totalCount)
#define displayed (state_P->__displayed)
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
#define fixed (param_P[6]->value.d)
#define minx (param_P[7]->value.f)
#define maxx (param_P[8]->value.f)
#define miny (param_P[9]->value.f)
#define maxy (param_P[10]->value.f)
#define markerType (param_P[11]->value.d)
#define control (param_P[12]->value.d)
#define bufferType (param_P[13]->value.d)
#define mode (param_P[14]->value.d)
/*-------------- BLOCK CODE ---------------*/
scattertxt(run_state,block_P)

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
    	int i,j;
	int operState;
	FILE* file_F;
	complex	val;
	char	fname[100];
	char curveTitle[80];


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Number of points ( dynamic plot window)";
     char   *ptype0 = "int";
     char   *pval0 = "128";
     char   *pname0 = "npts";
     char   *pdef1 = "Number of points to skip";
     char   *ptype1 = "int";
     char   *pval1 = "0";
     char   *pname1 = "skip";
     char   *pdef2 = "Title";
     char   *ptype2 = "file";
     char   *pval2 = "Scatter";
     char   *pname2 = "title";
     char   *pdef3 = "x Axis";
     char   *ptype3 = "file";
     char   *pval3 = "X";
     char   *pname3 = "x_axis";
     char   *pdef4 = "y Axis";
     char   *ptype4 = "file";
     char   *pval4 = "Y";
     char   *pname4 = "y_axis";
     char   *pdef5 = "Plot Style: 1=Line,2=Points,5=Bar Chart";
     char   *ptype5 = "int";
     char   *pval5 = "2";
     char   *pname5 = "plotStyleParam";
     char   *pdef6 = "Fixed Bounds ( 0=none, 1=fixed)";
     char   *ptype6 = "int";
     char   *pval6 = "0";
     char   *pname6 = "fixed";
     char   *pdef7 = "Minimum x";
     char   *ptype7 = "float";
     char   *pval7 = "-1.2";
     char   *pname7 = "minx";
     char   *pdef8 = "Maximum x";
     char   *ptype8 = "float";
     char   *pval8 = "1.2";
     char   *pname8 = "maxx";
     char   *pdef9 = "Minimum y";
     char   *ptype9 = "float";
     char   *pval9 = "-1.2";
     char   *pname9 = "miny";
     char   *pdef10 = "Maximum y";
     char   *ptype10 = "float";
     char   *pval10 = "1.2";
     char   *pname10 = "maxy";
     char   *pdef11 = "Marker type:0=dot,1=O,2=+,3=X,4=*,5=square,6=diamond,7=triangle";
     char   *ptype11 = "int";
     char   *pval11 = "0";
     char   *pname11 = "markerType";
     char   *pdef12 = "Control: 1=On, 0=Off";
     char   *ptype12 = "int";
     char   *pval12 = "1";
     char   *pname12 = "control";
     char   *pdef13 = "Buffer type:0= Float,1= Complex, 2=Integer";
     char   *ptype13 = "int";
     char   *pval13 = "0";
     char   *pname13 = "bufferType";
     char   *pdef14 = "0=Static,1=Dynamic";
     char   *ptype14 = "int";
     char   *pval14 = "0";
     char   *pname14 = "mode";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);
KrnModelParam(indexModel88,3 ,pdef3,ptype3,pval3,pname3);
KrnModelParam(indexModel88,4 ,pdef4,ptype4,pval4,pname4);
KrnModelParam(indexModel88,5 ,pdef5,ptype5,pval5,pname5);
KrnModelParam(indexModel88,6 ,pdef6,ptype6,pval6,pname6);
KrnModelParam(indexModel88,7 ,pdef7,ptype7,pval7,pname7);
KrnModelParam(indexModel88,8 ,pdef8,ptype8,pval8,pname8);
KrnModelParam(indexModel88,9 ,pdef9,ptype9,pval9,pname9);
KrnModelParam(indexModel88,10 ,pdef10,ptype10,pval10,pname10);
KrnModelParam(indexModel88,11 ,pdef11,ptype11,pval11,pname11);
KrnModelParam(indexModel88,12 ,pdef12,ptype12,pval12,pname12);
KrnModelParam(indexModel88,13 ,pdef13,ptype13,pval13,pname13);
KrnModelParam(indexModel88,14 ,pdef14,ptype14,pval14,pname14);

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
	if((numberInputBuffers = NO_INPUT_BUFFERS()) <= 0) {
		fprintf(stderr,"scatter: no inputs connected\n");
		return(2);
	}
	if((numberOutputBuffers = NO_OUTPUT_BUFFERS()) > numberInputBuffers) {
		fprintf(stderr,"scatter: too many outputs connected\n");
		return(3);
	}
	if(numberInputBuffers > 2) {
		fprintf(stderr,"scatter: too many inputs connected\n");
		return(3);
	}
	if(control && mode == DYNAMIC) {
		/*
		 * allocate arrays
		 */
		xx_P = (float* )calloc(npts,sizeof(float));
		if(xx_P == NULL) {
			fprintf(stderr,"Could not allocate space in scatter\n");
			return(4);
		}
		yy_P = (float* )calloc(npts,sizeof(float));
		if(yy_P == NULL) {
			fprintf(stderr,"Could not allocate space in scatter\n");
			return(4);
		}
	} else if(control && mode == STATIC) {
		/*
		 * allocate arrays
		 */
		xx_P = (float* )calloc(BLOCK_SIZE,sizeof(float));
		if(xx_P == NULL) {
			fprintf(stderr,"Could not allocate space in scatter\n");
			return(4);
		}
		yy_P = (float* )calloc(BLOCK_SIZE,sizeof(float));
		if(yy_P == NULL) {
			fprintf(stderr,"Could not allocate space in scatter\n");
			return(4);
		}
	}
    	count = 0;
	totalCount = 0;
	switch(bufferType) {
		case COMPLEX_BUFFER: 
			SET_CELL_SIZE_IN(0,sizeof(complex));
			if(numberOutputBuffers == 1)
				SET_CELL_SIZE_IN(0,sizeof(complex));
			break;
		case FLOAT_BUFFER: 
			if(numberInputBuffers == 1) {
				SET_CELL_SIZE_IN(0,sizeof(float));
				if(numberOutputBuffers == 1)
				   SET_CELL_SIZE_OUT(0,sizeof(float));
			}
			else {
				SET_CELL_SIZE_IN(0,sizeof(float));
				SET_CELL_SIZE_IN(1,sizeof(float));
				if(numberOutputBuffers == 2) {
				   SET_CELL_SIZE_OUT(0,sizeof(float));
				   SET_CELL_SIZE_OUT(1,sizeof(float));
				}
			}
			break;
		case INTEGER_BUFFER: 
			if(numberInputBuffers == 1) {
				SET_CELL_SIZE_IN(0,sizeof(int));
				if(numberOutputBuffers == 1)
				   SET_CELL_SIZE_OUT(0,sizeof(int));
			}
			else {
				SET_CELL_SIZE_IN(0,sizeof(int));
				SET_CELL_SIZE_IN(1,sizeof(int));
				if(numberOutputBuffers == 2) {
				    SET_CELL_SIZE_OUT(0,sizeof(int));
				    SET_CELL_SIZE_OUT(1,sizeof(int));
				}
			}
			break;
		default: 
			fprintf(stderr,"Bad buffer type specified in scatter \n");
			return(5);
			break;
	}


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 


	for(samples = MIN_AVAIL(); samples > 0; --samples) {




		   for(i=0; i<numberInputBuffers; ++i) {
	   		IT_IN(i);
			if(numberOutputBuffers > i) {
				if(IT_OUT(i)) {
					KrnOverflow("scatter",i);
					return(99);
				}
				switch(bufferType) {
					case COMPLEX_BUFFER:
	 					OUTCX(i,0) = INCX(i,0);
						break;
					case INTEGER_BUFFER:
	 					OUTI(i,0) = INI(i,0);
						break;
					case FLOAT_BUFFER:
	 					OUTF(i,0) = INF(i,0);
						break;
				}
			}
	        }

		if(++totalCount > skip && control) {
                	if(mode == STATIC) 
				count = blockOff + bufi;
			bufi++;
		if (bufi == BLOCK_SIZE && mode==STATIC) {
			blockOff += BLOCK_SIZE;
			xx_P = (float *)realloc((char *) xx_P,
				sizeof(float) * (blockOff + BLOCK_SIZE));
			if(xx_P==NULL)
			{
				fprintf(stderr,"Could not allocate space in scatter \n");
				return(7);
			}
			yy_P = (float *)realloc((char *) yy_P,
				sizeof(float) * (blockOff + BLOCK_SIZE));
			if(yy_P==NULL)
			{
				fprintf(stderr,"Could not allocate space in scatter \n");
				return(7);
			}
			bufi=0;

		}

			switch(bufferType) {
				case COMPLEX_BUFFER:
					val=INCX(0,0);
           				yy_P[count] = val.im;
					xx_P[count] = val.re;
					break;
				case FLOAT_BUFFER:
           			if(numberInputBuffers==2)
					        yy_P[count] = INF(1,0);
					xx_P[count] = INF(0,0);
					break;
				case INTEGER_BUFFER:
           			if(numberInputBuffers==2)
						yy_P[count] = (float)INI(1,0);
					xx_P[count] = (float)INI(0,0);
					break;
			}
			if(mode == DYNAMIC)
					count++;
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
                strcat(fname,".sct");
                file_F = fopen(fname,"w");
                for(i=0; i<count; i++)
                        fprintf(file_F,"%e %e\n",xx_P[i],yy_P[i]);		
                fprintf(stderr,"scatter created file: %s \n",fname);
		fclose(file_F);
		free(xx_P);
		free(yy_P);
      }
}


break;
}
return(0);
}
