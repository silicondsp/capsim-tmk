

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


/* file.c */
/*********************************************************************

		File Manipulation

***********************************************************************
Routines which load and store files, modify file names, etc.
*/
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <dirent.h>
#include <string.h>
#include  <unistd.h>
#include "capsim.h"


void file_path(char *result, char *filename, int mode, char *path[]);


extern int model_count;
extern int line_mode;
extern char *gal_paths[];
extern block_Pt pg_current;
extern block_Pt pb_current;
extern block_Pt pb_error;
//char *file_root();

void ToLowerCase(char *string);
void ToUpperCase(char *string);
/**********************************************************************

			LineLoad()

***********************************************************************
Reads and loads a topology file.  The file name is either
an input argument or is derived from the galaxy name.
The topology is always established in the current galaxy!
*/

int LineLoad(char *line)

{
	int error;
	int i, index;
	int name_flag = 0;
	char filename[NAME_LENGTH];
	char blkModelName[NAME_LENGTH];
	char result[MAX_PATH_LEN];

if(sscanf(line, "load %s", filename) == 1) {
	strcpy(blkModelName, file_root(filename));
	printf("model name: %s\n",blkModelName);
	if((index = mtable_index(blkModelName,GALAXY)) < 0)
		return(27);
	name_flag = 1;
}
else {
	index = pg_current->model_index;
	strcpy(blkModelName,model[index].name);
}

/* expand the topology file name for the current galaxy */
sprintf(filename,"%s.t",blkModelName);
#ifndef EMBEDDED_ECOS
file_path(result, filename, 4, gal_paths);
#else
sprintf(result,"/%s.t",blkModelName);

#endif
if (result[0] == '\0')
	/* couldn't find it */
	return(27);

/* Seek user approval if there are changes downstream */
if(!ApproveChanges(pg_current, line_mode))
	return(0);

if(name_flag) {
	/* Change the galaxy reference model */
	pg_current->model_index = index;
	strcpy(model[index].name, blkModelName);
	if(pg_current->type == UTYPE)
		/* Change the universe level instance name */
		strcpy(pg_current->name, blkModelName);
}

/* clear the current galaxy and galaxy model */
KrnStoreStack(NULL);
model[index].param_model_flag = 0;
for(i=0; i< MAX_PARAM; i++)
	KrnFreeParam(&model[index].param_AP[i]);
if(pg_current->type == UTYPE) {
	for(i=0; i< MAX_PARAM; i++)
		KrnFreeParam(&pg_current->param_AP[i]);
}
pg_current->info_P=NULL;
RemoveChildren(pg_current);
/*
 * allocate space for universe/galaxy information
 */
if (pg_current->info_P == NULL) {
        pg_current->info_P = (info_Pt) calloc ( 1,sizeof( info_t) ) ;





        if(pg_current->info_P == NULL) {
                fprintf(stderr,"Could not allocate space for information\n");
                pg_current->info_P=NULL;
                return(1);
        }

        strcpy(pg_current->info_P->title,"");
        strcpy(pg_current->info_P->author,"");
        strcpy(pg_current->info_P->date,"");
        strcpy(pg_current->info_P->descrip,"");

}


/* load the galaxy definition file */
if(KrnToplologyFileReader(result)) {
	/* if there is an error in topology file , remove the galaxy */
	RemoveChildren(pg_current);
	pb_current = NULL;
	return(26);
}

pb_current = pg_current->pchild;


/* Parameter Checking */
if(error = KrnVerifyParams(pg_current))
	return(error);

if(line_mode) {
	PrInfoAll(stdout,pg_current);
	PrInfoBlockCurrent();
}

return(0);

}

/*
 * Create a galaxy model entry
 * return index
 * note if a galaxy with the same name existed it will be overwritten
 */

 int KrnCreateModel(char *fileName)

{
int index, i;
int nameFlag = 0;

if((index = mtable_index(fileName,GALAXY)) < 0
 && model_count < MAX_MODELS) {
	/* create new model entry */
	index = ++model_count - 1;
	strcpy(model[index].name,fileName);
	ToUpperCase(fileName);
	strncpy(model[index].ident,fileName,MAX_IDENT_LEN);
	model[index].ident[MAX_IDENT_LEN] = '\0';
}
model[index].param_model_flag = 0;
model[index].mtype = GALAXY;
/* copy the original model parameters */
for(i=0; i<MAX_PARAM; i++) {
	KrnParamCheck(&model[index].param_AP[i],
		&model[pg_current->model_index].param_AP[i]);
}

return(index);
}

/**********************************************************************

			LineStore()

***********************************************************************
Stores the topology of the current galaxy in a file.  The file name
is either an input argument or is derived from the galaxy name.
If a filename is given, a new model table entry is referenced (and
created if necessary).
The galaxy model reference is changed to the new entry.
At the top (universe) level only, the galaxy instance name is also changed.
*/

int LineStore(char *line)

{
#ifndef EMBEDDED_ECOS
	FILE *fp;
	char filename[NAME_LENGTH];
	char string[MAX_LINE];
	int index, i;
	int nameFlag = 0;

if(pg_current == NULL)
	return(28);

index = pg_current->model_index;

if(sscanf(line, "store%s", string) == 1) {
	StripSuffix(string);
	sprintf(filename, "%s.t", string);
	nameFlag = 1;
}
else
	sprintf(filename,"%s.t",model[index].name);

if((fp = fopen(filename,"w")) == NULL)
	return(29);

strcpy(filename,file_root(filename));

index=KrnCreateModel(filename);
#if 0
if((index = mtable_index(filename,GALAXY)) < 0
 && model_count < MAXMODELS) {
	/* create new model entry */
	index = ++model_count - 1;
	strcpy(model[index].name,filename);
	ToUpperCase(filename);
	strncpy(model[index].ident,filename,MAX_IDENT_LEN);
	model[index].ident[MAX_IDENT_LEN] = '\0';
	model[index].param_model_flag = 0;
	model[index].mtype = GALAXY;
	/* copy the original model parameters */
	for(i=0; i<MAX_PARAM; i++) {
		KrnParamCheck(&model[index].param_AP[i],
			&model[pg_current->model_index].param_AP[i]);
	}
}
#endif
if(index >= 0 && nameFlag == 1) {
	pg_current->model_index = index;
	pg_current->change_flag = 1;
	if(pg_current->type == UTYPE)
		/* change the universe instance name */
		strcpy(pg_current->name,filename);
}

PrInfoAll(fp, pg_current);
fclose(fp);

ClearChanges(pg_current,0);
#endif

return(0);

}


/***********************************************************************

			mtable_index()

************************************************************************
Returns the index into the model table of the given name and
a given type.  Returns -1 if name not found.
*/

int mtable_index(char *name, int type)
 	/* name of desired block */
	 	/* type of desired block */
{
	int index;

index = 0;
for(index = 0; index < model_count; index++) {
	if(model[index].mtype != type)
		continue;
	if(strcmp(name, model[index].name) == 0)
		return(index);
}
return(-1);

}


/***********************************************************************

			file_path()

************************************************************************
Given a file name, an access mode, and a list of paths, this routine
searches for the file.  It writes the expanded file name in 'result',
using the first path that the file was found in.

This routine was written by Robert Kavaler (kavaler@oz), modified
by D.J. Hait.

Modified: 8/88 ljfaber...add vms file recognition, form, comments

*/

void file_path(char *result, char *filename, int mode, char *path[])

{
	char c1;
	int i;

if(filename == NULL) {
	result[0] = '\0';
	return;
}

/* check for direct or indirect path prefix */
c1 = filename[0];
#ifdef UNIX
if(c1 == '/' || c1 == '.') {
#endif
#ifdef VMS
if(c1 == '[') {
#endif
#ifdef DOS
if(c1 == '\\') {

#endif
	sprintf(result, "%s", filename);
	/* 'access' is a system call */
	if(access(result, mode) != 0)
		result[0] = '\0';
	return;
}

/* try list of path prefixes */
for(i=0; i<MAX_PATHS && path[i] != NULL; i++) {

#ifdef UNIX
	sprintf(result, "%s/%s", path[i], filename);
#endif
#ifdef VMS
	sprintf(result, "%s%s", path[i], filename);
#endif
#ifdef DOS
	sprintf(result, "%s\\%s", path[i], filename);
#endif



	if(access(result, mode) == 0)
		return;
}

result[0] = '\0';
return;

}


/*********************************************************************

			file_root

**********************************************************************

Finds the root name of (possibly) extended file name.
Removes any suffix (.c, etc) by overwriting a NULL on the dot.
Returns pointer to first character of root name.
*/

char *file_root(char *filename)

{
	char *s, *t;
	static char rootname[MAX_LINE];

s = t = filename;
while(*s != '\0') {
	if(*s == PATHDELIM)
		t = s+1;
	s++;
}

strcpy(rootname,t);
StripSuffix(rootname);

return(rootname);

}

/**********************************************************************

		StripSuffix()

***********************************************************************
If there is a suffix on a filename, the denoting '.' is overwritten
with a null, and a one is returned; else a zero is returned.
*/

int StripSuffix(char *filename)

{
	int len;
	char *s;

for(len = strlen(filename); len > 0; len--) {
	s = filename + len - 1;
	if(*s == PATHDELIM)
		break;
	if(*s == '.') {
		*s = '\0';
		return(1);
	}
}

return(0);

}


/*********************************************************************
 *
 *		galaxy_define()
 *
 *********************************************************************
 * This function reads in all ~.t file names from the galaxy path
 * indicated by the passed index.
 * These file names are then defined onto the model table.
 * This allows user access to all available galaxies.
 * Modified: November 23, 2017 Sasan Ardalan Use GNU CLIB opendir to get topology list
 */
#ifndef EMBEDDED_ECOS
int galaxy_define(int index)
	 /* new gal_path */
{
	FILE *fp;
	int err;
	char *gpath;
	char command[MAX_LINE];
	char filename[MAX_LINE];
	char *tmpFileName;
	char fileName[256];
	int length;


if(model_count >= MAX_MODELS)
	return(1);
if((gpath = gal_paths[index]) == NULL)
	return(2);

//tmpFileName = (char *)calloc(L_tmpnam,sizeof(char));
tmpFileName = (char *)calloc(100,sizeof(char));
strcpy(tmpFileName,"capsimXXXXXXXXX");
// xxxxx mkstemp(tmpFileName);
//tmpnam(tmpFileName);
//
#define UNIX
#ifdef UNIX

DIR *dp;
  struct dirent *ep;

  dp = opendir ("./");
  if (dp != NULL)
    {
      while (ep = readdir (dp))
      {

		  strcpy(fileName,ep->d_name);
		  length=strlen(fileName);
		  if(length >2)if(fileName[length-1]=='t' && fileName[length-2]=='.') {
		 // 			printf("Found Topology:%s<-\n",fileName);

                    strcpy(fileName,file_root(fileName));

#ifdef VMS
	ToLowerCase(fileName);
#endif

	               if(mtable_index(fileName,GALAXY) >=  0)
		                    continue;

	              /* create the model table entry */
	              strcpy(model[model_count].name, fileName);
	              ToUpperCase(fileName);
	              strncpy(model[model_count].ident, fileName, MAX_IDENT_LEN);
	              model[model_count].ident[MAX_IDENT_LEN] = '\0';
	              model[model_count].param_model_flag = 0;
	              model[model_count].mtype = GALAXY;
	              model_count++;
	              if(model_count >= MAX_MODELS) {
					      (void) closedir (dp);
					      return(-1);
			      }



	     }
    //     puts (ep->d_name);

      }
      (void) closedir (dp);
      return(0);
    }
  else {
    perror ("Couldn't open the directory");
    return(-1);

  }
//Follwing now obselete


//sprintf(command,"ls %s/*.t > %s", gpath,tmpFileName);
//sprintf(command,"/usr/bin/ls %s/*.t > %s", gpath,tmpFileName);

//sprintf(command,"dir /b *.t > %s",tmpFileName);

//sprintf(command,"dir /b *.t > xwwwww");
//sprintf(command,"dir   *.t > xwwwww");

//sprintf(command,"./CreateTopList.exe");
//fprintf(stderr,"Command is:%s\n",command);
//system(command);
//strcpy(tmpFileName,"xwwwww");

//if((fp = fopen(tmpFileName, "r")) == NULL)
//	return(3);
#endif

#ifdef VMS
sprintf(command,"dir/nohead/notrail/output:%s %s*.t",
		tmpFileName,gpath);
system(command);
if((fp = fopen(tmpFileName, "r")) == NULL)
	return(2);
#endif

#ifdef DOS
#if 00000
strcpy(tmpFileName,"zz6543");
sprintf(command,"dir /b  %s*.t > %s",
		gpath,tmpFileName);
printf("COMMAND=%s\n",command);
system(command);
if((fp = fopen(tmpFileName, "r")) == NULL)
	return(2);
#endif
#endif

while(fgets(filename, MAX_LINE, fp) != NULL) {
	strcpy(filename,file_root(filename));

#ifdef VMS
	ToLowerCase(filename);
#endif

	if(mtable_index(filename,GALAXY) >=  0)
		continue;

	/* create the model table entry */
	strcpy(model[model_count].name, filename);
	ToUpperCase(filename);
	strncpy(model[model_count].ident, filename, MAX_IDENT_LEN);
	model[model_count].ident[MAX_IDENT_LEN] = '\0';
	model[model_count].param_model_flag = 0;
	model[model_count].mtype = GALAXY;
	model_count++;
	if(model_count >= MAX_MODELS)
		break;
}

fclose(fp);

#ifdef UNIX
sprintf(command,"/bin/rm %s",tmpFileName);
system(command);
#endif
#ifdef VMS
sprintf(command,"delete %s;*",tmpFileName);
system(command);
#endif

#ifdef DOS
sprintf(command,"erase %s",tmpFileName);
system(command);
#endif


return(0);

}

#else
/*
 * EMBEDDED_ECOS Version
 */
galaxy_define(index)
	int index;	/* new gal_path */
{

	int err;
	char *gpath;
	char command[MAX_LINE];
	char filename[MAX_LINE];
	char *tmpFileName;
        int ptr=0;
        char *buffer;
        int bufferLength;

if(model_count >= MAXMODELS)
	return(1);
if((gpath = gal_paths[index]) == NULL)
	return(2);
buffer=(char*)calloc( MAX_FILE_SIZE_GALAXY_LIST,sizeof(char));
if(!buffer) {
    printf("galaxy_define could not allocate space for buffer to read in file\n");
    return(0);

}

if(KrnGetFileContent(GALAXY_LIST_FILE_NAME, buffer, MAX_FILE_SIZE_GALAXY_LIST)<0){
    printf("Could not get list of galaxies.\n");
    strcpy(buffer,"testsine.t\ntest.t\nuntitles.t\n");

    // return(0);
}
bufferLength=strlen(buffer);
ptr=0;
while(KrnGetLine(filename, MAX_LINE, buffer, &ptr,bufferLength) != NULL) {
	strcpy(filename,file_root(filename));


	if(mtable_index(filename,GALAXY) >=  0)
		continue;

	/* create the model table entry */
	strcpy(model[model_count].name, filename);
	ToUpperCase(filename);
	strncpy(model[model_count].ident, filename, MAX_IDENT_LEN);
	model[model_count].ident[MAX_IDENT_LEN] = '\0';
	model[model_count].param_model_flag = 0;
	model[model_count].mtype = GALAXY;
	model_count++;
	if(model_count >= MAXMODELS)
		break;
}
free(buffer);

return(0);

}



#endif


/*********************************************************************

			strdex()

**********************************************************************
This subroutine will return an integer representing the index of the
first occurence of a character within a string.
A (-1) is returned if the character is not found.
*/
int strdex(char *string,char match)


{
	int i,limit;

limit = strlen(string);

for (i=0; i<limit; i++)
	if(string[i] == match)
		return(i);

return(-1);

}


/****************************************************************/
void ToLowerCase(char *string)

{
	char *c;
	int offset = 'A' - 'a';

c = string;
while(*c) {
	if(*c >= 'A' && *c <= 'Z')
		*c -= offset;
	c++;
}

}


/****************************************************************/
void ToUpperCase(char *string)

{
	char *c;
	int offset = 'A' - 'a';

c = string;
while(*c) {
	if(*c >= 'a' && *c <= 'z')
		*c += offset;
	c++;
}

}




/**********************************************************************

			CsFileReader()

***********************************************************************
Function reads commandS from a file.
*/

int CsFileReader(char *filename)


{
int err;
int line_no = 0;
FILE *fp;
char line[MAX_LINE];
char string[MAX_LINE];
if((fp = fopen(filename,"r")) == NULL)
	return(27);


/* read each file line and interpret */
while(fgets(line,MAX_LINE,fp) != NULL) {
line_no++;
if((err = string_com(line)) != 0) {
	sprintf(string,"File '%s' (line %d): \"%s\"",
			filename, line_no, line);
	ErrorPrint(string, err);
	fclose(fp);
	return(2);
}
}
fclose(fp);
return(0);

}

