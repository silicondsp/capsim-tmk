 
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

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 



 

#define IMAGE_BUFFER 1
#define FLOAT_BUFFER 0


/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
      int  __ibufs;
      int  __obufs;
      float*  __bin;
      float*  __plotbin;
      float*  __xbin;
      float  __binWidth;
      int  __numberOfSamples;
      int  __totalCount;
      int  __total;
      FILE*  __histo_F;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define ibufs (state_P->__ibufs)
#define obufs (state_P->__obufs)
#define bin (state_P->__bin)
#define plotbin (state_P->__plotbin)
#define xbin (state_P->__xbin)
#define binWidth (state_P->__binWidth)
#define numberOfSamples (state_P->__numberOfSamples)
#define totalCount (state_P->__totalCount)
#define total (state_P->__total)
#define histo_F (state_P->__histo_F)

/*         
 *    PARAMETER DEFINES 
 */ 
#define blockt (param_P[0]->value.f)
#define stop (param_P[1]->value.f)
#define numberOfBins (param_P[2]->value.d)
#define file_spec (param_P[3]->value.s)
#define npts (param_P[4]->value.d)
#define skip (param_P[5]->value.d)
#define graphTitle (param_P[6]->value.s)
#define x_axis (param_P[7]->value.s)
#define y_axis (param_P[8]->value.s)
#define plotStyleParam (param_P[9]->value.d)
#define control (param_P[10]->value.d)
#define bufferType (param_P[11]->value.d)
/*-------------- BLOCK CODE ---------------*/
 int  histtxt(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

	float x;
	int i;
	int ii;
	int j;
	int jj;
        int     widthImage;
        int     heightImage;
        image_t         img;
	char title[80];
	char	filename[100];
	FILE* file_F;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "Starting point of left most bin";
     char   *ptype0 = "float";
     char   *pval0 = "-5.0";
     char   *pname0 = "blockt";
     char   *pdef1 = "Ending point of right  most bin";
     char   *ptype1 = "float";
     char   *pval1 = "5.0";
     char   *pname1 = "stop";
     char   *pdef2 = "Number of bins";
     char   *ptype2 = "int";
     char   *pval2 = "100";
     char   *pname2 = "numberOfBins";
     char   *pdef3 = "File name for output";
     char   *ptype3 = "file";
     char   *pval3 = "none";
     char   *pname3 = "file_spec";
     char   *pdef4 = "Number of points to collect";
     char   *ptype4 = "int";
     char   *pval4 = "1000";
     char   *pname4 = "npts";
     char   *pdef5 = "Points to skip before first plot";
     char   *ptype5 = "int";
     char   *pval5 = "0";
     char   *pname5 = "skip";
     char   *pdef6 = "Title";
     char   *ptype6 = "file";
     char   *pval6 = "Histogram";
     char   *pname6 = "graphTitle";
     char   *pdef7 = "X axis label";
     char   *ptype7 = "file";
     char   *pval7 = "Bins";
     char   *pname7 = "x_axis";
     char   *pdef8 = "Y axis label";
     char   *ptype8 = "file";
     char   *pval8 = "Histogram";
     char   *pname8 = "y_axis";
     char   *pdef9 = "Plot Style: 1=Line,2=Points,5=Bar Chart";
     char   *ptype9 = "int";
     char   *pval9 = "5";
     char   *pname9 = "plotStyleParam";
     char   *pdef10 = "Control: 1=On, 0=Off";
     char   *ptype10 = "int";
     char   *pval10 = "1";
     char   *pname10 = "control";
     char   *pdef11 = "Buffer Type: 0= float, 1=image";
     char   *ptype11 = "int";
     char   *pval11 = "0";
     char   *pname11 = "bufferType";
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

      }
break;
   


/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
            totalCount=0;
       total=0;

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 

/*
 * store as state the number of input/output buffers
 */
if((ibufs = NO_INPUT_BUFFERS()) <= 0) {
        fprintf(stderr,"hist: no inputs connected\n");
        return(2);
}
if((obufs = NO_OUTPUT_BUFFERS()) > ibufs) {
        fprintf(stderr,"hist: too many outputs connected\n");
        return(3);
}
binWidth=(stop-blockt)/((float)numberOfBins);
if(numberOfBins>512 || binWidth<0.)return(1);
if(control) {
	bin = (float *) malloc(numberOfBins * sizeof(float));  
	plotbin = (float *) malloc(numberOfBins * sizeof(float));  
	xbin = (float *) malloc(numberOfBins * sizeof(float));  
	if(bin == NULL || plotbin == NULL || xbin ==NULL) {
		fprintf(stderr,"hist could not allocate memory\n");
		return(4);
	}
}
for(i=0;i<numberOfBins;i++) {
	bin[i]=0.;
	xbin[i]= (float)i*binWidth + blockt + binWidth/2.;
}
numberOfSamples=0;
switch(bufferType) {
        case IMAGE_BUFFER:
                /*
                 * Image type
                 */
                for(i=0; i<ibufs; i++)
                        SET_CELL_SIZE_IN(i,sizeof(image_t));
                for(i=0; i<obufs; i++)
                        SET_CELL_SIZE_OUT(i,sizeof(image_t));
                break;
        case FLOAT_BUFFER:
                /*
                 * float
                 */
		break;
}


break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 

for(ii=MIN_AVAIL();ii>0;--ii) {
	for(i=0; i<ibufs; ++i) {
                        IT_IN(i);
                        if(obufs > i) {
                                if(IT_OUT(i)) {
				    KrnOverflow("hist",i);
				    return(99);
				}
                                if(bufferType==IMAGE_BUFFER)
                                        OUTIMAGE(i,0) = INIMAGE(i,0);
                                else
                                        OUTF(i,0) = INF(i,0);
                        }
	}
	switch(bufferType) {
	  case IMAGE_BUFFER:
		img=INIMAGE(0,0);
                widthImage=img.width;
                heightImage=img.height;
		total = widthImage*heightImage;
                for(i=0; i<heightImage; i++)
                   for(jj=0; jj<widthImage; jj++) {
			x=img.image_PP[i][jj];
			x=(x-blockt)/binWidth;
		        j=(int)x;
                        if(j<0)
                            bin[0] = bin[0] +1.;
                        else if (j>=numberOfBins)
                           bin[numberOfBins-1] = bin[numberOfBins-1] + 1.;
                        else
			   bin[j] = bin[j] + 1.;
	
		   }	

	     break;
	  case FLOAT_BUFFER:
	     if(++totalCount > skip && control ) {
		if(total == npts) continue;
		x=INF(0,0);
		x=(x-blockt)/binWidth;
		j=(int)x;
		if(j<0)
			bin[0] = bin[0] +1.;
		else if (j>=numberOfBins)
			bin[numberOfBins-1] = bin[numberOfBins-1] + 1.;
		else
			bin[j] = bin[j] + 1.;
		total++;
	     }
	     break;
	}

}
return(0);


break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 

if((totalCount - skip) > 0  || bufferType==IMAGE_BUFFER ) {
if(total != npts && bufferType == FLOAT_BUFFER)
            total = totalCount -skip;
for(j=0;j<numberOfBins;j++)
	plotbin[j] = bin[j]/(float)(binWidth*total);
sprintf(title,"Histogram %s",SNAME(0));
{
     strcpy(filename,graphTitle);
     strcat(filename,".his");
     file_F = fopen(filename,"w");
     for(i=0; i<numberOfBins; i++)
          fprintf(file_F,"%e %e\n",xbin[i],plotbin[i]);
     fprintf(stderr,"hist created file: %s \n",filename);
     fclose(file_F);
}
if(strcmp(file_spec,"none")==0)return(0);
histo_F = fopen(file_spec,"w");
for(i=0;i<numberOfBins;i++)
	fprintf(histo_F,"%f  %f\n",blockt+binWidth/2.+(float)i*binWidth,
bin[i]/(float)total);
fclose(histo_F);
}


break;
}
return(0);
}
