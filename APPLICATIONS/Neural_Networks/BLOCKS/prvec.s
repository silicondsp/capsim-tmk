<BLOCK>
<LICENSE>
/*  Capsim (r) Text Mode Kernel (TMK) Block Library (Blocks)
    Copyright (C) 1989-2018  Silicon DSP  Corporation 

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

prvec 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/**********************************************************************
			prvec()
***********************************************************************
<NAME>
prvec
</NAME>
<DESCRIPTION>
Stores vector  in a file.
</DESCRIPTION>
<PROGRAMMERS>
Programmer:  Sasan Ardalan 
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

       
<DESC_SHORT>
Stores vector in a file.
</DESC_SHORT>

<INCLUDES>
<![CDATA[

#include "buffer_types.h"


]]>
</INCLUDES>

<STATES>
	<STATE>
		<TYPE>FILE*</TYPE>
		<NAME>fp</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>ibufs</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>obufs</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>displayFlag</NAME>
		<VALUE>0</VALUE>
	</STATE>

</STATES>
 
<DECLARATIONS> 

	int i,j,k;
	doubleVector_t  theVector ;

</DECLARATIONS> 

         

<PARAMETERS>
<PARAM>
	<DEF>Name of output file</DEF>
	<TYPE>file</TYPE>
	<NAME>file_name</NAME>
	<VALUE>stdout</VALUE>
</PARAM>

<PARAM>
	<DEF>Display Block Name</DEF>
	<TYPE>int</TYPE>
	<NAME>display</NAME>
	<VALUE>0</VALUE>
</PARAM>


</PARAMETERS>

<INIT_CODE>
<![CDATA[ 

	if((ibufs = NO_INPUT_BUFFERS()) <= 0) {
		fprintf(stdout,"prvec: no input buffers\n");
		return(1);
	}
	if((obufs = NO_OUTPUT_BUFFERS()) > ibufs) {
		fprintf(stdout,"prvec: more output than input buffers\n");
		return(2);
	}
	if(strcmp(file_name,"stdout") == 0) {
		fp = stdout;
		 
	}
	else if(strcmp(file_name,"stderr") == 0) {
		fp = stderr;
		 
	}
	else if((fp = fopen(file_name,"w")) == NULL) {
		fprintf(stdout,"prvec: can't open output file '%s'\n",
			file_name);
		return(3);
	}
	 
	for(k=0; k< ibufs; k++)
	     SET_CELL_SIZE_IN(k,sizeof(doubleVector_t));
	     
	for(k=0; k< obufs; k++)
	     SET_CELL_SIZE_OUT(k,sizeof(doubleVector_t));	     
	     
]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

       if(  MIN_AVAIL() > 0) {
                if(display) {  
                     fprintf(fp,"\n");
                
                     fprintf(fp,"Output From prvec '%s'\n",block_P->name);
                
                    // for(j=0; j<ibufs; ++j)
                    //       fprintf(fp,"%-10s  ", SNAME(j));
                     fprintf(fp,"\n");
                }
	    }
        /* This mode synchronizes all input buffers */
        for(i = MIN_AVAIL(); i>0; i--) {
                for(j=0; j<ibufs; ++j) {
                        IT_IN(j);
                        if(j < obufs) {
                                if(IT_OUT(j)) {
					                 KrnOverflow("prvec",j);
					                 return(99);
				                }
				        }
				        //fprintf(fp,"Getting Vector\n");
				        
				        
                     //   OUTVEC(j,0) = INVEC(j,0);
                         
                        theVector=INVEC(j,0);
                        
                       // fprintf(fp,"Got Vector\n");
                        
                        
                        for(k=0; k< theVector.length; k++) {
                            fprintf(fp,"%-10g  ",theVector.vector_P[k]);
                        //      fprintf(fp,"Got Vector k=%d",k);
                        }
                        
                        fprintf(fp,"\n");
                        if(obufs>0 && j < obufs) {
                        
                               if(IT_OUT(j)) {
					                KrnOverflow("prvec",j);
					                return(99);
				               }
				               OUTVEC(j,0) = INVEC(j,0);
				        }
			 
                }
        }
	
	/* This mode empties all input buffers */
	for(j=0; j<ibufs; ++j) {
		if(j < obufs) {
			while(IT_IN(j)) {
				if(IT_OUT(j)) {
					KrnOverflow("prvec",j);
					return(99);
				}
				OUTVEC(j,0) = INVEC(j,0);
			}
		}
		else
			while(IT_IN(j));
	}
return(0);


]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

	if(fp != stdout && fp != stderr)
		fclose(fp);

]]>
</WRAPUP_CODE> 



</BLOCK> 

