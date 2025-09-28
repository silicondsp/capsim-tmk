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

linecode 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/**********************************************************************
                linecode()
***********************************************************************
Description:
This star inputs 0/1 binary data and outputs various line codes.
Line codes are selectable by the first input parameter `code_type':
	0 - Binary (NRZ) (1 = +1, 0 = -1)  (Default; 1 phase)
	1 - Biphase (Manchester) (1 = -1,+1; 0 = +1,-1)  (2 phase)
	2 - 2B1Q  (00 = -3, 01 = -1, 10 = +1, 11 = +3)  (1 phase)
	3 - RZ-AMI (Alternate mark inversion)
The code output oversampling rate (samples per baud interval) is
selected by the second parameter `smplbd'.  Note that multi-phase
codes require oversampling rates which are integer multiples of the
number of phases!
I/O buffers are float to be compatible with most stars.
Output buffer 0: Over sampled symbols.
Output buffer 1 (optional): symbols at baud rate.
Programmer:  L.J. Faber
Date: 11/25/86
Modified: 4/18/88 add 2B1Q
Modified: 5/88 add output1 as coded symbols, not oversampled
Modified: 6/88 change oversampling method to zero fill
<NAME>
linecode
</NAME>
<DESCRIPTION>
This star inputs 0/1 binary data and outputs various line codes.
Line codes are selectable by the first input parameter `code_type':
	0 - Binary (NRZ) (1 = +1, 0 = -1)  (Default; 1 phase)
	1 - Biphase (Manchester) (1 = -1,+1; 0 = +1,-1)  (2 phase)
	2 - 2B1Q  (00 = -3, 01 = -1, 10 = +1, 11 = +3)  (1 phase)
	3 - RZ-AMI (Alternate mark inversion)
The code output oversampling rate (samples per baud interval) is
selected by the second parameter `smplbd'.  Note that multi-phase
codes require oversampling rates which are integer multiples of the
number of phases!
I/O buffers are float to be compatible with most stars.
Output buffer 0: Over sampled symbols.
Output buffer 1 (optional): symbols at baud rate.
</DESCRIPTION>
<PROGRAMMERS>
Programmer:  L.J. Faber
Date: 11/25/86
Modified: 4/18/88 add 2B1Q
Modified: 5/88 add output1 as coded symbols, not oversampled
Modified: 6/88 change oversampling method to zero fill
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

           
<DESC_SHORT>
This star inputs 0/1 binary data and outputs various line codes (NRZ,Biphase Manchester,2B1Q,RZ-AMI).
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>template</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>even</NAME>
		<VALUE>1</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>oneState</NAME>
		<VALUE>-1</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberOutputBuffers</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>sample_A[25]</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>overFlowBuffer_A[25]</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>overFlowIndex</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>overFlowCodeValue</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>overFlow</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i;
	int j;
	int sign;
	int mag;
	int code_val;
	int no_samples;

</DECLARATIONS> 

       

<PARAMETERS>
<PARAM>
	<DEF>Code type:0-Binary(NRZ),1-Biphase(Manchester),2-2B1Q,3-RZ-AMI(Alternate mark inversion)</DEF>
	<TYPE>int</TYPE>
	<NAME>code_type</NAME>
	<VALUE>0</VALUE>
</PARAM>
<PARAM>
	<DEF>Samples per baud</DEF>
	<TYPE>int</TYPE>
	<NAME>smplbd</NAME>
	<VALUE>8</VALUE>
</PARAM>
</PARAMETERS>

     

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>bindata</NAME>
		<DELAY><TYPE>max</TYPE><VALUE_MAX>1</VALUE_MAX></DELAY>
	</BUFFER>
</INPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

	if((template = (float*)calloc(smplbd, sizeof(float))) == NULL) {
		fprintf(stderr, "linecode: cannot allocate space\n");
		return(1);
	}
	if((code_type == 0) || (code_type == 3)) {	/* Binary */
		template[0] = 1.;
	}
	else if(code_type == 1) {	/* Biphase */
		if(smplbd%2 != 0) {
			fprintf(stderr,
				"linecode: oversample rate not \
					compatible with code type\n");
			return(1);
		}
		template[0] = -1.;
		template[smplbd/2] = 1.;
	}
	else if(code_type == 2) {	/* 2B1Q */
		template[0] = 1.;
	}
	else {
		fprintf(stderr,"linecode: unrecognized code type\n");
		return(2);
	}
        numberOutputBuffers = NO_OUTPUT_BUFFERS();
	if(numberOutputBuffers == 0) {
                fprintf(stderr,"linecode: no output buffers connected \n");
                return(3);
        }	
	overFlow=FALSE;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


 for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) {
		IT_IN(0);
		if(code_type == 2) {
			even = ++even % 2;
			if(even) {
				mag = 1;
				if(bindata(0) == bindata(1)) mag = 3;	
				sign = -1;
				if(bindata(0) > 0.5) sign = 1;
			}
			else   continue;
		}
		else if (code_type == 3) {
			if (bindata(0)) {
				oneState = -1*oneState;
				sign = oneState;
				mag = 1.0;
			} else {
				mag = 0.0;
			}
		}
		else 	{	/* other code types */
			mag = 1;
			sign = -1;
			if(bindata(0) > 0.5) sign = 1;
		}

		code_val = sign * mag;
		for(i=0; i<smplbd; i++) {
			if(overFlow) {
			   for(j=overFlowIndex; j<smplbd; j++) {
				if(IT_OUT(0)) {
					KrnOverflow("linecode",0);
					return(99); 
				}
				OUTF(0,0) = overFlowCodeValue * template[j];
				overFlow=FALSE;
			   }
			}
				
			if(IT_OUT(0)) {
				overFlowIndex=i;
				overFlowCodeValue=code_val;
				overFlow=TRUE;
				fprintf(stderr,"linecode: Buffer 0 is full \n");
				return(0);
			}
			OUTF(0,0) = code_val * template[i];
		}
                if( numberOutputBuffers == 2 ) {
			if(IT_OUT(1)) {
				KrnOverflow("linecode",1);
				return(99); 
			}
                        OUTF(1,0) =code_val;
		}
	}

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

	free(template);

]]>
</WRAPUP_CODE> 



</BLOCK> 

