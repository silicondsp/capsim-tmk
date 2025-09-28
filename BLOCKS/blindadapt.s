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

blindadapt 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* blindadapt.s */
/***********************************************************************
                             blindadapt()
************************************************************************
<NAME>
blindadapt
</NAME>
<DESCRIPTION>
Blind adaptive equalization
</DESCRIPTION>
<PROGRAMMERS>
Date:  July 9, 1990 
Programmer: Karaoguz, Jeyhan 
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
Blind adaptive equalization
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 

#include <stdio.h>

]]>
</INCLUDES> 

<DEFINES> 

#define EE 2.7182818
#define big 21474836480.0

</DEFINES> 

        

<STATES>
	<STATE>
		<TYPE>float**</TYPE>
		<NAME>x_P</NAME>
	</STATE>
	<STATE>
		<TYPE>float**</TYPE>
		<NAME>w_P</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>mucounter</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>varcounter</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>tmpvar</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>tmpmu</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

   	int i;
   	int j, k;
        float register1[2];
        float register2[2];
        float output[2];
        float lambda11=0.0, lambda21=0.0, lambda22=0.0, lambda12=0.0;
        float xtemp=0.0, ytemp=0.0;
	FILE *fopen();
	FILE *imp_F;
	FILE *imp;
	FILE *imp_W;

</DECLARATIONS> 

                       

<PARAMETERS>
<PARAM>
	<DEF>Filter order</DEF>
	<TYPE>int</TYPE>
	<NAME>N</NAME>
	<VALUE>8 </VALUE>
</PARAM>
<PARAM>
	<DEF>Initial step size</DEF>
	<TYPE>float</TYPE>
	<NAME>mu</NAME>
	<VALUE>0.009</VALUE>
</PARAM>
<PARAM>
	<DEF>step size update ratio</DEF>
	<TYPE>float</TYPE>
	<NAME>muratio</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF>step size update rate (in samples)</DEF>
	<TYPE>int</TYPE>
	<NAME>murate</NAME>
	<VALUE>4000</VALUE>
</PARAM>
<PARAM>
	<DEF>variance update ratio</DEF>
	<TYPE>float</TYPE>
	<NAME>varratio</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF>variance update rate (in samples)</DEF>
	<TYPE>int</TYPE>
	<NAME>varrate</NAME>
	<VALUE>4000</VALUE>
</PARAM>
<PARAM>
	<DEF>mean</DEF>
	<TYPE>float</TYPE>
	<NAME>mean</NAME>
	<VALUE>1.0 </VALUE>
</PARAM>
<PARAM>
	<DEF>variance</DEF>
	<TYPE>float</TYPE>
	<NAME>var</NAME>
	<VALUE>0.14</VALUE>
</PARAM>
<PARAM>
	<DEF>Flag: 0=estimate, 1=error</DEF>
	<TYPE>int</TYPE>
	<NAME>outputFlag</NAME>
	<VALUE>0</VALUE>
</PARAM>
<PARAM>
	<DEF>initilization</DEF>
	<TYPE>float</TYPE>
	<NAME>init</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
</PARAMETERS>

<INIT_CODE>
<![CDATA[ 

	/*
	 * Allocate memory and return pointers for tapped delay line x_P and
	 * array containing impulse response samples, h_P.
	 *
	 */
	if( (x_P = (float**)calloc(2,sizeof(float*))) == NULL ||
	    (w_P = (float**)calloc(2,sizeof(float*))) == NULL ) {
	   	fprintf(stderr,"convolve: can't allocate work space\n");
		return(4);
	}
        for(i=0; i<2; i++)
	if( (x_P[i] = (float*)calloc(N,sizeof(float))) == NULL ||
	    (w_P[i] = (float*)calloc(N,sizeof(float))) == NULL ) {
	   	fprintf(stderr,"convolve: can't allocate work space\n");
		return(4);
	}
	/*
	 * Read in the impulse response samples into the array
	 * and initialize the tapped delay line to zero.
         * According to this for loop the impulse data is assumed to be
         * in the order of first real then imaginary value for each tap
         *
         */
	tmpvar = var;
	tmpmu = mu;
	mucounter = 0;
	varcounter = 0;
	    w_P[0][0] = init;
      for(j=1;j<N;j++)
	    w_P[0][j] = 0.0;
      for(j=0;j<N;j++)
	    w_P[1][j] = 0.0; 
      for(j=0;j<N;j++)
         for(i=0;i<2;i++){
            x_P[i][j] = 0.0; } 

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 




	while(IT_IN(0) && IT_IN(1)){
		/*
		 * Shift input samples into tapped delay line
		 */  
		mucounter++ ; 
		varcounter++ ; 
                for( i=0 ; i<2 ; i++)
		register2[i] = INF(i,0);

		for(i=0; i<N; i++) 
                    for(j=0; j<2; j++){
			register1[j] = x_P[j][i];
			x_P[j][i] = register2[j];
			register2[j] = register1[j];
		}
		/*
		 * Compute inner product 
		 */
                output[0] = 0.0;
                output[1] = 0.0;
		for (i=0; i<N; i++) { 
		     output[0] += ( x_P[0][i]*w_P[0][i] -
                                          x_P[1][i]*w_P[1][i]);
		     output[1] += ( x_P[0][i]*w_P[1][i] +
                                          x_P[1][i]*w_P[0][i]);
		}

                for(i=0; i<2; i++) {
                        if(IT_OUT(i)) {
				KrnOverflow("blindadapt",i);
				return(99);
			}
                        OUTF(i,0) = output[i];
                }



	 	xtemp = 2.0*mean*output[0]/tmpvar;
		ytemp = 2.0*mean*output[1]/tmpvar; 
		lambda11 = 1.0/((1.0+pow(EE,-xtemp))*(1.0+pow(EE,-ytemp)));
		lambda21 = 1.0/((1.0+pow(EE,xtemp))*(1.0+pow(EE,-ytemp)));
		lambda22 = 1.0/((1.0+pow(EE,xtemp))*(1.0+pow(EE,ytemp)));
		lambda12 = 1.0/((1.0+pow(EE,-xtemp))*(1.0+pow(EE,ytemp)));

		if(mucounter == murate) {
			tmpmu = muratio*tmpmu;
			mucounter = 0;
					}
		if(varcounter == varrate) {
			tmpvar = varratio*tmpvar;
			varcounter = 0;
					}

                for (i=0;i<N;i++) { 

		 w_P[0][i] += tmpmu*(1.0/tmpvar)*(lambda11*((mean-output[0])*x_P[0][i]+(mean - output[1])*x_P[1][i])+lambda21*((-mean-output[0])*x_P[0][i]+(mean-output[1])*x_P[1][i])+lambda22*((-mean-output[0])*x_P[0][i]+(-mean-output[1])*x_P[1][i])+lambda12*((mean-output[0])*x_P[0][i]+(-mean-output[1])*x_P[1][i]));

                 w_P[1][i] += tmpmu*(1.0/tmpvar)*(lambda11*((output[0]-mean)*x_P[1][i]+(mean-output[1])*x_P[0][i])+lambda21*((output[0]+mean)*x_P[1][i]+(mean-output[1])*x_P[0][i])+lambda22*((output[0]+mean)*x_P[1][i]+(-mean-output[1])*x_P[0][i])+lambda12*((output[0]-mean)*x_P[1][i]+(-mean-output[1])*x_P[0][i]));
                                     } 

}
imp_W = fopen("taps","w");
      for(j=0;j<N;j++)
         for(i=0;i<2;i++){
            fprintf(imp_W,"%f\n", w_P[i][j]);
                           } 
fclose(imp_W);
              

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

	free(x_P); free(w_P);

]]>
</WRAPUP_CODE> 



</BLOCK> 

