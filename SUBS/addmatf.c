
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
/* Matrix adds arr1 n*m to arr2, and returns sum in arr3.      */
/* Any or all matrices can be the same.                        */
/* This version uses (float) arrays.                           */
/* programmer: ljfaber  5/88                                   */
/***************************************************************/
#include <stdio.h>
#include <math.h>

void addmatf(float arr1[1][1], float arr2[1][1], int n, int m, float arr3[1][1])


{
	int i, j;

for(i=0; i<n; ++i)
	for(j=0; j<m; ++j)
		arr3[i*m][j] = arr1[i*m][j] + arr2[i*m][j];

}
