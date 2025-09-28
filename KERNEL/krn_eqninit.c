

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



#include  <math.h>
#include "krn_eqn.h"
#include "y.tab.h"

extern double Log(),Log10(),Exp(),Sqrt(), Integer();

static struct {
	char *name;
	double cval;
} consts[]= {
	"PI",	3.14159265358979,
	"E",	2.7182818284590,
	"GAMMA",	0.57721755490153,
	"DEG",	57.29577951308,
	"PHI",	1.61803398874989,
	0,	0
};

static struct {
	char 	*name;
	double (*func)();
} builtins[]= {
	"sin",	sin,
	"cos",	cos,
	"atan",	atan,
	"log",	Log,
	"log10",	Log10,
	"exp",	Exp,
	"sqrt", Sqrt,
	"int",	Integer,
	"abs",	fabs,
	0,	0
};

KrnEqnInit()
{

	int i;
	Symbol *s;

	for (i=0; consts[i].name; i++)
		KrnEqnInstall(consts[i].name,VAR,consts[i].cval);
	for(i=0; builtins[i].name; i++) {
		s=KrnEqnInstall(builtins[i].name,BLTIN,0.0);
		s->u.ptr = builtins[i].func;
	}
}
