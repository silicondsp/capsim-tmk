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

iirfil 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* iirfil.s */
/***********************************************************************
                             iirfil()
************************************************************************
This block designs and implements a cascade form IIR digital filter.
The specs and results of the design are stored in the file tmp.dat.
The cascade filter coefficients are store in a file tmp.cas as:
           ns: Number of sections
           zc1[i] zc2[i] i=1 to ns the numerator coefficients
           pc1[i] pc2[i] i=1 to ns the denominator coefficients
           in the Z-domain.
<NAME>
iirfil
</NAME>
<DESCRIPTION>
This block designs and implements a cascade form IIR digital filter.
The specs and results of the design are stored in the file tmp.dat.
The cascade filter coefficients are store in a file tmp.cas as:
           ns: Number of sections
           zc1[i] zc2[i] i=1 to ns the numerator coefficients
           pc1[i] pc2[i] i=1 to ns the denominator coefficients
           in the Z-domain.
</DESCRIPTION>
<PROGRAMMERS>
Date:  October 28, 1989 
Programmer: Sasan Ardalan.
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This block designs and implements a cascade form IIR digital filter.
</DESC_SHORT>
<INCLUDES>
<![CDATA[ 

#include "dsp.h"

]]>
</INCLUDES> 

<DEFINES> 

#define LOW_PASS 1
#define HIGH_PASS 2
#define BAND_PASS 3
#define BAND_STOP 4

</DEFINES> 

             

<STATES>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>ycas[20]</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>xs[3]</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>ys[3]</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>pc1[35]</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>pc2[35]</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>zc1[35]</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>zc2[35]</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>fsamp</NAME>
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
	int status;
	int	no_samples;
	char fname[100];
        FILE *fopen();
        FILE *ird_F;
        int IIRCas(char* name11);
        void PzConv(char* name);

</DECLARATIONS> 

                           

<PARAMETERS>
<PARAM>
	<DEF>1=Butterworth,2=Chebyshev,3=Elliptic</DEF>
	<TYPE>int</TYPE>
	<NAME>desType</NAME>
	<VALUE>3</VALUE>
</PARAM>
<PARAM>
	<DEF>1=LowPass,2=HighPass,3=BandPass,4=BandStop</DEF>
	<TYPE>int</TYPE>
	<NAME>filterType</NAME>
	<VALUE>1</VALUE>
</PARAM>
<PARAM>
	<DEF>Sampling Frequency, Hz</DEF>
	<TYPE>float</TYPE>
	<NAME>fs</NAME>
	<VALUE>32000.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Enter Passband Ripple in dB's</DEF>
	<TYPE>float</TYPE>
	<NAME>pbdb</NAME>
	<VALUE>0.1</VALUE>
</PARAM>
<PARAM>
	<DEF>Enter Stopband Attenuation in dB's</DEF>
	<TYPE>float</TYPE>
	<NAME>sbdb</NAME>
	<VALUE>35.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Passband Freq. Hz/LowPass/HighPass Only</DEF>
	<TYPE>float</TYPE>
	<NAME>fpb</NAME>
	<VALUE>3400.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Stopband Freq. Hz/LowPass/HighPass Only</DEF>
	<TYPE>float</TYPE>
	<NAME>fsb</NAME>
	<VALUE>4400.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Lower Passband Freq. Hz/BandPass/BandStop Only</DEF>
	<TYPE>float</TYPE>
	<NAME>fpl</NAME>
	<VALUE>220.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Upper Passband Freq. Hz/BandPass/BandStop Only</DEF>
	<TYPE>float</TYPE>
	<NAME>fpu</NAME>
	<VALUE>3400.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Lower Stopband Freq. Hz/BandPass/BandStop Only</DEF>
	<TYPE>float</TYPE>
	<NAME>fsl</NAME>
	<VALUE>10.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Upper Stopband Freq. Hz/BandPass/BandStop Only</DEF>
	<TYPE>float</TYPE>
	<NAME>fsu</NAME>
	<VALUE>4400.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Filter Name</DEF>
	<TYPE>file</TYPE>
	<NAME>filterName</NAME>
	<VALUE>tmp</VALUE>
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

	switch(filterType) {
	    case LOW_PASS:
		if(fpb >= fsb) {
		   fprintf(stderr,"iirfil:Low pass stop band frequency lower \
			\n than or equal to pass band. \n");
		   return(4);
		}
	 	break;
	    case HIGH_PASS:
		if(fpb <= fsb) {
		   fprintf(stderr,"iirfil:High pass stop band frequency \
			\n heigher than or equal to pass band. \n");
		   return(4);
		}
	 	break;
	    case BAND_PASS:
		if((fpl >= fpu) || (fpl <=fsl) || (fpu >= fsu) || (fsl >=fsu)){
		   fprintf(stderr,"iirfil: Band pass filter spec error.  \n");
		   return(4);
		}
		break;
	    case BAND_STOP:
		if((fpl >= fpu) || (fpl >=fsl) || (fpu <= fsu) || (fsl >=fsu)) {
		   fprintf(stderr,"iirfil: Band pass filter spec error.  \n");
		   return(4);
		}
		break;
	}
	/*
	 * Design the IIR filter.
	 * Put poles and Zeroes in file tmp.pz .
	 */
	status =IIRDesign(filterName,fs,fpb,fsb,fpl,fpu,fsl,fsu,
					pbdb,sbdb,filterType,desType);
	if (status) {
		fprintf(stderr,"Design Error in IIRDesign. \n");
		return(4);
	}
	/*
	 * Generate cascade coefficients from file tmp.pz
	 * Store in filterName.cas 
  	 */
	status=IIRCas(filterName);
	if (status) {
		fprintf(stderr,"Design Error in iircas cascade calc. \n");
		return(4);
	}
	/*
  	 * produce compact version of filterName.pz file
	 * store it in filterName.pz, i.e. overwrite filterName.pz
	 */
	PzConv(filterName);
	/*
	 * open file containing filter coefficients. Check 
	 * to see if it exists.
	 *
	 */
	strcpy(fname,filterName);
	strcat(fname,".cas");
        if( (ird_F = fopen(fname,"r")) == NULL) {
		fprintf(stderr,"iirfil: File tmp.cas could not be opened  \n");
		return(4);
	}
	/*
	 * Read in the filter coefficients and filter parameters.
	 *
	 */
         fscanf(ird_F,"%d",&ns);
      	 for (i=0; i<ns; i++) 
             {
              fscanf(ird_F,"%f",&zc1[i]); 
              fscanf(ird_F,"%f",&zc2[i]); 
	     }
      	 for (i=0; i<ns; i++) 
             {
              fscanf(ird_F,"%f",&pc1[i]); 
              fscanf(ird_F,"%f",&pc2[i]); 
	     }
         fscanf(ird_F,"%f",&fsamp);  
         fscanf(ird_F,"%f",&wnorm); 
         for (i=0; i<3; i++)
             {
              xs[i] = 0.0; 
              ys[i] = 0.0; 
             }
         for (i=0; i<20; i++){ ycas[i]=0.0;}   
              n = 0;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) {
               IT_IN(0);
               for (j=0; j< ns; j++){
                    if (j==0){
                              xs[1]=0.0;
                              xs[2]=0.0;
                              xs[0]=x(0);
                              if (n>0) xs[1]=x(1);
                              if (n>1) xs[2]=x(2);
                             }
                    if (j>0) { 
                             for (jj=0; jj<3; jj++)
                                           xs[jj] = ys[jj];
                    }

               jt = j*3;
               for (jj=0; jj<2; jj++)  
                     ys[jj+1] = ycas[jt+jj];

               ys[0]=xs[0]+(zc1[j]*xs[1])+(zc2[j]*xs[2])-(pc1[j]*ys[1])-(pc2[j]*ys[2]);

               for (jj=0; jj<2; jj++)   
                    ycas[jt+jj] = ys[jj];
               }

               if(IT_OUT(0)) {
			KrnOverflow("iirfil",0);
			return(99);
		}
               y(0) = ys[0]/wnorm;
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

