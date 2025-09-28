
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
 * This function accepts an integer input and breaks it into two
 * parts according to size variable. The output integer numbers are
 * to be used by mult_var.c function, therefore they are compatible
 * with that function. The reason for breaking the integer number
 * into two is because of the multiplication algorithm used in
 * mult_var.c function. The length of each part is size/2. The max
 * positive value that can be broken into two parts has the value
 * ((1<<(size-1))-1
 *
 * Programmmer : KARAOGUZ, Jeyhan
 * Date        : 9/23/90
 */

void part(int size,int input,int *X1_ptr,int *X0_ptr,int *less_flag)

/*
 * The variable size specifies the length of the input integer.
 * X1_ptr and X2_ptr are output parts. The pointer less_flag is
 * set to 1 if the number is negative and less than 1<<(size/2)
 * This flag is used in mult_var.c function to determine the sign
 * of the product correctly.
 */



{

int sign = 0;
int val, X1, X0, tmp;

val = 1;
val <<= (size/2);
val -= 1;

*less_flag = 0;

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
        	*less_flag = 1;
	};
/*
 * Break the number into two parts
 */

X0 = input & val;
tmp = input >> (size/2);
X1 = tmp & val;

/*
 * if less_flag is not 1 and sign is 1 then take the two's
 * complement of only X1. This is done to convey the negative
 * number information to mult_var.c function.
 */

if (*less_flag != 1)
	if (sign == 1) {
		X1 = ~X1;
		X1 += 1;
                };
/*
 * Output the parts
 */

*X1_ptr = X1;
*X0_ptr = X0;

}
