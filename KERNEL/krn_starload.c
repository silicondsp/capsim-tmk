
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


/* starload.c */
/***********************************************************************

		DYNAMIC LOAD ROUTINES

************************************************************************

Contains routines which perform dynamic loading of user stars.
*/

#include <a.out.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <stdio.h>
#include "capsim.h"

/* Installation specific paths! (These must be edited) */
#define CAPSIM_PATH "/usr/users/capsim/SRC"
#define CAPSIM_OBJ_FILE "/usr/users/capsim/SRC/capsim"
#define STARGAZE_PATH "/usr/users/capsim/STARS"

/**********************************************************************

			External Function Declarations

***********************************************************************
*/

/* prinfo.c */
extern int prinfo();

/********************************************************************

			Global Declarations

*********************************************************************
*/

extern int model_count;
extern char *star_paths[];


/***********************************************************************

			new_star()

************************************************************************
This program checks to see that the file ending in .o exists somewhere
in the defined star_path directories.  It then links and loads it,
and updates the model table accordingly.

*/

new_star(filename)
	char *filename;
{
	char sresult[MAXPATHLEN];
	char cresult[MAXPATHLEN];
	char oresult[MAXPATHLEN];
	char scratch[MAXPATHLEN];
	char ident[6];
	int index;
	int i, err;
	int stime, ctime, otime;	/* time stamps */
	struct stat buf;	/* for stat call */

	int s_exists, c_exists, o_exists;
	char ftype;

if(1)return(0);
#if 0
if(model_count >= MAXMODELS)
	return(160);

/* check for suffix */
if(*(filename + strlen(filename) - 1) != '.')
	return(162);
ftype = *(filename + strlen(filename) - 1);
if(!(ftype == 's' || ftype == 'c' || ftype == 'o'))
	return(162);

/* see if .s file exists */
s_exists = 0;
*(filename + strlen(filename) - 1) = 's';
file_path(&sresult[0], filename, 4, star_paths);
if (sresult[0] != '\0') {
	s_exists = 1;
	/* get time stamp */
	stat(sresult, &buf);
	stime = buf.st_mtime;
}
if(ftype == 's') goto case_s;

/* see if .c file exists */
c_exists = 0;
*(filename + strlen(filename) -1) = 'c';
file_path(&cresult[0], filename, 4, star_paths);
if (cresult[0] != '\0') {
	c_exists = 1;
	/* get time stamp */
	stat(cresult, &buf);
	ctime = buf.st_mtime;
}
if(ftype == 'c') goto case_c;

/* see if .o file exists */
o_exists = 0;
*(filename + strlen(filename) -1) = 'o';
file_path(&oresult[0], filename, 4, star_paths);
if (oresult[0] != '\0') {
	o_exists = 1;
	/* get time stamp */
	stat(oresult, &buf);
	otime = buf.st_mtime;
}
if(ftype == 'o') goto case_o;

/* unrecognized file type */
return(163);

case_s:
	if(!s_exists) return(166);
	sprintf(scratch, "%s/stargaze %s\n",STARGAZE_PATH, sresult);

	if(err = system(scratch)) return(164);
	c_exists = 1;
	ctime = stime + 1;
	strcpy(cresult,sresult);
	*(cresult + strlen(cresult) - 1) = 'c';

case_c:
	if(!c_exists) goto case_s;
	if(s_exists && ctime < stime) goto case_s;

	/* construct compile command */
	sprintf(scratch, "cc -c -g -I%s %s\n",CAPSIM_PATH, cresult);
	prinfo(stdout, scratch);

	if(err = system(scratch)) return(169);

	o_exists = 1;
	otime = ctime + 1;
	strcpy(oresult,cresult);
	*(oresult + strlen(oresult) - 1) = 'o';
	/* If the home of the source file is not working directory, */
	/* move the resulting object file with the source file. */
	/* This is necessary because -c flag always puts the object*/
	/* file in the working directory, not the source directory.*/
	if(cresult[0] != '.')	{
		sprintf(scratch, "mv %s.o %s\n",
			file_root(oresult), oresult);
		prinfo(stdout, scratch);
		if(err = system(scratch)) return(167);
	}

case_o:
	if(!o_exists) goto case_c;
	if(c_exists && otime < ctime) goto case_c;
	if(s_exists && otime < stime) goto case_s;


/* Now there is an object file is the source directory or the
  star directory.  Try to load this into next open star slot */
index = model_count;
if(err = load_obj_module(oresult, index))
	return(err);

/* define new star model entry */
strcpy(filename, file_root(filename));
strcpy(model[index].name, filename);
strncpy(model[index].ident, filename, 6);
model[index].ident[6] = '\0';
model[index].param_model_flag = 0;
model[index].mtype = CUSTOM;
model_count++;

return(0);
#endif
}


/**********************************************************************

			load_obj_module()

***********************************************************************

Function allocates space, links, and loads in the specified object
module.

Arguments:
	The name of the file to be loaded.
	The model table index of this star.
Returns:
	0 if successful,
	non-0 if not.
*/

static int load_obj_module(filename, index)
	char filename[];/* object file (full name) to load */
	int index;	/* index into gal table for function ptr */
{
#if 0
	typedef struct exec EXEC;	/* the header type */

	char headbuf[sizeof(EXEC)];	/* file header storage */
	EXEC *header;	/* the header itself */
	int fdobj;	/* the object file descriptor */
	int total_size;	/* the total size of the module */
	char *object_buffer;	/* the place to put the code */
	char command[MAXLINE];	/* the link command string */
	char tempfile[20];	/* a temporary file */
	int err;	/* scratch var */

/* Open the desired file */
if ((fdobj = open(filename,0)) < 0)
	return(170);

/* Try to read in the header */
if (read(fdobj,headbuf,sizeof(EXEC)) != sizeof(EXEC))
	return(171);

header = (EXEC *) headbuf;

/* Check to make sure it's an object file */
if (N_BADMAG(*header))
	return(172);

/* Now get the size of memory that we'll need */
if (header->a_bss != 0)
	return(173);

total_size = header->a_text + header->a_data;

/* Allocate the space, page-aligned */
object_buffer = (char *)valloc(total_size);
if (object_buffer == NULL)
	return(174);

close(fdobj);

/* create a temporary file */
strcpy(tempfile, mktemp("/usr/tmp/blXXXXXX"));

/* Link to this program */
/* Caveat -- only the math library is included! */

sprintf(command,"ld -A %s -T %x -N -o %s %s -lm -lc",
	CAPSIM_OBJ_FILE, object_buffer, tempfile, filename);

if (system(command) != 0)
	return(175);

/* now read in the linked file */
fdobj = open(tempfile, 0);

/* skip the header */
err = lseek(fdobj, (long)(sizeof(EXEC)), 0);

if (err < 0)
	return(176);

if(read(fdobj,object_buffer,total_size) < total_size)
	return(177);

close(fdobj);

unlink(tempfile);

/* Set the pointer to the code */
model[index].function = (PFI) object_buffer;

/* Success! */
#endif
return(0);

}

