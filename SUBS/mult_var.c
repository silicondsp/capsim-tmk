
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
 * This function multiplies two fixed-point numbers in
 * variable precision. The variable size specifies the word
 * length of each number.The fixed-point numbers are accepted
 * in size/2 bits pairs each representing the most significant
 * and least significant size/2 bits. The result is stored in
 * a word length of twice the size. For example if 32-bit size
 * is used the result is stored in 64-bit format. The way of
 * storing 64-bit is in two 32 bit registers namely OW1_ptr,
 * OW0_ptr where OW1_ptr is the most significant size/2 bits.
 * The sign of the product is determined by the numbers and
 * less_flag's which are recieved from part.c function.
 *
 * Programmer : KARAOGUZ, Jeyhan.
 * Date       : 9/15/90
 */

void multvar(int less_flag1, int less_flag2, int size, int X1, int X0, int Y1,int  Y0, int *OW1_ptr, int *OW0_ptr)

/*
 * less_flag1 is for X1, X0 and less_flag2 is for Y1, Y0.
 */


{

int acc, tmp;
int X2, Y2;
int W4, W3, W2, W1, W0;
int sign, partsize, carry;
int andvalue1, andvalue2;

/*
 * partsize is used to put the results in four registers of length
 * size/4, also it is used in the repartition of X1, X0, Y1, Y0.
 */

partsize = (size-2)/2;

andvalue1 = 1;
andvalue1 <<= (size-2)/2;
andvalue1 -= 1;

andvalue2 = 1;
andvalue2 <<= size/2 ;
andvalue2 -= 1;

/*
 * Determine the sign of the product.
 */

if (less_flag1 == 0 && less_flag2 == 0) {

/*
 * For this case, both numbers are either positive or negative but
 * if it is negative then it is greater than or equal to 1<<(size/2)
 * therefore determine the sign by EXORing the most significant
 * size/2 bits. The most significant bits (X1) and (Y1) are checked
 * because those numbers come as negative from part.c function
 * whereas Y0 and X0 come as absolute valued.
 */
	acc = X1^Y1;
	acc >>= (size-1);
	sign = acc & 1;
/*
 * Then, take the absolute value after setting the sign bit.
 */
	if (X1 < 0)
		X1 = (-X1);
	if (Y1 < 0)
		Y1 = (-Y1);
	}

else if (less_flag1 == 1 && less_flag2 == 0) {

/*
 * In this case, the number X is negative and less than 1<<(size/2)
 * and the number Y is either positive or negative therefore set the
 * sign bit after checking (Y1) the most significant bits.
 */
	if (Y1 < 0) {
		sign = 0;
		Y1 = (-Y1);
		}
	else
		sign = 1;
	}

else if (less_flag1 == 0 && less_flag2 == 1) {

/*
 * This case is just the opposite of previous one.
 */

	if (X1 < 0) {
		sign = 0;
		X1 = (-X1);
		}
	else sign = 1;
	}

/*
 * This case means both flags are 1 therefore both numbers are
 * negative and less than 1<<(size/2). The sign of the product
 * should be positive therefore the sign bit is set to 0. Since
 * the coming parts are absolute valued from part.c function
 * there is no need to take the absolute value again.
 */

else
	sign = 0;

/*
 * Do the repartition of X1, X0 and Y1, Y0. New values X1, X0
 * and Y1, Y0 are of length partsize. The remaining bits are
 * held in X2 and Y2. Note that each number is positive since
 * they are all absolute valued.
 */

acc = X1 << (size/2);
acc += X0;
tmp = acc << 1;
X1 = tmp >> (size/2);
X1 &= andvalue2;
X0 = acc & andvalue1;
acc = X1;
X2 = acc >> partsize;
X1 = acc & andvalue1;

acc = Y1 << (size/2);
acc += Y0;
tmp = acc << 1;
Y1 = tmp >> (size/2);
Y1 &= andvalue2;
Y0 = acc & andvalue1;
acc = Y1;
Y2 = acc >> partsize;
Y1 = acc & andvalue1;

/*
 * Multiply |X| and |Y| to produce the result |W|
 */

W4 = X2 & Y2;
acc = X0 * Y0;
tmp = acc << 1;
W1 = tmp>> (size/2);
W1 &= andvalue2;
W0 = acc & andvalue1;

acc = (X1 * Y0) + (X0 * Y1) + W1;
tmp = acc << 1;
W2 = tmp>> (size/2);
W2 &= andvalue2;
W1 = acc & andvalue1;

acc = (X2 * Y0) + (X1 * Y1) + (X0 * Y2) + W2;
tmp = acc << 1;
W3 = tmp>> (size/2);
W3 &= andvalue2;
W2 = acc & andvalue1;

tmp = W4 << partsize;
acc = tmp + (X2 * Y1) + (X1 * Y2) + W3;
tmp = acc << 1;
W4 = tmp>> (size/2);
W4 &= andvalue2;
W3 = acc & andvalue1;

/*
 * Recombine W and generate the result since at the moment
 * the result is in 5 different registers. What we want to
 * do is to put them in two registers eventually. This is
 * done in two steps. In this phase they are put in four
 * size/4 length registers.
 */

acc = W1 << partsize;
acc += W0;
W0 = andvalue2 & acc;
W1 = acc >> (size/2);
acc = W2 << (partsize-1);
acc += W1;
W1 = andvalue2 & acc;
W2 = acc >> (size/2);
acc = W3 << (partsize-2);
acc += W2;
W2 = andvalue2 & acc;
W3 = acc >> (size/2);
acc = W4 << (partsize-3);
acc += W3;
W3 = andvalue2 & acc;

/*
 * Take 2's complement if sign is 1
 */

if ( sign == 1) {

	W0 = ~W0;
	W0 &= andvalue2;
	W0 += 1;

	if ( W0 > andvalue2 )
		carry = 1;
	else
		carry = 0;

	W0 &= andvalue2;
	W1 = ~W1;
	W1 &= andvalue2;
	W1 += carry;

	if ( W1 > andvalue2 )
		carry = 1;
	else
		carry = 0;

	W1 &= andvalue2;
	W2 = ~W2;
	W2 &= andvalue2;
	W2 += carry;

	if ( W2 > andvalue2 )
		carry = 1;
	else
		carry = 0;

	W2 &= andvalue2;
	W3 = ~W3;
	W3 &= andvalue2;
	W3 += carry;
                    }
/*
 * Now, output the result in two size/2 length registers.
 */

acc = W3 << (size/2);
*OW1_ptr = acc + W2;
acc = W1 << (size/2);
*OW0_ptr = acc + W0;

}
