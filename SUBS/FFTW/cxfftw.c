
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
#include <math.h>
#include <stdio.h>


#include "fftw.h"
#define N 64

void cxifftw(fftw_complex *inBuffer, fftw_complex *outBuffer,int n)

{
     fftw_plan pi;




     pi = fftw_create_plan(n, FFTW_BACKWARD, FFTW_ESTIMATE);


     fftw_one(pi, inBuffer, outBuffer);

     fftw_destroy_plan(pi);

}

void cxfftw(fftw_complex *inBuffer, fftw_complex *outBuffer,int n)

{
     fftw_plan pf;



     pf = fftw_create_plan(n, FFTW_FORWARD, FFTW_ESTIMATE);



     fftw_one(pf, inBuffer, outBuffer);

     fftw_destroy_plan(pf);

}



