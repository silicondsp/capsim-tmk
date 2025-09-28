<BLOCK>
<LICENSE>
/*  Capsim (r) Text Mode Kernel (TMK) Star Library (Blocks)
    Copyright (C) 1989-2018  Silicon DSP Corporation 

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
 */
</LICENSE>
<BLOCK_NAME>

buildvec 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* buildvec.s */
/**********************************************************************
			buildvec()
***********************************************************************
<NAME>
buildvec
</NAME>
<DESCRIPTION>
Block collects a sample from  all its input samples to yield an output vector with the samples.
The number of input buffers is arbitrary and determined at run time.
The number of output buffers is also arbitrary (auto-fanout).
</DESCRIPTION>
<PROGRAMMERS>
Programmer: D.G.Messerschmitt March 7, 1985
Modified: 1/89 ljfaber. add auto-fanout
ModifiedL March 4, 2018 converted auto fan-in adder to buildvec.
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<INCLUDES>
<![CDATA[

#include "buffer_types.h"


]]>
</INCLUDES>
    
<DESC_SHORT>
Block collects a sample from  all its input samples to yield an output vector with the samples.
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>ibufs</NAME>
	</STATE>
	
	<STATE>
		<TYPE>int</TYPE>
		<NAME>obufs</NAME>
	</STATE>
	
    <STATE>
		<TYPE>doubleVector_t*</TYPE>
		<NAME>theVector_P</NAME>
	</STATE>	
</STATES>
 
<DECLARATIONS> 

	int i,j,k;
	int samples;
	float sample_out;
	doubleVector_t* newVector_P;

</DECLARATIONS> 

   
<INIT_CODE>
<![CDATA[ 

	/* store as state the number of input/output buffers */
	if((ibufs = NO_INPUT_BUFFERS()) < 1) {
		fprintf(stderr,"add: no input buffers\n");
		return(2);
	}
	if((obufs = NO_OUTPUT_BUFFERS()) < 1) {
		fprintf(stderr,"add: no output buffers\n");
		return(3);
	}
	
	
	for(k=0; k< obufs; k++)
	     SET_CELL_SIZE_OUT(k,sizeof(doubleVector_t));
	

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	/* read one sample from each input buffer and add them */
	for(samples = MIN_AVAIL(); samples >0; --samples) {

		sample_out = 0;
        /*
         * allocate a  new vector (Note better to setup a subroutine but we want to show all).
         */
         newVector_P= (doubleVector_t*) calloc(1, sizeof(doubleVector_t));
	     if(newVector_P==NULL) {
	           fprintf(stderr,"buildvec could not allocate space.\n");
	           return(1);
	     }
     
	     newVector_P->length=ibufs;
	     newVector_P->vector_P=(double *) calloc(ibufs, sizeof(double));
	     if(newVector_P->vector_P==NULL) {
	           fprintf(stderr,"buildvec could not allocate space.\n");
	            return(1);
	     }



		for(i=0; i<ibufs; ++i) {
			IT_IN(i);
			newVector_P->vector_P[i]=(double)INF(i,0);
			
		}
		for(i=0; i<obufs; i++) {
			if(IT_OUT(i)) {
				fprintf(stderr,"buildvec: Buffer %d is full\n",i);
				return(1);
			}
			OUTVEC(i,0) = *newVector_P;
		}
	}

	return(0);	/* at least one input buffer empty */


]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

