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

sampler1 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* sampler1.s */
/**************************************************************
			sampler1.s 
****************************************************************
	Inputs:	x, the data stream
		clock, the triggering clock
	Output: y, the sampled version of x
****************************************************************
This block simulates a sampler circuit. 
Triggering is on the positive edge of the clock. 
<NAME>
sampler1
</NAME>
<DESCRIPTION>
This block simulates a sampler circuit. 
Triggering is on the positive edge of the clock. 
	Inputs:	x, the data stream
		clock, the triggering clock
	Output: y, the sampled version of x
</DESCRIPTION>
<PROGRAMMERS>
Programmer: Jaejin Lee	
Date:       1/18/1990
Modified:   3/1/1990, add phase recording file
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

        
<DESC_SHORT>
This block simulates a sampler circuit.  Triggering is on the positive edge of the clock. 
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>FILE*</TYPE>
		<NAME>fp</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>count</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>done</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>inbufs</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>outbufs</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>stdflag</NAME>
		<VALUE>0</VALUE>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int phase;
	int no_samples;

</DECLARATIONS> 

       

<PARAMETERS>
<PARAM>
	<DEF>Enter phase recording file, none if no recording</DEF>
	<TYPE>file</TYPE>
	<NAME>phfile_name</NAME>
	<VALUE>phfile</VALUE>
</PARAM>
<PARAM>
	<DEF>Enter frame number</DEF>
	<TYPE>int</TYPE>
	<NAME>frame</NAME>
	<VALUE>8</VALUE>
</PARAM>
</PARAMETERS>

     

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>x</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>clock</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

        if((inbufs = NO_INPUT_BUFFERS()) != 2
             || (outbufs = NO_OUTPUT_BUFFERS()) != 1) {
          fprintf(stderr,"sampler: i/o buffers connect problem\n");
          return(1);
  	}
        if(frame < 1) {
                fprintf(stderr,"sampler: improper frame number\n");
                return(2);
        }
        if(strncmp(phfile_name,"std",3) == 0) {
                fp = stdout;
                stdflag = 1;
        }
        else if(strncmp(phfile_name,"none",4) == 0) {
                stdflag = -1;
        }
        else if( (fp = fopen(phfile_name, "w")) == NULL ) {
                fprintf(stderr,"sampler: can't open output file\n");
                return(3);
        }

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

 
	/* note the minimum number of samples on the input 	*/
	/* buffers and iterate that many times 			*/
	
	for(no_samples=MIN_AVAIL(); no_samples >0; --no_samples) 
	{
		IT_IN(0);	
		IT_IN(1);	
 		
		phase = count % frame;

		if (phase == 0) {
		   done = 0;
		}
		if ((done == 0) && (clock(0) > 0.5)) {
		   done = 1;
		   if(IT_OUT(0)) {
			KrnOverflow("sampler1",0);
			return(99);
		   }
		   OUTF(0,0) = x(0);
		   if (stdflag >= 0) fprintf(fp,"%d\n",phase);
		}
		if ((done == 0) && (phase == (frame - 1))) {
		   if(IT_OUT(0)) {
			KrnOverflow("sampler1",0);
			return(99);
		   }
		   OUTF(0,0) = x(0);
		   if (stdflag >= 0) fprintf(fp,"%d\n",phase);
		}
		count = phase + 1;
	}
	return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

        if(!stdflag && stdflag > 0) fclose(fp);

]]>
</WRAPUP_CODE> 



</BLOCK> 

