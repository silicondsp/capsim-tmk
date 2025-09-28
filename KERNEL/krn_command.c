
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


/* command.c */
/**********************************************************************

		LINE COMMAND INTERPRETER

***********************************************************************
*/
#include "capsim.h"

/**********************************************************************

		External Function Declarations

***********************************************************************
*/

static alias_look(char *word);


/* parameter.c */
extern KrnStoreStack();
extern LineParam();
extern LineChp();
extern LineArg();

/* connect.c */
extern LineConnect();
extern LineDisConnect();
extern LineName();
extern LineInsert();



/* star.c */
extern LineStar();
extern LineGalaxy();
extern LineReplace();

/* file.c */
extern LineLoad();
extern LineStore();
extern char *file_root();

/* block.c */
extern RemoveChildren();
extern RemoveBlock();
extern DeleteBlock();
extern BlockRename();

/* run.c */
extern LineRun();
#ifndef EMBEDDED_ECOS
FILE *krn_bufferGrowth_F;
#endif



#ifdef GRAPHICS
extern int cs_connOption;
extern int cs_showBuffer;
extern int cs_snapFlag;
extern int cs_nameFlag;
extern int cs_fastconnect;
extern int cs_hidePacer;
extern int cs_modal;
extern int cs_arrow;


#endif

/* prinfo.c */
extern prinfo();
extern PrInfoAll();
extern PrInfoBlock();
extern PrInfoBlockCurrent();
extern PrInfoParams();



extern int cs_xWindow;
extern int line_mode;


/**********************************************************************

		Global declarations

***********************************************************************
*/

extern int model_count;
extern int line_mode;
extern block_Pt pg_current;
extern block_Pt pb_current;
extern block_Pt pb_error;
extern param_Pt param_stack[];	/* from parameter.c */

extern char *star_paths[];	/* star file paths */
extern char *gal_paths[];	/* galaxy file paths */
extern char *doc_paths[];	/* documentation file paths */
static  char *alias_short[100], *alias_long[100];	/* the alias lists */


#ifdef  GRAPHICS
extern char *pic_paths[];       /* graphics file paths */
#endif


#define MAX_HIST	10
static char comm_history[MAX_HIST][MAX_LINE];		/* command history */
int history_count = 0;

extern	L_alias(), L_unalias(), L_path(), L_sh(),
	L_exit(), L_quit(), L_run(),
	L_star(), L_galaxy(), L_replace(), L_delete(), L_insert(),
	L_connect(), L_disconnect(), L_name(),
	L_load(), L_store(), L_remove(), L_new(),
	L_param(), L_chp(), L_arg(),
	L_up(), L_down(), L_back(), L_forward(), L_to(),
	L_info(), L_display(), L_man(),L_fcommand(),L_rename(),L_inform(),
	L_makecontig(),L_graphic(),L_setMaxSeg(),L_setCellInc(),L_state(),L_paramName()
	;

static char *L_char_arr[] = {
	/* This array MUST be in alphabetical order */
	"<","alias","arg","back","block","chp","connect","delete",
	"disconnect","display","down","exit","forward",
	"graphic","hblock","info","inform","insert","load",
	"makecontig","man","name",
	"new","param","path","quit","remove","rename","replace",
	"run","setcellinc","setmaxseg","sh","state","store",
	"to","unalias","up","parambyname",
	""	/* final NULL needed! */
	};

static PFI L_comm_arr[] = {
	/* This array MUST match the previous array ordering */
	L_fcommand,L_alias, L_arg, L_back, L_star,L_chp, L_connect,
	L_delete,
	L_disconnect, L_display, L_down, L_exit, L_forward,
	L_graphic,L_galaxy,L_info, L_inform,L_insert, L_load,
	L_makecontig,L_man, L_name,
	L_new, L_param, L_path, L_quit, L_remove,L_rename,
	L_replace, L_run, L_setCellInc,L_setMaxSeg,L_sh, L_state,L_store,
	L_to, L_unalias, L_up,L_paramName
	};


/**********************************************************************

			L_comm_lookup()

***********************************************************************
This function searches the command table to find the string.
If it is not found, -1 is returned.
*/

L_comm_lookup(string)
	char *string;
{
	int index;

for (index = 0; *L_char_arr[index] != '\0'; index++) {
	if (strcmp(L_char_arr[index], string) == 0)
		return(index);
	if (*L_char_arr[index] > *string)
		return(-1);
}
return(-1);

}


/**********************************************************************

			string_com()

***********************************************************************
This command executes the command represented by specified string.
The FIRST word is checked for an alias and expanded if necessary.
*/

string_com(string)
	char *string;
{
	int i, index;
	char *t;
	char command[MAX_LINE], word[MAX_LINE];

//printf("DEBUG: STRING COMM->%s<-\n",string);

while(*string == ' ' || *string == '\t')
	string++;
if(*string == '\0' || *string == '\n')
	/* a blank line */
	return(0);
else if(*string == '#')
	/* a comment line */
	return(0);

/* Remove any linefeed */
if(*(string+strlen(string)-1) == '\n')
	*(string+strlen(string)-1) = '\0';

if(*string == '!') {
	/* history reference (only used in line mode) */
	if(!line_mode)
		return(0);
	string++;
	if(*string == '\0')
		return(3);
	else if(*string == '!')
		index = MAX_HIST-1;
	else if(sscanf(string,"%d", &index) == 1)
		index -= history_count - MAX_HIST;
	else {
		for(index=MAX_HIST-1; index>=0; index--) {
			if(strncmp(string,comm_history[index],
					strlen(string)) == 0)
				break;
		}
	}

	if(index >= MAX_HIST || index < 0)
		return(3);
	if(comm_history[index][0] == '\0')
		return(3);
	strcpy(string,comm_history[index]);

	/* Echo old command to user */
	sprintf(command,"%12s%s\n","",string);
	prinfo(stdout,command);
}

/* Update command history file */
if(line_mode) {
	for(i=0; i<MAX_HIST-1; i++)
		strcpy(comm_history[i], comm_history[i+1]);
	strcpy(comm_history[MAX_HIST-1], string);
	history_count++;
}

/* move pointer to end of the first command word */
strcpy(command,string);
sscanf(string,"%s",word);
string += strlen(word);

/* if aliased first word, overwrite */
if((index = alias_look(word)) >= 0 ) {
	sprintf(command, "%s%s", alias_long[index], string);
	sscanf(command,"%s",word);
}

/* verify the main command word, then execute command */
//printf("DEBUG word->%s-<   command->%s-< \n",word,command);
if((index = L_comm_lookup(word)) == -1)
	return(2);

//printf("DEBUG INDEX=%d \n",index);
return( (*(L_comm_arr[index]))(command) );

}


/**********************************************************************

			alias_look()

***********************************************************************
This routine looks for an alias on the alias lists.
It starts from the most recent alias.
*/

static alias_look(char *word)
{
	int i = 0;

while(alias_short[i] != NULL) {

	/* if we can find the entry, return its index */
	if (strcmp(word, alias_short[i]) == 0)
		return(i);
	i++;
}

return(-1);

}


/**********************************************************************

			L_quit(), L_exit()

***********************************************************************
'quit' looks for changes in the topology, and seeks user approval.
'exit' leaves unconditionally.
*/

L_quit()
{
	block_Pt pgalaxy, ptemp;

pgalaxy = pg_current;
while((ptemp = pgalaxy->pparent) != NULL)
	pgalaxy = ptemp;
if(!ApproveChanges(pgalaxy,line_mode))
	return(0);

exit(0);
}

L_exit()
{
	exit(0);
}


/**********************************************************************

			L_run()

***********************************************************************
This command runs a simulation.
*/
L_run()
{
int	status;
/*
 * Open file to write buffer growth info.
 * This file is used by the buffer write increment routine (it_out())
 */
#ifndef EMBEDDED_ECOS
krn_bufferGrowth_F = fopen("buffer.dat","w");
#endif
status = LineRun();
#ifndef EMBEDDED_ECOS
if(krn_bufferGrowth_F) fclose(krn_bufferGrowth_F);
#endif
return(status);
}


/**********************************************************************

			L_param()

***********************************************************************
Set the parameters of the param stack.
*/
L_param(line)
	char *line;
{
return(LineParam(line));
}


/**********************************************************************

			L_param()

***********************************************************************
Set the parameters of the param stack.
*/
L_paramName(line)
	char *line;
{
return(LineParamName(line));
}
/**********************************************************************

			L_chp()

***********************************************************************
Change the parameters of the current block.
*/
L_chp(param)
	char *param;
{
return(LineChp(param));
}


/**********************************************************************

			L_arg()

***********************************************************************
Enter a parameter spec for the current galaxy model.
*/

L_arg(line)
	char *line;
{
return(LineArg(line));
}


/**********************************************************************

			L_load()

***********************************************************************
This functions loads a topology file into the current galaxy
*/
L_load(line)
	char *line;
{

	return(LineLoad(line));


}

/**********************************************************************

			L_fcommand()

***********************************************************************
This functions reads capsim commands from a file
*/
L_fcommand(line)
	char *line;
{
char filename[100];
sscanf(line,"%*s %s",filename);
return(CsFileReader(filename));
}

/**********************************************************************

			L_setMaxSeg()

***********************************************************************
This functions sets the maximum segments
*/
L_setMaxSeg(line)
	char *line;
{
sscanf(line,"%*s %d",&krn_maxMemSegments);
if(krn_maxMemSegments <= 0) krn_maxMemSegments=1;
fprintf(stderr,"The maximum number of segments are now %d\n",krn_maxMemSegments);
}
/**********************************************************************

			L_setCellInc()

***********************************************************************
This functions sets the maximum segments
*/
L_setCellInc(line)
	char *line;
{
sscanf(line,"%*s %d",&krn_numberSamples);
if(krn_numberSamples <= 0) krn_numberSamples=1;
fprintf(stderr,"The cell increment is now  %d\n",krn_numberSamples);
}

/**********************************************************************

			L_store()

***********************************************************************
Writes the current galaxy topology to a topology file.
Use either model table file, or user entered file name.
*/
L_store(line)
	char *line;
{
return(LineStore(line));
}


/**********************************************************************

			L_remove()

***********************************************************************
Remove the current block from the universe.
*/
L_remove()
{

if(pb_current == NULL)
	/* galaxy is empty */
	return(0);

pb_current = pb_current->pfsibling;
pb_current->change_flag = 1;
RemoveBlock(pb_current->pbsibling);

if(pg_current->pchild == NULL)
	pb_current = NULL;
pb_error = pb_current;

if(line_mode)
	PrInfoBlockCurrent();

return(0);

}


/**********************************************************************

			L_delete()

***********************************************************************
Remove the current block, but repair any connections.
*/
L_delete()
{

if(pb_current == NULL)
	/* galaxy is empty */
	return(0);

pb_current = pb_current->pfsibling;
pb_current->change_flag = 1;
DeleteBlock(pb_current->pbsibling);

if(pg_current->pchild == NULL)
	pb_current = NULL;
pb_error = pb_current;

if(line_mode)
	PrInfoBlockCurrent();

return(0);

}


/**********************************************************************

			L_new()

***********************************************************************
Clear out the current galaxy (remove all its children)
*/
L_new()
{
	int i;

if(!ApproveChanges(pg_current,line_mode))
	return(0);

/* this is needed to clear args */
KrnStoreStack(NULL);
for(i=0; i< MAX_PARAM; i++)
	KrnFreeParam(&model[pg_current->model_index].param_AP[i]);
RemoveChildren(pg_current);
pb_current = NULL;
/*
 * allocate space for universe/galaxy information
 */
if (pg_current->info_P == NULL) {
        pg_current->info_P = (info_Pt) calloc ( 1,sizeof( info_t) ) ;


        strcpy(pg_current->info_P->title,"");
        strcpy(pg_current->info_P->author,"");
        strcpy(pg_current->info_P->date,"");
        strcpy(pg_current->info_P->descrip,"");



        if(pg_current->info_P == NULL) {
        	fprintf(stderr,"Could not allocate space for information\n");
        	pg_current->info_P=NULL;
        	return(1);
	}
}

LineStore("store untitled");

return(0);

}


/**********************************************************************

			L_down()

***********************************************************************
Move down one level.
*/

L_down()
{

if(pb_current == NULL) {
	if(line_mode)
		PrInfoBlockCurrent();
	return(0);
}

if(pb_current->type != GTYPE)
	return(5);

pg_current = pb_current;
pb_current = pg_current->pchild;

if(line_mode) {
	PrInfoAll(stdout, pg_current);
	PrInfoBlockCurrent();
}

return(0);

}


/**********************************************************************

			L_up()

***********************************************************************
Move up one level.
*/

L_up()
{

if(pg_current->type == UTYPE)
	return(4);

pb_current = pg_current;
pg_current = pg_current->pparent;

if(line_mode) {
	PrInfoAll(stdout, pg_current);
	PrInfoBlockCurrent();
}

return(0);
}


/********************************************************************

			L_to()

*********************************************************************
Changes the current block to one whose name matches an input pattern.
Within a galaxy, search is in the 'forward' direction.
If there is no match, the current block is unchanged.	int rand, error;
	int range = 0;

The comparison is only on the input string so partial names
are sufficient!  Several special symbols are recognized:
	1) '*' means 'go to top level'
	2) '.' means 'go up one level', if possible.
	3) '/' means 'go down one level', if possible.
These symbols can be combined with normal text matching patterns.
For such compound patterns, interpretation is implemented until a
conflict or non-match occurs.
*/

L_to(line)
	char *line;
{
	block_Pt psave;
	char string[MAX_LINE];
	char name[NAME_LENGTH];
	char *t;
	int nlen, index;
	int match_flag = 0;

/* any string available? */
if(sscanf(line, "to%s", string) != 1) {
	if(line_mode)
		PrInfoBlockCurrent();
	return(0);
}

t = string;
while(*t) {
	if(*t == '*') {
		/* Go to top level */
		while(pg_current->pparent != NULL) {
			pb_current = pg_current;
			pg_current = pb_current->pparent;
		}
		t++;
		continue;
	}
	else if(*t == '.') {
		/* Go up one level, if possible */
		if(pg_current->pparent == NULL)
			break;
		pb_current = pg_current;
		pg_current = pb_current->pparent;
		t++;
		continue;
	}
	else if(*t == '/') {
		/* Go down one level, if possible */
		if(pb_current == NULL)
			break;
		if(pb_current->type != GTYPE)
			break;
		pg_current = pb_current;
		pb_current = pg_current->pchild;
		t++;
		continue;
	}
	else if(pb_current == NULL)
		break;

	strcpy(name, t);
	if((index = strdex(name,'*')) > 0)
		name[index] = '\0';
	if((index = strdex(name,'.')) > 0)
		name[index] = '\0';
	if((index = strdex(name,'/')) > 0)
		name[index] = '\0';
	nlen = strlen(name);
	t += nlen;

	psave = pb_current;
	/* search current galaxy for target name */
	do {
		pb_current = pb_current->pfsibling;
		if(strncmp(name,pb_current->name,nlen) == 0) {
			match_flag = 1;
			break;
		}
	} while(pb_current != psave);
	if(!match_flag)
		break;
	match_flag = 0;
}
if(line_mode)
	PrInfoBlockCurrent();

return(0);

}


/**********************************************************************

			L_forward()

***********************************************************************
This routine moves the selected block forward one.
*/

L_forward()
{

if(pb_current == NULL)
	return(0);

pb_current = pb_current->pfsibling;
if(line_mode)
	PrInfoBlockCurrent();

return(0);
}


/**********************************************************************

			L_back()

***********************************************************************
This routine moves the selected block back one.
*/

L_back()
{

if(pb_current == NULL)
	return(0);

pb_current = pb_current->pbsibling;
if(line_mode)
	PrInfoBlockCurrent();

return(0);
}


/**********************************************************************

			L_star()

***********************************************************************
Create a new star in the current galaxy.
*/

L_star(line)
	char *line;
{
return(LineStar(line));
}


/**********************************************************************

			L_galaxy()

***********************************************************************
Create a new galaxy at the current galaxy.
*/

L_galaxy(line)
	char *line;
{
return(LineGalaxy(line));
}


/**********************************************************************

			L_replace()

***********************************************************************
Directly replace current block with new model.
Maintain all connections, parameters, etc.
*/

L_replace(line)
	char *line;
{
return(LineReplace(line));
}


/**********************************************************************

			L_insert()

***********************************************************************
Insert current block before or after a specified block.
*/

L_insert(line)
	char *line;
{
return(LineInsert(line));
}


/**********************************************************************

			L_connect(), L_disconnect()

***********************************************************************
Connect or disconnect two blocks.
*/
L_connect(line)
	char *line;
{
return(LineConnect(line));
}

L_disconnect(line)
	char *line;
{
return(LineDisConnect(line));
}


/**********************************************************************

			L_name()

***********************************************************************
Name (or re-name) the connection signal between two blocks.
*/

L_name(line)
	char *line;
{
return(LineName(line));
}





/**********************************************************************

			L_rename()

***********************************************************************
Name (or re-name) the block.
*/

L_rename(line)
	char *line;
{
char blkName[NAME_LENGTH];
int args;
int status;
args=sscanf(line,"rename%s",blkName);
status=BlockRename(pg_current,pb_current,blkName);
fprintf(stderr,"Rename Status=%d current name=%s rename=%s\n",status,pb_current->name,blkName);
if(status)return(180);
return(status);
}



/**********************************************************************

			L_info()

***********************************************************************
This routine prints info about the selected block.
It is the same as 'display' with no arguments.
*/

L_info()
{
	if(!line_mode) {
		PrInfoBlock(NULL, pb_current);
	}
	else
		PrInfoBlock(stdout, pb_current);


return(0);

}


/**********************************************************************

			L_display()

***********************************************************************
This routine displays information about the current block,
or other options.
*/

L_display(line)
	char *line;
{
	char string[MAX_LINE];
	int i, offset;

if (sscanf(line, "display%s", string) < 1)  {
	/* no arguments -- display current block info */
	if(!line_mode) {
		PrInfoBlock(NULL, pb_current);
	}
	else
		PrInfoBlock(stdout, pb_current);
	return(0);
}

/* there is an argument */
if(string[0] == 'a')  {
	/* display all */
	if(!line_mode) {
		PrInfoAll(NULL, pg_current);
	}
	else {
	   PrInfoAll(stdout, pg_current);
	   PrInfoBlockCurrent();
	}
}

else if(strcmp(string,"on") == 0);	/* ignore */
else if(strcmp(string,"off") == 0);	/* ignore */

else if(string[0] == 'p') {
	/* display the parameter stack */
	PrInfoParams(stdout, param_stack);
}
else if(string[0] == 'h') {
	/* print command history */
	offset = history_count - MAX_HIST;
	for(i=0; i<MAX_HIST; i++) {
		if(i+offset < 0)
			continue;
		sprintf(string,"\t[%d] %s\n",i+offset,comm_history[i]);
		prinfo(stdout,string);
	}
}
else if(string[0] == 's') {
	/* display all stars */
	if(!line_mode) {
		PrInfoList(NULL, LIBRARY);
	}
	else
		PrInfoList(stdout, LIBRARY);
#ifdef UNIX
	PrInfoList(stdout, CUSTOM);
#endif

#ifdef DOS
	PrInfoList(stdout, CUSTOM);
#endif
}
else if(string[0] == 'g') {
	/* print all galaxies */
	if(!line_mode) {
		PrInfoList(NULL, GALAXY);
	}
	else
		PrInfoList(stdout, GALAXY);
}
else
	return(11);	/* unknown option */

return(0);

}


/**********************************************************************

			L_man()

***********************************************************************
Lets user review .s, .c, or .t files for either:
	1) current block (if no argument)
		star_path/name.s or gal_path/file.t
	2) named file (as argument)
		a) file.s => star_path/file.s ?
		b) file.c => star_path/file.c ?
		c) file.t => gal_path/file.t ?
		d) file.x or file =>  star_path/file.s ?

If the files cannot be located, an error message is printed.
*/

L_man(line)
	char *line;
{
	char string[MAX_LINE], result[MAX_LINE], command[MAX_LINE];
	int slen, index;
	char suffix;
	int suffix_flag = 0;

if(sscanf(line,"man%s", string) == 1) {
	/* there is an argument */
	if(StripSuffix(string)) {
		suffix = string[strlen(string)+1];
		suffix_flag = 1;
	}
	strcpy(string, file_root(string));
	if(suffix_flag) {
		/* path checking required */
		if(suffix == 't') {
			/* galaxy file */
			strcat(string,".t");
			file_path(result,string,4,gal_paths);
		}
		else if(suffix == 'c') {
			/* star .c file */
			strcat(string,".c");
			file_path(result,string,4,star_paths);
		}
		else {
			/* all others converted to .s */
			strcat(string,".s");
			file_path(result,string,4,star_paths);
		}
	}
	else {
		/* help request...check documentation path */
		strcat(string,".doc");
		file_path(result,string,4,doc_paths);
	}
}
else {	/* no filename specified...use current block or galaxy */
	if(pb_current != NULL)
		index = pb_current->model_index;
	else
		index = pg_current->model_index;

	if(model[index].mtype == GALAXY) {
		strcpy(string,model[index].name);
		strcat(string, ".t");
		file_path(result,string,4,gal_paths);
	}
	else {
		strcpy(string,model[index].name);
		strcat(string, ".s");
		file_path(result,string,4,star_paths);
	}
}

if(result[0] == '\0') {
	sprintf(result,"filename = %s\n",string);
	prinfo(stdout,result);
	return(14);
}

/* ready to go */
sprintf(string,"filename = %s\n",result);
prinfo(stdout,string);

if(!line_mode) {
#ifdef GRAPHICS
 IIP_ShowFile(result);

#endif
}
else {
#ifdef UNIX
sprintf(command,"more -d %s", result);
#endif
#ifdef VMS
sprintf(command,"type/page %s", result);
#endif
#ifdef DOS
//sprintf(command,"type /p %s", result);
sprintf(command,"notepad  %s", result);
#endif
fprintf(stderr,"Command:%s\n",command);
system(command);
}
return(0);

}	/* ends L_man */


/**********************************************************************

			L_alias()

***********************************************************************
Adds an alias pair for commands.
Note:	only first word(s) of a command can be aliased.
	only one alias per shortword allowed.
*/

L_alias(line)
	char *line;
{
	char shortcomm[MAX_LINE], scratch[MAX_LINE];
	int count, index, i;

if((count = sscanf(line, "alias%s%s", shortcomm, scratch)) < 1) {
	/* print all aliases */
	for (i=0; i<MAX_ALIAS && alias_short[i] != NULL; i++) {
		sprintf(scratch, "\t%-10s  %s\n",
			alias_short[i], alias_long[i]);
		prinfo(stdout, scratch);
	}
	return(0);
}
if(count < 2)
	/* improper alias form */
	return(17);

/* get the long name */
line += strlen("alias ") + strlen(shortcomm);
while (*line == ' ' || *line == '\t')
	line++;

/* line points to the long command; install it */
if((index = alias_look(shortcomm)) >= 0) {
	/* already in list; overwrite! */
	free(alias_long[index]);
	alias_long[index] = (char *)calloc(1, strlen(line)+1);
	strcpy(alias_long[index], line);
}
else {
	/* add new alias pair, if possible */
	for (i=0; i<MAX_ALIAS && alias_short[i] != NULL; i++)
		;

	if(i >= MAX_ALIAS)
		return(16);

	alias_short[i] = (char *)calloc(1,strlen(shortcomm)+1);
	strcpy(alias_short[i], shortcomm);
	alias_long[i] = (char *)calloc(1, strlen(line)+1);
	strcpy(alias_long[i], line);
	if(i+1 < MAX_ALIAS) {
		alias_short[i+1] = NULL;
		alias_long[i+1] = NULL;
	}
}
return(0);

}

/**********************************************************************

			L_unalias()

***********************************************************************
Remove the alias for the specified command.
*/

L_unalias(line)
	char *line;
{
	char word[MAX_LINE];
	int i, index;

if(sscanf(line, "unalias%s", word) < 1)
	return(0);

if ((index = alias_look(word)) < 0)
	return(19);

/* Remove alias by overwriting */
for(i = index; alias_short[i] != NULL; i++) {
	/* move all aliases up one position */
	alias_short[i] = alias_short[i+1];
	alias_long[i] = alias_long[i+1];
}

return(0);

}


/**********************************************************************

			L_path()

***********************************************************************
This routine adds a path to various path lists.
If no new path is provided, the present paths are displayed.
*/

L_path(line)
	char *line;
{
	char type[MAX_LINE], pathname[MAX_LINE];
	char string[MAX_LINE];
	char *pn;
	int i;
	int narg;

if((narg = sscanf(line, "path%s%s", type, pathname)) < 1)
	return(20);

if(type[0] == 's') {
	strcpy(string," Star Paths: ");
	for(i=0; i<MAX_PATHS && (pn = star_paths[i]) != NULL; i++) {
		strcat(string,"  ");
		strcat(string,pn);
	}
	if(narg == 1) {
		strcat(string,"\n");
		prinfo(stdout,string);
	}
	else {
		/* add path to the star list */
		if(i >= MAX_PATHS)
			return(22);
		star_paths[i] = (char*)calloc(1,sizeof(pathname)+1);
		strcpy(star_paths[i], pathname);
		if(i+1 < MAX_PATHS)
			star_paths[i+1] = NULL;
	}
}
else if(type[0] == 'g') {
	strcpy(string," Galaxy Paths: ");
	/* add path to the galaxy list */
	for (i=0; i<MAX_PATHS && (pn = gal_paths[i]) != NULL; i++) {
		strcat(string,"  ");
		strcat(string,pn);
	}
	if(narg == 1) {
		strcat(string,"\n");
		prinfo(stdout,string);
	}
	else {
		if(i >= MAX_PATHS)
			return(22);
		gal_paths[i] = (char *)calloc(1,sizeof(pathname)+1);
		strcpy(gal_paths[i], pathname);
		galaxy_define(i);
		if(i+1 < MAX_PATHS)
			gal_paths[i+1] = NULL;
	}
}
else if(type[0] == 'd') {
	strcpy(string," Documentation Paths: ");
	/* add path to the documentation list */
	for(i=0; i<MAX_PATHS && (pn = doc_paths[i]) != NULL; i++) {
		strcat(string,"  ");
		strcat(string,pn);
	}
	if(narg == 1) {
		strcat(string,"\n");
		prinfo(stdout,string);
	}
	else {
		if(i >= MAX_PATHS)
			return(22);
		doc_paths[i] = (char *)calloc(1,sizeof(pathname)+1);
		strcpy(doc_paths[i], pathname);
		if(i+1 < MAX_PATHS)
			doc_paths[i+1] = NULL;
	}
}
#ifdef GRAPHICS
else if(type[0] == 'p') {
        strcpy(string," PIC Graphics Paths: ");
        /* add path to the PIC Graphics list */
        for (i=0; i<MAX_PATHS && (pn = pic_paths[i]) != NULL; i++) {
                strcat(string,"  ");
                strcat(string,pn);
        }
        if(narg == 1) {
                strcat(string,"\n");
                prinfo(stdout,string);
        }
        else {
                if(i >= MAX_PATHS)
                        return(22);
                pic_paths[i] = (char *)calloc(1,sizeof(pathname)+1);
                strcpy(pic_paths[i], pathname);
                if(i+1 < MAX_PATHS)
                        pic_paths[i+1] = NULL;
        }
}
#endif

else
	return(20);

return(0);
}


/**********************************************************************

			L_sh()

**********************************************************************
Pass a command to the shell.
*/

L_sh(line)
	char *line;
{
	char string[MAX_LINE];

if (sscanf(line, "sh%s", string) < 1)
	return(0);

/* remove leading 'sh' */
line += strlen("sh");

system(line);

/* even if the shell gives an error, this is always correct! */
return(0);
}

/**********************************************************************

			L_inform()

***********************************************************************
Display/Modify information about universe/galaxy
*/

L_inform(line)
	char *line;
{
char infoText[200];
char infoField[40];
int args;
int status;
if(pg_current->info_P == NULL) return(0);
args=sscanf(line,"inform%s %[^\n]",infoField,infoText);
if (strncmp(infoField,"title",3) == 0)
	strcpy(pg_current->info_P->title,infoText);
else if (strncmp(infoField,"author",3) == 0)
	strcpy(pg_current->info_P->author,infoText);
else if (strncmp(infoField,"date",3) == 0)
	strcpy(pg_current->info_P->date,infoText);
else if (strncmp(infoField,"descrip",3) == 0)
	strcpy(pg_current->info_P->descrip,infoText);
else
{
	fprintf(stderr,"---------------------------------------------------\n");
	fprintf(stderr,"Title: %s \n",pg_current->info_P->title);
	fprintf(stderr,"Author: %s \n",pg_current->info_P->author);
	fprintf(stderr,"Date: %s \n",pg_current->info_P->date);
	fprintf(stderr,"Description: %s \n",pg_current->info_P->descrip);
	fprintf(stderr,"---------------------------------------------------\n");
}
return(0);


}


/**********************************************************************

			L_graphic()

***********************************************************************
Display/Modify  graphic options
*/

L_graphic(line)
	char *line;
{
char graphicText[200];
char graphicField[40];
int args;
int status;
#ifdef GRAPHICS
args=sscanf(line,"graphic%s%s",graphicField,graphicText);
if (strncmp(graphicField,"auto",2) == 0) {
        if(strcmp(graphicText,"on") == 0)
                cs_connOption = 1;
        else
                cs_connOption= 2;
}
else if (strncmp(graphicField,"fast",1) == 0) {
        if(strcmp(graphicText,"on") == 0)
                cs_fastconnect = 1;
        else
                cs_fastconnect= 0;
}
else if (strncmp(graphicField,"name",1) == 0) {
        if(strcmp(graphicText,"on") == 0)
                cs_nameFlag = 1;
        else
                cs_nameFlag= 0;
}
else if (strncmp(graphicField,"snap",1) == 0) {
        if(strcmp(graphicText,"on") == 0)
                cs_snapFlag = 1;
        else
                cs_snapFlag= 0;
}
else if (strncmp(graphicField,"pacer",1) == 0) {
        if(strcmp(graphicText,"on") == 0)
                cs_hidePacer = 1;
        else
                cs_hidePacer= 0;
}
else if (strncmp(graphicField,"buffer",1) == 0) {
        if(strcmp(graphicText,"on") == 0)
                cs_showBuffer = 1;
        else
                cs_showBuffer= 0;
}
else if (strncmp(graphicField,"modal",2) == 0) {
        if(strcmp(graphicText,"on") == 0)
                cs_modal = 1;
        else
                cs_modal= 0;
        /*
         * Ignore
         */
        cs_modal=0;
}
else if (strncmp(graphicField,"arrow",2) == 0) {
        if(strcmp(graphicText,"on") == 0)
                cs_arrow = 1;
        else
                cs_arrow= 0;
}
else {
        fprintf(stderr,"Show Buffer: %d\n",cs_showBuffer);
        fprintf(stderr,"Auto Connect: %d\n",cs_connOption);
        fprintf(stderr,"Fast Connect: %d\n",cs_fastconnect);
        fprintf(stderr,"Hide Pacer: %d\n",cs_hidePacer);
        fprintf(stderr,"Snap: %d\n",cs_snapFlag);
        fprintf(stderr,"Show Block Name: %d\n",cs_nameFlag);
        fprintf(stderr,"Modal Mode: %d\n",cs_modal);
        fprintf(stderr,"Arrow Mode: %d\n",cs_arrow);
}
#endif
return(0);


}



/**********************************************************************

			L_makecontig()

***********************************************************************
Make all input and output buffers contiguous
*/
L_makecontig()
{
return(KrnMakeContiguous());
}

/**********************************************************************

			L_state()

***********************************************************************
Make all input and output buffers contiguous
*/
L_state()
{
int	numberBlks;
int	numberGalaxies;
int 	maxBlksPerLevel;
int	depth;

fprintf(stderr,"---------- List of Galaxies ----------------\n");
Krn_GetState(&numberBlks,&numberGalaxies,&maxBlksPerLevel,&depth);
fprintf(stderr,"--------------------------------------------\n");
fprintf(stderr,"Total number of blocks=%d\n",numberBlks);
fprintf(stderr,"Total number of stars=%d\n",numberBlks-numberGalaxies);
fprintf(stderr,"Total number of galaxies  =%d\n",numberGalaxies);
fprintf(stderr,"Max blocks per Level  =%d\n",maxBlksPerLevel);
fprintf(stderr,"Galaxy Depth  =%d\n",depth);

return(0);
}

#ifndef GRAPHICS
/********************************************************************
 *
 *   			     CsCallUp.C
 *
 *   Sends a command to the Capsim line interpreter.
 *
 *********************************************************************
 */
 int CsCallUp(string)

char	string[];

{

	int	err;

if(0)
	CsInfo(string);

if((err = string_com(string)))
    	ErrorPrint(" Capsim line command error", err);

return(err);

}

/*****************************************************************
 *
 *		CsInfo()
 *
 * print a message to info window
 ******************************************************************/

int CsInfo(char *string)
{


printf("%s\n",string);

return(0);

}

#endif

