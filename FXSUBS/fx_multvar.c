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
 *
 * This function multiplies two fixed-point numbers in
 * variable precision. The variable size specifies the word
 * length of each number.The fixed-point numbers are accepted
 * in size/2 bits pairs each representing the most significant
 * and least significant size/2 bits. The result is stored in
 * a word length of twice the size. For example if 32-bit size
 * is used the result is stored in 64-bit format. The way of
 * storing 64-bit is in two 32 bit registers namely ow1_P,
 * ow0_P where ow1_P is the most significant size/2 bits.
 * The sign of the product is determined by the numbers and
 * less_flag's which are recieved from the fx_part.c function.
 *
 * Programmer : KARAOGUZ, Jeyhan
 * North Carolina State University
 * Date       : 9/15/90
 *
 */

Fx_MultVar(int less_flag1, int less_flag2, int size, int x1, int x0, int y1, int y0, int* ow1_P, int* ow0_P)

/*
 * less_flag1 is for x1, x0 and less_flag2 is for y1, y0.
 */

{

int acc, tmp;
int x2, y2;
int w4, w3, w2, w1, w0;
int sign, partsize, carry;
int andvalue1, andvalue2;

//printf("%d %d %d \n",less_flag1,x1,x0);
//printf("%d %d %d \n",less_flag2,y1,y0);

if(!x1 && !x0) {
    *ow1_P=0;
    *ow0_P=0;
    return;
}
if(!y1 && !y0) {
    *ow1_P=0;
    *ow0_P=0;

    return;
}

/*
 * partsize is used to put the results in four registers of length
 * size/4, also it is used in the repartition of x1, x0, y1, y0.
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
 * size/2 bits. The most significant bits (x1) and (y1) are checked
 * because those numbers come as negative from part.c function
 * whereas y0 and x0 come as absolute valued.
 */
	acc = x1^y1;
	acc >>= (size-1);
	sign = acc & 1;
/*
 * Then, take the absolute value after setting the sign bit.
 */
	if (x1 < 0)
		x1 = (-x1);
	if (y1 < 0)
		y1 = (-y1);
	}

else if (less_flag1 == 1 && less_flag2 == 0) {

/*
 * In this case, the number X is negative and less than 1<<(size/2)
 * and the number Y is either positive or negative therefore set the
 * sign bit after checking (y1) the most significant bits.
 */
	if (y1 < 0) {
		sign = 0;
		y1 = (-y1);
		}
	else
		sign = 1;
	}

else if (less_flag1 == 0 && less_flag2 == 1) {

/*
 * This case is just the opposite of previous one.
 */

	if (x1 < 0) {
		sign = 0;
		x1 = (-x1);
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
 * Do the repartition of x1, x0 and y1, y0. New values x1, x0
 * and y1, y0 are of length partsize. The remaining bits are
 * held in x2 and y2. Note that each number is positive since
 * they are all absolute valued.
 */

acc = x1 << (size/2);
acc += x0;
tmp = acc << 1;
x1 = tmp >> (size/2);
x1 &= andvalue2;
x0 = acc & andvalue1;
acc = x1;
x2 = acc >> partsize;
x1 = acc & andvalue1;

acc = y1 << (size/2);
acc += y0;
tmp = acc << 1;
y1 = tmp >> (size/2);
y1 &= andvalue2;
y0 = acc & andvalue1;
acc = y1;
y2 = acc >> partsize;
y1 = acc & andvalue1;

/*
 * Multiply |X| and |Y| to produce the result |W|
 */

w4 = x2 & y2;
acc = x0 * y0;
tmp = acc << 1;
w1 = tmp>> (size/2);
w1 &= andvalue2;
w0 = acc & andvalue1;

acc = (x1 * y0) + (x0 * y1) + w1;
tmp = acc << 1;
w2 = tmp>> (size/2);
w2 &= andvalue2;
w1 = acc & andvalue1;

acc = (x2 * y0) + (x1 * y1) + (x0 * y2) + w2;
tmp = acc << 1;
w3 = tmp>> (size/2);
w3 &= andvalue2;
w2 = acc & andvalue1;

tmp = w4 << partsize;
acc = tmp + (x2 * y1) + (x1 * y2) + w3;
tmp = acc << 1;
w4 = tmp>> (size/2);
w4 &= andvalue2;
w3 = acc & andvalue1;

/*
 * Recombine W and generate the result since at the moment
 * the result is in 5 different registers. What we want to
 * do is to put them in two registers eventually. This is
 * done in two steps. In this phase they are put in four
 * size/4 length registers.
 */

acc = w1 << partsize;
acc += w0;
w0 = andvalue2 & acc;
w1 = acc >> (size/2);
acc = w2 << (partsize-1);
acc += w1;
w1 = andvalue2 & acc;
w2 = acc >> (size/2);
acc = w3 << (partsize-2);
acc += w2;
w2 = andvalue2 & acc;
w3 = acc >> (size/2);
acc = w4 << (partsize-3);
acc += w3;
w3 = andvalue2 & acc;

/*
 * Take 2's complement if sign is 1
 */

if ( sign == 1) {

	w0 = ~w0;
	w0 &= andvalue2;
	w0 += 1;

	if ( w0 > andvalue2 )
		carry = 1;
	else
		carry = 0;

	w0 &= andvalue2;
	w1 = ~w1;
	w1 &= andvalue2;
	w1 += carry;

	if ( w1 > andvalue2 )
		carry = 1;
	else
		carry = 0;

	w1 &= andvalue2;
	w2 = ~w2;
	w2 &= andvalue2;
	w2 += carry;

	if ( w2 > andvalue2 )
		carry = 1;
	else
		carry = 0;

	w2 &= andvalue2;
	w3 = ~w3;
	w3 &= andvalue2;
	w3 += carry;
                    }
/*
 * Now, output the result in two size/2 length registers.
 */

acc = w3 << (size/2);
*ow1_P = acc + w2;
acc = w1 << (size/2);
*ow0_P = acc + w0;

}
