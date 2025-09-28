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

scrambler 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/***********************************************************
			scrambler()
************************************************************
This routine expects a sequence of input bits (0.0 or 1.0)
and gives as an output another sequence of bits (also 0.0
or 1.0).
The scrambler and descrambler implemented here,
which are self-synchronizing,
are given in the CCITT recommendation V35.
The input parameters are:
mode: The operation done on the input sequence is either scrambling
	(if mode = 0 ) or descrambling (if mode = 1 ).
seed: Can be used to force two scramblers out of phase
	by choosing two values for the seed
<NAME>
scrambler
</NAME>
<DESCRIPTION>
This routine expects a sequence of input bits (0.0 or 1.0)
and gives as an output another sequence of bits (also 0.0
or 1.0).
The scrambler and descrambler implemented here,
which are self-synchronizing,
are given in the CCITT recommendation V35.
The input parameters are:
mode: The operation done on the input sequence is either scrambling
	(if mode = 0 ) or descrambling (if mode = 1 ).
seed: Can be used to force two scramblers out of phase
	by choosing two values for the seed
</DESCRIPTION>
<PROGRAMMERS>
Programmer: O. E. Agazzi / D.G.Messerschmitt
Date: March 31, 1982.
Converted to V2.0 by DGM March 11, 1985
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

   
<DESC_SHORT>
The scrambler and descrambler implemented here,which are self-synchronizing, are given in the CCITT recommendation V35.
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>long</TYPE>
		<NAME>shift_reg</NAME>
		<VALUE>seed</VALUE>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	long output_bit;
	int	no_samples;

</DECLARATIONS> 

       

<PARAMETERS>
<PARAM>
	<DEF>mode: The operation done on the input sequence is either scrambling,mode = 0,or descrambling,mode = 1.</DEF>
	<TYPE>int</TYPE>
	<NAME>mode</NAME>
	<VALUE></VALUE>
</PARAM>
<PARAM>
	<DEF>seed: Can be used to force two scramblers out of phase by choosing two values for the seed.</DEF>
	<TYPE>int</TYPE>
	<NAME>seed</NAME>
	<VALUE>12</VALUE>
</PARAM>
</PARAMETERS>

    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>bitin</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
    

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>bitout</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

		/* error if mode not zero or one */
		if(mode != 0 && mode != 1)
			return(1);

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) {

		IT_IN(0);
		/* error if bitin(0) not zero or one */
		if((bitin(0) != (float) 0) && (bitin(0) != (float) 1))
			return(2);

		/* algorithms are slightly different for scrambling
		   and descrambling */
		if(mode == 0) { /* scrambling desired */
			
			/* generate next output bit */
			output_bit = (((shift_reg>>2)&1) +
			 	((shift_reg>>19)&1) + 1 + (long) bitin(0));
			output_bit = output_bit & 1;

			/* generate next shift register state */
			shift_reg = (shift_reg << 1) | output_bit;
			}

		else {  /* descrambling desired */

			/* generate next shift register state */
			shift_reg = (shift_reg<<1)|(long) bitin(0);

			/* generate next output bit */
			output_bit = (((shift_reg >> 3) & 1) + 1 +
		  	  ((shift_reg>>20)&1) + (shift_reg&1))%2;
			}

		if(IT_OUT(0)) {
			KrnOverflow("scrambler",0);
			return(99);
		}
		bitout(0) = (float) (output_bit == 0);
		}

	return(0);


]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

