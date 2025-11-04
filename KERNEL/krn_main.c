
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



/* main.c */
/**********************************************************************

                        Main Program

***********************************************************************
This is the top-level of CAPSIM/BLOSIM.
The program can be configured for either UNIX or VMS by setting a
definition in the include file "krn_capsim.h".
This program is based on an original concept called BLOSIM,
developed at the University of California, Berkeley, 1985.
The primary authors were D.G. Messerschmitt and D.J. Hait.
Since arrival at NCSU in November 1987, the program has been
extensively remodeled, debugged, and improved with many added features
including, but not limited to:
        - program re-organization, saving 20% on executable size.
        - improved scheduling for run-time efficiency
        - improved run-time logic to control buffer size
        - buffer memory de-allocation, for multiple runs
        - internal star and galaxy parameter model storage,
           specification, and definition.
        - on-line parameter prompting, with type/value checking
        - on-line review of commands and star/galaxy source files
        - command history and alias mechanisms
        - compilation control for UNIX or VMS operating systems

These changes and improvements are now considered copyrighted.

Developers: L. J. Faber, S. H. Ardalan
Date: October, 1988

*/

#include <unistd.h>
#include <stdio.h>
#include "capsim.h"



#ifdef TCL_SUPPORT

#include <tcl.h>
int Tcl_AppInit(Tcl_Interp *interp);

#endif









/* system globals */
int     cs_xWindow=1;
int     cs_linepgraph=0;
int graphics_mode = 0;
int line_mode = 1;      /* commands from standard input */

#ifdef UNIX
char *star_paths[MAX_PATHS] = { ".", NULL}; /* .s file locations */
char *gal_paths[MAX_PATHS]  = { ".", NULL}; /* .t files locations */
char *doc_paths[MAX_PATHS]  = {NULL}; /* documentation location */
#endif


#ifdef DOS
char *star_paths[MAX_PATHS] = { ".\\", NULL}; /* .s file locations */
char *gal_paths[MAX_PATHS]  = { ".\\", NULL}; /* .t files locations */
char *doc_paths[MAX_PATHS]  = {NULL}; /* documentation location */
#endif




/*
 * S for equation parsing and evaluation
 * krn_buffer contains the line with an expression on each call to yyparse
 * krn_bufferPtr is an integer pointing to the current character in krn_buffer.
 * It is used by the parser. Set it to zero prior to passing a line to
 * be evaluated to yyparse.
 * Most importantly krn_eqnResult contains the result of an expression
 * evaluation. Note that it is not valid for assignments.
 * krn_lineno is used for reporting errors etc.
 *
 */
int     krn_lineno=1;
int     krn_bufferPtr=0;
char    *krn_buffer;
float   krn_eqnResult=0;

/*
 * Command alias lists
 */
char *alias_short[MAX_ALIAS] = {"help", NULL};
char *alias_long[MAX_ALIAS]  = {"man capsim", NULL};

block_Pt pg_current;    /* current galaxy pointer */
block_Pt pb_current;    /* current block pointer */
block_Pt pb_error;      /* error block pointer */

extern int model_count; /* number of block models presently defined */
extern int history_count;/* number of valid commands entered */

/* External Function Declarations */
/* command.c */
extern string_com();

/* block.c */
extern block_Pt CreateUniverse();
extern block_Pt CreateBlock();

/* star.c */
extern star_Pt CreateStar();

/* prinfo.c */
extern prinfo();
extern ErrorPrint();

/* file.c */
extern char *file_root();
extern GalaxyDefine();

/*
 * Buffer maximum segments and cell increment
 */
int     krn_numberSamples;
int     krn_maxMemSegments;

KrnList *krn_bufferMemory;  /* track the buffer and other memory in link list to free after each simulation */
KrnList *krn_bufferPointerMemory;  /* track the buffer and other memory in link list to free after each simulation */

void KrnDestroy(void *data) {
    if(data) free(data);
}
void KrnDestroyBuffer(void *data) {
buffer_Pt buffer_P;
int i;
buffer_P=data;
    if(buffer_P) {
              if(buffer_P->memseg) {

                      free(buffer_P->memseg);

               }
               free(buffer_P);
    }
}

/*
 * For DSP Support Currently TMS320
 */
  int     dsp_capsim;
  int     dsp_inputValue;
  int     dsp_port;
  int     dsp_outputValue;


/*********************************************************************

                        main()

**********************************************************************
If a source topology file is supplied (eg."capsim myuniv.t")
the file is opened, commands are read from it, and
the simulation topology is run.  The program then exits.

If no file is specified, a prompt is written to the standard output,
and commands come from the standard input ("line mode").
[If the system has graphics capability ("graphics mode"), commands
come from the graphics interface program, Capsim().]
After an "exit" or "quit" command, the program exits;
if "quit" is used, warning of any un-saved changes is made.
Saving or running is achieved directly through line commands.

Command line options:

  -l <file> :   (load) First read commands from the specified file.
                At EOF, switch to line mode (or graphics mode),
                which makes this a "load and wait" option.

  -b        :   (blosim line-mode) Come up in line mode.  This is
                the default mode, unless there is graphics capability.

When capsim initiates, it looks for a command file named ".capsimrc"
in the current working directory, or in the user's home directory.
If it exists, it is loaded.  Since the .capsimrc file is run every
time the user executes capsim, is most useful for storing commands
which don't change from run to run.  For example, it could contain
aliases of common commands, or "path" statements to tell capsim where
to look for stars and galaxies.
*/
#if 1
#ifdef EMBEDDED_ECOS
int main(void)
#else
int main(int argc,char **argv)
#endif

{
        char *s;
        char entry_message[4*MAX_LINE];
        int err;
        int load_flag = 0;      /* has a load file been entered? */
        char load_file[MAX_LINE];/* initial file to load */

        int tcl_script_flag = 0;      /* has a tcl scrript  file been entered? */
        char tcl_script_file[MAX_LINE];/* initial tcl script file to load */


        int rc_flag = 0;        /* is initialization file present? */
        char rc_file[MAX_LINE];  /* the initialization file name */
        char command[MAX_LINE];  /* a command sentence */
        char    strBuf[100];
        int count;                   /* Counter*/
#ifdef TCL_SUPPORT
        int tclSupport=1;
	Tcl_Interp *krn_TCL_Interp=NULL;
#else
        int tclSupport=0;
#endif
	char *krn_tclScriptFile;

printf("Welcome to Capsim Text Mode Kernel (CapsimTMK)\n");
printf("(c)1989-2017 Silicon DSP Corporation\n");

printf("This is free software; see the source for copying conditions. There is NO\n");
printf("warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.\n");



printf("http://www.silicondsp.com\n");
printf("Version 6.2\n");




strcpy(load_file, "universe");
line_mode = 0;
/*
 * set number of samples used for cell increment and source stars
 */
krn_numberSamples= KRN_DEFAULT_NUMBER_SAMPLES;

/*
 * set the default maximum number of segments
 */

krn_maxMemSegments = KRN_DEFAULT_MAX_MEM_SEGMENTS;

/*
 * allocate the link list to track memory usage especially buffer usage
 */

krn_bufferMemory=(KrnList*)calloc(1,sizeof(KrnList));
krn_bufferPointerMemory=(KrnList*)calloc(1,sizeof(KrnList));


KrnListInit(krn_bufferMemory,KrnDestroy);
KrnListInit(krn_bufferPointerMemory,KrnDestroyBuffer);



/* initiallize all data structures */
if(tclSupport) {
     int c;
     int index;

     opterr=0;

     while ((c=getopt(argc,argv,"bct:")) != -1) {
        switch (c) {
	    case 'b':
	       printf("Interactive mode \n");
	        line_mode = 1;
                graphics_mode = 0;
                cs_xWindow = 0;
                tclSupport=0;

	       break;
	    case 'c':
	       tclSupport=1;
	       printf("TCL no script  \n");
	       break;

	    case 't':
                tcl_script_flag = 1;
               //         strcpy(tcl_script_file, file_root(argv[optind]));
                        strcpy(tcl_script_file, optarg);
                tclSupport=1;
	        printf("TCL with script : %s \n",optarg);
	        break;
	    case '?':
	       printf("Unknown option \n");
	       break;
       }

     }
     for (index=optind; index <argc; index++) {
                printf ("Running topology %s\n",argv[index]);
		       /* lone topology file remains */
                load_flag = 1;
                line_mode = 0;
                graphics_mode = 0;
                strcpy(load_file, file_root(argv[index]));
		tclSupport=0;
     }
     if (tclSupport) {
          /*
           * Capsim Initialization
           */
          sys_init();
          line_mode=1;

          if(tcl_script_flag) {
                  krn_tclScriptFile=(char*)calloc(MAX_LINE,sizeof(char));
                  strcpy(krn_tclScriptFile,tcl_script_file);
          } else {
               krn_tclScriptFile=(char*)NULL;


          }
          Tcl_Main(argc, argv, Tcl_AppInit);
          exit(0);
     } else {



     }
}

#if 00000

#ifndef EMBEDDED_ECOS
/* Get command line arguments */
while (--argc > 0 && (*++argv)[0] == '-') {
        s = argv[0] + 1;
        switch (*s) {
          case 'l':
                argv++;
                argc--;
                load_flag = 1;
                if(argc > 0)
                        strcpy(load_file, file_root(*argv));
                tclSupport=0;
                break;

          case 'b':
                argv++;
                argc--;
                line_mode = 1;
                graphics_mode = 0;
                cs_xWindow = 0;
                tclSupport=0;
                break;

          case 'x':
                argv++;
                argc--;
                line_mode = 1;
                graphics_mode = 0;
                cs_xWindow = 0;
                cs_linepgraph=1;
                tclSupport=0;
                break;

          case 'm':
                argv++;
                argc--;
                /*
                 * modal versus modeless
                 */
                break;

            case 'i':
                argv++;
                argc--;
                /*
                 * Just bring up iip
                 */
                break;

            case 'f':
                argv++;
                argc--;
                /*
                 * Just bring up iip
                 */
                break;
          case 't':
                argv++;
                argc--;
                tcl_script_flag = 1;
                if(argc > 0)
                        strcpy(tcl_script_file, file_root(*argv));
                tclSupport=1;
                break;

        default:
                prinfo(stdout," Usage: capsim [-lf <loadfile>] [-bmi] \n");
                exit(1);
                break;

        } /* ends switch */
}

if(argc > 0) {
        /* lone topology file remains */
        load_flag = 1;
        line_mode = 0;
        graphics_mode = 0;
        strcpy(load_file, file_root(*argv));
}
if (argc < 0) {
        argc=1;
        argv--;
}
#else
/* EMBEDDED_ECOS Hard code topology to load for now */
        load_flag = 1;
        line_mode = 0;
        graphics_mode = 0;
        printf("Welcome to Embedded Capsim on ECOS\n");
        strcpy(load_file, "testsine");


#endif
#endif


/* initiallize all data structures */
sys_init();

/* print welcome message if in line mode */
if(line_mode) {

        sprintf(entry_message,"\n\
                CapsimTMK\n\
                Silicon DSP Corporation \n\
                \n\tTopology File: %s.t\n", load_file);

        prinfo(stdout, entry_message);
}


/* attempt to find ".capsimrc" */
strcpy(rc_file, ".capsimrc");
if(access(rc_file, 4L) == 0) {
        /* it is in working directory */
        if(err = KrnToplologyFileReader(rc_file))
                exit(3);
}
else {
        /* look in user's home directory */
        /* (the environment variable HOME needs to be set) */
#ifdef DOS

        strcpy(rc_file, "");

#else

        strcpy(rc_file, getenv("HOME"));
#endif

#ifdef DOS
strcat(rc_file, ".capsimrc");
#endif

#ifdef UNIX
        strcat(rc_file, "/.capsimrc");
#endif
#ifdef VMS
        strcat(rc_file, ".capsimrc");
#endif
        if(access(rc_file, 4L) == 0) {
                if(err = KrnToplologyFileReader(rc_file))
                        exit(4);
        }
}


if(graphics_mode) {
        ErrorPrint("main: error in mode logic",1);
        exit(5);
}
else if(line_mode) {
        /* read from standard input */
        if(load_flag) {
                /* load in any specified file */
                sprintf(command,"load %s",load_file);
                if(err = string_com(command))
                        ErrorPrint("",err);
        }

        line_reader();
}
else {
        /* load and go */
        if(!load_flag) {
                ErrorPrint("main: error in flag logic",1);
                exit(6);
        }

        sprintf(command,"load %s.t",load_file);
        if(err = string_com(command)) {
                ErrorPrint("", err);
                exit(7);
        }
        if(err = string_com("run")) {
                ErrorPrint("", err);
                exit(8);
        }
}

}  /* ends main */

#endif
/**********************************************************************

                        line_reader()

***********************************************************************

Function inputs commands from standard input.
A prompt is printed at each line.
*/

line_reader()

{
        int err;
        char line[MAX_LINE];
        char prompt[MAX_LINE];

#ifdef EMBEDDED_ECOS

#else

sprintf(prompt,"CapsimTMK[%d]-> ", history_count);
prinfo(stdout, prompt);

while(fgets(line,MAX_LINE,stdin) != NULL) {
        if((err = string_com(line)) != 0)
                ErrorPrint("", err);

        sprintf(prompt,"CapsimTMK[%d]-> ", history_count);
        prinfo(stdout, prompt);
}

#endif

}

#ifdef ECOS
/**********************************************************************

                        KrnToplologyFileReader()

***********************************************************************
Function defines the topology of a GALAXY read from a file.
*/

KrnToplologyFileReader(char *fileName)

{


int err;
int line_no = 0;
char line[MAX_LINE];
char string[MAX_LINE];
int lmode_save, gmode_save;
char *buffer;
int ptr=0;
int bufferLength;


buffer=(char*)calloc(MAX_TOP_FILE_SIZE,sizeof(char));
if(!buffer) {
    printf("Failed to allocate space in KrnToplologyFileReader\n");
    exit(0);
}

if(KrnGetFileContent(fileName, buffer, MAX_TOP_FILE_SIZE-1)<0) {
        printf("Could not read in %s in KrnTopFileReader\n",fileName);
        strcpy(buffer,"# topology file:  testsine.t\n inform title  \n inform author  \n inform date  \n inform descrip  \n \n arg -1 (none) \n \n param int 128 \n param float 1\n param float 32000\n param float 1000\n param float 0\n param float 1\n param int 128\n star sine0 sine\n \n param file stdout\n param int 1\n param int 0\n star prfile0 prfile\n \n connect sine0 0 prfile0 0\n\n");
#if 000
        free(buffer);
        return(1);
#endif
}
lmode_save = line_mode;
gmode_save = graphics_mode;
graphics_mode = 0;
bufferLength=strlen(buffer);
/* read each file line and interpret */
while(KrnGetLine(line,MAX_LINE,buffer,&ptr, bufferLength)) {
        printf("KrnGetLine:%s\n",line);
        line_no++;
        if((err = string_com(line)) != 0) {
                sprintf(string,"File '%s' (line %d): \"%s\"",
                                fileName, line_no, line);
                ErrorPrint(string, err);

                line_mode = lmode_save;
                graphics_mode = gmode_save;
                free(buffer);
                return(2);
        }

}

line_mode = lmode_save;
graphics_mode = gmode_save;


free(buffer);

return(0);

}

#else


/**********************************************************************

			KrnToplologyFileReader()

***********************************************************************
Function defines the topology of a GALAXY read from a file.
*/

KrnToplologyFileReader(filename)

	char *filename;
{
	int err;
	int line_no = 0;
	FILE *fp,*fopen();
	char line[MAX_LINE];
	char string[MAX_LINE];
	int lmode_save, gmode_save;
if((fp = fopen(filename,"r")) == NULL)
	return(1);

lmode_save = line_mode;
#if 0
line_mode = 0;
#endif
gmode_save = graphics_mode;
graphics_mode = 0;

/* read each file line and interpret */
while(fgets(line,MAX_LINE,fp) != NULL) {
	line_no++;
	if((err = string_com(line)) != 0) {
		sprintf(string,".File '%s' (line %d): \"%s\"",
				filename, line_no, line);
		ErrorPrint(string, err);
		fclose(fp);
		line_mode = lmode_save;
		graphics_mode = gmode_save;
		return(2);
	}
}
fclose(fp);
line_mode = lmode_save;
graphics_mode = gmode_save;

return(0);

}
#endif
/*****************************************************************

                        sys_init()

******************************************************************
Overall system initialization.
 */

int sys_init()

{
        int i,j;
        block_Pt pblock;

/* Dummy call to link library functions */
SysCalls();

/* initiallize the model table for library stars */
for(i=0; i < model_count; i++)
        model[i].mtype = LIBRARY;

for(i=0; i < model_count; i++) {
        for(j=0; j<IO_BUFFERS; j++) {
              model[i].inputBuffers_AP[j]=(bufferSpec_Pt)NULL;
              model[i].outputBuffers_AP[j]=(bufferSpec_Pt)NULL;

        }

}

/* create the universe (galaxy) block */
pg_current = CreateUniverse();
pb_current = NULL;
/* create the universe model */
strcpy(model[model_count].name,"universe");
strcpy(model[model_count].ident,"UNIV");
model[model_count++].mtype = GALAXY;

/* define all galaxy names in initial galaxy paths */
galaxy_define(0);

/*
 * Initialize equation parser and evaluator
 */
KrnEqnInit();

return(0);
}



 int CsFileWindow()
{
return(0);
}

 int IIP_AppendCurve()
{
return(0);
}


 int IIP_SetAxisLabels()
{
return(0);
}

 int IIP_SetTitles()
{
return(0);
}



 int IIP_NewInitedCurveRec()
{
return(0);
}


/*
 * These functions are used by the equation parser and evaluator
 */
yyerror(s)
char *s;
{
        puts(s);
}

execerror(s,t)
char *s;
char *t;
{
        puts(s);
        puts(t);
}


#if 000
#ifdef TCL_SUPPORT

int
Plus1ObjCmd(ClientData clientData, Tcl_Interp *interp,
                int objc, Tcl_Obj *CONST objv[]);


/*
 * Tcl_AppInit is called from Tcl_Main
 * after the Tcl interpreter has been created,
 * and before the script file
 * or interactive command loop is entered.
 */
int
Tcl_AppInit(Tcl_Interp *interp) {
        /*
         * Tcl_Init reads init.tcl from the Tcl script library.
         */
        if (Tcl_Init(interp) == TCL_ERROR) {
                return TCL_ERROR;
        }
        /*
         * Register application-specific commands.
         */
        Tcl_CreateObjCommand(interp, "plus1", Plus1ObjCmd,
                        (ClientData)NULL, (Tcl_CmdDeleteProc *)NULL);
        Random_Init(interp);
//SHA   Blob_Init(interp);
        /*
         * Define the start-up filename. This file is read in
         * case the program is run interactively.
         */
        Tcl_SetVar(interp, "tcl_rcFileName", "~/.mytcl",
                TCL_GLOBAL_ONLY);
        /*
         * Test of Tcl_Invoke, which is defined on page 691.
         */
        Tcl_Invoke(interp, "set", "foo", "$xyz [foo] {", NULL);
        return TCL_OK;
}



#endif
#endif

