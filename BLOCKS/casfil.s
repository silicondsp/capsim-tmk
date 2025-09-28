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

casfil 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* casfil.s */
/***********************************************************************
                             casfil()
************************************************************************
Star implements cascade form IIR digital filter.
Parameter: (file) File with the filter coefficients and parameters
The inputs from the file are as follows;
           ns: Number of sections
           zeroSec_A[i] zeroSec2_A[i] i=1 to ns the numerator coefficients
           poleSec1_A[i] poleSec2_A[i] i=1 to ns the denominator coefficients
           in the Z-domain.
Date:  October 15, 1988 
Programmer: Tulay Adali
Modified: Sasan Ardalan
<NAME>
casfil
</NAME>
<DESCRIPTION>
Star implements cascade form IIR digital filter.
Parameter: (file) File with the filter coefficients and parameters
The inputs from the file are as follows;
           ns: Number of sections
           zeroSec_A[i] zeroSec2_A[i] i=1 to ns the numerator coefficients
           poleSec1_A[i] poleSec2_A[i] i=1 to ns the denominator coefficients
           in the Z-domain.
</DESCRIPTION>
<PROGRAMMERS>
Date:  October 15, 1988 
Programmer: Tulay Adali
Modified: Sasan Ardalan
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

             
<DESC_SHORT>
Star implements cascade form IIR digital filter.
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>ycas_A[20]</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>xs_A[3]</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>ys_A[3]</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>poleSec1_A[35]</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>poleSec2_A[35]</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>zeroSec_A[35]</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>zeroSec2_A[35]</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>fs</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>wnorm</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>ns</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>n</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

   	int i,j,jj,jt;
        FILE *ird_F;

</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF>File with cascade filter parameters</DEF>
	<TYPE>file</TYPE>
	<NAME>filename</NAME>
	<VALUE>tmp.cas</VALUE>
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

	/*
	 * open file containing filter coefficients. Check 
	 * to see if it exists.
	 *
	 */
        if( (ird_F = fopen(filename,"r")) == NULL) {
		fprintf(stderr,"Casfil: File could not be opened  \n");
		return(4);
	}
	/*
	 * Read in the filter coefficients and filter parameters.
	 *
	 */
         fscanf(ird_F,"%d",&ns);
      	 for (i=0; i<ns; i++) 
             {
              fscanf(ird_F,"%f %f",&zeroSec_A[i],&zeroSec2_A[i]); 
	     }
      	 for (i=0; i<ns; i++) 
             {
              fscanf(ird_F,"%f %f",&poleSec1_A[i],&poleSec2_A[i]); 
	     }
         fscanf(ird_F,"%f",&fs);  
         fscanf(ird_F,"%f",&wnorm); 
	 for (i=0; i<3; i++)
         {
              xs_A[i] = 0.0;
              ys_A[i] = 0.0;
         }
         for (i=0; i<20; i++){ ycas_A[i]=0.0;}   
              n = 0;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


        while (IT_IN(0))
        {
               for (j=0; j< ns; j++){
                    if (j==0){
                              xs_A[1]=0.0;
                              xs_A[2]=0.0;
                              xs_A[0]=x(0);
                              if (n>0) xs_A[1]=x(1);
                              if (n>1) xs_A[2]=x(2);
                    }
                    if (j>0) { 
                             for (jj=0; jj<3; jj++)
                                           xs_A[jj] = ys_A[jj];
                    }

                    jt = j*3;
                    for (jj=0; jj<2; jj++)  
                        ys_A[jj+1] = ycas_A[jt+jj];

                    ys_A[0]=xs_A[0]+(zeroSec_A[j]*xs_A[1])+(zeroSec2_A[j]*xs_A[2])-(poleSec1_A[j]*ys_A[1])-(poleSec2_A[j]*ys_A[2]);

                    for (jj=0; jj<2; jj++)   
                          ycas_A[jt+jj] = ys_A[jj];
               }

               if(IT_OUT(0)) {
			               KrnOverflow("casfil",0);
			               return(99);
	           }
               y(0) = ys_A[0]/wnorm;
               n = n+1;
        }

        return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

