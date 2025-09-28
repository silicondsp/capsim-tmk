


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
#include <stdlib.h>

#define EXPAND 1
#define COMPRESS 0

/*********************************************************************/
/*  Mu-law Codec                                                     */
/*  Written by Sasan H. Ardalan, CCSP, NCSU October 1987.            */
/*  This routine will compress or expand a mu 255 sample             */
/*  The flag determines whether to expand(1) or compress(0)          */
/*********************************************************************/

int getbits(unsigned x,unsigned p,unsigned n);


int mulawq(int xx,int flag)

{
    int sample;
    int i,segnum;
    int polarity;
    unsigned int x,y;
    unsigned int a,b,c;
    unsigned int p;
    static unsigned int compress [8] = { 0, 16,32,48,64,80,96,112 };

    if ( flag == COMPRESS ) {
	     sample = xx;
		polarity = 0;
		if ( sample < 0 ) polarity = 128;
		x = abs (sample);
		y=x+33;
		for (i=0;  i<8; i++) {
			p=12-i;
			if (getbits(y,p,1)== 1) break;
		}
		segnum=i;
		p=12-segnum;

		y=getbits(y,p-1,4);
		y= y | compress[7-segnum] | polarity;
		return(y);
	}
	if ( flag == EXPAND ) {
	/* Expand */
		y=xx;
		x = getbits (y, 3, 4);
		a = 2*x+1+32;
		b = getbits (y,6,3);
		x = (a << b );
		x = x -33;
		sample =x;
		if ( getbits (y,7,1) == 1 ) sample = -sample;
		return(sample);
	}
}

/* get n bits from position p */
int getbits(unsigned x,unsigned p,unsigned n)

{
	return((x>> (p+1-n)) & ~(~0 << n ));
}

