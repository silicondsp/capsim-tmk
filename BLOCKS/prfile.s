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

prfile 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/**********************************************************************
			prfile()
***********************************************************************
Prints samples from an arbitrary number of input buffers to a file,
which is named as a parameter.  If the file name is set to "stdout",
or "stderr" the output goes to the terminal.
- A sample from each input is printed in columns on a single line.
	If printing to stdout, these are labeled with signal names.
- The printing function can be disabled without removing the star,
	via a control parameter.
- Data "flow-through" is implemented: if any outputs are connected,
	their values come from the correspondingly numbered input.
	(This feature is not affected by the control parameter.)
	(There cannot be more outputs than inputs.)
<NAME>
prfile
</NAME>
<DESCRIPTION>
Prints samples from an arbitrary number of input buffers to a file,
which is named as a parameter.  If the file name is set to "stdout",
or "stderr" the output goes to the terminal.
- A sample from each input is printed in columns on a single line.
	If printing to stdout, these are labeled with signal names.
- The printing function can be disabled without removing the star,
	via a control parameter.
- Data "flow-through" is implemented: if any outputs are connected,
	their values come from the correspondingly numbered input.
	(This feature is not affected by the control parameter.)
	(There cannot be more outputs than inputs.)
</DESCRIPTION>
<PROGRAMMERS>
Programmer:  L.J.Faber
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
Prints samples from an arbitrary number of input buffers to a file, which is named as a parameter.
</DESC_SHORT>


<DEFINES> 

#define FLOAT_BUFFER 0
#define COMPLEX_BUFFER 1
#define INTEGER_BUFFER 2

</DEFINES> 

      

<STATES>
	<STATE>
		<TYPE>FILE*</TYPE>
		<NAME>fp</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberInputBuffers</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberOutputBuffers</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>displayFlag</NAME>
		<VALUE>0</VALUE>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i,j,k;
	complex val;

</DECLARATIONS> 

         

<PARAMETERS>
<PARAM>
	<DEF>Name of output file</DEF>
	<TYPE>file</TYPE>
	<NAME>file_name</NAME>
	<VALUE>stdout</VALUE>
</PARAM>
<PARAM>
	<DEF>Print output control (0/Off, 1/On)</DEF>
	<TYPE>int</TYPE>
	<NAME>control</NAME>
	<VALUE>1</VALUE>
</PARAM>
<PARAM>
	<DEF>Buffer type:0= Float,1= Complex, 2=Integer</DEF>
	<TYPE>int</TYPE>
	<NAME>bufferType</NAME>
	<VALUE>0</VALUE>
</PARAM>
</PARAMETERS>

<INIT_CODE>
<![CDATA[ 

if((numberInputBuffers = NO_INPUT_BUFFERS()) <= 0) {
	fprintf(stdout,"prfile: no input buffers\n");
	return(1);
}
if((numberOutputBuffers = NO_OUTPUT_BUFFERS()) > numberInputBuffers) {
	fprintf(stdout,"prfile: more output than input buffers\n");
	return(2);
}
if(strcmp(file_name,"stdout") == 0) {
	fp = stdout;
	displayFlag = 1;
}
else if(strcmp(file_name,"stderr") == 0) {
	fp = stderr;
	displayFlag = 1;
}
else if((fp = fopen(file_name,"w")) == NULL) {
	fprintf(stdout,"prfile: can't open output file '%s'\n",
		file_name);
	return(3);
}
switch(bufferType) {
	case COMPLEX_BUFFER: 
		for(i=0; i< numberInputBuffers; i++)
			SET_CELL_SIZE_IN(i,sizeof(complex));
		for(i=0; i< numberOutputBuffers; i++)
			SET_CELL_SIZE_OUT(0,sizeof(complex));
		break;
	case FLOAT_BUFFER: 
		for(i=0; i< numberInputBuffers; i++)
			SET_CELL_SIZE_IN(i,sizeof(float));
		for(i=0; i< numberOutputBuffers; i++)
			SET_CELL_SIZE_OUT(0,sizeof(float));
		break;
	case INTEGER_BUFFER: 
		for(i=0; i< numberInputBuffers; i++)
			SET_CELL_SIZE_IN(i,sizeof(int));
		for(i=0; i< numberOutputBuffers; i++)
			SET_CELL_SIZE_OUT(0,sizeof(int));
		break;
	default: 
		fprintf(stderr,"Bad buffer type specified in prfile \n");
		return(4);
		break;
}

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

	
if(control) {
	if(displayFlag && MIN_AVAIL() > 0) {
		fprintf(fp,"\n");
		for(j=0; j<(numberInputBuffers-2); j++)
			fprintf(fp,"%-6s","");
		fprintf(fp,"Output From Prfile '%s'\n",block_P->name);
		for(j=0; j<numberInputBuffers; ++j)
			fprintf(fp,"%-10s  ", SNAME(j));
		fprintf(fp,"\n");
	}
	/* This mode synchronizes all input buffers */
	for(i = MIN_AVAIL(); i>0; i--) {
		for(j=0; j<numberInputBuffers; ++j) {
			IT_IN(j);
			if(j < numberOutputBuffers) {
				if(IT_OUT(j)) {
					KrnOverflow("prfile",j);
					return(99);
				}
				switch(bufferType) {
					case COMPLEX_BUFFER: 
					   OUTCX(j,0) = INCX(j,0);
					   break;
					case FLOAT_BUFFER: 
					   OUTF(j,0) = INF(j,0);
					   break;
				        case INTEGER_BUFFER: 
					   OUTI(j,0) = INI(j,0);
					   break;
				}

			}
			switch(bufferType) {
				case COMPLEX_BUFFER: 
				   val=INCX(j,0);
				   if(fp!= stdout) 
				       fprintf(fp,"%-10g %-10g ", val.re,val.im);
				   else {
				       fprintf(stderr,"%-10g %-10g ", val.re,val.im);
				       
				   }
				   break;
				case FLOAT_BUFFER: 
				    if(fp!= stdout) 
					    fprintf(fp,"%-10g  ", INF(j,0));
				   else {
				       fprintf(stderr,"%-10g  ", INF(j,0));
				       
				   }
				   break;
			        case INTEGER_BUFFER: 
				    if(fp!= stdout)
					    fprintf(fp,"%-d  ", INI(j,0));
					else {
				       fprintf(stderr,"%-d  ", INI(j,0));
				       


					}
				   break;
			}

		}
		if(fp!= stdout)
		   fprintf(fp,"\n");
		else  {
                  fprintf(stderr," \n ");
				  

		}
		    
	}
}
else {
	/* This mode empties all input buffers */
	for(j=0; j<numberInputBuffers; ++j) {
		if(j < numberOutputBuffers) {
			while(IT_IN(j)) {
				if(IT_OUT(j) ){
					KrnOverflow("prfile",j);
					return(99);
				}
				switch(bufferType) {
					case COMPLEX_BUFFER: 
					   OUTCX(j,0) = INCX(j,0);
					   break;
					case FLOAT_BUFFER: 
					   OUTF(j,0) = INF(j,0);
					   break;
				        case INTEGER_BUFFER: 
					   OUTI(j,0) = INI(j,0);
					   break;
				}

			}
		}
		else
			while(IT_IN(j));
	}
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

