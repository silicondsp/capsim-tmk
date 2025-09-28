

/*	(C) COPYRIGHT 1982, 1983, 1984 DSPS INC., OTTAWA CANADA 
	AND L. ROBERT MORRIS. ALL RIGHTS RESERVED.
*/
#include <math.h> 
#define pi 3.1415926

void cxfft(float *x,int *mfft)
//float *x;
//int   *mfft;
{
	int	n;
	int	m;
	float   u[2],w[2],t[2];
	int	nv2;
	int	nm1;
	int	j,i;
	int	le,le1,ip;
	int	l,k;
	float 	tmp;

	m = *mfft;
	n=1;
	n <<= m;
	nv2 = n/2;
	nm1 = n-1 ;
	j= 0;
/*	BIT REVERSAL, OR UNSCRAMBLING  */
	for (i=0; i< nm1; i++) {
	if ( i < j ) {
		t[0] = x[j*2]; t[1] = x[2*j+1];
		x[2*j] = x[2*i]; x[2*j+1] = x[2*i+1];
		x[2*i] = t[0]; x[2*i+1]=t[1];
	}
	k = nv2;
	while ( k < j+1 ) {
		j=j-k;
		k=k/2;
	}
	j=j+k;
	}
/*	"M" STAGES FOR 2**M POINTS	*/
	for (l=1; l<= m; l++) {
		le=1;
		le <<= l;
		le1 = le/2;
		u[0] = 1.0; u[1]=0.0;
		w[0] = cos(pi/((float )le1)); w[1] = sin(pi/((float )le1));
			for (j=0; j< le1; j++) {
				for (i=j; i< n; i=i+le) {
					ip=i+le1;
/*                        ----- THE "BUTTERFLY" ---       */

					t[0] = x[2*ip]*u[0] - x[2*ip+1]*u[1];
					t[1] = x[2*ip]*u[1] + x[2*ip+1]*u[0];
					x[2*ip] = x[2*i] - t[0];
					x[2*ip+1] = x[2*i+1] - t[1];
					x[2*i] = x[2*i] + t[0];
					x[2*i+1] = x[2*i+1] + t[1];
				}
/*			------  END OF BUTTERFLY   ------ */

			tmp = u[0];
			u[0] = tmp*w[0] - u[1]*w[1];
			u[1] = tmp*w[1] + u[1]*w[0];
			}
		}
}




/*	(C) COPYRIGHT 1982, 1983, 1984 DSPS INC., OTTAWA CANADA 
	AND L. ROBERT MORRIS. ALL RIGHTS RESERVED.
*/
#include <math.h> 
#define pi 3.1415926

void cxifft(float *x,int *mfft)

{
	int	n;
	int	m;
	float   u[2],w[2],t[2];
	int	nv2;
	int	nm1;
	int	j,i;
	int	le,le1,ip;
	int	l,k;
	float 	tmp;

	m = *mfft;
	n=1;
	n <<= m;
	nv2 = n/2;
	nm1 = n-1 ;
	j= 0;
/*	BIT REVERSAL, OR UNSCRAMBLING  */
	for (i=0; i< nm1; i++) {
	if ( i < j ) {
		t[0] = x[j*2]; t[1] = x[2*j+1];
		x[2*j] = x[2*i]; x[2*j+1] = x[2*i+1];
		x[2*i] = t[0]; x[2*i+1]=t[1];
	}
	k = nv2;
	while ( k < j+1 ) {
		j=j-k;
		k=k/2;
	}
	j=j+k;
	}
/*	"M" STAGES FOR 2**M POINTS	*/
	for (l=1; l<= m; l++) {
		le=1;
		le <<= l;
		le1 = le/2;
		u[0] = 1.0; u[1]=0.0;
		w[0] = cos(pi/((float )le1)); w[1] = -sin(pi/((float )le1));
			for (j=0; j< le1; j++) {
				for (i=j; i< n; i=i+le) {
					ip=i+le1;
/*                        ----- THE "BUTTERFLY" ---       */

					t[0] = x[2*ip]*u[0] - x[2*ip+1]*u[1];
					t[1] = x[2*ip]*u[1] + x[2*ip+1]*u[0];
					x[2*ip] = x[2*i] - t[0];
					x[2*ip+1] = x[2*i+1] - t[1];
					x[2*i] = x[2*i] + t[0];
					x[2*i+1] = x[2*i+1] + t[1];
				}
/*			------  END OF BUTTERFLY   ------ */

			tmp = u[0];
			u[0] = tmp*w[0] - u[1]*w[1];
			u[1] = tmp*w[1] + u[1]*w[0];
			}
		}
}




