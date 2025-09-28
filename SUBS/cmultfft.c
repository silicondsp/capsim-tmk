


/*  Capsim (r) Text Mode Kernel (TMK) Star Library (Blocks)
    Copyright (C) 1989-2017 Silicon DSP Corporation 

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



/* cmultfft.c */
/**********************************************************************/
/* This function performs complex multiplication on two arrays in     */
/* `compressed' form, as after using the function rfft().             */
/* The result is returned in the first array in the argument list,    */
/* also in compressed form.                                           */
/**********************************************************************/

#include <stdio.h>

void cmultfft(float array1[], float array2[], int npoints)

	
{
	int i;
	float real, imag;

array1[0] *= array2[0];
array1[1] *= array2[1];
for(i=2; i<npoints; i +=2) {
	real = array1[i] * array2[i] - array1[i+1] * array2[i+1];
	imag = array1[i] * array2[i+1] + array1[i+1] * array2[i];
	array1[i] = real;
	array1[i+1] = imag;
}

}   /* ends */
