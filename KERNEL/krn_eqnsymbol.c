
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

#include  <string.h>
#include <stdlib.h>

#include "krn_eqn.h"
#include "y.tab.h"

#define NULL 0

void yyerror(char *s);
void execerror(char *s,char *t);

/*
 * symbol table: linked list
 */
static	Symbol *symlist=0;
static char *emalloc(unsigned n);

Symbol *KrnEqnLookup(char	*s)
	
{
	Symbol	*sp;

	for(sp=symlist; sp != (Symbol *) 0; sp=sp->next)
		if (strcmp(sp->name,s) == 0)
			return sp;
	return 0;
}

Symbol *KrnEqnInstall(char *s,int	t,double	d)

{
	Symbol	*sp;


	sp=(Symbol *) emalloc(sizeof(Symbol));
	sp->name=emalloc(strlen(s) +1); /* +1 for '\0' */
	strcpy(sp->name,s);
	sp->type = t;
	sp->u.val =(float)d;
	sp->next = symlist; /* put at front of list */
	symlist =sp;
	return sp;
}

static char *emalloc(unsigned n)

{
	char	*p;


	p=malloc(n);
	if(p== NULL)
		execerror("Out of memory","error");
	return p;
}
