
/*
    Capsim (r) Text Mode Kernel (TMK)
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
    Silicon DSP  Corporation
    Las Vegas, Nevada
*/


/* SysCalls.c */
/**********************************************************************

			SysCalls()

***********************************************************************

This dummy function is called once from main -- it simply serves to
reference external system and math library calls in order to force
the loader to include them in the object file.
This is a temporary fixup since references to library functions in
dynamically loaded stars does not work.
Any library functions required should be added to this function.

Programmer: D.G. Messerschmitt
Date: May 8, 1986
Modified: ljfaber 5/88: add return and dummy call in main.
		This is necessary because of libobj.a and loader
		requirements.
*/

#include <math.h>
#include "capsim.h"

void SysCalls()
{
#if 0
	FILE *popen();
#endif

if(1) return;	/* This statement causes immediate return */
#if 0

	/* trig functions */
	sin(); cos(); tan(); asin(); acos(); atan(); atan2();

	/* misc functions */
	fabs(); sqrt(); rand(); srand(); random(); srandom();

	/* exponential functions */
	log(); log10(); exp(); pow();

	/* functions to set up pipe */
	popen(); pclose();

	/* functions from SUBS library */
	cmultfft(); gcd(); lcm();
	multmatf(); copymatf(); addmatf(); diagmatf(); transpf();
	sinc(); fpround(); fpquant(); cxfft();
        imatmult(); iscalmult();
	/*
	 * for mu-law quantizer
	 */
	mulawq();
	/*
	 * for eye diagram
	 */
	eye();
	calsdr();
#endif

}





