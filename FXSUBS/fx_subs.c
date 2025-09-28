
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




/***********************
** fct:		quant
** pgmmer:	G. Bottomley
** North Carolina State University
** date:	6/6/89
** purpose:	quantize double into 16-bit int
** note:	routine based on S. Ardalan and S. T. Alexander,
**			"Fixed-point roundoff error analysis of the exponentially
**			windowed RLS algorithm for time-varying systems," IEEE
**			Trans. ASSP, vol. ASSP-35, pp. 770-783, June 1987.
** note:	adding +-0.5 doesn't seem quite enough to cause 0.5 to
**	rounded to 1, and -0.5 to be rounded to -1..
** note:  unlike Ardalan's routine, quantizing to 16 bits and
**		checking for overflows
**********************/

int Fx_Quant(x,frac,size,overflow)
	double x;		/*quantity to be quantized*/
	int frac;		/*number of bits for fraction*/
	int size;		/*max number of bits for the fixed-point
                                  representation */
	int *overflow;	/*overflow flag*/
{
	double a;
	long q;
	long max;

        /*calculate the maximum number allowed in arithmetic*/
        max=1;
        max = (max << (size-1))-1; /* size-1 because MSB is sign bit*/

	/*multiply by power of two*/
	/*Note: Ardalan used int for q, which reversed signs for 15 bits
	  on my machine*/
	q=1;
	q = q<<frac;
	a = x*(double)q;

	/*round*/
	if (a > 0.0) a += 0.500000000000;
	else if (a < 0.0) a -= 0.500000000000;

	/*check overflow*/
	*overflow = 0;
	if (a > max) {
		a = max;
		*overflow = 1;
		}
	if (a < -(max+1)) {
		a = -(max+1);
		*overflow = 1;
		}

	/*return truncated form*/
	return( (int)a );
}

/***********************
** fct:		iquant
** pgmmer:	G. Bottomley
** date:	6/6/89
** purpose:	unquantize 16-bit int into double
**********************/

int Fx_IQuant(qx,frac)
	int qx;			/*quantized*/
	int frac;		/*number of bits for fraction*/
{
	static float divisor = 1.000000;
	static int oldfrac = 0;
	int i;

	if (frac != oldfrac) {
		divisor = 1.0;
		for (i=0; i<frac; i++)
			divisor = divisor*2.00000;
		}
	oldfrac = frac;

	return( (int)((float)qx/divisor) );

}

/***********************
** fct:		roundacc
** pgmmer:	G. Bottomley
** date:	6/6/89
** purpose:	round 32-bit accumulator to return 16-bit int
** note:	routine based on S. Ardalan and S. T. Alexander,
**			"Fixed-point roundoff error analysis of the exponentially
**			windowed RLS algorithm for time-varying systems," IEEE
**			Trans. ASSP, vol. ASSP-35, pp. 770-783, June 1987.
** note: in my computer, >> always shifts in 0's.  Therefore
**		negative numbers must be done differently.
** note:  unlike Ardalan's routine, quantizing to 16 bits and
**		checking for overflows and works for 0 shift
**********************/

int Fx_RoundAcc(acc,shift,size,overflow)
	long acc;	/*32-bit accumulator*/
	int shift;	/*shift right for accumulator*/
	int size;	/*max number of bits for the fixed-point
                          representation */
	int *overflow;	/*flag set if overflow occurs*/

{
	long max;
	long tmp;

        /*calculate the maximum number allowed in arithmetic*/
        max=1;
        max = max << (size-1); /* size-1 because MSB is sign bit*/

	if (shift==0 || acc==0) {
		tmp = acc;
		goto jmp;
		}

	if (shift < 0) {
		if (shift < -(size-1)) {
			if (acc > 0)
				tmp = max;
			else
				tmp = -(max+1);
			goto jmp;
			}
		tmp = acc << -shift;
		goto jmp;
		}

	if (acc >= 0) {

		/*do shifting and rounding*/
		tmp = acc >> (shift-1);
		if (tmp!=0) {
			tmp = tmp+1;		/*adds +-0.5*/
			tmp = tmp>>1;	/*truncate*/
			}
		}
	else {	/*negative number*/
		tmp = (-acc) >> (shift-1);
		if (tmp!=0) {
			tmp = tmp+1;		/*adds +-0.5*/
			tmp = tmp>>1;	/*truncate*/
			}
		tmp = -tmp;
	}

	/*check for overflow*/
jmp:*overflow = 0;
	if (tmp >= max) {
		tmp = (max-1);
		*overflow = 1;
		}
	if (tmp <= -(max+1)) {
		tmp = -max;
		*overflow = 1;
		}

	return( (int)tmp);

}
/***********************
** fct:		sdiv
** pgmmer:	G. Bottomley
** date:	6/6/89
** purpose:	perform division of two 16-bit representations
**	assuming both have binary point in same location
** note: using rounding to provide final result
**********************/

int Fx_SDiv(a,b,frac,overflow)
	int a;		/*number of a/b*/
	int b;
	int frac;	/*number of bits fraction for result*/
	int *overflow;	/*flag set if overflow occurs, 2 if div by zero*/

{
	long tmp;

	if (b == 0) {
		*overflow = 2;
		if (a >= 0) return(32767);
		else return(-32768);
		}

	tmp = ((long)a)<<(frac+1);
	tmp = tmp/b;
	return( Fx_RoundAcc(tmp,1,overflow));

}
