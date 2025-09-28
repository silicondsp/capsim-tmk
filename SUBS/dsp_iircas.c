

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
 * Module iirfilter.c
 *
 * This program simulates an IIR filter. There are two input files and one
 * output file.
 *
 *
 * Created :  July 14, 1987
 *
 *
 */

#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>

#include "dsp.h"

int IIRCas(char* name)
{
  int      i,            /* array and loop index                    */
           nump,numz,    /* # of poles and zeroes                   */
           numpts,       /* size of the data set                    */
           loop,
           numsection;   /* # of cascade sections from ccoef()      */

  float    zcoef[2][100],   /* zero coefficients. used by ccoef().  */
           pcoef[2][100],   /* pole ------  ditto  _________        */
           constant,           /* constant value of transfer function  */
           fsamp,           /* sampling frequency                   */
           temp,
           zreal[51],zimg[51],  /* real & img values of zeroes      */
           preal[51],pimg[51];  /* real & img values of poles       */



  FILE     *fp,*fpRes;
  char	   filename[100];



     strcpy(filename,name);
     strcat(filename,".pz");
     fp = fopen(filename,"r");
     strcpy(filename,name);
     strcat(filename,".cas");
     fpRes = fopen(filename,"w");

     if((fp==NULL)||(fpRes==NULL)) {  /* check for file errors*/
        printf("Error in opening files. \n");
        fclose(fp);
        fclose(fpRes);
	return(1);
     }        /* end if - file error check     */

     fscanf(fp,"%d %d",&numz,&nump); /* get pole-zero data.          */
     for(i=1;i<=numz;++i)
        fscanf(fp,"%e %e",&zreal[i],&zimg[i]);
     for(i=1;i<=nump;++i)
        fscanf(fp,"%e %e",&preal[i],&pimg[i]);
     fscanf(fp,"%e %e",&fsamp,&constant);

     fclose(fp);   /* Don't need these open files anymore.         */

     /*
      * This calculates the cascade sections from pole zero data.
      */

     ccoef(zreal,zimg,preal,pimg,numz,nump,zcoef,pcoef,&numsection);

     /*
      * Store the cascade sections
      */
     fprintf(fpRes,"%d \n",numsection);
     for(i=1;i<=numsection;++i)
	fprintf(fpRes,"%16.9e %16.9e \n",zcoef[0][i],zcoef[1][i]);
     for(i=1;i<=numsection;++i)
	fprintf(fpRes,"%16.9e %16.9e \n",pcoef[0][i],pcoef[1][i]);
     fprintf(fpRes,"%f \n",fsamp);
     fprintf(fpRes,"%16.9e \n",constant);
     fclose(fpRes);
     return(0);
}

