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
<BLOCK_NAME>ecountfap</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/**********************************************************************
                ecountfap()
***********************************************************************
"error counter"
This block compares two data streams for "equality".  (Since the input
streams are floating point, a guard band is used.) An output stream
is created, with 'zero' output for equality, and 'one' if there is a
difference.  (Note: the output stream is optional--if no block is
connected to the output, there is no output.)
Param. 1 selects an initial number of samples to be ignored for
the final error tally (used during training sequences); default zero.
Param 2 sets an index, after which a message is printed to stderr for
each error.  It defaults to "infinity", i.e. no error messages.
This block prints a final message to stderr giving the error rate
(errors/smpl), disregarding the initial ignored samples.
<NAME>
ecountfap
</NAME>
<DESCRIPTION>
"error counter"
This block compares two data streams for "equality".  (Since the input
streams are floating point, a guard band is used.) An output stream
is created, with 'zero' output for equality, and 'one' if there is a
difference.  (Note: the output stream is optional--if no block is
connected to the output, there is no output.)
Param. 1 selects an initial number of samples to be ignored for
the final error tally (used during training sequences); default zero.
Param 2 sets an index, after which a message is printed to stderr for
each error.  It defaults to "infinity", i.e. no error messages.
This block prints a final message to stderr giving the error rate
(errors/smpl), disregarding the initial ignored samples.
This block appends results to file. Useful for BER in batch mode.
</DESCRIPTION>
<PROGRAMMERS>
Programmer: L.J. Faber 
Date: Dec 1987
Modified: April 1988
Modified: May 1988--Fix report print
Modified: June 1988--Fix report print
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This block compares two data streams for "equality" (use for BER). Appends to file.
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 

#include <math.h>
#include <stdio.h>
#include <TCL/tcl.h>

]]>
</INCLUDES> 



<DEFINES> 

#define GBAND 0.001	/* guard band for equality */

</DEFINES> 

       

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>samples</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>error_count</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>hits</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>obufs</NAME>
	</STATE>
	<STATE>
		<TYPE>FILE*</TYPE>
		<NAME>fp</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i,j;
	int numin;
	int err_out;
	char theVar[100];
	char theName[100];
#ifdef TCL_SUPPORT
        Tcl_Obj *varNameObj_P;
        Tcl_Obj *objVar_P;
#endif	

</DECLARATIONS> 

         

<PARAMETERS>
<PARAM>
	<DEF>Number of samples to ignore for final error tally</DEF>
	<TYPE>int</TYPE>
	<NAME>ignore</NAME>
	<VALUE>0</VALUE>
</PARAM>
<PARAM>
	<DEF>Index after which each error is printed to terminal</DEF>
	<TYPE>int</TYPE>
	<NAME>err_msg</NAME>
	<VALUE>30000</VALUE>
</PARAM>
<PARAM>
	<DEF>File name to append results</DEF>
	<TYPE>file</TYPE>
	<NAME>fileName</NAME>
	<VALUE>ecount.dat</VALUE>
</PARAM>
</PARAMETERS>

     

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>w</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>x</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

        fp=fopen(fileName,"a");
       if(!fp) {
          fprintf(stderr, "ecountfap: could not open file : %s for append\n",fileName);
          return(2);
       }
	obufs = NO_OUTPUT_BUFFERS();

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	numin = MIN_AVAIL();
	for(i=0; i<numin; i++) {
		IT_IN(0);
		IT_IN(1);
		err_out = 0;
		if(w(0) > x(0) + GBAND || w(0) < x(0) - GBAND ) {
			hits++;
			if(samples >= ignore) {
				err_out = 1.;
				error_count++;
				if(samples >= err_msg)
	fprintf(stderr, "ecount: symbol error @%d\n",samples);

			}
			else {
				if(samples >= err_msg)
	fprintf(stderr, "ecount: symbol error @%d  (ignore)\n",samples);
			}
		}
		samples++;

		for(j=0; j<obufs; j++) {
			if(IT_OUT(j)) {
				KrnOverflow("ecount",j);
				return(99);
			}
			OUTF(j,0) = err_out;
		}
	}

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

	fprintf(stderr,"ecount: hits/samples = %d/%d  (ignore %d)  BER = %d/%d = %.4g\n",
		hits, samples, samples>ignore? ignore:samples,
		error_count, samples>ignore? samples-ignore:0,
		samples>ignore? (float)error_count/(samples-ignore):0);
	fprintf(fp,"%d  %d   %d  %d %d  %.4g \n",
		hits, samples, samples>ignore? ignore:samples,
		error_count, samples>ignore? samples-ignore:0,
		samples>ignore? (float)error_count/(samples-ignore):0);
       fclose(fp);
       
#ifdef TCL_SUPPORT
       if(!krn_TCL_Interp) {
          
	  return(0);
       }
       sprintf(theVar,"%.4g",samples>ignore? (float)error_count/(samples-ignore):0);
       sprintf(theName,"%s_ber",STAR_NAME);
       
	
	varNameObj_P=Tcl_NewStringObj(theName, strlen(theName));
	objVar_P=Tcl_NewObj();
		   
	Tcl_SetDoubleObj(objVar_P,samples>ignore? (float)error_count/(samples-ignore):0);
	Tcl_ObjSetVar2(krn_TCL_Interp,varNameObj_P,NULL,objVar_P,TCL_NAMESPACE_ONLY);
       
       
#endif       
  

]]>
</WRAPUP_CODE> 

<RESULTS>
   <RESULT>
       <NAME>BlockName_ber</NAME><TYPE>float</TYPE><DESC>The bit error rate (BER)</DESC>
   </RESULT>

</RESULTS>


</BLOCK> 

