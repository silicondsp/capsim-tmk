

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
 * IIP
 * The Integrated Interactive Plotting Package
 *
 *
 * Author: Sasan H. Ardalan
 */





/*
 *  AIFF Linked List Management
 *  copyright (c) 1993 Sasan Ardalan.  All rights reserved.
 *
 *  module name: iip_aifflist.c
 *
 *  description:
 *    Various useful list utilities.
 *
 */

#include <stdlib.h>
#include <stdio.h>
#include "types.h"

#include "aiff.h"

void  IIPC2P(p,string)
char	*string;
char 	*p;
{
unsigned int	i,n;
n=strlen(string);
for(i=1; i<n+1; i++) {
	p[i]=string[i-1];
#if 0
printf("c2p: %d str=%c p=%c \n",i,string[i-1],p[i]);
#endif
}
p[0]=(char)n;
return;
}


void  IIPP2C(string,p)
char	*string;
char  *p;
{
int	i,n;
n=p[0];
for(i=0; i<n; i++) {
	string[i]=p[i+1];
#if 0
printf("p2c: %d str=%c p=%c \n",i,string[i],p[i+1]);
#endif
}
return;
}


/*
 *  IIPCreateMarkerHeader()
 */
iip_MarkerHdr_Pt	IIPCreateMarkerHeader()
{
iip_MarkerHdr_Pt        hdr_P;
hdr_P=(iip_MarkerHdr_Pt)calloc(1,sizeof(iip_MarkerHdr_t));
return(hdr_P);
}


/*
 *  IIPMarkerAdd()
 *
 *  Make an object and add it to the list.
 *
 *		hdr_P	pointer to the header for the list.
 */

void IIPMarkerAdd(    name,position,id,
		      hdr_P)
unsigned long position;
char	*name;
MarkerIdType	id;
iip_MarkerHdr_t *hdr_P;

{

    /*
     *  If number of nodes is zero, malloc to head ptr and tail ptr.
     *  Otherwise just add a new tail, remembering to fill in its address
     *  to the parent node.
     */
    if (hdr_P->head_P == NULL)
        hdr_P->head_P = hdr_P->tail_P = (iip_Marker_t *) malloc(sizeof(iip_Marker_t));
    else
    {
        hdr_P->tail_P->next_P = (iip_Marker_t *) malloc(sizeof(iip_Marker_t));
        hdr_P->tail_P = hdr_P->tail_P->next_P;
    }

    hdr_P->num++;
    hdr_P->tail_P->position = position;
    hdr_P->tail_P->next_P = NULL;
    strcpy(hdr_P->tail_P->name,name);
    hdr_P->tail_P->id = id;



   return;
}




/*
 *  IIPMarkerDel()
 *
 *  Delete an object from the list and delete the segment.
 *
 *  Arguments:	segId	Id of the segment to delete.
 *		hdr_P	pointer to the header for the list.
 */

void IIPMarkerDel(id, hdr_P)
MarkerIdType	id;
iip_MarkerHdr_t *hdr_P;

{


    iip_Marker_t	*current_P,	/* ptr to current node		*/
		*prev_P,		/* ptr to previous node		*/
		*tmp_P;			/* temporary ptr		*/


    /*
     * Search for object by segment ID.
     */
    for (prev_P = NULL, current_P = hdr_P->head_P;
         current_P != NULL && current_P->id != id;
         prev_P = current_P, current_P = current_P->next_P);


    if (current_P)
    {
        if (prev_P) {
	    tmp_P = current_P->next_P;
	    if (tmp_P)
	    	prev_P->next_P = tmp_P;
	    else {
	    	prev_P->next_P = tmp_P;
		hdr_P->tail_P = prev_P;
	     }

	}
        else /* current segment is the head of the list */
	{
	    tmp_P = current_P->next_P;
	    if (tmp_P)
		/*
		 * make what head points to the new head
		 */
            	hdr_P->head_P = tmp_P;
	    else
		/*
		 * head is the only object left
		 * so indicate empty list
		 */
		hdr_P->head_P= NULL;
	}

        free(current_P);
    }

    return;
}


/*
 *  IIPMarkerGetObj()
 *
 *  Get an object node from the list based on segment number.
 *   NULL value returned if not found.
 *
 *  Arguments:	segId	Id of the segment .
 *		hdr_P	pointer to the header for the list.
 */

iip_Marker_t *IIPMarkerGet( id, hdr_P)
MarkerIdType id;
iip_MarkerHdr_t *hdr_P;

{


    iip_Marker_t	*current_P;	/* ptr to current node		*/


    /*
     * Search for object by segment ID.
     */
    for (current_P = hdr_P->head_P;
         current_P != NULL && current_P->id != id;
         current_P = current_P->next_P);

    return(current_P);
}


/*
 *  IIPMarkerDelList()
 *
 *  Delete an entire list and  segments.
 *
 */

void IIPMarkerDelList(hdr_P)
iip_MarkerHdr_t *hdr_P;

{


    iip_Marker_t	*current_P,	/* ptr to current node		*/
		*prev_P,		/* ptr to previous node		*/
		*tmp_P;			/* temporary ptr		*/


    current_P = hdr_P->head_P;

     if (hdr_P->head_P == NULL) return;

    /*
     * Go down the list and delete all the objects
     */
    do {

	  tmp_P = current_P->next_P;
        	free(current_P);
	  current_P=tmp_P;
    } while (current_P != NULL);
    /*
     * set the linked list to empty
     */
    hdr_P->head_P = NULL;


    return;
}

/*
 * Get an array of markers with the number of markers
 * from the linked list.
 *
 */

void IIPMarkerArrayFromList(hdr_P,  numberMarkers_P,  marker_PP)

iip_MarkerHdr_t *hdr_P;
int	*numberMarkers_P;
Marker	**marker_PP;

{

    int	numberInList=0;
    Marker	*marker_P;
    iip_Marker_t	*current_P;	/* ptr to current node		*/

    if (hdr_P->head_P == NULL) {
	  *numberMarkers_P = 0;
	  return;
    }

     for ( current_P = hdr_P->head_P; current_P; current_P = current_P->next_P)
		numberInList++;


    marker_P = (Marker *)calloc(numberInList,sizeof(Marker));

    if(marker_P == NULL) {
	fprintf(stderr,"AIFF Could not allocate space for markers\n");
	*marker_PP = NULL;
	return;
    }
     *numberMarkers_P =  0;
     for ( current_P = hdr_P->head_P; current_P; current_P = current_P->next_P)
     {


		IIPC2P(marker_P[ *numberMarkers_P ].markerName,current_P->name);
		marker_P[ *numberMarkers_P ].position= current_P->position;
		marker_P[ *numberMarkers_P ].id= current_P->id;
		*numberMarkers_P += 1;


      }
      *marker_PP=marker_P;
      return;

}

/*
 * Setup a linked list based on arrays of points and
 * the number of points.
 *
 */


void IIPMarkerCreateListFromArray( hdr_P,  numberPoints,  marker_P)

iip_MarkerHdr_t *hdr_P;
int	numberPoints;
Marker	*marker_P;

{

	int 	i;
	int	typeFlag;
	char	string[256];


	if (numberPoints == 0 ) return;

	/*
	 * Add points to linked list
	 */

	for (i=0; i<numberPoints; i++) {
		IIPP2C(string,marker_P[i].markerName);

		IIPMarkerAdd(string,marker_P[i].position,
			marker_P[i].id,hdr_P, NULL);
	}

      return;

}


/*
 * Print markers
 */

void IIPMarkerPrint( hdr_P)

iip_MarkerHdr_t *hdr_P;

{

    int	numberInList=0;
    Marker	*marker_P;
    iip_Marker_t	*current_P;	/* ptr to current node		*/

    if (hdr_P->head_P == NULL) {
	  return;
    }

     for ( current_P = hdr_P->head_P; current_P;
				current_P = current_P->next_P) {

		printf("Marker Name: %s, id: %d Position: %d\n",
			current_P->name,current_P->id, current_P->position);

	}
		numberInList++;


return;
}
