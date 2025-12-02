

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


#include <math.h>

#define EMBEDDED_ECOS


#ifndef EMBEDDED_ECOS
#include <errno.h>
#endif

extern	int	errno;
double errcheck(double d,char	*s);

double Log(double x)
	
{
	return errcheck(log(x),"log");
}

double Log10(double x)
	 
{
	return errcheck(log10(x),"log10");
}
double Exp(double x)
	 
{
	return	errcheck(exp(x),"exp");
}

double Sqrt(double x)
	
{
	return	errcheck(sqrt(x),"sqrt");
}

double Pow(double x,double y)
	
{
	return errcheck(pow(x,y),"exponentiation");
}

double Integer(double x)
	 
{
	return(double)(long)x;
}

double errcheck(double d,char	*s)

{
#ifndef EMBEDDED_ECOS
	if	(errno == EDOM) {
		errno=0;
		execerror(s,"argument out of domain");
	} else if (errno == ERANGE) {
		errno =0;
		execerror(s,"result out of range");
	}
#else
        d=0;
#endif
	return d;

}
