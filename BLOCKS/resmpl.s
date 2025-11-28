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
resmpl
</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* resmpl.s */
/**********************************************************************
			resmpl()
***********************************************************************
This star performs interpolation or decimation on an input data stream,
in order to change the output data rate.  Polynomial or sinc interpol-
ation is used to create output values that occur "between" input points.
An initial time offset between the input/output streams can be entered.
Param.	1 - (float) ratio:  output data rate/input data rate.
	2 - (float) phi:  delay of first output sample, relative to
		first input sample; expressed in units of input data
		period.  Normally -1 < phi < 1.  default: 0.
	3 - (int) intype:  type of interpolation:
		0: sinc (3 point)
		1: 1rst order (line) (default)
		2: 2nd order (parbola)
		3: 3rd order polynomial
Warning: although any output/input rate ratio > 0 will work, some
spectral problems can occur.  Time interpolation is not optimal, since
there is no access to an infinite number of points!
This problem is magnified as ratio deviates farther from unity.
If ratio < 1 (decimation mode), aliasing can occur if the input signal
is not properly bandlimited.
Programmer: L.J. Faber
Date: June, 1988.
Modified by Jie Gao on Oct 25,04
*/
]]>
</COMMENTS> 

<DESC_SHORT>
This star performs interpolation or decimation on an input data stream, in order to change the output data rate.  Polynomial or sinc interpol- ation is used to create output values that occur "between" input points.  An initial time offset between the input/output streams can be entered.
</DESC_SHORT>

<DECLARATIONS> 

	int i,j;
	float beta;	/* interpolation fraction */
	float beta2;
	float sinc(float x);	/* custom function in SUBS library */
	int  no_samples;
	

</DECLARATIONS> 




<STATES>
	<STATE>
		<TYPE> long </TYPE>
		<NAME> incount </NAME>
		<VALUE> 0 </VALUE>
	</STATE>
	<STATE>
		<TYPE> long </TYPE>
		<NAME> outcount </NAME>
		<VALUE> 0 </VALUE>
	</STATE>
	<STATE>
		<TYPE> float </TYPE>
		<NAME> phase </NAME>
		<VALUE> phi </VALUE>
	</STATE>
	<STATE>
		<TYPE> double </TYPE>
		<NAME> outaccum </NAME>
		<VALUE> phase </VALUE>
	</STATE>
	<STATE>
		<TYPE> float </TYPE>
		<NAME> Q </NAME>
		<VALUE> 0 </VALUE>
	</STATE>
	<STATE>
		<TYPE> float </TYPE>
		<NAME> R </NAME>
		<VALUE> 0 </VALUE>
	</STATE>
	<STATE>
		<TYPE> float </TYPE>
		<NAME> S </NAME>
		<VALUE> 0 </VALUE>
	</STATE>
</STATES>



<PARAMETERS>
	<PARAM>
		<DEF> ratio:  output data rate/input data rate. </DEF>
		<TYPE> float </TYPE>
		<NAME> ratio </NAME>
		<VALUE> 1. </VALUE>
	</PARAM>
	<PARAM>
		<DEF> delay of first output sample, rel. to first sample.Expressed in units of input data period. </DEF>
		<TYPE> float </TYPE>
		<NAME> phi </NAME>
		<VALUE> 0 </VALUE>
	</PARAM>
	<PARAM>
		<DEF> Type of interpolation: 0: sinc (3 point) 1: 1rst order (line) (default) 2: 2nd order (parbola) 3: 3rd order polynomial </DEF>
		<TYPE> int </TYPE>
		<NAME> intype </NAME>
		<VALUE> 1 </VALUE>
	</PARAM>
</PARAMETERS>



<INPUT_BUFFERS>
	<BUFFER>
		<TYPE> float </TYPE>
		<NAME> x </NAME>
		<DELAY> <TYPE> max </TYPE> <VALUE_MAX> 3 </VALUE_MAX> </DELAY>
	</BUFFER>
</INPUT_BUFFERS>



<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE> float </TYPE>
		<NAME> y </NAME>
	</BUFFER>
</OUTPUT_BUFFERS>

<INIT_CODE>
<![CDATA[ 

	if( ratio <= 0) {
		fprintf(stderr,"resmpl: improper ratio parameter\n");
		return(1);
	}
	if( intype < 0 || intype > 3) {
		fprintf(stderr,"resmpl: unknown interpolation type\n");
		return(2);
	}

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

	for(no_samples=MIN_AVAIL();no_samples >0; --no_samples) {
		IT_IN(0);
		incount++;
		if(intype == 0) ;
		else if(intype == 1) {
			Q = x(1) - x(0);
			R = S = 0;
		}
		else if(intype == 2) {
			Q = -1.5*x(0) + 2*x(1) - .5*x(2);
			R = .5*x(0) - x(1) + .5*x(2);
			S = 0;
		}
		else if(intype == 3) {
			Q = -11*x(0)/6 + 3*x(1) - 1.5*x(2) + x(3)/3;
			R = x(0) - 2.5*x(1) + 2*x(2) - .5*x(3);
			S = -x(0)/6 + .5*x(1) - .5*x(2) + x(3)/6;
		}

		while( (int)outaccum <= incount - 1) { //ST_DBG
			if(IT_OUT(0)) {
				KrnOverflow("resmpl",0);
				return(99);
			}
			outcount++;
			beta = incount- outaccum;
			if(intype == 0) {
				y(0) = x(0)*sinc (beta)
					+ x(1)*sinc (1-beta)
					+ x(2)*sinc (2-beta);
			}
			else {
				beta2 = beta*beta;
				y(0) = x(0) + Q*beta
					+ R*beta2 + S*beta2*beta;
			}
			/*this method prevents accumulation of error*/
			outaccum = phase + outcount / ratio;
		}
	}

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

