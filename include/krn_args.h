
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
 * krn_args.h
 *
 * global declarations for qplot library
 *
 * Authors:
 * Dr. Sasan H. Ardalan

 *
 */


/*
 * Object structure.  Holds object data.
 * Objects  are held in a circular list.  The list_P member of the header
 * points to the "last" object in the list; the next node is a sentinel with
 * sentFlag == TRUE, and the next node is the "first" object in the list.
 *
 * Linked List to hold argument  objects together
 */

typedef struct krn_argObj {

	param_Pt	parameters_P;
	int		argNumber;
	int		key;

	unsigned int
     	tagFlag : 1,	/* whether tagged 		*/
		sentFlag : 1;	/* this node is a sentinel 		*/


	struct krn_argObj		*next_P;   /* ptr to next entry.*/

} krn_ArgObj_t, *krn_ArgObj_Pt;



/*
 *  Header for macro object list.
 */

typedef struct {
	int			num;		/* number of objects	*/


	krn_ArgObj_Pt		list_P;		/* ptr to last object in*/
						/*   circular list	*/
} krn_ArgHdr_t, *krn_ArgHdr_Pt;







