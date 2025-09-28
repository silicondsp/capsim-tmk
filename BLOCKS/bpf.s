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

bpf 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* bpf.s */
/***********************************************************************
                             bpf()
************************************************************************
Star implements a band pass IIR digital filter.
Parameters ; 
             fs: sampling frequency
             freq: resonant frequency
	     ro: magnitude of the pole (less than one, for stability)
                 ( Q increases when magnitude of the pole approaches
                  to the unit circle, i.e. when ro is close to one.)
Date:  November 23, 1988
Mod:   November 29, 1988 (Another zero ,at -1, is added.) 
Programmer:  Tulay ADALI
<NAME>
bpf
</NAME>
<DESCRIPTION>
Star implements a band pass IIR digital filter.
Parameters ; 
             fs: sampling frequency
             freq: resonant frequency
	     ro: magnitude of the pole (less than one, for stability)
                 ( Q increases when magnitude of the pole approaches
                  to the unit circle, i.e. when ro is close to one.)
</DESCRIPTION>
<PROGRAMMERS>
Date:  November 23, 1988
Mod:   November 29, 1988 (Another zero ,at -1, is added.) 
Programmer:  Tulay ADALI
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
Star implements a band pass IIR digital filter.
</DESC_SHORT>

<INCLUDES>
<![CDATA[ 

#include <math.h>

]]>
</INCLUDES> 

<DEFINES> 

#define PI 3.1415926

</DEFINES> 

    

<STATES>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>xs[3]</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>ys[3]</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

   	int i;
        float tetha;
	int	 no_samples;

</DECLARATIONS> 

         

<PARAMETERS>
<PARAM>
	<DEF>Sampling Frequency</DEF>
	<TYPE>float</TYPE>
	<NAME>fs</NAME>
	<VALUE>8000.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Center Frequency</DEF>
	<TYPE>float</TYPE>
	<NAME>freq</NAME>
	<VALUE>1000.0</VALUE>
</PARAM>
<PARAM>
	<DEF><![CDATA[Modulus: determines Q. Must be <  1.0]]></DEF>
	<TYPE>float</TYPE>
	<NAME>ro</NAME>
	<VALUE>0.99</VALUE>
</PARAM>
</PARAMETERS>

    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>x</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
    

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>y</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

         for (i=0; i<3; i++)
             {
              xs[i] = 0.0; 
              ys[i] = 0.0; 
             }
              tetha=0.0;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) {
       		IT_IN(0);
                tetha = (2.0* (PI * freq) ) / fs;
		xs[0] = x(0);
               /*
                *
                * Calculate the next output.
                *
                */
                ys[0] = xs[0]-xs[2]+2.0*ro*cos(tetha)*ys[1]-ro*ro*ys[2];  
                if(IT_OUT(0)) {
			KrnOverflow("bpf",0);
			return(99);
		}
                y(0)=ys[0];
                xs[2] = xs[1];
		xs[1] = xs[0];
                ys[2] = ys[1];
                ys[1] = ys[0];
               }
        return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

