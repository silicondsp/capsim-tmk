

/*  Capsim (r) Text Mode Kernel (TMK) Star Library (Blocks)
    Copyright (C) 1989-2017   Silicon DSP  Corporation

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
*/


#include <math.h>
#include <stdio.h>

/*
 *
 *-----------------------------------------------------------------------
 *  AUTHORS:      A. H. GRAY, JR.  AND J. D. MARKEL
 *      GRAY -    UNIV. OF CALIF., SANTA BARBARA, CA 93109
 *     BOTH -    SIGNAL TECHNOLOGY, INC., 15 W. DE LA GUERRA STREET
 *               SANTA BARBARA, CA 93101
 *-----------------------------------------------------------------------
 *
 * Translated from FORTRAN to C by Sasan Ardalan, Feb. 22, 1991
 */

#if 0
main(argc,argv)
int argc;
char **argv;
{
float x_A[100],a_A[21],rc_A[21];
int j,m,n;
int i;
int mp,jb;
float alpha;


      x_A[0] = 1.;
      x_A[1] = 1.44;
      x_A[2] = 1.44*x_A[1] - 1.26;
      for(j=4; j<=40; j++) {

        x_A[j-1] = 1.44*x_A[j-1-1] - 1.26*x_A[j-2-1] + .81*x_A[j-3-1];
      }

      n = 40;
      for (m=2; m<=3; m++) {

        	Dsp_Covar(n, x_A, m, a_A, &alpha, rc_A);
        	mp = m + 1;
        	for(i=0; i<mp; i++)
        		printf("a = %e rc= %e \n",a_A[i],rc_A[i]);
        	printf("alpha= %e \n",alpha);

        	Dsp_Auto(n, x_A, m, a_A, &alpha, rc_A);
        	for(i=0; i<mp; i++)
        		printf("a = %e rc= %e \n",a_A[i],rc_A[i]);
        	printf("alpha= %e \n",alpha);


  	  }
  	  for(jb=1; jb<=40; jb++) {

         	j = 44 - jb;
        	x_A[j-1] = x_A[j-3-1];
      }
      for(j=1; j<=3; j++) {

        	jb = 43 + j;
        	x_A[j-1] = 0.;
        	x_A[jb-1] = 0.;
      }
      m = 3;
      n = 46;
      Dsp_Covar(n, x_A, m, a_A, &alpha, rc_A);
      mp = m + 1;
      for(i=0; i<mp; i++)
        		printf("a = %e rc= %e \n",a_A[i],rc_A[i]);
      printf("alpha= %e \n",alpha);

      Dsp_Auto(n, x_A, m, a_A, &alpha, rc_A);

      for(i=0; i<mp; i++)
        		printf("a = %e rc= %e \n",a_A[i],rc_A[i]);
      printf("alpha= %e \n",alpha);

}
#endif

/*
 *
 *-----------------------------------------------------------------------
 * SUBROUTINE:  COVAR
 * A SUBROUTINE FOR IMPLEMENTING THE COVARIANCE
 * METHOD OF LINEAR PREDICTION ANALYSIS
 *-----------------------------------------------------------------------
 *
 */

int Dsp_Covar(int n,float* x_P,int m,float* a_P,float* alpha_P,float* grc_P)


{
/*
 *
 *   INPUTS:   N - NO. OF DATA POINTS
 *             x_A(N) - INPUT DATA SEQUENCE
 *             M - ORDER OF FILTER (M<21, SEE NOTE*)
 *  OUTPUTS:   A - FILTER COEFFICIENTS
 *             ALPHA - RESIDUAL "ENERGY"
 *             A - FILTER COEFFICIENTS
 *             GRC - "GENERALIZED REFLECTION COEFFICIENTS",
 *
 **PROGRAM LIMITED TO M=20, BECAUSE OF THE DIMENSIONS
 * B(M*(M-1)/2), BETA(M), AND CC(M+1)
 *
 */
float b_A[190],beta_A[20],cc_A[21];
int	mp,j,mt,m2;
int	np1,np;
float alpha;
int mf,minc,n1,n2,n3,n4;
int jp,ip;
int msub,mm1,isub;
float gam;
float s;



mp = m + 1;
mt = (mp*m)/2;
for(j=0; j<mt; j++)
	b_A[j]=0.0;
for(j=0; j<mp; j++)
	grc_P[j]=0.0;
*alpha_P=0.0;
alpha = 0.;
cc_A[0] = 0.;
cc_A[1] = 0.;
for( np=mp-1; np < n; np++) {
        np1 = np - 1;
	alpha = alpha + x_P[np]*x_P[np];
        cc_A[0] = cc_A[0] + x_P[np]*x_P[np1];
        cc_A[1] = cc_A[1] + x_P[np1]*x_P[np1];
}
b_A[0]  = 1.;
beta_A[0] = cc_A[1];
grc_P[0] = -cc_A[0]/cc_A[1];
a_P[0] = 1.;
a_P[1] = grc_P[0];
alpha = alpha + grc_P[0]*cc_A[0];
mf = m;
for(minc = 2; minc<= mf; minc++) {
	for(j=1; j<= minc; j++) {
          	jp = minc + 2 - j;
          	n1 = mp + 1 - jp;
          	n2 = n + 1 - minc;
          	n3 = n + 2 - jp;
          	n4 = mp - minc;
          	cc_A[jp-1] = cc_A[jp-1-1] + x_P[n4-1]*x_P[n1-1] - x_P[n2-1]*x_P[n3-1];
	}
        cc_A[0] = 0.;
	for (np=mp; np<= n; np++) {
          	n1 = np - minc;
          	cc_A[0] = cc_A[0] + x_P[n1-1]*x_P[np-1];
	}
        msub = (minc*minc-minc)/2;
        mm1 = minc - 1;
        n1 = msub + minc;
        b_A[n1-1] = 1.;
	for (ip=1; ip<= mm1; ip++) {
          isub = (ip*ip-ip)/2;

          if(beta_A[ip-1] <= 0.0) {
          	    /*
			     * WARNING - SINGULAR MATRIX
			     */
          		fprintf(stderr,"WARNING - SINGULAR MATRIX - COVAR \n");
				return(1);

          }
	  /*50*/
          gam = 0.;
	  for( j=1; j<= ip; j++) {
            n1 = isub + j;
            gam = gam + cc_A[j+1-1]*b_A[n1-1];
	  }
          gam = gam/beta_A[ip-1];
	  for(jp=1; jp<=ip; jp++) {
               n1 = msub + jp;
               n2 = isub + jp;
               b_A[n1-1] = b_A[n1-1] - gam*b_A[n2-1];
	  }
	}
        beta_A[minc-1] = 0.;
	for(j =1; j<= minc; j++) {
             n1 = msub + j;
             beta_A[minc-1] = beta_A[minc-1] + cc_A[j+1-1]*b_A[n1-1];
	}

    if(beta_A[minc-1] <= 0.0) {
    	    /*
			 * WARNING - SINGULAR MATRIX
			 */
        	fprintf(stderr,"WARNING - SINGULAR MATRIX - COVAR \n");
			return(1);
	}
	/*100*/
    s = 0.;
	for( ip=1; ip<=minc; ip++)
		s= s + cc_A[ip-1]*a_P[ip-1];
        grc_P[minc-1] = -s/beta_A[minc-1];
	for(ip=2; ip <=minc; ip++) {
             m2 = msub + ip - 1;
             a_P[ip-1] = a_P[ip-1] + grc_P[minc-1]*b_A[m2-1];
	}
        a_P[minc] = grc_P[minc-1];
        s = grc_P[minc-1]*grc_P[minc-1]*beta_A[minc-1];
        alpha = alpha - s;

        if(alpha <= 0.0) {
	        /*
			 * WARNING - SINGULAR MATRIX
			 */
        	fprintf(stderr,"WARNING - SINGULAR MATRIX - COVAR \n");
			return(1);
		}
}

*alpha_P = alpha;

return(0);

}

/*
 *-----------------------------------------------------------------------
 *SUBROUTINE:  AUTO
 *A SUBROUTINE FOR IMPLEMENTING THE AUTOCORRELATION
 *METHOD OF LINEAR PREDICTION ANALYSIS
 *-----------------------------------------------------------------------
 *
 *   INPUTS:   N - NO. OF DATA POINTS
 *             x_A(N) - INPUT DATA SEQUENCE
 *             M - ORDER OF FILTER (M<21, SEE NOTE*)
 *  OUTPUTS:   A - FILTER COEFFICIENTS
 *            ALPHA - RESIDUAL "ENERGY"
 *            RC - REFLECTION COEFFICIENTS
 *
 *  PROGRAM LIMITED TO M<21 BECAUSE OF DIMENSIONS OF R(.)
 */
int Dsp_Auto(int n,float* x_P,int m,float* a_P,float* alpha_P,float* rc_P)


{

float r_A[21];
int	mp,j,mt,m2;
float alpha;
int mf,minc,mh;
int k,ip,nk,np,n1;
float s;
float at;
int ib;


mp = m + 1;
for(k=1; k<=mp; k++) {

      	 r_A[k-1]=0.0;

         nk = n - k + 1;
         for (np=1; np<=nk; np++) {

          	n1 = np + k - 1;
          	r_A[k-1] = r_A[k-1] + x_P[np-1]*x_P[n1-1];
         }
}

rc_P[0] = -r_A[1]/r_A[0];
a_P[0] = 1.;
a_P[1] = rc_P[0];
alpha = r_A[0] + r_A[1]*rc_P[0];
for( minc=2; minc<= m; minc++) {
      	s=0.0;

        for (ip=1; ip<=minc; ip++) {


          		n1 = minc - ip + 2;
          		s = s + r_A[n1-1]*a_P[ip-1];
	    }
        rc_P[minc-1] = -s/alpha;
        mh = minc/2 + 1;
        for(ip=2; ip<=mh; ip++) {

          	ib = minc - ip + 2;
          	at = a_P[ip-1] + rc_P[minc-1]*a_P[ib-1];
          	a_P[ib-1] = a_P[ib-1] + rc_P[minc-1]*a_P[ip-1];
          	a_P[ip-1] = at;
        }

        a_P[minc+1-1] = rc_P[minc-1];
        alpha = alpha + rc_P[minc-1]*s;
        if(alpha <= 0.0) {
        	/*
			 * WARNING - SINGULAR MATRIX
			 */
        	fprintf(stderr,"WARNING - SINGULAR MATRIX - AUTO \n");
        	return(1);
        }
}
return(0);

}
