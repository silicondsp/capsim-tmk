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

predlms 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/**********************************************************************
                predlms()
***********************************************************************
This block implements a multichannel input/output FIR predictor, which
is adapted using the power normalized LMS algorithm.
It can be used as an equalizer, FSE, DFE, or echo canceller.
An arbitrary number p input channels are transversal filtered
to produce an arbitrary number q output estimate signals.
Note: each output buffer connected to this block implies a separate
output channel, and identically numbered error input channel.
Input signal channels are then connected to higher numbered buffers.
It is assumed that the estimate error is computed externally.
Do NOT implement an external (causality) unit-delay from
output estimate to input error; this delay is handled automatically.
Param.	1 - Name of ASCII input specification file.  Filter orders
		and initial tap values are given.  default => prfile
The proper specification file format is:
  (int) # output channels, q
  (int) # input channels, p
  (int) order of in ch.#1  . . .  (int) order of in ch.#p
  (float) ch.#1, tap 1 . . .  (float) ch.#1, tap last
      .                                                {output ch.1}
      .
  (float) ch.#p, tap 1 . . .  (float) ch.#p, tap last
   .
   .
   .
  (float) ch.#1, tap 1 . . .  (float) ch.#1, tap last
      .                                                {output ch.q}
      .
  (float) ch.#p, tap 1 . . .  (float) ch.#p, tap last
Param.	2 - Name of output file, for final adapted filter values.
	  default => prfileo.  The file is written in proper
	  input-file format.  This file can then be used to initialize
	  the filter for the next run, if desired.
It is assumed that each output prediction filter will create one
estimate output for EACH input sample/error sample pair.
Any decimation, etc. must occur externally.
Param.	3 - (float) lambda.  It is a multiplicative factor to
	  control adaptation rate.  default => 1.0
Param.	4 - (float) delta.  Tap leakage factor.  default => 1.0
	  Default implies no tap leakage occurs.
	5 - (int) wait.  number of samples to skip before blockting
	  adaptation.  The predictor still inputs samples, and
	  outputs a zero estimate.  default => 0
	6 - (int) adapt.  number of samples to adapt filter.  After
 	  this number, filter taps are fixed, and estimates are still
	  produced.  default => -1  (implies always adapt)
<NAME>
predlms
</NAME>
<DESCRIPTION>
This block implements a multichannel input/output FIR predictor, which
is adapted using the power normalized LMS algorithm.
It can be used as an equalizer, FSE, DFE, or echo canceller.
An arbitrary number p input channels are transversal filtered
to produce an arbitrary number q output estimate signals.
Note: each output buffer connected to this block implies a separate
output channel, and identically numbered error input channel.
Input signal channels are then connected to higher numbered buffers.
It is assumed that the estimate error is computed externally.
Do NOT implement an external (causality) unit-delay from
output estimate to input error; this delay is handled automatically.
Param.	1 - Name of ASCII input specification file.  Filter orders
		and initial tap values are given.  default => prfile
The proper specification file format is:
  (int) # output channels, q
  (int) # input channels, p
  (int) order of in ch.#1  . . .  (int) order of in ch.#p
  (float) ch.#1, tap 1 . . .  (float) ch.#1, tap last
      .                                                {output ch.1}
      .
  (float) ch.#p, tap 1 . . .  (float) ch.#p, tap last
   .
   .
   .
  (float) ch.#1, tap 1 . . .  (float) ch.#1, tap last
      .                                                {output ch.q}
      .
  (float) ch.#p, tap 1 . . .  (float) ch.#p, tap last
Param.	2 - Name of output file, for final adapted filter values.
	  default => prfileo.  The file is written in proper
	  input-file format.  This file can then be used to initialize
	  the filter for the next run, if desired.
It is assumed that each output prediction filter will create one
estimate output for EACH input sample/error sample pair.
Any decimation, etc. must occur externally.
Param.	3 - (float) lambda.  It is a multiplicative factor to
	  control adaptation rate.  default => 1.0
Param.	4 - (float) delta.  Tap leakage factor.  default => 1.0
	  Default implies no tap leakage occurs.
	5 - (int) wait.  number of samples to skip before blockting
	  adaptation.  The predictor still inputs samples, and
	  outputs a zero estimate.  default => 0
	6 - (int) adapt.  number of samples to adapt filter.  After
 	  this number, filter taps are fixed, and estimates are still
	  produced.  default => -1  (implies always adapt)
</DESCRIPTION>
<PROGRAMMERS>
Programmer: L.J. Faber 
Date: April 1988
Modified: May 1988  add multichannel output
Modified: June 1988  estimate-referenced prediction energy
Modified: Aug 1988  est. input power.  new parameter delta.
Modified: Sept 1988  add parameters 5,6 and associated.
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This block implements a multichannel input/output FIR predictor, which is adapted using the power normalized LMS algorithm.
</DESC_SHORT>


<DEFINES> 

#define Mch  	10	/* maximum i or o channels */

</DEFINES> 

           

<STATES>
	<STATE>
		<TYPE>int*</TYPE>
		<NAME>orders</NAME>
	</STATE>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>W</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>N</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>p</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>q</NAME>
	</STATE>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>Z</NAME>
	</STATE>
	<STATE>
		<TYPE>FILE*</TYPE>
		<NAME>fp</NAME>
	</STATE>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>xpower</NAME>
	</STATE>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>epower</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int i,j,k,jj;
	float xdata;
	float error[Mch];
	float z[Mch];
	int index;
	float estimate;		/* prediction to output */
	float xalpha;		/* lms adaptation variable */

</DECLARATIONS> 

               

<PARAMETERS>
<PARAM>
	<DEF> Name of ASCII input specification file.</DEF>
	<TYPE>file</TYPE>
	<NAME>ifile_name</NAME>
	<VALUE>prfile</VALUE>
</PARAM>
<PARAM>
	<DEF> Name of ASCII output specification file.</DEF>
	<TYPE>file</TYPE>
	<NAME>ofile_name</NAME>
	<VALUE>prfileo</VALUE>
</PARAM>
<PARAM>
	<DEF> LMS loop gain</DEF>
	<TYPE>float</TYPE>
	<NAME>lambda</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF> LMS tap leakage factor </DEF>
	<TYPE>float</TYPE>
	<NAME>delta</NAME>
	<VALUE>1.0</VALUE>
</PARAM>
<PARAM>
	<DEF> Number of samples to skip before blockting adaptation</DEF>
	<TYPE>int</TYPE>
	<NAME>wait</NAME>
	<VALUE>0</VALUE>
</PARAM>
<PARAM>
	<DEF> Number of samples to adapt. Freeze after this number of  iterations</DEF>
	<TYPE>int</TYPE>
	<NAME>adapt</NAME>
	<VALUE>-1</VALUE>
</PARAM>
</PARAMETERS>

<INIT_CODE>
<![CDATA[ 

	if(NO_OUTPUT_BUFFERS() < 1) {
		fprintf(stderr,"pred: no output data channels\n");
		return(1);
	}
	if(NO_INPUT_BUFFERS() < NO_OUTPUT_BUFFERS() +1) {
		fprintf(stderr,"pred: not enough input buffers\n");
		return(2);
	}
	if((fp = fopen(ifile_name, "r")) == NULL) {
		fprintf(stderr,"pred: can't open spec file %s\n",
			ifile_name);
		return(3);
	}
	fscanf(fp, "%d", &q);
	fscanf(fp, "%d", &p);
	if(p > Mch || q > Mch) {
		fprintf(stderr,"pred: more than %d i/o channels\n",Mch);
		return(4);
	}
	if( q != NO_OUTPUT_BUFFERS() ||
	    p != NO_INPUT_BUFFERS() - q ) {
		fprintf(stderr,
		"pred: spec file %s does not agree with topology\n",
			ifile_name);
		return(5);
	}
	if(   (orders = (int*)calloc(p,sizeof(float))) == NULL
	   || (xpower = (float*)calloc(p,sizeof(float))) == NULL
	   || (epower = (float*)calloc(q,sizeof(float))) == NULL  ) {
		fprintf(stderr,"pred: can't allocate filter space\n");
		return(6);
	}
	N = 0;
	for(j=0; j<p; j++) {
		if((fscanf(fp,"%d",&orders[j])) != 1) {
			fprintf(stderr,"pred: improper input file %s\n",
					ifile_name);
			return(7);
		}
		N += orders[j];
	}
	if(  (W = (float*)calloc(N*q,sizeof(float))) == NULL
	   ||(Z = (float*)calloc(N,sizeof(float))) == NULL  ) {
		fprintf(stderr,"pred: can't allocate filter space\n");
		return(8);
	}
	for(k=0; k<q; k++) {
		for(i=0; i<N; i++) {
			if((fscanf(fp,"%f",&W[i*q+k])) != 1) {
				fprintf(stderr,"pred: improper input file %s\n",
					ifile_name);
				return(7);
			}
		}
	}
	fclose(fp);
	/* set up unit delay in error channels */
	for(k=0; k<q; k++)
		SET_DMIN_IN(k,1);
	/* initialize input power variables */
	for(j=0; j<p; j++)
		xpower[j] = 1e-1;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

#if 0
if(MIN_AVAIL() == 0) return(0);
#endif

for(jj = MIN_AVAIL(); jj>0; jj--) {

if(wait > 0) {
	wait--;
	for(k=0; k<q; k++) {
		IT_IN(k);
		if(IT_OUT(k)) {
			KrnOverflow("predlms",k);
			return(99);
		}
		OUTF(k,0) = 0;
	}
	for(j=0; j<p; j++)
		IT_IN(q+j);
	return(0);
}

/*** Normal Operation ***/
/* input new data and update power state */
for(j=0; j<p; j++) {
	IT_IN(q+j);
	z[j] = INF(q+j,0);
	xpower[j] *= .96;
	xpower[j] += .04 * z[j] * z[j];
}
/* input unit-delayed error(s) */
for(k=0; k<q; k++) {
	IT_IN(k);
	error[k] = INF(k,1);
	/* update error power state */
	epower[k] *= .96;
	epower[k] += .04 * error[k] * error[k];
}
if(adapt == 0) goto resume;

/**** lms algorithm *****/
for(k=0; k<q; k++) {
	/* update filter taps */
	index = 0;
	for(j=0; j<p; j++) {
		xalpha = error[k]/(2 * (1+orders[j]) * xpower[j]);
		xalpha *= lambda;
		/* LMS update taps */
		for(i=0; i<orders[j]; i++) {
			W[index*q+k] += xalpha * Z[index];
			W[index*q+k] *= delta;
			index++;
		}
	}
}

resume:

/* update data array */
for(i=N-1; i>0; i--)
	Z[i] = Z[i-1];
index = 0;
for(j=0; j<p; j++) {
	Z[index] = z[j];
	index += orders[j];
}
/* Compute, output estimate for each output channel */
for(k=0; k<q; k++) {
	estimate = 0;
	for(i=0; i<N; i++)
		estimate += W[i*q+k] * Z[i];
	if(IT_OUT(k)) {
			KrnOverflow("predlms",k);
			return(99);
	}
	OUTF(k,0) = estimate;
}
		
if(adapt > 0) adapt--;

}
return(0);


]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

for(k=0; k<q; k++) {
	if(epower[k] <= 0) epower[k] = 1e-30;
	fprintf(stderr,"predlms: pred error power(%d) = %#g = %#.3g dB\n",
	       k,epower[k],10*log10(epower[k]));
}
if((fp = fopen(ofile_name, "w")) == NULL) {
	fprintf(stderr,"pred: can't open output file %s\n", ofile_name);
	return(1);
}
fprintf(fp, "%d\n", q);
fprintf(fp, "%d\n", p);
for(j=0; j<p; j++) {
	fprintf(fp, "%d \t", orders[j]);
}
fprintf(fp, "\n");
for(k=0; k<q; k++) {
	index = 0;
	for(j=0; j<p; j++) {
		fprintf(fp, "\n");
		for(i=0; i<orders[j]; i++) {
			fprintf(fp, "%g   \t", W[index*q+k]);
			if((i+1)%5 == 0) fprintf(fp, "\n");
			index++;
		}
		fprintf(fp, "\n");
	}
	fprintf(fp, "\n");
}
fclose(fp);
free((char*)orders);free((char*)W);
free((char*)xpower);free((char*)epower);

]]>
</WRAPUP_CODE> 



</BLOCK> 

