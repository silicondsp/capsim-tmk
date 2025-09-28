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

more 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* more.s */
/**********************************************************************
			more()
***********************************************************************
Function prints samples from an arbitrary number of input buffers
	to the terminal output using the "more" command
	(one sample from each input is printed on each line)
This routine does not print the time axis; to obtain the time
	axis, the user should connect the block time() to input #0
<NAME>
more
</NAME>
<DESCRIPTION>
Function prints samples from an arbitrary number of input buffers
	to the terminal output using the "more" command
	(one sample from each input is printed on each line)
This routine does not print the time axis; to obtain the time
	axis, the user should connect the block time() to input #0
</DESCRIPTION>
<PROGRAMMERS>
Programmer: D.G.Messerschmitt
Date: May 6, 1986
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

    
<DESC_SHORT>
Function prints samples from an arbitrary number of input buffers to the terminal output using the "more" command (one sample from each input is printed on each line)
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>no_buffers</NAME>
	</STATE>
	<STATE>
		<TYPE>FILE*</TYPE>
		<NAME>fp</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int buffer_no,no_samples;
	FILE *popen();

</DECLARATIONS> 

   
<INIT_CODE>
<![CDATA[ 

	/* determine and store as state the number of input buffers */
	if((no_buffers = NO_INPUT_BUFFERS()) <= 0) {
		fprintf(stderr,"more: no input buffers\n");
		return(1); /* no input buffers */
	}
	if( (fp = popen("more","w")) == NULL)
			return(1); /* pipe can't be created */

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	for(no_samples=MIN_AVAIL();no_samples>0;--no_samples) {

		for(buffer_no=0; buffer_no<no_buffers; ++buffer_no) {
			IT_IN(buffer_no);
			fprintf(fp, "%f ",*(float *)PIN(buffer_no,0));
			}
		fprintf(fp,"\n");
		}

	return(0);	/* one input buffer empty */


]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

	pclose(fp);
        return(0);

]]>
</WRAPUP_CODE> 



</BLOCK> 

