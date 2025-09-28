

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


/*-----------------------------------------------------------------------------
 *                    MODULE ccoef.c
 *
 * I have used this module from iirfo.c present in /usr/local/dsp/prog1d
 * on ece-csc. This is the "C" version  of the FORTRAN code
 * given to me by Sasan. Since this piece of code was not written by me,
 * I assume no responsibility for the bugs in this. I have gone over this
 * very poorly documented code and it looks okay. This code calculates the
 * cascade sections of the IIR filter and returns them in the arrays zc and pc.
 *
 *                                                Harish P. Hiriyannaiah.
 *-----------------------------------------------------------------------------
 */
#include <stdio.h>
#include <math.h>
#include "dsp.h"


void ccoef(float zzr[],float zzi[],float pzr[],float pzi[],int nz,int np,float zc[2][100],float pc[2][100],int *ns)


{
	float rz,iz,rzz,izz;
	int ico[100],nzc,npc,ib,nzs,nps,i,j;
	nzc = 0;
	npc = 0;
	/*
	         CALCULATE ZERO SECTION'S COEFFICIENTS
					*/
	if (nz == 0);
	else {
		for (i = 1; i <= nz;++i) ico[i] = 0;
		for (i = 1; i <= nz;++i) {
			if (ico[i] == 1);
			else {
				rz = zzr[i];
				iz = zzi[i];
				ib = i+1;
				if (iz == 0);
				else if (ib > nz) {
					printf("WARNING: No conjugate Zero for %e  %e\n",zzr[i],zzi[i]);
                                        goto step100;
				}
				else {
					for (j = ib;j <= nz;++j) {
						if (ico[j] == 1);
						else {
							rzz = zzr[j];
							izz = zzi[j];
							if (rz == 0.0 && rzz != 0.0);
							else if (rz == 0.0 && rzz == 0.0) {
				                               if (fabs((izz+iz)/iz) > 2.e-4);
						       	       else {
									++nzc;
									ico[i] = 1;
									ico[j] = 1;
									zc[0][nzc] = -2*rz;
									zc[1][nzc] = rz*rz+iz*iz;
									goto step100;
								}
							}
				                        else if(fabs((rzz-rz)/rz) > 2.e-4);
					                else if(fabs((izz+iz)/iz) > 2.e-4);
							else {
								++nzc;
								ico[i] = 1;
								ico[j] = 1;
								zc[0][nzc] = -2*rz;
								zc[1][nzc] = rz*rz+iz*iz;
								goto step100;
							}
						}
					}
				}
				for (j = ib;j <= nz;++j) {
					if (j > nz) break;
					else if (ico[j] == 1);
					else {
						rzz = zzr[j];
						izz = zzi[j];
						if (izz != 0.0);
						else {
							++nzc;
							ico[i] = 1;
							ico[j] = 1;
							zc[0][nzc] = -(rz+rzz);
							zc[1][nzc] = rz*rzz;
							goto step100;
						}
					}
				}
				++nzc;
				ico[i] = 1;
				zc[0][nzc] = -rz;
				zc[1][nzc] = 0.0;
step100:;
			}
		}
	}
	/*
	         CALCULATE POLE SECTION'S COEFFICIENTS
					*/
	if (np == 0);
	else {
		for (i = 1; i <= np;++i) ico[i] = 0;
		for (i = 1; i <= np;++i) {
			if (ico[i] == 1);
			else {
				rz = pzr[i];
				iz = pzi[i];
				ib = i+1;
				if (iz == 0);
				else if (ib > np) {
					printf("WARNING: No conjugate Pole for %e  %e\n",pzr[i],pzi[i]);
                                        goto step200;
				}
				else {
					for (j = ib;j <= np;++j) {
						if (ico[j] == 1);
						else {
							rzz = pzr[j];
							izz = pzi[j];
							if (rz == 0.0 && rzz != 0.0);
							else if (rz == 0.0 && rzz == 0.0) {
						        if(fabs((izz+iz)/iz) > 2.e-4);
								else {
									++npc;
									ico[i] = 1;
									ico[j] = 1;
									pc[0][npc] = -2*rz;
									pc[1][npc] = rz*rz+iz*iz;
									goto step200;
								}
							}
					                else if(fabs((rzz-rz)/rz) > 2.e-4);
					                else if(fabs((izz+iz)/iz) > 2.e-4);
							else {
								++npc;
								ico[i] = 1;
								ico[j] = 1;
								pc[0][npc] = -2*rz;
								pc[1][npc] = rz*rz+iz*iz;
								goto step200;
							}
						}
					}
				}
				for (j = ib;j <= np;++j) {
					if (j > np) break;
					else if (ico[j] == 1);
					else {
						rzz = pzr[j];
						izz = pzi[j];
						if (izz != 0.0);
						else {
							++npc;
							ico[i] = 1;
							ico[j] = 1;
							pc[0][npc] = -(rz+rzz);
							pc[1][npc] = rz*rzz;
							goto step200;
						}
					}
				}
				++npc;
				ico[i] = 1;
				pc[0][npc] = -rz;
				pc[1][npc] = 0.0;
step200:;
			}
		}
	}
	/*
	         CALCULATE NUMBER OF SECTIONS
					*/
	*ns = max0(nzc,npc);
	if (*ns == nzc) {
		if(*ns == npc);
		else {
			nps = npc+1;
			for (i = nps;i <= *ns;++i) {
				pc[0][i] = 0.0;
				pc[1][i] = 0.0;
			}
		}
	}
	else {
		nzs = nzc+1;
		for (i = nzs;i <= *ns;++i) {
			zc[0][i] = 0.0;
			zc[1][i] = 0.0;
		}
	}
	return;
}


