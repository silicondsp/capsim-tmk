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

freqimp 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*
 *
<NAME>
freqimp
</NAME>
<DESCRIPTION>
Calculate impulse response from frequency response
</DESCRIPTION>
<PROGRAMMERS>
Sasan H. Ardalan
</PROGRAMMERS>
 *
 */

]]>
</COMMENTS> 

      
<DESC_SHORT>
Calculate impulse response from frequency response
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>freqRes_A</NAME>
	</STATE>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>impRes_A</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numSamples</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>conj</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int 	i;
	int	j;
	void Dsp_FreqImp(float freqRes1_A[],int nfft1,float impRes1_A[]);


</DECLARATIONS> 

       

<PARAMETERS>
<PARAM>
	<DEF>Number of frequency points  to input</DEF>
	<TYPE>int</TYPE>
	<NAME>nfft</NAME>
	<VALUE>64</VALUE>
</PARAM>
<PARAM>
	<DEF>Conjugatate (0=No, 1=Yes)</DEF>
	<TYPE>int</TYPE>
	<NAME>conjFlag</NAME>
	<VALUE>0</VALUE>
</PARAM>
</PARAMETERS>

    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>xfreq</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
    

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>ximp</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

	numSamples=0;
	/*
	 * Allocate array for frequency response 
	 */
	freqRes_A= (float *)malloc(nfft*sizeof(float));
	if(freqRes_A==NULL) {
		fprintf(stderr,"Unable to allocate space in freqimp block \n");
		return(1);
	}
	/*
	 * Allocate array for impulse response
	 */
	impRes_A= (float *)malloc(2*nfft*sizeof(float));
	if(impRes_A==NULL) {
		fprintf(stderr,"Unable to allocate space in freqimp block \n");
		return(2);
	}
	if (conjFlag) conj= -1.0;
		else conj = 1.0;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

for (j = MIN_AVAIL(); j > 0; --j) {
	/*
	 * Get frequency response 
	 */

	IT_IN(0);
	freqRes_A[numSamples]=xfreq(0);
	numSamples++;
	/*
	 * Check if nfft samples read in
	 */
	if(numSamples == 2*nfft) {
		for(i=0; i<nfft; i++)
		   freqRes_A[2*i+1] = conj*freqRes_A[2*i+1];	

		/*
		 * Compute impulse response
		 */

		Dsp_FreqImp(freqRes_A,nfft,impRes_A);

		/* 
 		 *  Output Impulse response
 	 	 */
		for (i=0; i<2*nfft; i++) {
			if(IT_OUT(0)) {
				KrnOverflow("freqimp",0);
				return(99);
			}
			ximp(0)=impRes_A[i];
		numSamples=0;
		}
	}
}

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

	free(impRes_A);
	free(freqRes_A);

]]>
</WRAPUP_CODE> 



</BLOCK> 

