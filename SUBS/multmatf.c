
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
/***************************************************************/
/* Matrix multiply arr1 n1*m1 by arr2 m1*m2 and return in arr3 */
/* arr1 and arr2 may be the same matrices.  arr3 may also be   */
/* same as arr1 or arr2, in this version.                      */
/* This version uses (float) arrays.                           */
/* programmer: ljfaber  5/88                                   */
/***************************************************************/
#include <stdio.h>
#include <math.h>
#include <stdlib.h>

void copymatf(float  arr1[1][1],int  n,int m, float arr2[1][1]);
#if 0000  //.NEED TO FIX mismatch linaer aaray versus [][]
void multmatf(float arr1[1][1],float  arr2[1][1],int  n1, int m1, int m2,float  arr3[1][1])

{
	int i, j, k;
	float *temp;
temp = (float*)calloc(n1*m2,sizeof(float));

for(i=0; i<n1; ++i) {
	for(j=0; j<m2; ++j) {
		temp[i*m2+j] = 0;
		for(k=0; k<m1; ++k)
			temp[i*m2+j] += arr1[i*m1][k]*arr2[k*m2][j];
	}
}
copymatf(temp, n1,m2, arr3);

}
#endif



#if 0000
void multmatf(float arr1[1][1],float  arr2[1][1],int  n1, int m1, int m2,float  arr3[1][1])

{
	int i, j, k;
	float *temp;
temp = (float*)calloc(n1*m2,sizeof(float));

for(i=0; i<n1; ++i) {
	for(j=0; j<m2; ++j) {
		temp[i*m2+j] = 0;
		for(k=0; k<m1; ++k)
			temp[i*m2+j] += arr1[i*m1][k]*arr2[k*m2][j];
	}
}
copymatf(temp, n1,m2, arr3);

}
#endif


#if 0000
void copymatf(float  arr1[1][1],int  n,int m, float arr2[1][1])

{
	int i, j;

for(i=0; i<n; ++i)
	for(j=0; j<m; ++j)
		arr2[i*m][j] = arr1[i*m][j];


}
#endif

