
/*  Capsim (r) Text Mode Kernel (TMK) Star Library (Blocks)
    Copyright (C) 1989-2002  XCAD Corporation 

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

    http://www.xcad.com
    XCAD Corporation
    Raleigh, North Carolina */


/* cmultfftw.c */
/**********************************************************************/
/* This function performs complex multiplication on two arrays in     */
/*  rfftw complex  form.                                               */
/* The result is returned in the first array in the argument list,    */
/* also in rfftw complex  form.                                           */
/**********************************************************************/

#include <stdio.h>
#include <rfftw.h>

cmultfftw(array1, array2, npoints)

	fftw_real array1[], array2[];
	int npoints;			/* number of point in arrays */
{
	int i;
	fftw_real real, imag;

array1[0] *= array2[0];
for(i=1; i<npoints/2; i++ ) {
	real = array1[i] * array2[i] - array1[npoints-i] * array2[npoints-i];
	imag = array1[i] * array2[npoints-i] + array1[npoints-i] * array2[i];
	array1[i] = real;
	array1[npoints-i] = imag;
}

}   /* ends */
