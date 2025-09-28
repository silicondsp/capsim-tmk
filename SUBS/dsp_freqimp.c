
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
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include "dsp.h"
/*
 * Calculate impulse response from array of frequency response
 * Use inverse FFT
 * Author: Sasan H. Ardalan
 */


void Dsp_FreqImp(float freqRes_A[],int nfft,float impRes_A[])
{
	float *xx_A;
	int i,k,mfft;

	mfft = (int)(log((float)nfft)/log(2.0)+0.5)+1;
	fprintf(stderr,"nfft= %d mfft = %d \n",nfft,mfft);
	xx_A=(float *) malloc((4*nfft)*sizeof(float));
	for (i=0; i< nfft; i++) {
		xx_A[2*i]=freqRes_A[2*i];
		xx_A[2*i+1]=freqRes_A[2*i+1];

	}

	for (i=1; i<nfft; i++) {
		k=2*nfft-i;
		xx_A[2*k]=xx_A[2*i];
		xx_A[2*k+1]= -xx_A[2*i+1];
        }
	xx_A[2*nfft]=0.0;
	xx_A[2*nfft+1]=0.0;
	cxfft(xx_A,&mfft);
	for (i=0; i<2*nfft; i++) {
		impRes_A[i]=xx_A[2*i]/nfft/2;
   	}
	free(xx_A);
}
