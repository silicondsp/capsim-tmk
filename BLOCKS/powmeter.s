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

powmeter 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* powmeter.s */
/******************************************************************
			powmeter() 
*******************************************************************
This star is an averaging logarithmic power meter, which can be
connected either in-line or terminating.
If an output is connected, input 0 is passed through unchanged.  
If no output is connected, the signal is absorbed (like sink).
The star computes 10*log10(square) of the signal at input 0, and
(optionally) compares it to another signal at input 1.
If no signal is connected to input 1, power is referenced to unity.
This star ultimately prints an ASCII file with the power results.
	Parameter 1: (file) name of output file; default => powfile
		  2: (int) number of samples to average; default => 1
<NAME>
powmeter
</NAME>
<DESCRIPTION>
This star is an averaging logarithmic power meter, which can be
connected either in-line or terminating.
If an output is connected, input 0 is passed through unchanged.  
If no output is connected, the signal is absorbed (like sink).
The star computes 10*log10(square) of the signal at input 0, and
(optionally) compares it to another signal at input 1.
If no signal is connected to input 1, power is referenced to unity.
This star ultimately prints an ASCII file with the power results.
	Parameter 1: (file) name of output file; default => powfile
		  2: (int) number of samples to average; default => 1
</DESCRIPTION>
<PROGRAMMERS>
Programmer: 	L.J. Faber
Date:		May 1988
Modified:	9/88  output to stdout if desired
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This star is an averaging logarithmic power meter, which can be connected either in-line or terminating.
</DESC_SHORT>
         

<STATES>
	<STATE>
		<TYPE>FILE*</TYPE>
		<NAME>fp</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>count</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>ibufs</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>obufs</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>sumxsq</NAME>
		<VALUE>0.</VALUE>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>sumysq</NAME>
		<VALUE>0.</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>stdflag</NAME>
		<VALUE>0</VALUE>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i,j;
	float xval;
	float yval;
	float power;

</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF></DEF>
	<TYPE>file</TYPE>
	<NAME>powfile_name</NAME>
	<VALUE>powfile</VALUE>
</PARAM>
<PARAM>
	<DEF></DEF>
	<TYPE>int</TYPE>
	<NAME>N</NAME>
	<VALUE>1</VALUE>
</PARAM>
</PARAMETERS>

<INIT_CODE>
<![CDATA[ 

	if( (ibufs = NO_INPUT_BUFFERS()) < 1 || ibufs > 2) {
		fprintf(stderr,"powmeter: input buffer count\n");
		return(1);
	}
	if( (obufs = NO_OUTPUT_BUFFERS()) > 1) {
		fprintf(stderr,"powmeter: output buffer count\n");
		return(2);
	}
	if(N < 1) {
		fprintf(stderr,"powmeter: improper parameter N\n");
		return(3);
	}
	if(strncmp(powfile_name,"std",3) == 0) {
		fp = stdout;
		stdflag = 1;
	}
	else if( (fp = fopen(powfile_name, "w")) == NULL ) {
		fprintf(stderr,"powmeter: can't open output file\n");
		return(4);
	}

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	for(i=MIN_AVAIL();i>0; --i) {
		IT_IN(0);
		xval = INF(0,0);
		sumxsq += xval * xval;
		if(ibufs == 2) {
			IT_IN(1);
			yval = INF(1,0);
			sumysq += yval * yval;
		}
		else sumysq = N;
		if(++count == N) {
			count = 0;
			if(sumxsq <= 0) sumxsq = 1e-12;
			if(sumysq <= 0) sumysq = 1e-12;
			power = 10.*log10(sumxsq/sumysq);
			fprintf(fp,"%#.3g\n",power);
			sumxsq = sumysq = 0;
		}
		/* optional output */
		if(obufs) {
			if(IT_OUT(0)) {
				KrnOverflow("powmeter",0);
				return(99);
			}
			OUTF(0,0) = xval;
		}
	}
	return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

	if(!stdflag) fclose(fp);

]]>
</WRAPUP_CODE> 



</BLOCK> 

