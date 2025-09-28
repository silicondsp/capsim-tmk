

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
/* Creates arr1 as an n*n diagonal matrix with entry = factor. */
/* This version uses (float) arrays.                           */
/* programmer: ljfaber  5/88                                   */
/***************************************************************/
#include <stdio.h>
#include <math.h>

void diagmatf(float arr1[1][1], float factor, int n)

{
	int i, j;

for(i=0; i<n; ++i) {
	arr1[i*n][i] = factor;
	for(j=0; j<i; ++j)
		arr1[i*n][j] = arr1[j*n][i] = 0.;
}

}
