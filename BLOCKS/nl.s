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

nl 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*************************************************************
			Normalized Lattice Filter
				nl()
***************************************************************
<NAME>
nl
</NAME>
<DESCRIPTION>
Normalized Lattice Filter
</DESCRIPTION>
<PROGRAMMERS>
Programmer: Sasan H Ardalan
Date: August 22,1987
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

           
<DESC_SHORT>
Normalized Lattice Filter
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>FILE*</TYPE>
		<NAME>fp</NAME>
	</STATE>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>k</NAME>
	</STATE>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>c</NAME>
	</STATE>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>nu</NAME>
	</STATE>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>xb</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>n</NAME>
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
</STATES>
 
<DECLARATIONS> 

	int buffer_no;
	FILE *fopen();
        float xf,ysum,sum,tmp;
        int n1,n2,i,j,m;
	int	noSamples;

</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF>File with normalized lattice filter parameters</DEF>
	<TYPE>file</TYPE>
	<NAME>file_name</NAME>
	<VALUE>tmp.lat</VALUE>
</PARAM>
</PARAMETERS>

    

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>x</NAME>
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

		if(strcmp(file_name,"stdin") == 0)
			fp = stdin;
		else if((fp = fopen(file_name,"r")) == NULL)
			return(1); /* nl() file cannot be opened */
	     /*****************************************************
		   read lattice filter parameters from file
	      ****************************************************/
	     fscanf(fp,"%d",&n);
	     n1=n+1;
	     /*   allocate work space      */
	     if(((k=(float*)calloc(n,sizeof(float))) == NULL) ||
		((c=(float*)calloc(n,sizeof(float))) == NULL) ||
		((nu=(float*)calloc(n1,sizeof(float))) == NULL) ||
		((xb=(float*)calloc(n1,sizeof(float))) == NULL )) {
		fprintf(stderr,"nl(): can't allocate work space \n");
		return(1);
    	     }
 	     for (i=0; i<n; i++) {
    	     fscanf(fp,"%f ",&k[i]);
    	     tmp=k[i]*k[i];
    	     tmp=1.0-tmp;
	     c[i]=sqrt(tmp);
             }
             n1=n+1;
             for (i=0; i<n1; i++) {
                   fscanf(fp,"%f ",&nu[i]);
             }
             fscanf(fp,"%f",&wsc);
             fscanf(fp,"%f",&fs);
             fscanf(fp,"%f",&wnorm);
      	     /*    initial conditions   */
             for (i=0; i<n1; i++) xb[i]=0.0; 
             fclose(fp);

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


     for(noSamples=MIN_AVAIL();noSamples >0; --noSamples) {
     	  IT_IN(0);
	  xf=x(0);
          for (m=0; m<n; m++) {
             i=n-m;
             xb[i]=xb[i-1]*c[i-1]+k[i-1]*xf;
             xf=xf*c[i-1]-k[i-1]*xb[i-1];    
          }
          xb[0]=xf;
          sum=0.0;
          for (m=0; m<n+1; m++)  sum=sum+xb[m]*nu[m];
          ysum=sum;
	  if(IT_OUT(0)) {
		KrnOverflow("nl",0);
		return(99);
	  }
          y(0)=ysum*wsc/wnorm;
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

