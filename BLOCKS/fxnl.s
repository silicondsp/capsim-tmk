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

fxnl 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*************************************************************
Fixed Point Normalized Lattice Filter
				fxnl()
This block implements a fixed point normalized lattice filter. 
All variables used are of type integer so that the algorithm can 
be directly implemented on a Digital Signal Processor.
This block supports both floating point and integer buffers.
If floating point buffers are used, the input samples are quantized 
with the input quantizer range and number of bits specified as
parameters.
The output is also converted to floating point within the
original quantizer range. e.g. +- 5 volts.
If integer buffers are used, no quantization is used and the
integer input samples are processed directly.
This block can be replace the floating point normalized lattice block
nl.s to analyze the effects of fixed point implementation
with different word sizes.
***************************************************************
*/
<NAME>
fxnl
</NAME>
<DESCRIPTION>
Fixed Point Normalized Lattice Filter
				fxnl()
This block implements a fixed point normalized lattice filter. 
All variables used are of type integer so that the algorithm can 
be directly implemented on a Digital Signal Processor.
This block supports both floating point and integer buffers.
If floating point buffers are used, the input samples are quantized 
with the input quantizer range and number of bits specified as
parameters.
The output is also converted to floating point within the
original quantizer range. e.g. +- 5 volts.
If integer buffers are used, no quantization is used and the
integer input samples are processed directly.
This block can be replace the floating point normalized lattice block
nl.s to analyze the effects of fixed point implementation
with different word sizes.
</DESCRIPTION>
<PROGRAMMERS>
Programmer: Sasan H Ardalan
Date: September 7, 1991 
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
This block implements a fixed point normalized lattice filter. 
</DESC_SHORT>


<DEFINES> 

#define FLOAT_BUFFER 0
#define INTEGER_BUFFER 1

</DEFINES> 

              

<STATES>
	<STATE>
		<TYPE>int*</TYPE>
		<NAME>k</NAME>
	</STATE>
	<STATE>
		<TYPE>int*</TYPE>
		<NAME>c</NAME>
	</STATE>
	<STATE>
		<TYPE>int*</TYPE>
		<NAME>nu</NAME>
	</STATE>
	<STATE>
		<TYPE>int*</TYPE>
		<NAME>xb</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>n</NAME>
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
		<TYPE>float</TYPE>
		<NAME>wsc</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>wnorm</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>fs</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>bitPrec</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>quant</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int buffer_no;
        float xf,tmp;
	int	xq;
	int	sum,ysum;
	float	val;
	int	xfq,yq;
        int n1,n2,i,j,m;
	int	noSamples;
	FILE* fp;

</DECLARATIONS> 

             

<PARAMETERS>
<PARAM>
	<DEF>File with normalized lattice filter parameters</DEF>
	<TYPE>file</TYPE>
	<NAME>file_name</NAME>
	<VALUE>tmp.lat</VALUE>
</PARAM>
<PARAM>
	<DEF>Fixed point precision for coefficients, bits</DEF>
	<TYPE>int</TYPE>
	<NAME>regBits</NAME>
	<VALUE>16</VALUE>
</PARAM>
<PARAM>
	<DEF>Input/output quantization bits</DEF>
	<TYPE>int</TYPE>
	<NAME>quantBits</NAME>
	<VALUE>16</VALUE>
</PARAM>
<PARAM>
	<DEF>Input/output Range e.g. +- 5 volts</DEF>
	<TYPE>int</TYPE>
	<NAME>quantRange</NAME>
	<VALUE>10.0</VALUE>
</PARAM>
<PARAM>
	<DEF>0=Float Buffers,1=Integer Buffer</DEF>
	<TYPE>int</TYPE>
	<NAME>bufferType</NAME>
	<VALUE>0</VALUE>
</PARAM>
</PARAMETERS>

<INIT_CODE>
<![CDATA[ 

if((numberInputBuffers = NO_INPUT_BUFFERS()) <= 0) {
        fprintf(stderr,"fxn1: no inputs connected\n");
        return(1);
}
if(numberInputBuffers > 1) {
        fprintf(stderr,"fxnl: only one  input allowed \n");
        return(2);
}
if((numberOutputBuffers = NO_OUTPUT_BUFFERS()) > numberInputBuffers) {
        fprintf(stderr,"fxnl: too many outputs connected\n");
        return(3);
}
if(numberOutputBuffers == 0) {
        fprintf(stderr,"fxnl: no output connected\n");
        return(4);
}
if(strcmp(file_name,"stdin") == 0)
			fp = stdin;
else if((fp = fopen(file_name,"r")) == NULL) {
		fprintf(stderr,"fxnl():can't open file \n");
		return(1); /* nl() file cannot be opened */
}
/*****************************************************
   read lattice filter parameters from file
****************************************************/
fscanf(fp,"%d",&n);
n1=n+1;
/*   allocate work space      */
if(((k=(int*)calloc(n,sizeof(int))) == NULL) ||
		((c=(int*)calloc(n,sizeof(int))) == NULL) ||
		((nu=(int*)calloc(n1,sizeof(int))) == NULL) ||
		((xb=(int*)calloc(n1,sizeof(int))) == NULL )) {
		fprintf(stderr,"fxnl(): can't allocate work space \n");
		return(1);
}
bitPrec=1;
bitPrec = bitPrec<< regBits;
quant=1;
quant = quant<< quantBits;
for (i=0; i<n; i++) {
		/*
		 * Read k parameters
		 */
    	     	fscanf(fp,"%f ",&val);
		k[i]=val*bitPrec;
    	     	tmp=val*val;
    	     	tmp=1.0-tmp;
	     	val=sqrt(tmp);
		c[i]=val*bitPrec;
}
n1=n+1;
for (i=0; i<n1; i++) {
                   fscanf(fp,"%f ",&val);
		   nu[i]=val*bitPrec;
}
fscanf(fp,"%f",&wsc);
fscanf(fp,"%f",&fs);
fscanf(fp,"%f",&wnorm);
/*    
 * initial conditions   
 */
for (i=0; i<n1; i++) xb[i]=0.0; 
fclose(fp);
switch (bufferType) {
	case FLOAT_BUFFER:
		SET_CELL_SIZE_IN(0,sizeof(float));
		SET_CELL_SIZE_OUT(0,sizeof(float));
		break;
	case INTEGER_BUFFER:
		SET_CELL_SIZE_IN(0,sizeof(int));
		SET_CELL_SIZE_OUT(0,sizeof(int));
		break;
}

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


     for(noSamples=MIN_AVAIL();noSamples >0; --noSamples) {
     	  IT_IN(0);
	switch (bufferType) {
		case FLOAT_BUFFER:
			/*
			 * input floating point sample and quantize
			 */
			xf=INF(0,0);
	  		xfq = (int) xf*quant/(2.0 * quantRange);
			break;
		case INTEGER_BUFFER:
			xq=INI(0,0);
			break;
	}
             

        for (m=0; m<n; m++) {
             i=n-m;
             xb[i]=xb[i-1]*c[i-1]+k[i-1]*xfq;
	     xb[i] = xb[i] >> regBits;
             xfq=xfq*c[i-1]-k[i-1]*xb[i-1];    
	     xfq = xfq >> regBits;
        }
        xb[0]=xfq;
        sum=0;
        for (m=0; m<n+1; m++)  sum=sum+xb[m]*nu[m];
        ysum=sum >> regBits;
     	  if(IT_OUT(0)) {
		KrnOverflow("fxnl",0);
		return(99);
	  }
	switch (bufferType) {
		case FLOAT_BUFFER:
			/*
			 * convert to float and output floating point sample
			 */
          		OUTF(0,0)=ysum*wsc/wnorm*quantRange*2.0/quant;
			break;
		case INTEGER_BUFFER:
          		OUTI(0,0)=(int) ysum*wsc/wnorm;
			break;
	}
             

     }


]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

	free(k);
	free(nu);
	free(c);
	free(xb);

]]>
</WRAPUP_CODE> 



</BLOCK> 

