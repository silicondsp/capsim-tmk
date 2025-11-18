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

fxfirtaps 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* fxfirfil.s */
/***********************************************************************
                             fxfirfil()
************************************************************************
The block reads in floating point taps for the FIR filter.
Implements Fixed Point FIR Filter.
Date:  October 19, 1989 
Programmer: Sasan H. Ardalan. 
<NAME>
firfil
</NAME>
<DESCRIPTION>
This star designs FIR low pass, highj pass, band pass, and band stop 
filters using the windowing method.
The block stores the specs of the FIR filter in the file tmp.spec.
The block stores the FIR filter taps in the file tmp.tap.
</DESCRIPTION>
<PROGRAMMERS>
Date:  October 19, 1989 
Programmer: Sasan H. Ardalan. 
Modified: June 17, 2007 for fixed point
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This block implements an  FIR based on taps stored in a file in fixed point arithmetic
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 

#include <math.h>
#include <stdio.h>

]]>
</INCLUDES> 

<DEFINES> 



</DEFINES> 

                       

<PARAMETERS>
<PARAM>
	<DEF>File with Taps (first line # of taps)</DEF>
	<TYPE>file</TYPE>
	<NAME>fileName</NAME>
	<VALUE>tmp.tap</VALUE>
</PARAM>
<PARAM>
	<DEF>Number of bits to represent fraction</DEF>
	<TYPE>int</TYPE>
	<NAME>qbits</NAME>
	<VALUE>8</VALUE>
</PARAM>
<PARAM>
	<DEF>Word length</DEF>
	<TYPE>int</TYPE>
	<NAME>size</NAME>
	<VALUE>32</VALUE>
</PARAM>
<PARAM>
	<DEF>Accumulator Roundoff bits</DEF>
	<TYPE>int</TYPE>
	<NAME>roundoff_bits</NAME>
	<VALUE>8</VALUE>
</PARAM>
<PARAM>
	<DEF>Accumulator Word length</DEF>
	<TYPE>int</TYPE>
	<NAME>accumSizeRound</NAME>
	<VALUE>32</VALUE>
</PARAM>

<PARAM>
	<DEF>saturation mode</DEF>
	<TYPE>int</TYPE>
	<NAME>saturation_mode</NAME>
	<VALUE>1</VALUE>
</PARAM>
<PARAM>
	<DEF>Error Out (1=error 0=floating point response)</DEF>
	<TYPE>int</TYPE>
	<NAME>errorControl</NAME>
	<VALUE>1</VALUE>
</PARAM>
</PARAMETERS>     

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>int</TYPE>
		<NAME>x</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
    

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>int</TYPE>
		<NAME>y</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>error</NAME>
	</BUFFER>
</OUTPUT_BUFFERS> 

<STATES>
	<STATE>
		<TYPE>int*</TYPE>
		<NAME>x_P</NAME>
	</STATE>
	<STATE>
		<TYPE>double*</TYPE>
		<NAME>h_P</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>N</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>fxfactor</NAME>
	</STATE>
	<STATE>
		<TYPE>int*</TYPE>
		<NAME>fxfactor1_P</NAME>
	</STATE>
	<STATE>
		<TYPE>int*</TYPE>
		<NAME>fxfactor0_P</NAME>
	</STATE>
	<STATE>
		<TYPE>int*</TYPE>
		<NAME>fxfactLessFlag_P</NAME>
	</STATE>
	<STATE>
		<TYPE>int*</TYPE>
		<NAME>less_flag2_P</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>maxv</NAME>
	</STATE>
	<STATE>
		<TYPE>int*</TYPE>
		<NAME>overflow</NAME>
	</STATE>	
	
	
</STATES>
 
<DECLARATIONS> 

   	int i;
   	int j;
	int val;
	int status;
	int numberTaps;
	int tmp1,tmp2;
        float sum;
	int	no_samples;
	FILE *imp_F;
	doublePrecInt	accumulate;
        int sum1, sum0;
	int out;
	double factor;
	int input1,input0;
	int less_flag2;
	int out1,out0;

</DECLARATIONS> 



    



<INIT_CODE>
<![CDATA[ 


	/*
	 * open file containing impulse response samples. Check 
	 * to see if it exists.
	 *
	 */
        if( (imp_F = fopen(fileName,"r")) == NULL) {
		fprintf(stderr,"firtaps: file could not be opened.\n");
		return(4);
	}
	fscanf(imp_F,"%d",&numberTaps);
	/*
	 * Allocate memory and return pointers for tapped delay line x_P and
	 * array containing impulse response samples, h_P.
	 *
	 */
	if( (x_P = (int*)calloc(numberTaps,sizeof(int))) == NULL ||
	    (h_P = (double*)calloc(numberTaps,sizeof(double))) == NULL ) {
	   	fprintf(stderr,"fxfirtaps: can't allocate work space\n");
		return(4);
	}
	if( (fxfactor0_P = (int*)calloc(numberTaps,sizeof(int))) == NULL ||
	    (fxfactor1_P = (int*)calloc(numberTaps,sizeof(int))) == NULL ||
	    (fxfactLessFlag_P = (int*)calloc(numberTaps,sizeof(int))) == NULL) {
	   	fprintf(stderr,"fxfirtaps: can't allocate work space\n");
		return(5);
	}
	
	/*
	 * Read in the impulse response samples into the array
	 * and initialize the tapped delay line to zero.
	 *
	 */
	for (i=0; i<numberTaps; i++) {
		x_P[i]= 0.0;
		fscanf(imp_F,"%lf",&h_P[i]);
	}
	N=numberTaps;
	fclose(imp_F);
	
	if (size > 32) {
		fprintf(stderr,"fxfirtaps: size can not be greater than 32\n");	
                return(6);
		}
	if ((size & 1) == 1) {
		fprintf(stderr,"fxfirtaps: Sorry, size can not be an odd number\n");	
                return(7);
		}
		
	/*
	 * store fixed point tap coefficients (part1,part2,lessFlag)
	 */
        if (qbits > 30) {
	/* 
	 * Because 1<<31 becomes a negative number in this machine 
	 */
		fprintf(stderr,"fxfirtaps:At most 30 bits are allowed for fraction\n"); 
	        return(7);
       }
	/* 
	 * Calculate the maximum number to be represented by size bits 
	 */
        maxv=1;
        maxv <<= (size-1); 
	maxv -= 1;
	val=1; 
	val <<= qbits;	
        for (i=0; i<numberTaps; i++) {
              factor=h_P[i];	
              if (factor>0.0)
		   fxfactor = (int)(factor * val + 0.5);
              else
		   fxfactor = (int)(factor * val - 0.5);
              if (fxfactor > maxv || (-fxfactor) > maxv) {
        	    fprintf(stderr,"fxfirtaps: gain can not be represented by size bits\n");
        	    return(8);
              }
              Fx_Part(size,fxfactor,&fxfactor1_P[i],&fxfactor0_P[i],&fxfactLessFlag_P[i]);
	}

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 




	for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) {
		IT_IN(0);
		/*
		 * Shift input sample into tapped delay line
		 */
		tmp2=x(0);
		for(i=0; i<N; i++) {
			tmp1=x_P[i];
			x_P[i]=tmp2;
			tmp2=tmp1;
		}
		/*
		 * Compute double precision inner product 
		 */
                sum = 0.0;
		for (i=0; i<N; i++) { 
		     sum += ((double)x_P[i])*h_P[i];
		}
		
		sum1 = 0;
		sum0 = 0;

		for (i=0; i<N; i++) { 
                          Fx_Part(size,x_P[i],&input1,&input0,&less_flag2);
        
                          Fx_MultVar(fxfactLessFlag_P[i],less_flag2,size,fxfactor1_P[i],fxfactor0_P[i],
                                    input1,input0,&out1,&out0);

		
                          Fx_AddVar(size,saturation_mode,out1,out0,sum1,sum0,&sum1,&sum0); 
                         
				    
				    
		}
                Fx_RoundVar(size,accumSizeRound,roundoff_bits,sum1,sum0,&out);

		if(IT_OUT(0)) {
			KrnOverflow("fxfirfil",0);
			return(99);
		}
		/*
	  	 * set output buffer to response result
		 */
		y(0) = out;
		
		
		if(IT_OUT(1)) {
			KrnOverflow("fxfirfil",1);
			return(99);
		}
		/*
	  	 * set output buffer to response result
		 */
		error(0) = sum-(double)out*((double)errorControl);
	}

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

	free(x_P); free(h_P); 
	free(fxfactor0_P);
	free(fxfactor1_P);
	free(fxfactLessFlag_P);

]]>
</WRAPUP_CODE> 



</BLOCK> 

