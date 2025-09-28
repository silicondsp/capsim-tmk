
/*  Capsim (r) Text Mode Kernel (TMK) Star Library (Blocks)
    Copyright (C) 1989-2017  Silicon DSP  Corporation

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


/*
 * calculate signal to distortion ratio
 * the array xx_A contains the Discrete Fourier Transform of the signal
 *
 * written by Sasan Ardalan
 *
 */
#include <math.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define SIG_WIDTH 4
#define ANAL_WIDTH 8

void calsdr(float xx_A[],float *sdr_P,int points,char* file)

{
  float totsp;
  float* spect_A;
  int i,j,k,p;
  int iict;
  float sigmax;
  float sig, totNoise;
  float sdr,sdrdB;
  FILE *res_F;

  if(points < 8) {
	  fprintf(stderr,"Too few points (%d) in calcsdr. Need at least 8.\n",points);
           return ;

    }

  /*
   * open file to store results
   */
  if (strcmp(file,"none") == 0 ) res_F = stdout;
     else res_F = fopen(file,"w");

    if(!res_F) {
	       fprintf(stderr,"Could not open file in calcsdr.\n");
           return ;
  }

  /*
   * allocate space for spectrum
   */
  spect_A = (float *) calloc(points,sizeof(float));
  /*
   * compute spectrum
   */
  totsp = 0.0;
  for (i=3; i< points; i++) {
	spect_A[i] = xx_A[2*i]*xx_A[2*i] +xx_A[2*i+1]*xx_A[2*i+1];
	totsp += spect_A[i];
  }
  fprintf(res_F," Signal to Distortion Analysis \n");
  fprintf(res_F," Total power = %e ", totsp);
  /*
   * find maximum component and index iict
   */
  iict=0;
  sigmax = 2*spect_A[2];  // skip DC

  for (i=3; i< points/2 ; i++) {
	if ( !(2*spect_A[i] <= sigmax )) {
		iict = i;
		sigmax = 2*spect_A[i];
	}
  }
  fprintf(res_F,"Peak at %d value: %e \n",iict,spect_A[iict]);
  /*
   * print the points around the peak
   */
  fprintf(res_F,"Power Spectrum \n Point    Power \n ------------- \n");
  for (k=0; k< 2*ANAL_WIDTH; k++)
	if ((iict + k - ANAL_WIDTH) > 1 )
	   fprintf(res_F,"%d %e \n",k+iict-ANAL_WIDTH,spect_A[k+iict-ANAL_WIDTH]);
  /*
   * find signal and noise power
   */
  sig = 0.0;
  totNoise = 0.0;
  for (i =3; i< points/2; i++) {
	if( (i<=iict+SIG_WIDTH) && (i>=iict-SIG_WIDTH )) sig += 2*spect_A[i];
        else
		totNoise += 2*spect_A[i];
  }
  /*
   * adding dc power
   */
 // totNoise += spect_A[0];
  if (totNoise < 1.0e-15) totNoise = 1.0e-15;
  sdr = sig/totNoise;
  sdrdB = 10.0*log10(sdr);
  fprintf(res_F, "Results : \n Signal Strength = %e \n Total Noise = %e \n",
		sig,totNoise);
  fprintf(res_F, "Signal to Distortion Ratio: %e and %e(dB) \n",
		sdr,sdrdB);
  *sdr_P = sdr;
  if (strcmp(file,"none") != 0 ) fclose(res_F);
  free(spect_A);
  return;

}
