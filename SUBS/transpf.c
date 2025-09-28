/*************************************************************/
/* transpose matrix arr  n*m  in place.  Use (float).        */
/*************************************************************/
#include <stdio.h>
#include <math.h>
#include <stdlib.h>

void transpf(float arr[1][1],int  n,int  m)
	 
{
	float *temp;
	int i, j;
temp = (float*)calloc(n*m,sizeof(float));

for (i=0;i<n;++i)
	for (j=0;j<m;++j)
		temp[j*n+i] = arr[i*m][j];
for (i=0;i<n;++i)
	for (j=0;j<m;++j)
		arr[i*m][j] = temp[i*m+j];

}
