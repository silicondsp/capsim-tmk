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
<BLOCK_NAME>sdr</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* sdr.s */
/**********************************************************************
                                sdr()
***********************************************************************
	inputs:		(One channel)
	outputs:	(optional feed-through of input channels)
	parameters:	int npts, the number of points to use 
			int skip, number of points to skip before calculation 
			window flag (0=Rect 1= Hamming)
*************************************************************************
Programmer: 	Sasan Ardalan
Date: 		2/16/89
Modified:	L.J. Faber 1/3/89.  Add flow through; general cleanup.
*/

]]>
</COMMENTS> 

<DESC_SHORT>
Compute signal to distortion ratio
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 
#include <cap_fft.h>
#include <TCL/tcl.h>
]]>
</INCLUDES>

                 

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
		<TYPE>float*</TYPE>
		<NAME>xpts</NAME>
	</STATE>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>ypts</NAME>
	</STATE>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>spect</NAME>
	</STATE>
	<STATE>
		<TYPE>cap_fft_cpx*</TYPE>
		<NAME>cxinBuff</NAME>
	</STATE>
	<STATE>
		<TYPE>cap_fft_cpx*</TYPE>
		<NAME>cxoutBuff</NAME>
	</STATE>
	<STATE>
		<TYPE>cap_fft_cfg</TYPE>
		<NAME>cfg</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>count</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>total_count</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>fftl</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>fftexp</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int samples;
    	int i,j;
	float tmp;
	float wind;
	char title1[80];
  	float sdr,sdrdB;
        float norm;
	char theName[100];
	void calsdr(float xx_A[],float *sdr_P,int points,char* file);
#ifdef TCL_SUPPORT
        Tcl_Obj *varNameObj_P;
        Tcl_Obj *objVar_P;
#endif
</DECLARATIONS> 

           

<PARAMETERS>
<PARAM>
	<DEF>Number of points to collect</DEF>
	<TYPE>int</TYPE>
	<NAME>npts</NAME>
	<VALUE></VALUE>
</PARAM>
<PARAM>
	<DEF>Number of points to skip</DEF>
	<TYPE>int</TYPE>
	<NAME>skip</NAME>
	<VALUE></VALUE>
</PARAM>
<PARAM>
	<DEF>File to store SDR results</DEF>
	<TYPE>file</TYPE>
	<NAME>sdrRes</NAME>
	<VALUE></VALUE>
</PARAM>
<PARAM>
	<DEF>Window: 0=Rect., 1=Hamming</DEF>
	<TYPE>int</TYPE>
	<NAME>windFlag</NAME>
	<VALUE>0</VALUE>
</PARAM>
</PARAMETERS>

<INIT_CODE>
<![CDATA[ 

        /*                                                      
         * allocate arrays                                      
         */                                                     
        xpts = (float* )calloc(npts,sizeof(float));           
        ypts = (float* )calloc(npts,sizeof(float));           
	if(ibufs > 1) {
		fprintf(stderr,"plot: only one  input allowed \n");
		return(5);
	}
	/* store as state the number of input/output buffers */
	if((ibufs = NO_INPUT_BUFFERS()) <= 0) {
		fprintf(stderr,"plot: no inputs connected\n");
		return(2);
	}
	if((obufs = NO_OUTPUT_BUFFERS()) > ibufs) {
		fprintf(stderr,"plot: too many outputs connected\n");
		return(3);
	}
        /*
	 * compute the power of 2 number of fft points
	 */
	fftexp = (int) (log((float)npts)/log(2.0)+0.5);
	fftl = 1 << fftexp;
	if (fftl > npts ) {
		fftl = fftl/2;
		fftexp -= 1;
	}
        spect = (float* )calloc(2*fftl,sizeof(float));           
        cfg=cap_fft_alloc(fftl,0,NULL,NULL);
        if ((cxinBuff = (cap_fft_cpx*)calloc(fftl,sizeof(cap_fft_cpx))) == NULL)
        {
                fprintf(stderr,"cmxfft: can't allocate work space \n");
                return(6);
        }
        if ((cxoutBuff = (cap_fft_cpx*)calloc(fftl,sizeof(cap_fft_cpx))) == NULL)
        {
             fprintf(stderr,"cmxfft: can't allocate work space \n");
             return(7);
        }


]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	for(samples = MIN_AVAIL(); samples > 0; --samples) {
		for(i=0; i<ibufs; ++i) {
	   		IT_IN(i);
			if(obufs > i) {
				if(IT_OUT(i)) {
					KrnOverflow("sdr",i);
					return(99);
				}
	 			OUTF(i,0) = INF(i,0);
			}
	        }

		if(++total_count > skip) {
			for(i=0; i<ibufs; ++i)
           			ypts[npts*i+count] = INF(i,0);

			xpts[count] = total_count - 1;

     			if(++count >= npts) {
                            norm=1.0/(float)fftl;
			    for(i=0; i<fftl; i++) {
			        if(windFlag == 1) 
				/*
				 * Hamming Window
				 */
				  wind= 0.54-0.46*cos(2.*3.1415926*i/(fftl-1));
				else 
				  wind= 1.0;
				       
				cxinBuff[i].r=ypts[i]*wind*norm;
				cxinBuff[i].i = 0.0;
				}

                                cap_fft(cfg,cxinBuff,cxoutBuff);
                                for(i=0; i< fftl; i++) {
                                       spect[2*i]=cxoutBuff[i].r*norm;
                                       spect[2*i+1]=cxoutBuff[i].i*norm;

                                }
				calsdr(spect,&sdr,fftl,sdrRes);
  				if (sdr) sdrdB = 10.*log10(sdr);
 				   else sdrdB = -200.0;
 				fprintf(stderr,"SDR = %e %e (dB) \n",sdr,sdrdB);
				count = 0;
#ifdef TCL_SUPPORT				
     if(krn_TCL_Interp) {

				sprintf(theName,"%s_var",STAR_NAME);
	                        varNameObj_P=Tcl_NewStringObj(theName, strlen(theName));
	                        objVar_P=Tcl_NewObj();
	                        Tcl_SetDoubleObj(objVar_P,sdr);
	                        Tcl_ObjSetVar2(krn_TCL_Interp,varNameObj_P,NULL,objVar_P,TCL_NAMESPACE_ONLY);
       }
#endif				
				
			}
		}
	}

	return(0);


]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 
       free((cap_fft_cpx*)cxinBuff);
        free((cap_fft_cpx*)cxoutBuff);
        free((char*)spect);
                                                                                


]]>
</WRAPUP_CODE> 

<RESULTS>
   <RESULT>
       <NAME>BlockName_sdr</NAME><TYPE>float</TYPE><DESC>The Signal to Distortion(Noise) Ratio</DESC>
   </RESULT>

</RESULTS>



</BLOCK> 

