/**************************************************************************
 * Parks-McClellan algorithm for FIR filter design (C version)
 *-------------------------------------------------
 *  Copyright (C) 1995  Jake Janovetz (janovetz@coewl.cen.uiuc.edu)
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 *************************************************************************/

/***************************************************************************
 * Test program for the remez() function.  Sends appropriate arguments to
 * remez() to generate a filter.  Then, prints the resulting coefficients
 * to stdout.
 **************************************************************************/

 /*
  * Modified by Sasan Ardalan to read in file with filter parameters
  * in a specific format.
  * June 10, 2007
  */
  
#include "remez.h"
#include <math.h>
#include <stdio.h>

main()
{
   double *weights_P, *desired_P, *bands_P;
   double *h_P;
   int i;
   FILE *fp;
   int numberTaps;
   int numberBands;
   FILE *out_F;
   float fb,fe;
   float desired;
   float weight;
   
   fp=fopen("tmp.rmz", "r");
   if(!fp) {
	   fprintf(stderr, "FIR Design(CAD):Could not open tmp.rmz\n");
	   exit(1);
   }
  
   out_F=fopen("tmp.taps","w");
   if(!out_F) {
	   fprintf(stderr, "FIR Design(CAD):Could not open tmp.taps to write\n");
	   exit(1);
   } 
   
   fscanf(fp,"%d",&numberTaps);
   fscanf(fp,"%d",&numberBands);
   
   bands_P = (double *)calloc(numberBands*2 , sizeof(double));
   weights_P = (double *)calloc(numberBands, sizeof(double));
   desired_P = (double *)calloc(numberBands , sizeof(double));
   h_P = (double *)calloc(numberTaps , sizeof(double));

   
   if( !bands_P || !weights_P || !desired_P || !h_P) {
   	   fprintf(stderr, "FIR Design(CAD): Could not allocate memory\n");
	   exit(1);
 
   }
   
 
   
   for (i=0; i< numberBands; i++) {
	
	        fscanf(fp,"%f %f %f %f",&fb,&fe, &weight, &desired);
		
		printf("READING BAND %f %f %f %f\n",fb,fe, weight, desired);
		desired_P[i]=desired;
		weights_P[i]=weight;
		bands_P[2*i]=fb;
		bands_P[2*i+1]=fe;
		
        	   
   }
   fclose(fp);
   
   
 

   remez(h_P, numberTaps, numberBands, bands_P, desired_P, weights_P, BANDPASS);
   
   fprintf(out_F,"%d\n",numberTaps);
   for (i=0; i<numberTaps; i++)
   {
       fprintf(out_F,"%23.20f\n", h_P[i]);
   }
   fclose(out_F);

   free(bands_P);
   free(weights_P);
   free(desired_P);
   free(h_P);
}

