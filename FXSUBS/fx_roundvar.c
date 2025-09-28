
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



/*
 * This function performs rounding operation. The variable roundOffBits
 * should have the same value as the number of bits to represent the
 * fractional  part of the input number to this function. Then,  the
 * output number is the decimal value of the fractional input number.
 * Decimal value is found after rounding operation. The size variable
 * is the same variable that is used in Fx_MultVar.c and Fx_AddVar.c.
 *
 * Programmer : KARAOGUZ, Jeyhan
 * North Carolina State University
 * Date       : 10/6/90
 */

Fx_RoundVar(int size,int outputSize,int roundOffBits,int x1,int x0,int* out_P)

/*
 * x1 and x0 are received from Fx_AddVar.c function.
 */

{
int halfmask, halfmax, max, mask, signCheck, tmp;
int i, check, out, shift, point=0;

if (size != 32) {
	halfmax = 1;
	halfmax <<= size;
	halfmax -= 1;
	}
else
	halfmax = -1;

mask = 1;
mask <<= (2*size);
mask -= 1;

if (roundOffBits <= 32) {
	halfmask = 1;
	halfmask <<= (32 - (roundOffBits - 1));
	halfmask -= 1;
	}
else
	halfmask = 0;

max = 1;
max <<= (outputSize - 1);
max -= 1;

/*
 * Determine the sign of the number.
 */

signCheck = x1 >> (size - 1);
signCheck &= 1;

/*
 * If the total size is less than 32 then combine x1 and x0 by first
 * shifting x1 to the left by size bits and then simply adding it to
 * x0.
 */

if (size < 16) {

	x1 <<= size;
	out = x1 + x0;

	if (signCheck == 1) {
		out = ~out;
                out &= mask;
		out += 1;
		}

	out >>= (roundOffBits - 1);
	out += 1;
	out >>= 1;


	if (out > max) {
		printf("overflow\n");
		if (signCheck == 0)
			out = max;
		else
			out = (-max);
		}

	if (signCheck == 1)
		out = (-out);
	}
else {

	if (signCheck == 1) {
		x1 = ~x1;
		x1 &= halfmax;
		x0 = ~x0;
		x0 &= halfmax;
		x0 += 1;
		if (x0 > halfmax && halfmax != -1) {
			x1 += 1;
			x0 &= halfmax;
			}
		if (size == 32 && x0 == 0)
			x1 += 1;
		}


	tmp = x1;

	for (i = 0 ; i < 32 ; i++) {
		check = tmp & 1;
		if (check == 1)
			point = i;
		tmp >>= 1;
		}

	if ( ((point - roundOffBits + 1) + size ) < 31 || (x1 == 0)) {

		shift = size - roundOffBits + 1;

		if (shift < 0)
			x1 >>= (-shift);
		else
			x1 <<= shift;

		x0 >>= (roundOffBits - 1);
		x0 &= halfmask;
		out = x1 + x0;
		out += 1;
		out >>= 1;

		if (out > max) {
			printf("overflow\n");
			if (signCheck == 0)
				out = max;
			else
				out = (-max);
			}

		if (signCheck == 1)
			out = (-out);
		}
	else {
		printf("use more roundoff bits\n");
		out = 0;
		}
	}

*out_P = out;

}
