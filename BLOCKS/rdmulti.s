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

rdmulti 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*************************************************************
			rdmulti()
***************************************************************
This function performs the simple task of reading
sample values in from a file, and then placing them on
it's output buffer. The file may have multiple sample values
per line, which can be integer or float.
Added Option:
If more than one output buffer is connected, then the samples are
routed to each buffer in sequence mod the number of buffers.
Thus, if two column data is to be read and column one is to be placed on
buffer 0 and coulmn two on buffer 1 then simpley connect two buffers to
the block. This can also be used to read three or more columns. 
The data in the file does not need tb be in column format.
An example use for this routine is to access a stored waveform
as input to a simulation.
The parameters are:
	file_name = name of file to read from, defaults to "stdin"
Typical usage:
param file input_file
block Reader read_file.s
param default
block Reader read_file.s
(The first version will read from the file with name input_file,
	while the second version will read from standard input)
<NAME>
rdmulti
</NAME>
<DESCRIPTION>
This function performs the simple task of reading
sample values in from a file, and then placing them on
it's output buffer. The file may have multiple sample values
per line, which can be integer or float.
Added Option:
If more than one output buffer is connected, then the samples are
routed to each buffer in sequence mod the number of buffers.
Thus, if two column data is to be read and column one is to be placed on
buffer 0 and coulmn two on buffer 1 then simpley connect two buffers to
the block. This can also be used to read three or more columns. 
The data in the file does not need tb be in column format.
An example use for this routine is to access a stored waveform
as input to a simulation.
The parameters are:
	file_name = name of file to read from, defaults to "stdin"
Typical usage:
param file input_file
block Reader read_file.s
param default
block Reader read_file.s
(The first version will read from the file with name input_file,
	while the second version will read from standard input)
</DESCRIPTION>
<PROGRAMMERS>
Programmer: R. T. Wietelmann / D.G.Messerschmitt
Date: June 5, 1982
Modified for V2.0 by D.G. Messerschmitt March 7, 1985
Modified: July 10, 1985 by D.J.Hait
Modified: April, 1988 L.J.Faber: add "auto-fanout"
Modified: April, 1991 S. H. Ardalan: Demux auto-fanout
</PROGRAMMERS>	
*/

]]>
</COMMENTS> 

     
<DESC_SHORT>
This function performs the simple task of reading sample values in from a file, and then placing them on its output buffer. The file may have multiple sample values per line, which can be integer or float. If more than one output buffer is connected, then the samples are routed to each buffer in sequence mod the number of buffers.
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>obufs</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>j</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>FILE*</TYPE>
		<NAME>fp</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i,k;
	float x;
	FILE *fopen();

</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF>File that contains data</DEF>
	<TYPE>file</TYPE>
	<NAME>file_name</NAME>
	<VALUE>stdin</VALUE>
</PARAM>
</PARAMETERS>

<INIT_CODE>
<![CDATA[ 

	if(strcmp(file_name,"stdin") == 0)
		fp = stdin;
	else if((fp = fopen(file_name,"r")) == NULL) {
		fprintf(stderr,"read_file: cannot open file\n");
		return(1); /* file cannot be opened */
	}
	if( (obufs = NO_OUTPUT_BUFFERS()) < 1 ) {
		fprintf(stderr,"read_file: no output buffers\n");
		return(2);
	}

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	/* output a maximum of NUMBER_SAMPLES_PER_VISIT samples to output buffer(s) */
	for(i=0; i < NUMBER_SAMPLES_PER_VISIT; ++i) {

		/* Read input lines until EOF */
		if(fscanf(fp,"%f",&x) == EOF)
			break;

		/* input sample available: */
		/* increment time on output buffer(s) */
		/* and output a sample */
			if(IT_OUT(j)) {
				KrnOverflow("rdmulti",j);
				return(99);
			}
			OUTF(j,0) = x;
		j += 1;
		if(j == obufs) j=0;
	}

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

        if (fp != stdout)
             fclose(fp);
        return(0);

]]>
</WRAPUP_CODE> 



</BLOCK> 

