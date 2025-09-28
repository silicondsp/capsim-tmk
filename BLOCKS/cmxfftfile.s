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
<BLOCK_NAME>cmxfftfile</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* cmxfftfile.s */
/***********************************************************************
                             cmxfftfile()
************************************************************************
	Inputs:		The FFT of the signal to be filtered, X(k)		
	Outputs:	The FFT of the impulse response (from a file)
                        times the input signal, Y(k) = X(k)H(k)
	Parameters:	int fftexp, the exponent of the fft length
			file_name, the name of the file containinf the samples
************************************************************************
This star reads a file and computes its FFT during the initialization phase.
(This produces H(k)).
During execution, the star performs a complex multiplication of 
the FFT of the file with the input complex data blocks (The input fft, X(k)). 
It then outputs the complex result.
This star multiplies the two complex data streams  as follows: 
Each complex sample is assumed to be composed of a real sample followed by 
an imaginary sample.  This star operates like a "butterfly," i.e.
	c1 = a + jb = x1(0) + x1(1)
	c2 = c + jd = x2(0) + x2(1)
	r = c1 * c2 = (ac-bd) + j(bc+ad) = y(0) + y(1)
Programmer:    	Prayson W. Pate,Sasan Ardalan	
Date: 	 	March 12, 1989	
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This star reads a file and computes its FFT during the initialization phase.  (This produces H(k)).  During execution, the star performs a complex multiplication of the FFT of the file with the input complex data blocks (The input fft, X(k)).  It then outputs the complex result.
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 
#include <cap_fft.h>
]]>
</INCLUDES> 

         

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>fftl</NAME>
	</STATE>
	<STATE>
		<TYPE>cap_fft_cpx*</TYPE>
		<NAME>cxinBuff</NAME>
	</STATE>
	<STATE>
		<TYPE>cap_fft_cpx*</TYPE>
		<NAME>cxoutBuff</NAME>
	</STATE>
	<STATE>
		<TYPE>cap_fft_cfg</TYPE>
		<NAME>cfg</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>sample</NAME>
	</STATE>
	<STATE>
		<TYPE>FILE*</TYPE>
		<NAME>fp</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int no_samples;
	int i,j;
	FILE *fopen();
	float a,b,c,d;
	complex val;

</DECLARATIONS> 

       

<PARAMETERS>
<PARAM>
	<DEF>log2 [ length of FFT ]</DEF>
	<TYPE>int</TYPE>
	<NAME>fftexp</NAME>
	<VALUE></VALUE>
</PARAM>
<PARAM>
	<DEF>File with impulse response</DEF>
	<TYPE>file</TYPE>
	<NAME>file_name</NAME>
	<VALUE>imp.dat</VALUE>
</PARAM>
</PARAMETERS>

    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>complex</TYPE>
		<NAME>x1</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
    

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>complex</TYPE>
		<NAME>y</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

	fftl = 1 << fftexp;
	if (fftl < 8)
	{
		fprintf(stderr,"fftfile: fft length is too short \n");
		return(1);
	}
        cfg=cap_fft_alloc(fftl,0,NULL,NULL);
        if ((cxinBuff = (cap_fft_cpx*)calloc(fftl,sizeof(cap_fft_cpx))) == NULL)
        {
                fprintf(stderr,"cmxfft: can't allocate work space \n");
                return(2);
        }
        if ((cxoutBuff = (cap_fft_cpx*)calloc(fftl,sizeof(cap_fft_cpx))) == NULL)
        {
                fprintf(stderr,"cmxfft: can't allocate work space \n");
                return(3);
        }


	if(strcmp(file_name,"stdin") == 0)
		fp = stdin;
	else if((fp = fopen(file_name,"r")) == NULL) {
		fprintf(stderr,"fftfile: cannot open file\n");
		return(1); /* file cannot be opened */
	}
	i=0;
	/* Read input lines until EOF */
	while((fscanf(fp,"%f",&cxinBuff[i].r) != EOF) && i<(fftl)) i++;
        for(i=0; i< fftl; i++) {
                  cxinBuff[i].i=0.0;

        }
	/* perform fft calculation		*/
	cap_fft(cfg,cxinBuff,cxoutBuff);
	sample = 0;
	SET_CELL_SIZE_IN(0,sizeof(complex));
	SET_CELL_SIZE_OUT(0,sizeof(complex));

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	/* note the minimum number of samples on the 	*/
	/* input buffers and iterate that many times 	*/
	
	{
	for(no_samples=(MIN_AVAIL());no_samples >0; --no_samples) 

	{
		/*  get samples	*/
		IT_IN(0);	
		a = x1(0).re;
		c = cxoutBuff[sample].r;

		/* now get imaginary samples	*/
		b = x1(0).im;
		d = cxoutBuff[sample].i;

		/* output 		*/
		if(IT_OUT(0)) {
			KrnOverflow("cmxfftfile",0);
			return(0);
		}
		val.re = a*c - b*d;

		val.im = b*c + a*d;
		y(0)=val;
		
		sample++;	
		if (sample == fftl) sample = 0;

	}
	return(0);
	}

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

	/* free up allocated space	*/
        free((cap_fft_cpx*)cxinBuff);
        free((cap_fft_cpx*)cxoutBuff);
                                                                                


]]>
</WRAPUP_CODE> 



</BLOCK> 

