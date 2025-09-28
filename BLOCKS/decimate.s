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

decimate 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*************************************************************
	Decimation filter for weights in Delta Sigma Modulation
***************************************************************
<NAME>
decimate
</NAME>
<DESCRIPTION>
Decimation filter for weights in Delta Sigma Modulation
</DESCRIPTION>
<PROGRAMMERS>
Programmer: Sasan H Ardalan
Date: August 22,1987
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

<DESC_SHORT>
Decimation filter for weights in Delta Sigma Modulation
</DESC_SHORT>

<DEFINES> 

#define UNIFORM 1
#define TRIANGULAR 2
#define PARABOLIC 3

</DEFINES> 

      

<STATES>
	<STATE>
		<TYPE>int*</TYPE>
		<NAME>weights_P</NAME>
	</STATE>
	<STATE>
		<TYPE>int*</TYPE>
		<NAME>x_P</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>wnorm</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>k</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int buffer_no,no_samples;
        float xf,ysum,sum,tmp;
        int n1,n2,i,j,m;
	int nf1,nfd2,nfd3;
	float	tmp2,tmp1;

</DECLARATIONS> 

         

<PARAMETERS>
<PARAM>
	<DEF>Weighting: 1-Uniform 2-Triangular 3-Parabolic</DEF>
	<TYPE>int</TYPE>
	<NAME>iw</NAME>
	<VALUE>3</VALUE>
</PARAM>
<PARAM>
	<DEF>Number of taps for FIR decimation filter</DEF>
	<TYPE>int</TYPE>
	<NAME>nf</NAME>
	<VALUE>128</VALUE>
</PARAM>
<PARAM>
	<DEF>Decimation factor</DEF>
	<TYPE>int</TYPE>
	<NAME>idec</NAME>
	<VALUE>32</VALUE>
</PARAM>
</PARAMETERS>

    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>xx</NAME>
	</BUFFER>
</INPUT_BUFFERS>
 
    

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>y</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 

/*   
 * allocate work space      
 */
if(((weights_P=(int*)calloc(nf,sizeof(int))) == NULL) ||
		(x_P =(int*)calloc(nf,sizeof(int))) == NULL) { 
		fprintf(stderr,"decimate(): can't allocate work space \n");
		return(1);
}
nf1=nf-1;
nfd2=(int)(nf/2);
nfd3=(int)(nf/3.)+1;
/*
 * setup weights for decimation filters
 */
wnorm=0.0;
for(i=0; i<nf; i++) {
	switch(iw) {
		   case UNIFORM:
			weights_P[i]=1;
		        break;
		   case PARABOLIC:
	   		if(i <= nfd3)  {
	      		   weights_P[i]=(int)(i*(i+1)/2);
	      		   weights_P[nf-i-1]=weights_P[i];
			} else  if(i <= nfd2) {
	      		   weights_P[i]=(int)(nfd3*(nfd3+1)/2+(i-nfd3)*(2*nfd3-1-i));
	      		   weights_P[nf-i-1]=weights_P[i];
			} 
			break;
		   case TRIANGULAR:
	   	      if(i <=  nfd2-1)  
	      			weights_P[i]=i;
	   	      else
	      			weights_P[i]=nf-i;
		      break;
		   default:
			fprintf(stderr,"decimate invalid window type\n");
			return(2);
			break;
	}
	/*
	 * Initialized Tapped Delay Line to Zero
	 */
	x_P[i]=0;
    	wnorm=wnorm+weights_P[i];
}
k=0;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


while(IT_IN(0)) {
	/*
         * Shift input sample into tapped delay line
         */
         tmp2=xx(0);
         for(i=0; i<nf; i++) {
                tmp1=x_P[i];
                x_P[i]=tmp2;
                tmp2=tmp1;
         }
         /*
          * Compute inner product
          */
         sum = 0.0;
         for (i=0; i<nf; i++) {
                     sum += x_P[i]*weights_P[i];
         }
	 k++;
	 if(k==idec) {
	 	if(IT_OUT(0)) {
			KrnOverflow("decimate",0);
			return(99);
		}
	 	y(0)=sum/wnorm;
		k=0;
	 }

}


]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

	free(x_P);
	free(weights_P);

]]>
</WRAPUP_CODE> 



</BLOCK> 

