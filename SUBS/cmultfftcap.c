

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


/* cmultfftw.c */
/**********************************************************************/
/* This function performs complex multiplication on two arrays in     */
/*  cap_fft_cpx complex  form from real forward FFTs.                                               */
/* The result is returned in the first array in the argument list,    */
/* also in cap_fft_cpx complex  form.                                           */
/**********************************************************************/

#include <stdio.h>
#include <cap_fft.h>
#include <cap_fftr.h>

void cmultfftcap(cap_fft_cpx *array1, cap_fft_cpx * array2, int npoints, float conjugate)


{
	int i;
	cap_fft_scalar real, imag;

array1[0].r *= array2[0].r;    //DC term
//array1[npoints-1].r *= array2[npoints-1].r;  //Nyquist terms
array1[0].i *= array2[0].i;  //Nyquist terms
for(i=1; i<npoints-1; i++ ) {
	real = array1[i].r * array2[i].r - array1[i].i * array2[i].i*conjugate;
	imag = array1[i].r * array2[i].i*conjugate + array1[i].i * array2[i].r;
	array1[i].r = real;
	array1[i].i = imag;
}

}   /* ends */
