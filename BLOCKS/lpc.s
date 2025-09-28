<BLOCK>
<LICENSE>
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
</LICENSE>
<BLOCK_NAME>

lpc 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* lpc.s */
/***********************************************************************
                             lpc()
************************************************************************
This star computes the LPC parameters of the input samples.
The method is based on the routines of "Linear Prediction Analysis
Programs (AUTO-COVAR)", by A. H. Gray and J.D. Markel in IEEE Press
Programs for Digital Signal Processing.
<NAME>
lpc
</NAME>
<DESCRIPTION>
This star computes the LPC parameters of the input samples.
The method is based on the routines of "Linear Prediction Analysis
Programs (AUTO-COVAR)", by A. H. Gray and J.D. Markel in IEEE Press
Programs for Digital Signal Processing.
</DESCRIPTION>
<PROGRAMMERS>
Date:       February 22, 1991 
Programmer: Sasan Ardalan
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This star computes the LPC parameters of the input samples.
</DESC_SHORT>

<INCLUDES>
<![CDATA[ 

#include <math.h>
#include <stdio.h>

]]>
</INCLUDES> 

<DEFINES> 

#define PI 3.1415926
#define AUTO 0
#define COVAR 1

</DEFINES> 

      

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>n</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberOfOutputs</NAME>
	</STATE>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>x_P</NAME>
	</STATE>
	<STATE>
		<TYPE>FILE*</TYPE>
		<NAME>fp</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

   	int i;
   	int j;
	int nrot;
	float tmp1,tmp2;
	float a_A[21];
	float rc_A[21];
	float alpha;
	float* vector();
	int result;
	float realAz,imgAz,Az;
	float theta,dtheta;
	int Dsp_Covar(int n1,float* x1_P,int m1,float* a1_P,float* alpha1_P,float* grc1_P);
	int Dsp_Auto(int n1,float* x1_P,int m1,float* a1_P,float* alpha1_P,float* rc1_P);

</DECLARATIONS> 

             

<PARAMETERS>
<PARAM>
	<DEF>N :  Size of the input window </DEF>
	<TYPE>int</TYPE>
	<NAME>N</NAME>
	<VALUE>128 </VALUE>
</PARAM>
<PARAM>
	<DEF><![CDATA[m:  Order of the all-pole model <=20]]></DEF>
	<TYPE>int</TYPE>
	<NAME>m</NAME>
	<VALUE>10 </VALUE>
</PARAM>
<PARAM>
	<DEF>0=Auto, 1=Covar Method</DEF>
	<TYPE>int</TYPE>
	<NAME>flag</NAME>
	<VALUE>0</VALUE>
</PARAM>
<PARAM>
	<DEF>File to store the AR coefficients and reflection coeff</DEF>
	<TYPE>file</TYPE>
	<NAME>fileName</NAME>
	<VALUE>stdout</VALUE>
</PARAM>
<PARAM>
	<DEF>Number of points for spectrum</DEF>
	<TYPE>int</TYPE>
	<NAME>npts</NAME>
	<VALUE>128</VALUE>
</PARAM>
</PARAMETERS>

    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>x</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

       if(m > 20) {
		fprintf(stderr,"lpc: Order > 20 \n");
		return(2);
	}
       numberOfOutputs=NO_OUTPUT_BUFFERS();
       if(numberOfOutputs > 1) {
		fprintf(stderr,"lpc: Number of Outputs > 1 \n");
		return(1);
       }
	/*
	 * Initialize the tapped delay line  to zero.
	 *
	 */
	x_P=vector(N);
	for (i=0; i<N; i++) {
		x_P[i] = 0.0;
	}
       if(strcmp(fileName,"stdout") == 0) fp=stdout;
       else fp=fopen(fileName,"w");
       if(fp == NULL)  {
		fprintf(stderr,"lpc: could not open file! \n");
		return(3);
       }
       n = 0;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 




while(IT_IN(0)) {
	n += 1 ;
	/*
	 * Shift input sample into tapped delay line
	 */
	tmp2=x(0);
	for(i=0; i<N; i++) {
		tmp1=x_P[i];
		x_P[i]=tmp2;
		tmp2=tmp1;
	}

        if(n== N){
		/*
		 * collected N samples. Perform LPC Analysis
		 */
		switch (flag) {
			case AUTO:
			   result=Dsp_Auto(n,x_P,m,a_A,&alpha,rc_A);
			   break;
			case COVAR:
			   result=Dsp_Covar(n,x_P,m,a_A,&alpha,rc_A);
			   break;
		}
      		for(i=0; i<=m; i++)
                        fprintf(fp,"%e  %e \n",a_A[i],rc_A[i]);
      		fprintf(fp,"%e \n",alpha);

		dtheta=PI/(float)npts;
		for(i=0; i<npts; i++) {
		   theta=i*dtheta;
		   realAz=0.0;
		   imgAz=0.0;
		   for(j=0; j<=m; j++) {

			realAz += a_A[j]*cos(j*theta);
			imgAz += a_A[j]*sin(j*theta);
		   }
		   Az= sqrt(realAz*realAz+imgAz*imgAz);
		   if(IT_OUT(0)) {
			KrnOverflow("lpc",0);
			return(99);
		   }
		   OUTF(0,0)=1.0/Az;
		   

		}	
		/*
		 * initialize
		 */
		for (i=0; i<N; i++) {
			x_P[i] = 0.0;
		}
      		for(i=0; i<=m; i++) {
			a_A[i]=0.0;
			rc_A[i]=0.0;
		}
		alpha=0.0;
		n=0;

        }

}
    

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

/*
 * close the file
 */
if(strcmp(fileName,"stdout") != 0) fclose(fp);

]]>
</WRAPUP_CODE> 



</BLOCK> 

