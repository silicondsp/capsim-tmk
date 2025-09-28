

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



/* star.c */
/*******************************************************************

		STAR AND GALAXY CREATION

********************************************************************
*/

#include "capsim.h"

void SetStarOut(star_Pt  pstar,int output_no,POINTER  pbuffer);
void SetStarIn(star_Pt pstar,int input_no,POINTER pbuffer,POINTER signal_name);
star_Pt CreateStar();


/* prinfo.c */
extern void ErrorAlloc();

/* parameter.c */
extern int KrnVerifyParams();

/* block.c */
extern block_Pt CreateBlock();
extern block_Pt FindBlock();
extern int BufferLength();

/* file.c */
extern char *file_root();
extern int StripSuffix();


extern block_Pt pb_error;
extern block_Pt pb_current;
extern block_Pt pg_current;
extern int model_count;
extern int line_mode;
extern int graphics_mode;


/**********************************************************************

			line_star()

***********************************************************************
Function reads input line and creates a STAR instance.
*/

LineStar(line)
	char *line;
{
	char starname[NAME_LENGTH];
	char modelname[NAME_LENGTH];
	char string[MAX_LINE];
	char suffix;
	int i, index;
	int args;
	int error;
	int custom_flag = 0;
	block_Pt pblock;

/* read input line */
args = sscanf(line,"block%s%s",starname,modelname);
if(args < 1)
	return(100);

if(args == 1)
	strcpy(modelname,starname);

if(StripSuffix(modelname)) {
	suffix = modelname[strlen(modelname)+1];
	custom_flag = 1;
#ifdef VMS
	/* no dynamic load (custom stars) for VMS */
	return(104);
#endif
}

if(args == 1) {
	/* autocreate instance name from model name */
	for(i=0; ; i++) {
		sprintf(starname,"%s%d", modelname,i);
		if(FindBlock(pg_current, starname) == NULL)
			break;
	}
}
else {
	/* test for reserved names */
	if(strcmp(starname,"input") == 0
 	 || strcmp(starname,"output") == 0)
		return(103);

	/* make sure instance name is not already used */
	if(FindBlock(pg_current, starname) != NULL)
		return(101);


}

strcpy(modelname, file_root(modelname));
/* test for reserved names */
if(strcmp(modelname,"input") == 0
 || strcmp(modelname,"output") == 0)
	return(103);

/* TEMPORARY: Convert certain old names into new names */
if(strcmp(modelname,"fork") == 0) strcpy(modelname,"node");
if(strcmp(modelname,"printfile") == 0) strcpy(modelname,"prfile");

/* verify that star model is in model table */
if(!custom_flag) {
	/* all library stars should be in table */
	if((index = mtable_index(modelname, LIBRARY)) < 0) {
#ifndef GRAPHICS
		return(104);
#else
		if(line_mode)
			return(104);
		/*
		 * If loading graphics file, substitute
		 * "null" star for unrecognized stars
		 */
		sprintf(string,
"Warning: unknown block '%s' replaced with 'null' in hblock %s\n",
			modelname,NameTree(pg_current));
		ErrorPrint(string,104);
		strcpy(modelname,"null");
		if((index = mtable_index(modelname, LIBRARY)) < 0)
			return(104);
#endif
	}
}
else {
#if 0
	if((index = mtable_index(modelname, CUSTOM)) < 0) {
		strcat(modelname, ".");
		strcat(modelname, suffix);
		/* try to dynamically load object code */
		if(error = new_star(modelname))
			return(error);

		index = model_count-1;
	}
#endif
#ifdef VMS
	return(104);
#endif
}

/* create the new block */
pblock = CreateBlock(pg_current);
pb_current = pb_error = pblock;

strcpy(pblock->name, starname);
pblock->model_index = index;
pblock->type = STYPE;
pblock->function = model[index].function;
if(line_mode || graphics_mode || args == 1)
	pblock->change_flag = 1;

/* create the star (buffer connector) */
pblock->star_P = CreateStar();




/* load in parameter model, if necessary */
if(model[index].param_model_flag != 1) {

	/* Call star function to initialize parameters */
	(*(pblock->function)) (PARAM_INIT,pblock);
	if(model[index].param_model_flag != 1)
		return(102);
}


/* load in input buffers model, if necessary */
{

        /* Call star function to initialize input buffers */
        (*(pblock->function)) (INPUT_BUFFER_INIT,pblock);

}

/* load in input buffers model, if necessary */
{

        /* Call star function to initialize input buffers */
        (*(pblock->function)) (OUTPUT_BUFFER_INIT,pblock);

}



/* load paramstack into block */
KrnStoreStack(pblock);

/* Parameter Checking */
if(error = KrnVerifyParams(pblock))
	return(error);

return(0);

}


/*********************************************************************

			line_galaxy()

**********************************************************************
Creates a GALAXY instance.
*/

LineGalaxy(line)
	char *line;
{
	char galaxy_name[NAME_LENGTH];
	char modelname[NAME_LENGTH];
	char string[MAX_LINE];
	int args, np;
	int error, save_mode;
	int i, index;
	block_Pt pblock;
	param_Pt pparam;

/* scan the line, inputting the galaxy name */
args = sscanf(line,"hblock%s%s",galaxy_name,modelname);
if(args < 1)
	return(110);

if(args == 1) {
	strcpy(modelname, file_root(galaxy_name));
	/* autocreate instance name from model name */
	for(i=0; ; i++) {
		sprintf(galaxy_name,"%s%d", modelname,i);
		if(FindBlock(pg_current, galaxy_name) == NULL)
			break;
	}
}
else {
	strcpy(modelname, file_root(modelname));
	if(strcmp(galaxy_name,"input") == 0
	  || strcmp(galaxy_name,"output") == 0)
		return(113);

	/* make sure galaxy name is not already used */
	if(FindBlock(pg_current, galaxy_name) != NULL)
		return(111);
}

/* all galaxies should be in model table */
if((index = mtable_index(modelname, GALAXY)) < 0)
	return(114);

/* create the galaxy block */
pb_error = pblock = CreateBlock(pg_current);

pblock->model_index = index;
pblock->type = GTYPE;
strcpy(pblock->name, galaxy_name);
if(line_mode || graphics_mode || args == 1)
	pblock->change_flag = 1;


/* prepare for galaxy load */
KrnStoreStack(pblock);
pg_current = pblock;
save_mode = line_mode;
line_mode = 0;

/* read topo file for galaxy definition */
error = LineLoad("load");

/* restore previous state */
pg_current = pblock->pparent;
pb_current = pblock;
line_mode = save_mode;

return(error);

}


/**********************************************************************

			LineReplace()

***********************************************************************
Function replaces the current block function with a new model.
All connections are left in place.  Parameters are rechecked.
*/

LineReplace(line)
	char *line;
{
	char blkname[NAME_LENGTH];
	char modelname[NAME_LENGTH];
	int i, index;
	int args;
	int save_mode, error;
	block_Pt pblock;
	star_Pt create_star();

/* read input line */
args = sscanf(line,"replace%s%s",blkname,modelname);
if(args < 1)
	return(120);

if(args == 1) {
	strcpy(modelname,file_root(blkname));
	/* autocreate instance name from model name */
	for(i=0; ; i++) {
		sprintf(blkname,"%s%d", modelname,i);
		if(FindBlock(pg_current, blkname) == NULL)
			break;
	}
}
else {
	strcpy(modelname, file_root(modelname));
	if(strcmp(blkname,"input") == 0
	 || strcmp(blkname,"output") == 0)
		return(123);

	/* make sure instance name is not already used */
	if(FindBlock(pg_current, blkname) != NULL)
		return(121);
}

/* verify that new block model is in model table */
pblock = pb_current;
if((index = mtable_index(modelname, LIBRARY)) >= 0) {
	strcpy(pblock->name, blkname);
	pblock->model_index = index;
	pblock->change_flag = 1;
	if(pblock->type = GTYPE)
		pblock->star_P = CreateStar();
	pblock->type = STYPE;
	pblock->function = model[index].function;
	if(model[index].param_model_flag != 1)
		(*(pblock->function)) (PARAM_INIT,pblock);

	for(i=0; i< MAX_PARAM; i++)
		KrnFreeParam(&pblock->param_AP[i]);
	return(KrnVerifyParams(pblock));
}
else if((index = mtable_index(modelname, GALAXY)) >= 0) {
	strcpy(pblock->name, blkname);
	pblock->model_index = index;
	pblock->change_flag = 1;
	pblock->type = GTYPE;

	/* prepare for galaxy load */
	for(i=0; i< MAX_PARAM; i++)
		KrnFreeParam(&pblock->param_AP[i]);
	pg_current = pblock;
	save_mode = line_mode;
	line_mode = 0;
	error = LineLoad("load");
	pg_current = pblock->pparent;
	pb_current = pblock;
	line_mode = save_mode;
	return(error);
}
else
	return(124);

}


/****************************************************************

			CreateStar()

*****************************************************************
Function allocates and initializes the storage for a STAR
	data structure
*/

star_Pt CreateStar()

{
	star_Pt pstar;

/* First, allocate the storage for the star data structure */
pstar = (star_Pt) calloc(1,sizeof(star_t));
if(!pstar) ErrorAlloc("Star Data Structure in create_star");



/* Initialize the star data structure */
pstar->numberInBuffers = 0;
pstar->numberOutBuffers = 0;

/* Indicate that st.var. storage has not yet been allocated */
pstar->state_P = NULL;



return(pstar);

}


/***************************************************************

			set_star_in()

****************************************************************
Function creates connection from star to a single input buffer.
*/

void SetStarIn(star_Pt pstar,int input_no,POINTER pbuffer,POINTER signal_name)


{

pstar->inBuffer_P[input_no] = pbuffer;
pstar->signalName[input_no] = signal_name;
(pstar->numberInBuffers)++;

return;

}

/******************************************************************

			SetStarOut()

*******************************************************************
Function creates connection between star and a single output buffer.
*/

void SetStarOut(star_Pt  pstar,int output_no,POINTER  pbuffer)


{

pstar->outBuffer_P[output_no] = pbuffer;
(pstar->numberOutBuffers)++;

return;

}


/*********************************************************************

			MinimumSamples()

***********************************************************************

Function returns the minimum number of available samples in all input
buffers of a STAR
*/

MinimumSamples(star_Pt pstar)


{
	int no_buffers, i;
	int min, len;

/* if there are no input buffers return zero */
if((no_buffers = pstar->numberInBuffers) == 0)
	 return(0);

min = BufferLength(pstar->inBuffer_P[0]);

for(i=1; i<no_buffers; i++) {
	if(min > (len = BufferLength(pstar->inBuffer_P[i])))
		min = len;
}

return(min);

}

