
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
 * The reason for doing the arithmetic in 2's complement form instead
 * of signed arithmetic is because of overflow.The input
 * numbers are accepted in two registers of length size bits. The
 * result is stored in a register of length twice the size. This
 * function is compatible with the Fx_MultVar.c function if the size
 * variables are the same. That is, you can add the outputs of
 * multiplication function with Fx_AddVar.c. This is very convenient
 * for FIR filter applications.
 *
 * Programmer : KARAOGUZ, Jeyhan.
 * Date       : 9/17/90
 * Part of Capsim Subroutine Library
 */


#include <stdio.h>

void Fx_AddVar(int size,int saturationMode,int x1,int x0,int y1,int y0,int *ow1_P,int *ow0_P)

/*
 * Variable saturationMode specifies whether the result should be
 * saturated or not in case of overflow.
 */


{

int x3, x2, y3, y2, w3, w2, w1, w0;
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

if (((x1 >> (size-1)) == 0) && ((y1 >> (size - 1)) == 0))
        both_pos_flag = 1;

if ((((x1 >> (size-1)) & 1) == 1) && (((y1 >> (size - 1)) & 1) == 1))
        both_neg_flag = 1;

if (both_pos_flag != 1 && both_neg_flag != 1)
        saturationMode = 0;

/*
 * Break the input numbers into four different registers. This is
 * convenient in determining the carry's and saturation.
 */

x2 = x1 & max;
acc = x1 >> (size/2);
x3 = acc & max;
acc = x0 >> (size/2);
x1 = acc & max;
x0 = x0 & max;


y2 = y1 & max;
acc = y1 >> (size/2);
y3 = acc & max;
acc = y0 >> (size/2);
y1 = acc & max;
y0 = y0 & max;

/*
 * Add input numbers and calculate the result
 */

acc = x0 + y0;

if (acc > max) {
	w0 = acc & max;
	carry = acc >> size/2;
        }
else
	w0 = acc;

acc = x1 + y1 + carry;

if (acc > max) {
	w1 = acc & max;
	carry = acc >> size/2;
	}
else  {
	w1 = acc;
	carry = 0;
	}

acc = x2 + y2 + carry;

if (acc > max) {
	w2 = acc & max;
	carry = acc >> size/2;
        }
else {
	w2 = acc;
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

if (saturationMode == 1) {

        acc = x3 + y3 + carry;
        w3 = acc & max;
        saturation_carry = acc >> size/2;
        check = (w3 >> ((size/2)-1)) & 1;

        if (w3 == 0 && w2 == 0 && w1 == 0 && w0 == 0)
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

                acc = w3 << (size/2);
                *ow1_P = acc + w2;
                acc = w1 << (size/2);
                *ow0_P = acc + w0;
                }
        else {
                if (pos_overflow == 1) {
                        *ow1_P = pos_max1;
                        *ow0_P = pos_max0;
                        }
                else {
                        *ow1_P = neg_least1;
                        *ow0_P = neg_least0;
                        }
                }
       }
else {

        acc = x3 + y3 + carry;

        if( acc > max ) {
                w3 = acc & max;
                carry = acc >> size/2;
                }
        else
                w3 = acc;


        acc = w3 << (size/2);
        *ow1_P = acc + w2;
        acc = w1 << (size/2);
        *ow0_P = acc + w0;
        }

}
