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

dec_qpsk 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/**********************************************************************
				dec_qpsk
 *********************************************************************
Description:
This block inputs constellation points and decods them into a bit stream.
It is assumed that the constellation was produced by qpsk.s.
Not  efficient but illustrative.
<NAME>
dec_qpsk
</NAME>
<DESCRIPTION>
This block inputs constellation points and decods them into a bit stream.
It is assumed that the constellation was produced by qpsk.s.
</DESCRIPTION>
<PROGRAMMERS>
Progrramer: Sasan Ardalan
Date: Dec 14, 2000
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This block inputs constellation points and decods them into a bit stream. It is assumed that the constellation was produced by qpsk.s.
</DESC_SHORT>


<DECLARATIONS> 

	int	i,k,j,jj;
	static float a_A[4]= {1,1,-1,-1};
	static float b_A[4]= {1,-1,1,-1};
	float x,y;
        float d,dmin;
        int index;
        float b0,b1;

</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF>Normalizing Gain</DEF>
	<TYPE>float</TYPE>
	<NAME>gain</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
</PARAMETERS>

     

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>id</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>qd</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
    

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>bits</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 


]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


       for(jj=(MIN_AVAIL());jj >0; --jj)
       {
                IT_IN(0);
                IT_IN(1);
		x=id(0)*gain;
                y=qd(0)*gain;
                dmin=10000.0;
                index=0;
                for(i=0; i<4; i++) {
                    d=sqrt((x-a_A[i])*(x-a_A[i])+(y-b_A[i])*(y-b_A[i]));
                    if ( d <dmin) {
                            dmin=d;
                            index=i;
                    }
                }
                switch (index) {
                    case 0:
                       b0=0;
                       b1=0;
                       break;
                    case 1:
                       b0=1;
                       b1=0;
                       break;
                    case 2:
                       b0=0;
                       b1=1;
                       break;
                    case 3:
                       b0=1;
                       b1=1;
                       break;
                }

  		if(IT_OUT(0)) {
				KrnOverflow("dec_qpsk",0) ;
				return(99);
		}
                bits(0)=b1;

  		if(IT_OUT(0)) {
				KrnOverflow("dec_qpsk",0) ;
				return(99);
		}
                bits(0)=b0;


		
	}
	return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

