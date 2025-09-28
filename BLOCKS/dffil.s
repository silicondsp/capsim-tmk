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

dffil 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* dffil.s */
/***********************************************************************
                             dffil()
************************************************************************
Star implements direct form IIR digital filter.
Parameter: (file) File with the filter coefficients and parameters
The inputs from the file are as follows;
           num: Number of numerator coefficients 
	   numerator coefficients
	   denum: Number of denominator coefficients
	   denominator coefficients
*/
/**********************************************************************
c Direct form filter coefficients are read from a file                *
c The inputs from the file are as follows:                            *
c  m n : where m is the number of zeroes plus one                     *
c        n is the number of poles                                     *
c  b(i) i=1,m+n : the numerator and denominator coefficients          *
c                     						      *
c  In the z domain:						      *
c      Y(z)/X(z)=C(z)/[1+A(z)]					      *
c  C(z)=c0+c1*z**(-1)+... cm-1*z**(-m+1)			      *
c  A(z)=a1*z**(-1)+...+an*z**(-n)				      *
c								      *
c  The subroutine calculates the vector inner product y(k)=x_Tb_      *
c  x_ where x_=[x(k) x(k-1) ... x(k-m+1) -y(k-1) -y(k-2) ... -y(k-n)] T
c  b_=[c0 c1 ... cm-1 a1 a2 ... an ]T				      *
c								      *
c								      *
c**********************************************************************
<NAME>
dffil
</NAME>
<DESCRIPTION>
Star implements direct form IIR digital filter.
Parameter: (file) File with the filter coefficients and parameters
The inputs from the file are as follows;
           num: Number of numerator coefficients 
	   numerator coefficients
	   denum: Number of denominator coefficients
	   denominator coefficients
*/
/**********************************************************************
c Direct form filter coefficients are read from a file                *
c The inputs from the file are as follows:                            *
c  m n : where m is the number of zeroes plus one                     *
c        n is the number of poles                                     *
c  b(i) i=1,m+n : the numerator and denominator coefficients          *
c                     						      *
c  In the z domain:						      *
c      Y(z)/X(z)=C(z)/[1+A(z)]					      *
c  C(z)=c0+c1*z**(-1)+... cm-1*z**(-m+1)			      *
c  A(z)=a1*z**(-1)+...+an*z**(-n)				      *
c								      *
c  The subroutine calculates the vector inner product y(k)=x_Tb_      *
c  x_ where x_=[x(k) x(k-1) ... x(k-m+1) -y(k-1) -y(k-2) ... -y(k-n)] T
c  b_=[c0 c1 ... cm-1 a1 a2 ... an ]T				      *
c								      *
c								      *
c**********************************************************************
</DESCRIPTION>
<PROGRAMMERS>
Date:  July 30, 1991 
Programmer: Sasan H. Ardalan 
</PROGRAMMERS>
*/

]]>
</COMMENTS> 

         
<DESC_SHORT>
Star implements direct form IIR digital filter.
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>b_A</NAME>
	</STATE>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>x_A</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>m</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>n</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>fs</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>wnorm</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>nt</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	float 	temp1,temp2;
	double 	sum;
	int 	i,j,np1;
	float 	x1,yr;
        FILE *ird_F;

</DECLARATIONS> 

     

<PARAMETERS>
<PARAM>
	<DEF>File with direct form  filter parameters</DEF>
	<TYPE>file</TYPE>
	<NAME>filename</NAME>
	<VALUE>tmp.df</VALUE>
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

	/*
	 * open file containing filter coefficients. Check 
	 * to see if it exists.
	 *
	 */
        if( (ird_F = fopen(filename,"r")) == NULL) {
		fprintf(stderr,"dffil: File could not be opened  \n");
		return(4);
	}
	/*
	 * Read in the filter coefficients and filter parameters.
	 *
	 */
         fscanf(ird_F,"%d %d",&m,&n);
	 nt=m+n;
	 b_A = (float *)malloc((nt+5)*sizeof(float));
	 if(b_A == NULL) {
		fprintf(stderr,"dffil: could not allocate space \n");
		return(5);
	 } 
	 x_A = (float *)malloc((nt+5)*sizeof(float));
	 if(x_A == NULL) {
		fprintf(stderr,"dffil: could not allocate space \n");
		return(6);
	 } 
	 for(i=0; i<nt-1; i++)
		fscanf(ird_F,"%e",&b_A[i]);
for(i=0; i<nt; i++)
	fprintf(stderr,"%e \n",b_A[i]);
         fscanf(ird_F,"%f",&fs);  
         fscanf(ird_F,"%f",&wnorm); 
	 fclose(ird_F);
	/*   ***                                                     ***
	 *   *** initialize input vector x and coefficient vector b  ***
	 *   ***                                                     ***
	 */
	for(i=0; i<nt-1; i++) 
        	x_A[i]=0.0;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

while (IT_IN(0)) {
	x1 = x(0);
	/*   ***                                                     ***
	 *   ***  the following loop calculates the filter  response  ***
	 *   ***                                                     ***
	 */
fprintf(stderr,"yr= %e x1= %e\n",yr,x1);
        yr= - y(1);
    
	/*   ***                                                     ***
	 *   ***  shift    the new value of x(0) into the vector x    ***
	 *   ***                                                     ***
	 */
        temp2=x1;
	for(i=0; i< m; i++) {
        	temp1=x_A[i];
        	x_A[i]=temp2;
        	temp2=temp1;
	}
	/*   ***                                                     ***
	 *   ***  shift -y into vector x                              ***
	 *   ***                                                     ***
	 */
	if ( n != 0) { 
        	temp2=yr;
		for(i=m; i<nt-1; i++) { 
        		temp1=x_A[i];
        		x_A[i]=temp2;
        		temp2=temp1;
		}
	}
	/*   ***                                                     ***
	 *   *** calculate  value of y.                              ***
	 *   *** yest= x(transpose)*b                                ***
	 *   ***                                                     ***
	 */
        sum=0.0;
	for(i=0; i<nt-1; i++) 
		sum=sum+x_A[i]*b_A[i];
        if(IT_OUT(0)) {
		KrnOverflow("dffil",0);
		return(99);
	}
        y(0) = sum/(double)wnorm;
}

        return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

	free(b_A);
	free(x_A);

]]>
</WRAPUP_CODE> 



</BLOCK> 

