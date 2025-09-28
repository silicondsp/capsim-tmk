

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

/*
 *  copyright (c) 1987  Sasan H. Ardalan.  All rights reserved.
 *
 *
 *  module name: pz_conv.c
 *  main function name:	PzConv()
 *
 *  author: Sasan Ardalan
 *  revised by:
 *
 *  revision history:
 *     version	--date-- -by-	-reason----------------------------------------
 *	0.1.1	10/10/88  dr	Initial release
 *
 *  compiled on: VAXstation II/GPX - o/s: microVMS 4.5
 *
 *  This program converts a file containing poles and zeros to
 *  a compact form in which conjugate poles(zeroes)  are represented by
 *  a single pole(zero)
 *
 *
 */
#include <stdio.h>
#include <math.h>
#include <string.h>


#define STAMP_OUT  100.0
#define EPS 1.0e-5
void PzConv(char* name)
{
    int np,nz;
    float pr_A[100],pi_A[100],
	  zr_A[100],zi_A[100];
    int	  conj[100];
    int i,k;
    float fsamp,constant;

    char filename[80];
    FILE *in_F, *out_F;

    strcpy(filename,name);
    strcat(filename,".pz");
    in_F= fopen(filename,"r");
    fscanf(in_F,"%d %d",&nz,&np);
    for(i=0; i<nz; i++) {
	fscanf(in_F,"%e %e",&zr_A[i],&zi_A[i]);
    }
    for(i=0; i<np; i++) {
	fscanf(in_F,"%f %f",&pr_A[i],&pi_A[i]);
    }
    fscanf(in_F,"%f %f",&fsamp,&constant);

    /*
     * done reading poles and zeroes
     * close file and open same file for output
     */
    fclose(in_F);
    strcpy(filename,name);
    strcat(filename,".pz");
    out_F= fopen(filename,"w");
    fprintf(stderr,"Storing poles and zeroes in compressed form. \n");
    fprintf(stderr,"File is: %s  ... use IIP to plot \n",filename);
    for(i=0; i<nz; i++)
	if (zi_A[i] != 0.0 )
		for (k = i+1; k<nz; k++)
			if((fabs(zi_A[i] + zi_A[k])< EPS ) &&
				(fabs(zr_A[i] - zr_A[k]) < EPS) )
				zi_A[k] = STAMP_OUT;
    for(i=0; i<np; i++)
	if (pi_A[i] != 0.0 )
		for (k = i+1; k<np; k++)
			if((fabs(pi_A[i] + pi_A[k]) < EPS) &&
				 (fabs(pr_A[i] - pr_A[k]) < EPS ) )
				pi_A[k] = STAMP_OUT;


    k= 0;
    for(i=0; i<nz; i++) {
	if (zi_A[i] != STAMP_OUT )  {
			zi_A[k] = zi_A[i];
			zr_A[k] = zr_A[i];
			k +=1;
	}

     }
    nz = k;

    k= 0;
    for(i=0; i<np; i++) {
	if (pi_A[i] != STAMP_OUT )  {
			pi_A[k] = pi_A[i];
			pr_A[k] = pr_A[i];
			k +=1;
	}

     }
    np = k;
    fprintf(out_F,"%d %d  \n",nz,np);
    for(i=0; i<nz; i++) {
	fprintf(out_F,"%e %e \n",zr_A[i],zi_A[i]);
    }
    for(i=0; i<np; i++) {
	fprintf(out_F,"%e %e \n",pr_A[i],pi_A[i]);
    }
    fprintf(in_F,"%f %f",fsamp,constant);
    fclose(out_F);

    return;
}










