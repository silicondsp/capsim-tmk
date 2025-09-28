

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
#include <math.h>
#include <stdio.h>


#include "cap_fft.h"
#define N 64

void cxifftcap(cap_fft_cpx *inBuffer, cap_fft_cpx *outBuffer,int n)

{
     cap_fft_cfg  cfg;




     cfg = cap_fft_alloc(n, INVERSE_FFT, 0,0);


     cap_fft(cfg, inBuffer, outBuffer);

     free(cfg);

}

void cxfftcap(cap_fft_cpx *inBuffer, cap_fft_cpx *outBuffer,int n)

{
     cap_fft_cfg cfg;



     cfg = cap_fft_alloc(n, FORWARD_FFT, 0,0);



     cap_fft(cfg, inBuffer, outBuffer);

     free(cfg);

}



