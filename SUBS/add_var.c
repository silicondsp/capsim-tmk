
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
 * This function adds two fixed-point numbers in variable precision.
 * The addition is done in 2's complement arithmetic i.e., if the
 * operands are negative they are accepted in two's complement form.
 * Also the output is in 2's complement form if it is negative.
 * The reason of doing the arithmetic in 2's complement form instead
 * of sign arithmetic is because it is easier to implement.The input
 * numbers are accepted in two registers of length size bits. The
 * result is stored in a register of length twice the size. This
 * function is compatible with the mult_var.c function if the size
 * variables are the same. That is, you can add the outputs of
 * multiplication function with add_var.c. This is very convenient
 * for FIR filter applications.
 *
 * Programmer : KARAOGUZ, Jeyhan.
 * Date       : 9/17/90
 */
#include <stdio.h>



void addvar(int size,int saturation_mode,int X1,int X0,int Y1,int Y0,int *OW1_ptr,int *OW0_ptr)

/*
 * Variable saturation_mode specifies whether the result should be
 * saturated or not in case of overflow.
 */


{

int X3, X2, Y3, Y2, W3, W2, W1, W0;
int acc, max, carry=0, saturation_carry=0, check=0;
int pos_overflow=0, neg_overflow=0, pos_max1, pos_max0, zero_flag=0;
int neg_least1, neg_least0, both_pos_flag=0, both_neg_flag=0;


max = 1;
max <<= (size/2);
max -= 1;

/*
 * In case of saturation, calculate the saturation values
 */

pos_max1 = (1 << (size - 1)) - 1;
pos_max0 = (1 << size) - 1;

if (size == 32)
	pos_max0 = 0xffffffff;

neg_least1 = (1 << (size - 1));
neg_least0 = 0;

/*
 * Following three 'if' statements are used to determine the
 * signs of the input numbers. Sign of the numbers are needed
 * because the saturation modes are different for negative
 * and positive results sice we are using 2's complement
 * arithmetic. Note that if input numbers have opposite sign
 * there won't be any saturation therefore the saturation mode
 * is set to zero.
 */

if (((X1 >> (size-1)) == 0) && ((Y1 >> (size - 1)) == 0))
        both_pos_flag = 1;

if ((((X1 >> (size-1)) & 1) == 1) && (((Y1 >> (size - 1)) & 1) == 1))
        both_neg_flag = 1;

if (both_pos_flag != 1 && both_neg_flag != 1)
        saturation_mode = 0;

/*
 * Break the input numbers into four diffrent registers. This is
 * convenient in determining the carry's and saturation.
 */

X2 = X1 & max;
acc = X1 >> (size/2);
X3 = acc & max;
acc = X0 >> (size/2);
X1 = acc & max;
X0 = X0 & max;


Y2 = Y1 & max;
acc = Y1 >> (size/2);
Y3 = acc & max;
acc = Y0 >> (size/2);
Y1 = acc & max;
Y0 = Y0 & max;

/*
 * Add input numbers and calculate the result
 */

acc = X0 + Y0;

if (acc > max) {
	W0 = acc & max;
	carry = acc >> size/2;
        }
else
	W0 = acc;

acc = X1 + Y1 + carry;

if (acc > max) {
	W1 = acc & max;
	carry = acc >> size/2;
	}
else  {
	W1 = acc;
	carry = 0;
	}

acc = X2 + Y2 + carry;

if (acc > max) {
	W2 = acc & max;
	carry = acc >> size/2;
        }
else {
	W2 = acc;
	carry = 0;
	}

/*
 * Check if saturation mode is set, if it is then saturate the result in
 * in case of oveflow to the values determined at the beginning. If the
 * mode is not set to 1 then do your arithmetic ignoring any overflow.
 * This is convenient in the case where you might have overflow in
 * intermediate steps but your result is bounded by the word-length.
 * In that case 2's complement arithmetic gives  the correct result even
 * overflow might occur in intermediate additions.
 */

if (saturation_mode == 1) {

        acc = X3 + Y3 + carry;
        W3 = acc & max;
        saturation_carry = acc >> size/2;
        check = (W3 >> ((size/2)-1)) & 1;

        if (W3 == 0 && W2 == 0 && W1 == 0 && W0 == 0)
                zero_flag = 1;

        if (saturation_carry == 1 && check == 0 && zero_flag != 1) {
                printf("negative overflow in addition\n");
                neg_overflow = 1;
                }

        if (both_neg_flag == 1 && zero_flag == 1) {
                printf("negative overflow in addition\n");
                neg_overflow = 1;
                }

        if (check == 1 && both_pos_flag == 1) {
                printf("positive overflow in addition\n");
                pos_overflow = 1;
                }

        if (pos_overflow != 1 && neg_overflow != 1) {

                acc = W3 << (size/2);
                *OW1_ptr = acc + W2;
                acc = W1 << (size/2);
                *OW0_ptr = acc + W0;
                }
        else {
                if (pos_overflow == 1) {
                        *OW1_ptr = pos_max1;
                        *OW0_ptr = pos_max0;
                        }
                else {
                        *OW1_ptr = neg_least1;
                        *OW0_ptr = neg_least0;
                        }
                }
       }
else {

        acc = X3 + Y3 + carry;

        if( acc > max ) {
                W3 = acc & max;
                carry = acc >> size/2;
                }
        else
                W3 = acc;


        acc = W3 << (size/2);
        *OW1_ptr = acc + W2;
        acc = W1 << (size/2);
        *OW0_ptr = acc + W0;
        }

}
