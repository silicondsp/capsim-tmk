
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
 * This function performs rounding operation. The variable roundoff_bits
 * should have the same value as the number of bits to represent the
 * fractional  part of the input number to this function. Then,  the
 * output number is the decimal value of the fractional input number.
 * Decimal value is found after rounding operation. The size variable
 * is the same variable that is used in mult_var.c and add_var.c.
 *
 * Programmer : KARAOGUZ, Jeyhan
 * Date       : 10/6/90
 */

 #include <stdio.h>


void roundvar(int size,int output_size,int roundoff_bits,int X1,int X0,int *OUT_ptr)


/*
 * X1 and X0 are received from add_var.c function.
 */


{
int halfmask, halfmax, max, mask, sign_check, tmp;
int i, check, OUT, shift, point=0;

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

if (roundoff_bits <= 32) {
	halfmask = 1;
	halfmask <<= (32 - (roundoff_bits - 1));
	halfmask -= 1;
	}
else
	halfmask = 0;

max = 1;
max <<= (output_size - 1);
max -= 1;

/*
 * Determine the sign of the number.
 */

sign_check = X1 >> (size - 1);
sign_check &= 1;

/*
 * If the total size is less than 32 then combine X1 and X0 by first
 * shifting X1 to the left by size bits and then simply adding it to
 * X0.
 */

if (size < 16) {

	X1 <<= size;
	OUT = X1 + X0;

	if (sign_check == 1) {
		OUT = ~OUT;
                OUT &= mask;
		OUT += 1;
		}

	OUT >>= (roundoff_bits - 1);
	OUT += 1;
	OUT >>= 1;


	if (OUT > max) {
		printf("overflow\n");
		if (sign_check == 0)
			OUT = max;
		else
			OUT = (-max);
		}

	if (sign_check == 1)
		OUT = (-OUT);
	}
else {

	if (sign_check == 1) {
		X1 = ~X1;
		X1 &= halfmax;
		X0 = ~X0;
		X0 &= halfmax;
		X0 += 1;
		if (X0 > halfmax && halfmax != -1) {
			X1 += 1;
			X0 &= halfmax;
			}
		if (size == 32 && X0 == 0)
			X1 += 1;
		}


	tmp = X1;

	for (i = 0 ; i < 32 ; i++) {
		check = tmp & 1;
		if (check == 1)
			point = i;
		tmp >>= 1;
		}

	if ( ((point - roundoff_bits + 1) + size ) < 31 || (X1 == 0)) {

		shift = size - roundoff_bits + 1;

		if (shift < 0)
			X1 >>= (-shift);
		else
			X1 <<= shift;

		X0 >>= (roundoff_bits - 1);
		X0 &= halfmask;
		OUT = X1 + X0;
		OUT += 1;
		OUT >>= 1;

		if (OUT > max) {
			printf("overflow\n");
			if (sign_check == 0)
				OUT = max;
			else
				OUT = (-max);
			}

		if (sign_check == 1)
			OUT = (-OUT);
		}
	else {
		printf("use more roundoff bits\n");
		OUT = 0;
		}
	}

*OUT_ptr = OUT;

}
