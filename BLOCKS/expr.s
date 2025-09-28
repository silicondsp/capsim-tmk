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

expr 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* expr.s */
/**********************************************************************
			expr()
***********************************************************************
Function evaluates all its input samples through an expression
specified as a parameter to yield an output sample;
the number of input buffers is arbitrary and determined at run time.
The number of output buffers is also arbitrary (auto-fanout).
In the expression refer to the sample on input buffer 0 as in0, for
input buffer 1 as in1 and so on. For example:
	sin(5*PI*in0/100)*exp(-0.001*in1)
Note the PI is predefined.
<NAME>
expr
</NAME>
<DESCRIPTION>
Function evaluates all its input samples through an expression
specified as a parameter to yield an output sample;
the number of input buffers is arbitrary and determined at run time.
The number of output buffers is also arbitrary (auto-fanout).
In the expression refer to the sample on input buffer 0 as in0, for
input buffer 1 as in1 and so on. For example:
	sin(5*PI*in0/100)*exp(-0.001*in1)
Note the PI is predefined.
</DESCRIPTION>
<PROGRAMMERS>
Programmer: Sasan H. Ardalan
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

    
<DESC_SHORT>
Function evaluates all its input samples through an expression specified as a parameter.
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>ibufs</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>obufs</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i,j;
	int samples;
	float sampleIn;
	char	expression[256];

</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF>Enter expression ( buffers are in0,in1,...)</DEF>
	<TYPE>file</TYPE>
	<NAME>paramExpr</NAME>
	<VALUE>in0*1</VALUE>
</PARAM>
</PARAMETERS>

<INIT_CODE>
<![CDATA[ 

	/*
	 *  Store as state the number of input/output buffers 
	 */
	if((ibufs = NO_INPUT_BUFFERS()) < 1) {
		sprintf(stderr,"expr: no input buffers\n");
		return(2);
	}
	if((obufs = NO_OUTPUT_BUFFERS()) < 1) {
		sprintf(stderr,"expr: no output buffers\n");
		return(3);
	}

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	/* 
	 * Read one sample from each input buffer  
	 */
	for(samples = MIN_AVAIL(); samples >0; --samples) {


		for(i=0; i<ibufs; ++i) {
			IT_IN(i);
			
			sampleIn = INF(i,0);
			/*
			 * Setup expression for ini=sampleIn
			 * This will be passed to the parser.
			 * The symbol table will contain the symbols
			 * in0,in1,... which are equal to the buffer
			 * samples. When we later evaluate the expression
			 * which refers to in0, in1,... they will be recognized.
			 */
			sprintf(expression,"in%d=%e\n",i,sampleIn);
			krn_bufferPtr=0;
                        krn_buffer=expression;
                        yyparse();
		}
		/*
		 * since in0,in1,... are setup, evaluate expression. 
		 * First add an end of line ( all expressions must end with
		 * an end of line character.
		 * Next set the buffer pointer to zero and the buffer to
		 * the expression and call yyparse()
		 */
		strcpy(expression,paramExpr);
		strcat(expression,"\n");
		krn_bufferPtr=0;
                krn_buffer=expression;
               	yyparse();
//        	if(krn_yyerror) {
//                	krn_yyerror=FALSE;
//                	fprintf(stderr,"expr: Error in expression\n");
//                	return(7);
//        	}


		/*
		 * the result of evaluating the expression is in 
		 * krn_eqnResult. Ship it out to the output buffers
		 */
		for(i=0; i<obufs; i++) {
			if(IT_OUT(i)) {
				fprintf(stderr,"expr: Buffer %d is full\n",i);;
				return(1);
			}
			OUTF(i,0) = krn_eqnResult;
		}
	}

	return(0);	/* at least one input buffer empty */


]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

