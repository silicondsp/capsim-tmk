

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
 * Capsim Kernel v1.0
 *
 *
 */


/* capsim.h */
#include <stdio.h>
#include <math.h>

#include <stdlib.h>

#include <tcl.h>


#define TCL_SUPPORT


/*
 * The following are needed for Embedded Version
 */
#define MAX_TOP_FILE_SIZE 10000
#define MAX_FILE_SIZE_GALAXY_LIST 2000
#define GALAXY_LIST_FILE_NAME "/galaxy_list.dat"

//#define DOS
#define UNIX



/* file path name dividers */
#ifdef UNIX
#define PATHDELIM  '/'
#endif

#ifdef DOS
#define PATHDELIM  '\\'
#endif


/*
 * type specifications
 */
typedef char *STRING, *POINTER;

typedef int (*PFI)();	/* PFI is pointer to function returning int */




#ifndef FALSE
#define FALSE 0
#endif


#ifndef TRUE
#define TRUE 1
#endif


/*
 * DEFINITIONS
 */

/*
 * max number of fifos connected to the input or output of a block
 */
#define IO_BUFFERS 25

/*
 *
 */

#define MAX_DYNAMIC_PARAMETERS_CONNECTIONS 25

/*
 * max number of star and galaxy models
 */
#define MAX_MODELS 500

/*
 * maximum number of characters in a block name
 */
#define NAME_LENGTH 256

/*
 * maximum number of characters in a parameter file name
 */
#define PARAM_FILE_NAME_LENGTH 256



 /*
 * maximum array size in array parameter
 */
#define KRN_PARAM_MAX_ARRAY_SIZE 25

/*
 * a pure output STAR must limit the number of samples it puts
 * out each time it is called, else buffers can grow too large...
 * programmers of such stars should set this number to NUMBER_SAMPLES_PER_VISIT.
 */

#define KRN_DEFAULT_NUMBER_SAMPLES 128

/*
 * The global integer krn_numberSamples is used by stars to determine
 * how many samples to output. It is also used to set the
 * CELL_INC that is the number of cells to allocate if the buffer is full
 * For compatibility with previous versions its value is set to 128 upon
 * initialization. It can be change through a Capsim line command.
 * Its minimum value is 1
 */
extern int krn_numberSamples;


#define NUMBER_SAMPLES_PER_VISIT krn_numberSamples

/*
 * the number of cells allocated when a buffer is enlarged
 */
#define CELL_INC  NUMBER_SAMPLES_PER_VISIT

/*
 * The following global is the maximum size of a buffer in segments
 * where each segment is CELL_INC samples
 */
extern int krn_maxMemSegments;

/*
 * Default maximum number of segments
 */
#define KRN_DEFAULT_MAX_MEM_SEGMENTS 100000


/*
 * Maximum number of parameters per star
 */
#define MAX_PARAM  30

/*
 * max number of star or galaxy paths
 */
#define MAX_PATHS 5

/*
 * max characters in path description
 */
#define MAX_PATH_LEN 1024

/*
 * max number of aliases that can be used
 */
#define MAX_ALIAS 50

/*
 * max characters in line input
 */
#define MAX_LINE ((3*NAME_LENGTH) + MAX_PATH_LEN)


/*
 * maximum number of characters in a block name
 */
#define MAX_IDENT_LEN 7

/*
 * max characters in signal name
 */
#define SNLEN 40



#define KRN_BLOCK_TYPE_REGULAR 0
#define KRN_BLOCK_TYPE_SPICE 1
#define KRN_BLOCK_TYPE_NETWORK 2

#ifdef TCL_SUPPORT
Tcl_Interp *krn_TCL_Interp;
#endif



/******************************************************************

	DATA STRUCTURE OF A STAR

******************************************************************
*/

typedef struct {

	/*
 	 * number of input buffers to star
         */
	int numberInBuffers;

	/*
 	 * pointer to input buffers, where IO_BUFFERS
	 *  is the max number of input buffers defined in "alloc.h"
	 */
	POINTER inBuffer_P[IO_BUFFERS];

	/*
	 * signal names assigned to input buffers
	 */
	POINTER signalName[IO_BUFFERS];

	/*
	 * number of output buffers to star
 	 */
	int numberOutBuffers;

	/*
	 * pointer to output buffers, where IO_BUFFERS
	 *   is the max number of output buffers defined in "alloc.h"
 	 */
	POINTER outBuffer_P[IO_BUFFERS];

	/*
	 * pointer to state variables for user function
	 *  implementing this star
 	 */
	POINTER state_P;


	} star_t, *star_Pt;


/*
 * definitions which refer to the states of the simulation
 * (they correspond to cases in star code)
 */

#define PARAM_INIT  0	/* initialization of parameter model */
#define SYSTEM_INIT 1	/* initialization of buffers, states, etc.*/
#define USER_INIT   2	/* any initialization provided by the user */
#define MAIN_CODE   3	/* the main part of the simulation */
#define WRAPUP	    4	/* executed after simulation deadlock */
#define DYNAMIC_INIT	5	/*  */
#define OUTPUT_BUFFER_INIT	6	/*  */
#define INPUT_BUFFER_INIT	7	/*  */





/*******************************************************************
 *
 * 	Data structure for a parameter value.
 *
 *******************************************************************
 */

typedef struct {
	int type;	/* param type option: see below */
	union {
		int d;
		float f;
		char *s;
		float *a;	/* for arrays */
	} value;	/* parameter value */
	char *def;	/* definition string for prompting */
	char *name;	/* Name of parameter */
	int arg;	/* if >= 0, galaxy arg index */
	int array_size;	/* if array type, # of float elements */
			/* pointed to by value.s */
	int exprFlag;   /* Flag: if value determined by expression then TRUE */
	char *express;	/* Parameter expression				*/

} param_t, *param_Pt;

/*******************************************************************
 *
 *      Data structure for buffers (input/output).
 *
 *******************************************************************
 */

typedef struct {
        char *type;      /* definition string for prompting */
        char *name;     /* Name of parameter */

} bufferSpec_t, *bufferSpec_Pt;






/*
 *  Options for parameter types
 */

#define PARAM_NOSET	-1 /* parameter not set */
#define PARAM_DEFAULT	0  /* parameter is to default */
#define PARAM_INT	1  /* value.d is integer */
#define PARAM_FLOAT	2  /* value.f is float */
#define PARAM_FUNCTION	3  /* value.s names a function (string) */
#define PARAM_FILE	4  /* value.s names a file (string) */
#define PARAM_ARRAY	5  /* value.s is a pointer to an array of
				floats, size being array_size  */
#define PARAM_ARG	6  /* parameter comes from parent galaxy */
#define PARAM_STRING	7  /* value.s names a file (string) SHA_NEW*/




/***********************************************************************
 * This structure defines the global model table for blocks.
 * It is used to define instances of blocks as they are created.
 ***********************************************************************
 */

typedef struct {

	/*
	 * pointer to object code, if a star
 	 */
	PFI function;

	/*
	 * print name (model name) of star or galaxy
 	 */
	char name[NAME_LENGTH];

	/*
	 * icon identifier string -- 6 chars max, plus NULL!
	 */
	char ident[MAX_IDENT_LEN];

	/*
	 * is parameter model created yet?
	 */
	int param_model_flag;

	/*
	 * info about parameters
 	 */
	param_Pt param_AP[MAX_PARAM];

	/*
	 * info about input buffers
 	 */
	bufferSpec_Pt inputBuffers_AP[IO_BUFFERS];

	/*
	 * info about output buffers
 	 */
	bufferSpec_Pt outputBuffers_AP[IO_BUFFERS];

	/*
	 * type of block modeled
	 */
	int mtype;

	}  modelEntry_t;

extern modelEntry_t model[];

/* Possible block model types (mtype) */
#define INVALID	0
#define LIBRARY	1	/* library star */
#define CUSTOM	2	/* custom (user defined) star */
#define GALAXY	3	/* galaxy block */


/*
 * linked list for arguments
 */


/*
 * Object structure.  Holds argument object data.
 * Objects  are held in a circular list.  The list_P member of the header
 * points to the "last" object in the list; the next node is a sentinel with
 * sentFlag == TRUE, and the next node is the "first" object in the list.
 *
 * Linked List to hold argument  objects together
 */

typedef struct krn_argObj {

	param_Pt	parameter_P;
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









/********************************************************************
 *		Structure for CAPSIM Blocks
 ********************************************************************
 */


/*
 * Block  information
 * Title:
 * Author:
 * Date:
 * Description:
 */
typedef struct {
	char title[100];
	char author[100];
	char date[80];
	char descrip[200];
} info_t,*info_Pt;



typedef struct block {

    /*
	 * pointer to the galaxy block immediately above in structure
 	 */
        struct block *pparent;

    /*
	 * pointer to the first block lower in the tree,
	 * (defined only for a UNIVERSE or GALAXY block)
	 */
        struct block *pchild;

    /*
	 * pointer to the forward sibling block in the same GALAXY
	 */
        struct block *pfsibling;

    /*
	 * pointer to the backward sibling block in the same GALAXY
	 */
        struct block *pbsibling;


    /*
	 *
	 */
        struct block *dynamicParamBlocksConnected_P[MAX_DYNAMIC_PARAMETERS_CONNECTIONS];
	/*
	 *
	 */
		 int numberDynamicParamConnections;

         struct block *dynamicParamBlock_P;

		 int sizeDynamicParam;

	     POINTER dynamicParam_P;


    /*
	 * pointers to blocks in the same GALAXY which are connected
     *  to the inputs of this block; if the connection is external to
  	 *  the GALAXY, this pointer points to the GALAXY block itself
	 */
        struct block *inputs[IO_BUFFERS];

    /*
	 * for each input, the connecting block's output number
	 */
        int output_no[IO_BUFFERS];

	/*
	 * array of pointers to signal names for each input
	 */
	char *signalName[IO_BUFFERS];

    /* pointers to blocks in the same GALAXY which are connected
     *  to the output of this block; if the connection is external to
     *  the GALAXY, this pointer points to the GALAXY block itself
	 */
        struct block *outputs[IO_BUFFERS];

    /*
	 * for each output, the connected block's input number
	 */
        int input_no[IO_BUFFERS];

    /*
	 * pointer to the permanent storage for parameters
	 */
        param_Pt param_AP[MAX_PARAM];

    /*
	 * pointer to arguments linked list header
	 */
        krn_ArgHdr_Pt argHdr_P;

    /*
	 * pointer to the data structure of a star block
 	 */
        star_Pt star_P;

    /*
	 * the type of block: UNIVERSE, GALAXY, or STAR
	 */
        int type;

    /*
	 * a pointer to the user STAR function code
	 */
        PFI function;

    /*
	 * the name of the block (instance name)
	 */
        char name[NAME_LENGTH];

    /*
	 * the name of the block (instance name)
	 */
     char paramFile[PARAM_FILE_NAME_LENGTH];


	 /*
	  * parameter pointer
	  */
	 POINTER params_P;

	/*
	 * index into model table for this block
	 */
	int model_index;

	/*
	 *  has this block been changed? params, conns, etc
	 */
	int change_flag;


    /*
	 * Is block selected.
	 */
        int selectFlag;


     /*
	 * have galaxy graphics been changed?
	 */
        int graphicChangeFlag;


	/*
	 * Information
	 */
	info_Pt info_P;

	/*
 	 * block type:
	 * Spice, Transmission Line Node, etc
	 */
	int blkType;

} block_t, *block_Pt;


/*
 * Definitions for block type field
 */
#define UTYPE 3   /* Universe */
#define GTYPE 2   /* Galaxy */
#define STYPE 1   /* Star */








/********************************************************************

                DATA STRUCTURE OF A BUFFER

********************************************************************
A buffer is a doubly linked list of cell structures, each with
a pointer to a data storage location */

typedef struct cell {

        /* pointer to the next newest cell */
        struct cell *pnew;

        /* pointer to the next oldest cell */
        struct cell *pold;

        /* pointer to the cell data storage location */
        POINTER pdata;

        } cell_t;


typedef struct {

        /* size of one cell in bytes */
        int cellsize;

        /* maximum samples delay which must be retained in buffer */
        int dmax;

        /* minimum samples delay when this buffer is used for input  */
        int dmin;

        /* current number of allocated buffer cells */
        int cells_alloc;

        /* pointer to last (input/output) cell accessed by the user */
        cell_t *plast_rd;
        cell_t *plast_wr;

        /* delay of the 'plast' cell relative to current sample */
        int dlast_rd;
        int dlast_wr;

        /* pointer to the cell where the most recent new sample
          was stored in the buffer by the outputting block */
        cell_t *pnewest;

        /* number of samples currently stored in the buffer:
          the current and any newer samples, and past samples
          with delay less than or equal to dmin -- these are
          samples accessible by the inputting block */
        int cells_stored;

        /* have the buffer cells been initialized? */
        int init_buffer;

        /* table to hold pointers for allocated memory segments,
          needed to free them later */
        cell_t **memseg;

        } buffer_t, *buffer_Pt;


//#ifndef LIST_H
#define LIST_H



/*****************************************************************************
*                                                                            *
*  Define a structure for linked list elements.                              *
*                                                                            *
*****************************************************************************/

typedef struct KrnListElmt_ {

void               *data;
struct KrnListElmt_   *next;

} KrnListElmt;


/*****************************************************************************
*                                                                            *
*  Define a structure for linked lists.                                      *
*                                                                            *
*****************************************************************************/

typedef struct List_ {

int                size;

int                (*match)(const void *key1, const void *key2);
void               (*destroy)(void *data);

KrnListElmt           *head;
KrnListElmt           *tail;

} KrnList;


char *krn_tclScriptFile;

/*****************************************************************************
*                                                                            *
*  --------------------------- Public Interface ---------------------------  *
*                                                                            *
*****************************************************************************/

void KrnListInit(KrnList *list, void (*destroy)(void *data));

void KrnListDestroy(KrnList *list);

int KrnListInsNext(KrnList *list, KrnListElmt *element, const void *data);

int KrnListRemNext(KrnList *list, KrnListElmt *element, void **data);

#define KRN_LIST_SIZE(list) ((list)->size)

#define KRN_LIST_HEAD(list) ((list)->head)

#define KRN_LIST_TAIL(list) ((list)->tail)

#define KRN_LIST_IS_HEAD(list, element) ((element) == (list)->head ? 1 : 0)

#define KRN_LIST_IS_TAIL(element) ((element)->next == NULL ? 1 : 0)

#define KRN_LIST_DATA(element) ((element)->data)

#define KRN_LIST_NEXT(element) ((element)->next)




extern KrnList *krn_bufferMemory;
extern KrnList *krn_bufferPointerMemory;
extern void KrnDestroy(void *data);
extern void KrnDestroyBuffer(void *data);

char *NameTree( block_Pt );


















/*
 * GLOBALS for equation parsing and evaluation
 * krn_buffer contains the line with an expression on each call to yyparse
 * krn_bufferPtr is an integer pointing to the current character in krn_buffer.
 * It is used by the parser. Set it to zero prior to passing a line to
 * be evaluated to yyparse.
 * Most importantly krn_eqnResult contains the result of an expression
 * evaluation. Note that it is not valid for assignments.
 * krn_lineno is used for reporting errors etc.
 *
 */
extern int     krn_lineno;
extern int     krn_bufferPtr;
extern char    *krn_buffer;
extern float   krn_eqnResult;
extern int     krn_yyerror;

void KrnMain(int argc,char **argv);
int KrnGetFileContent(char *fileName, char *buffer, int max);
int KrnToplologyFileReader(char *filename);
int KrnGetLine(char *line, int max, char *buffer, int *ptr_P,int bufferLength);
void KrnModelConnectionOutput(int mt_index,int connectionIndex,char* name,char* type);
void KrnModelConnectionInput(int mt_index,int connectionIndex,char* name,char* type);






