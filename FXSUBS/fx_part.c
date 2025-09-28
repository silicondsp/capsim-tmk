
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
 * This function accepts an integer input and breaks it into two
 * parts according to size variable. The output integer numbers are
 * to be used by Fx_MultVar.c function, therefore they are compatible
 * with that function. The reason for breaking the integer number
 * into two is because of the multiplication algorithm used in
 * Fx_MultVar.c function. The length of each part is size/2. The max
 * positive value that can be broken into two parts has the value
 * ((1<<(size-1))-1
 *
 * Programmmer : KARAOGUZ, Jeyhan
 * Date        : 9/23/90
 * North Carolina State University
 */

Fx_Part(int size,int input,int* x1_P,int* x0_P,int* lessFlag_P)

/*
 * The variable size specifies the length of the input integer.
 * x1_P and x0_P are output parts. The pointer lessFlag_P is
 * set to 1 if the number is negative and less than 1<<(size/2)
 * This flag is used in Fx_MultVar.c function to determine the sign
 * of the product correctly.
 */


{

int sign = 0;
int val, x1, x0, tmp;

val = 1;
val <<= (size/2);
val -= 1;

*lessFlag_P = 0;

if ( input<0 ) {
/*
 * Calculate the absolute value and set the sign bit to 1.
 */
	input = ~input;
	input += 1;
	sign = 1;
/*
 * Check if the number is less than 1<<(size/2).
 */
	if ( input <= val )
        	*lessFlag_P = 1;
	};
/*
 * Break the number into two parts
 */

x0 = input & val;
tmp = input >> (size/2);
x1 = tmp & val;

/*
 * if lessFlag_P is not 1 and sign is 1 then take the two's
 * complement of only x1. This is done to convey the negative
 * number information to mult_var.c function.
 */

if (*lessFlag_P != 1)
	if (sign == 1) {
		x1 = ~x1;
		x1 += 1;
                };
/*
 * Output the parts
 */

*x1_P = x1;
*x0_P = x0;

}
