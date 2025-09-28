

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

#include "capsim.h"


/*
 * krn_expeval.c
 *
 * Written by Sasan H. Ardalan
 *
 * This routine evaluates expressions in parameter specifications
 *
 */

/*********************************************************************

		External Function Declarations

**********************************************************************
*/
extern void KrnFreeParam();


/**********************************************************************

			Global Declarations

***********************************************************************
*/

extern int line_mode, graphics_mode;
extern block_Pt pb_current;
extern block_Pt pg_current;
extern block_Pt pb_error;


extern int     krn_lineno;
extern int     krn_bufferPtr;
extern char    *krn_buffer;
extern float   krn_eqnResult;


 float	KrnEvalParamExp(expression)
char	*expression;
{
char argAssignment[80];
modelEntry_t *gmodel;
param_Pt pp;
int i, j,np;
int type;
int	doAssignment;


/*
 * set argument values in symbol table
 */

gmodel = &model[pg_current->model_index];
if((np = KrnParamCount(gmodel->param_AP)) != 0) {
	/*
	 * the current galaxy has arguments
	 */
	for(i=0; i<MAX_PARAM; i++) {
        	pp = gmodel->param_AP[i];
		/*
		 * if parameter pointer is NULL then this
		 * argument number has been skipped.
		 * examine the next one.
		 * recall that argument numbers do not have to be contiguous
		 */
        	if (pp == NULL) {
                	continue;
        	}
		doAssignment=TRUE;
		/*
		 * create assignment statement and send to parser
		 * e.g. arg5=1055.0
		 * Note line feed
		 * if not integer or floating point set to zero
		 */
        	type = pp->type;
        	switch(type) {
		  case PARAM_INT:
        		sprintf(argAssignment,"arg%d=%d\n", i,pp->value.d);
			break;
		  case PARAM_FLOAT:
        		sprintf(argAssignment,"arg%d=%e\n", i,pp->value.f);
			break;
		  default:
			doAssignment=FALSE;
			break;

		}
		if(doAssignment) {
			krn_bufferPtr=0;
			krn_buffer=argAssignment;
			printf("String is :%s",krn_buffer);
			yyparse();
			printf("Final result is = %f \n",krn_eqnResult);
		}
	}




}




/*
 * allocate space for expression to parser
 */
krn_buffer=(char *)calloc(strlen(expression)+2,sizeof(char));
strcpy(krn_buffer,expression);
/*
 * make sure it has an end of line character
 */
krn_buffer[strlen(expression)]='\n';
krn_buffer[strlen(expression)+1]='\0';


krn_lineno=1;
/*
 * skip over '=' by starting  pointer from one
 */
krn_bufferPtr=1;
#ifdef DEBUG
printf("String is :%s",krn_buffer);
#endif

yyparse();

#ifdef DEBUG
printf("Final result is = %f \n",krn_eqnResult);
#endif



return(krn_eqnResult);
}

