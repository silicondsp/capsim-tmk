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

stats 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* stats.s */
/***************************************************************
			stats() 
*******************************************************************
	Input:		x, the signal of interest
	Output:		optional:  terminate signal or flow through
	Parameters:	1: file sig_name, signal identifier
			2: file stat_file, statistics file name
				default => no file created.
*******************************************************************
This star calculates the statistics of the incoming signal.  
The parameter is a filename for storage of the results.
<NAME>
stats
</NAME>
<DESCRIPTION>
This star calculates the statistics of the incoming signal.  
The parameter is a filename for storage of the results.
	Input:		x, the signal of interest
	Output:		optional:  terminate signal or flow through
	Parameters:	1: file sig_name, signal identifier
			2: file stat_file, statistics file name
				default => no file created.
*******************************************************************
</DESCRIPTION>
<PROGRAMMERS>
Programmer: 	Prayson W. Pate
Date:		December 8, 1987
Modified:	February 22, 1987
		April 1988
		May 1988 ljfaber: add 'flow-thru' capability
				: add signal identifier
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This star calculates the statistics of the incoming signal.  The parameter is a filename for storage of the results.
</DESC_SHORT>


<INCLUDES>
<![CDATA[ 

#include <math.h>
#include <stdio.h>
#include <TCL/tcl.h>

]]>
</INCLUDES> 

          

<STATES>
	<STATE>
		<TYPE>FILE*</TYPE>
		<NAME>file_ptr</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>obufs</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>count</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>totalCount</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>sum_x</NAME>
		<VALUE>0.0</VALUE>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>sum_x2</NAME>
		<VALUE>0.0</VALUE>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>max</NAME>
		<VALUE>-1e30</VALUE>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>min</NAME>
		<VALUE>1e30</VALUE>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i,j;
	float xSample;	/* current sample of input signal	*/
	float mu;	/* mean = sum_x/count			*/
	float var;	/* variance = (sum_x2/count - mu**2)	*/
	float sigma;	/* std dev  = square root of variance	*/
	double sqrt();
	char theVar[100];
	char theName[100];
#ifdef TCL_SUPPORT
        Tcl_Obj *varNameObj_P;
        Tcl_Obj *objVar_P;
#endif	

</DECLARATIONS> 

       

<PARAMETERS>
<PARAM>
	<DEF>Points to skip</DEF>
	<TYPE>int</TYPE>
	<NAME>skip</NAME>
	<VALUE></VALUE>
</PARAM>
<PARAM>
	<DEF>File to store results</DEF>
	<TYPE>file</TYPE>
	<NAME>stat_file</NAME>
	<VALUE>stat.dat</VALUE>
</PARAM>
</PARAMETERS>

    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>x</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

	if( (obufs = NO_OUTPUT_BUFFERS()) > 1) {
		fprintf(stderr,"stats: only one output allowed\n");
		return(2);
	}

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	/* note the minimum number of samples on the input 	*/
	/* buffers and iterate that many times 			*/
	for(i=MIN_AVAIL();i>0; --i) {
    	     IT_IN(0);
	     for(j=0; j<obufs; j++) {
			if(IT_OUT(j)) {
				KrnOverflow("stats",j);
				return(99);
			}
			OUTF(j,0) = x(0);
	     }
	     if(++totalCount > skip) {
		count++;
		xSample = x(0);
		if (xSample > max)
			max = xSample;
		if (xSample < min)
			min = xSample;

		sum_x += xSample;
		sum_x2 += xSample * xSample;
	     }
	}
	return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

	mu = sum_x/count;
	var = (sum_x2/count) - (mu*mu);
	sigma = sqrt(var);
	fprintf(stderr,"samples   \t%d       \tmean    \t%g\n",count,mu);
	fprintf(stderr,"maximum   \t%g  \tminimum \t%g\n",max,min);
	fprintf(stderr,"variance  \t%g  \tsigma   \t%g\n",var,sigma);
	fprintf(stderr,"samples   \t%d       \tmean    \t%g\n",count,mu); 
	fprintf(stderr,"maximum   \t%g  \tminimum \t%g\n",max,min);
	fprintf(stderr,"variance  \t%g  \tsigma   \t%g\n",var,sigma);
	{
		if( (file_ptr = fopen(stat_file,"w")) == NULL) {
			fprintf(stderr,"stats: can't open results file %s \n",
				stat_file);
			return(3);
	}
	{
		fprintf(file_ptr,"samples   %d  mean      %e \n",count,mu);
		fprintf(file_ptr,"maximum   %e  minimum %e \n",max,min);
		fprintf(file_ptr,"variance  %e  sigma   %e \n",var,sigma);
	}
	
#ifdef TCL_SUPPORT
       if(!krn_TCL_Interp) {
          
	  return(0);
       }
       
       sprintf(theName,"%s_sigma",STAR_NAME);

	varNameObj_P=Tcl_NewStringObj(theName, strlen(theName));
	objVar_P=Tcl_NewObj();
	Tcl_SetDoubleObj(objVar_P,sigma);
	Tcl_ObjSetVar2(krn_TCL_Interp,varNameObj_P,NULL,objVar_P,TCL_NAMESPACE_ONLY);
        
       
       sprintf(theName,"%s_mean",STAR_NAME);
	varNameObj_P=Tcl_NewStringObj(theName, strlen(theName));
	objVar_P=Tcl_NewObj();
	Tcl_SetDoubleObj(objVar_P,mu);
	Tcl_ObjSetVar2(krn_TCL_Interp,varNameObj_P,NULL,objVar_P,TCL_NAMESPACE_ONLY);
       
       
       
        sprintf(theName,"%s_max",STAR_NAME);
	varNameObj_P=Tcl_NewStringObj(theName, strlen(theName));
	objVar_P=Tcl_NewObj();
	Tcl_SetDoubleObj(objVar_P,max);
	Tcl_ObjSetVar2(krn_TCL_Interp,varNameObj_P,NULL,objVar_P,TCL_NAMESPACE_ONLY);
        
      
       
       sprintf(theName,"%s_min",STAR_NAME);
	varNameObj_P=Tcl_NewStringObj(theName, strlen(theName));
	objVar_P=Tcl_NewObj();
	Tcl_SetDoubleObj(objVar_P,min);
	Tcl_ObjSetVar2(krn_TCL_Interp,varNameObj_P,NULL,objVar_P,TCL_NAMESPACE_ONLY);
 
     

       
       
       
       
       sprintf(theName,"%s_var",STAR_NAME);
	varNameObj_P=Tcl_NewStringObj(theName, strlen(theName));
	objVar_P=Tcl_NewObj();
	Tcl_SetDoubleObj(objVar_P,var);
	Tcl_ObjSetVar2(krn_TCL_Interp,varNameObj_P,NULL,objVar_P,TCL_NAMESPACE_ONLY);


       
              
#endif

}
fclose(file_ptr);

]]>
</WRAPUP_CODE> 

<RESULTS>
   <RESULT>
       <NAME>BlockName_sigma</NAME><TYPE>float</TYPE><DESC>The standard deviation of the input stream</DESC>
   </RESULT>
   <RESULT>
       <NAME>BlockName_var</NAME><TYPE>float</TYPE><DESC>The variance of the input stream</DESC>
   </RESULT>
   <RESULT>
       <NAME>BlockName_mean</NAME><TYPE>float</TYPE><DESC>The mean of the input stream</DESC>
   </RESULT>
   <RESULT>
       <NAME>BlockName_min</NAME><TYPE>float</TYPE><DESC>The minimum value  of the input stream</DESC>
   </RESULT>
   <RESULT>
       <NAME>BlockName_max</NAME><TYPE>float</TYPE><DESC>The maximum value  of the input stream</DESC>
   </RESULT>
</RESULTS>


</BLOCK> 

