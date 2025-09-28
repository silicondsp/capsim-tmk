

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
 * krn_arguments.c
 *
 * functions that manipulate link list for Capsim arguments
 *
 * Authors:
 * Sasan H. Ardalan (prototyping, development)
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *									     *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 *
 */


#include "capsim.h"







/*
 * KrnFixupArgList--
 *	Call after making changes to the number and/or order of
 * Objects in the Object list.
 */
 void KrnFixupArgList(hdr_P)
krn_ArgHdr_Pt    hdr_P;

{

	krn_ArgObj_Pt	object_P;
	int		i;

	/*
	 * Count Objects.
	 */

	i = 0;
	object_P = hdr_P->list_P->next_P->next_P;
	while (!object_P->sentFlag) {
		i++;
		object_P = object_P->next_P;
	}

	hdr_P->num = i;

	return;

}









/*
 * KrnNewInitedArgRec--
 *	Return a new, init-ed Object record.  The caller should set fields
 * of the record as desired, then call KrnAppendObject (or a similar
 * routine) to insert it into the Object list.  Horrible things will happen
 * if the x/y data isn't set up properly before the new Object is added
 * to the list.
 */
 krn_ArgObj_Pt KrnNewInitedArgObj()
{

	krn_ArgObj_Pt	object_P;
	static int	ObjectNum = 1;
	int		i;

	object_P = (krn_ArgObj_Pt) malloc(sizeof(krn_ArgObj_t));
	if(object_P == NULL) {
		fprintf(stderr,"Could not create space for new Object\n");
		return(0);
	}


	/*
	 * Others
	 */
	object_P->sentFlag = FALSE;
	object_P->next_P = NULL;

	return(object_P);

}



extern void KrnAppendArg();
/*
 */

 krn_ArgHdr_Pt KrnNewArgHdr()
{

	krn_ArgHdr_Pt	hdr_P;


	hdr_P = (krn_ArgHdr_Pt) malloc(sizeof(krn_ArgHdr_t));
	hdr_P->num = 0;

	hdr_P->list_P = (krn_ArgObj_Pt) malloc(sizeof(krn_ArgObj_t));
	hdr_P->list_P->sentFlag = TRUE;
	hdr_P->list_P->next_P = hdr_P->list_P;



	return(hdr_P);

}



/*
 * KrnAppendArg--
 *	Appends a new (or unlinked) Object record to the given Object list.
 * Calls the fixup routine to straighten out counts, etc.
 */
 void KrnAppendArg(hdr_P, newArgObj_P)
krn_ArgHdr_Pt    hdr_P;
krn_ArgObj_Pt	newArgObj_P;

{

krn_ArgObj_Pt	object_P;


	/*
	 * hdr_P->list_P is the LAST Object in the circular Object list.
	 * the following node is the sentinel; the one following that
	 * is the FIRST Object.  hdr_P->list_P is left pointing to the
	 * newArgObj_P, which is the "new" last Object.  This code works
	 * even when hdr_P->list_P points only to the sentinel (i.e.,
	 * when the Object list is empty).
	 */

	newArgObj_P->next_P = hdr_P->list_P->next_P;
	hdr_P->list_P->next_P = newArgObj_P;
	hdr_P->list_P = newArgObj_P;



	KrnFixupArgList();





return;

}



/*
 * KrnDeleteArg--
 *	Deletes a Object and frees whatever is appropriate.
 */

 void KrnDeleteArg(hdr_P,object_P)
krn_ArgHdr_Pt    hdr_P;
krn_ArgObj_Pt	object_P;

{

	krn_ArgObj_Pt	tmp_P;
	char 	command[100];

	if(object_P==NULL) return;

	/*
	 * Find the Object.  Note that this will let you delete the
	 * sentinel.
	 */

	tmp_P =  hdr_P->list_P->next_P;
	while (!tmp_P->next_P->sentFlag && (tmp_P->next_P != object_P))
		tmp_P = tmp_P->next_P;

	if (tmp_P->next_P != object_P) {
		fprintf(stderr, "ERROR: KrnDeleteArg: requested \
Object not found in hdr\n");
		return;
	}

	/*
	 * Unlink it
	 */

	tmp_P->next_P = object_P->next_P;
	if (hdr_P->list_P == object_P)
		hdr_P->list_P = tmp_P;


	/*
	 * Free the parameter block
	 */
	KrnFreeParam(&object_P->parameter_P);

	/*
	 * Free the Object record itself
	 */

	free(object_P);

	/*
	 * And fixup...
	 */

	KrnFixupArgList(hdr_P);



	return;

}


/*
 * KrnDeleteAllObjects--
 *	Deletes all Objects and frees whatever is appropriate.
 */

 void KrnDeleteAllObjects(hdr_P)
krn_ArgHdr_Pt    hdr_P;

{

	krn_ArgObj_Pt	tmp_P;


	tmp_P =  hdr_P->list_P->next_P;
	while (hdr_P->num) {
		KrnDeleteArg(hdr_P->list_P);
	}
	return;


}



 void KrnInheritAttrib(newArgObj_P,object_P)
krn_ArgObj_Pt newArgObj_P;
krn_ArgObj_Pt object_P;
{

return;
}



/*
 * KrnGetArg--
 *	Given argument number, returns structure.
 * 	If argument number does not exist then a NULL is returned.
 */

 krn_ArgObj_Pt KrnGetArg(hdr_P,number)
krn_ArgHdr_Pt    hdr_P;
int	number;

{

	krn_ArgObj_Pt	tmp_P;

	/*
	 * Find the Object.  Note that this will let you delete the
	 * sentinel.
	 */

	tmp_P =  hdr_P->list_P->next_P;
	while (!tmp_P->next_P->sentFlag && (tmp_P->next_P->argNumber != number))
		tmp_P = tmp_P->next_P;

	if (tmp_P->next_P->argNumber != number) {
		return(NULL);
	}
	return(tmp_P->next_P);
}

/*
 * KrnDeleteArgNumber--
 *	Given argument number, returns structure.
 * 	If argument number does not exist then a NULL is returned.
 */

 void  KrnDeleteArgNumber(hdr_P,number)
krn_ArgHdr_Pt    hdr_P;
int	number;

{
krn_ArgObj_Pt	object_P;


KrnDeleteArg(hdr_P,KrnGetArg(hdr_P,number));

return;
}

/*
 * KrnCreateArray--
 * Set the galaxy parameter array to the pointers to the parameter
 * data structure for each argument.  Use NULL for argument numbers with
 * no parameters
 */

 void  KrnCreateArray(galaxy_P)
block_Pt galaxy_P;

{
krn_ArgHdr_Pt    hdr_P;
int	i;
krn_ArgObj_Pt	tmp_P;

	hdr_P=galaxy_P->argHdr_P;

	for(i=0; i<MAX_PARAM; i++)
		galaxy_P->param_AP[i]=NULL;

	/*
	 * go through list
	 */

	tmp_P =  hdr_P->list_P->next_P;
	while (!tmp_P->next_P->sentFlag ) {
		galaxy_P->param_AP[tmp_P->next_P->argNumber]=
				tmp_P->next_P->parameter_P;

		printf("list argnumber=%d  type=%d,  def=%s\n",
			tmp_P->next_P->argNumber,
			tmp_P->next_P->parameter_P->type,
			tmp_P->next_P->parameter_P->def);
		tmp_P = tmp_P->next_P;
	}

	for(i=0;  i<MAX_PARAM; i++) {
	    if( galaxy_P->param_AP[i])
		printf("number=%d, type=%d,  def=%s\n",i,
			galaxy_P->param_AP[i]->type,
			galaxy_P->param_AP[i]->def);
	}

	return;
}

/*
 * KrnCreateArgListFromArray--
 * Create a linked list from the parameter array
 */

 void  KrnCreateArgListFromArray(galaxy_P)
block_Pt galaxy_P;

{
krn_ArgHdr_Pt    hdr_P;
int	i;
krn_ArgObj_Pt	tmp_P;
krn_ArgObj_Pt newArgObj_P;

	hdr_P=galaxy_P->argHdr_P;

	for(i=0; i<MAX_PARAM; i++) {
		if(galaxy_P->param_AP[i] == NULL)
				continue;
		newArgObj_P=KrnNewInitedArgObj();
		newArgObj_P->parameter_P=galaxy_P->param_AP[i];
		newArgObj_P->argNumber=i;
		KrnAppendArg(hdr_P, newArgObj_P);
	}


	return;
}
