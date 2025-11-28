
#include <tcl.h>
#include <capsim.h>


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



int L_display(char *);
int L_star(char *);
int L_replace(char *);
int L_chp(char*);
int L_paramName(char*);
int L_connect(char*);
int L_to(char*);
int L_run(void);
int L_galaxy(char*);
int L_disconnect(char*);
int L_new();
int L_store(char *);
int L_load(char*);

int L_arg(char *);
int L_setMaxSeg(char *);
int L_setCellInc(char *);
int L_back(void);
int L_up(void);
int L_forward(void);
int L_down(void);
int L_delete(void);
int L_makecontig(void);
int L_state(void);
int L_info(void);


int L_path(char *);
int L_insert(char *);
int L_name(char *);
int L_inform(char *);
int L_man(char *);

int L_remove(char*  );



int
UpCmd(ClientData clientData, Tcl_Interp *interp,
		int argc, const char *argv[])
{

	L_up();
	return TCL_OK;
}


int
StateCmd(ClientData clientData, Tcl_Interp *interp,
		int argc, const char *argv[])
{

	L_state();
	return TCL_OK;
}

int
InfoCmd(ClientData clientData, Tcl_Interp *interp,
		int argc, const char *argv[])
{

	L_info();
	return TCL_OK;
}



int
DownCmd(ClientData clientData, Tcl_Interp *interp,
		int argc, const char *argv[])
{

	L_down();
	return TCL_OK;
}


int
RemoveCmd(ClientData clientData, Tcl_Interp *interp,
		int argc, const char *argv[])
{

	L_remove("x");
	return TCL_OK;
}

int
DeleteCmd(ClientData clientData, Tcl_Interp *interp,
		int argc, const char *argv[])
{

	L_delete();
	return TCL_OK;
}

int
ForwardCmd(ClientData clientData, Tcl_Interp *interp,
		int argc, const char *argv[])
{

	L_forward();
	return TCL_OK;
}

int
BackCmd(ClientData clientData, Tcl_Interp *interp,
		int argc, const char *argv[])
{

	L_back();
	return TCL_OK;
}

int
MakeContigCmd(ClientData clientData, Tcl_Interp *interp,
		int argc, const char *argv[])
{

	L_makecontig();
	return TCL_OK;
}
int
RunCmd(ClientData clientData, Tcl_Interp *interp,
		int argc, const char *argv[])
{

	L_run();
	return TCL_OK;
}


int
NewCmd(ClientData clientData, Tcl_Interp *interp,
		int argc, const char *argv[])
{

	L_new();
	return TCL_OK;
}


int
PathCmd(ClientData clientData, Tcl_Interp *interp,
		int argc, const char *argv[])
{
	int rand, error;
	int range = 0;
	char command[200];

	if (argc !=3 ) {
		interp->result = "Usage: path [sgd] thePath";
		return TCL_ERROR;
	}
        else {
	        sprintf(command,"path %s %s",argv[1],argv[2]);
	}

	L_path(command);

	sprintf(interp->result, "%s", command);
	return TCL_OK;
}



int
SetMaxSegCmd(ClientData clientData, Tcl_Interp *interp,
		int argc, const char *argv[])
{
	int rand, error;
	int range = 0;
	char command[200];

	if (argc !=2 ) {
		interp->result = "Usage: setMaxSeg integer";
		return TCL_ERROR;
	}
        else {
	        sprintf(command,"setMaxSeg %s",argv[1]);
	}

	L_setMaxSeg(command);

	sprintf(interp->result, "%s", command);
	return TCL_OK;
}



int
SetCellIncCmd(ClientData clientData, Tcl_Interp *interp,
		int argc, const char *argv[])
{
	int rand, error;
	int range = 0;
	char command[200];

	if (argc !=2 ) {
		interp->result = "Usage: setCellInc integer";
		return TCL_ERROR;
	}
        else {
	        sprintf(command,"setCellInc %s",argv[1]);
	}

	L_setCellInc(command);

	sprintf(interp->result, "%s", command);
	return TCL_OK;
}

int
ManCmd(ClientData clientData, Tcl_Interp *interp,
		int argc, const char *argv[])
{
	int  error;

	char command[200];

	if (argc !=2 ) {
		interp->result = "Usage: man block";
		return TCL_ERROR;
	}
        else {
	        sprintf(command,"man %s",argv[1]);
	}

	L_man(command);

	sprintf(interp->result, "%s", command);
	return TCL_OK;
}

int
BlockCmd(ClientData clientData, Tcl_Interp *interp,
		int argc, const char *argv[])
{
	int rand, error;
	int range = 0;
	char command[200];

	if (argc > 3) {
		interp->result = "Usage: block block_model,or block block_name block_model";
		return TCL_ERROR;
	}
	if (argc == 3) {
	        sprintf(command,"block %s %s",argv[1],argv[2]);

	} else {
	        sprintf(command,"block %s",argv[1]);
	}

	L_star(command);

	sprintf(interp->result, "%s", command);
	return TCL_OK;
}
int
ReplaceCmd(ClientData clientData, Tcl_Interp *interp,
		int argc, const char *argv[])
{
	int rand, error;
	int range = 0;
	char command[200];

	if (argc > 3) {
		interp->result = "Usage: replace block_model,or block block_name block_model";
		return TCL_ERROR;
	}
	if (argc == 3) {
	        sprintf(command,"replace %s %s",argv[1],argv[2]);

	} else {
	        sprintf(command,"replace %s",argv[1]);
	}

	L_replace(command);

	sprintf(interp->result, "%s", command);
	return TCL_OK;
}

int
HBlockCmd(ClientData clientData, Tcl_Interp *interp,
		int argc, const char *argv[])
{
	int rand, error;
	int range = 0;
	char command[200];

	if (argc > 3) {
		interp->result = "Usage: hblock block_model, or hblock block_name block_model";
		return TCL_ERROR;
	}
	if (argc == 3) {
                sprintf(command,"hblock %s %s",argv[1], argv[2]);

	} else {
	        sprintf(command,"hblock %s",argv[1]);
	}

	L_galaxy(command);

	sprintf(interp->result, "%s", command);
	return TCL_OK;
}

/*
 * The command format is "insert <-,+> <specifiedBlockName> <i,o number>"
 */
int
InsertCmd(ClientData clientData, Tcl_Interp *interp,
		int argc, const char *argv[])
{
	int rand, error;
	int range = 0;
	char command[200];

	if (argc != 4 ) {
		interp->result = "Usage: The command format is:insert <-,+> <specifiedBlockName> <i,o number>";
		return TCL_ERROR;
	}
	if (argc == 4) {
                sprintf(command,"insert %s %s %s",argv[1], argv[2],argv[3]);

	}

	L_insert(command);

	sprintf(interp->result, "%s", command);
	return TCL_OK;
}

/*
 * The command format is "name_to inNum sigName"
 */
int
SigNameCmd(ClientData clientData, Tcl_Interp *interp,
		int argc, const char *argv[])
{
	int rand, error;
	int range = 0;
	char command[200];

	if (argc != 4 ) {
		interp->result = "Usage: The command format is:name name_to inNum sigName";
		return TCL_ERROR;
	}
	if (argc == 4) {
                sprintf(command,"name %s %s %s",argv[1], argv[2],argv[3]);

	}

	L_name(command);

	sprintf(interp->result, "%s", command);
	return TCL_OK;
}

/*
 * The command format is "name_to inNum sigName"
 */
int
InformCmd(ClientData clientData, Tcl_Interp *interp,
		int argc, const char *argv[])
{
	int rand, error;
	int range = 0;
	char command[200];

	if (argc != 3 || argc != 1 ) {
		interp->result = "Usage: The command format is:inform field info (note enlcose in {})";
		return TCL_ERROR;
	}
	if (argc == 3) {
                sprintf(command,"inform %s %s",argv[1], argv[2]);

	}
	if (argc == 1) {
                sprintf(command,"inform");

	}

	L_inform(command);

	sprintf(interp->result, "%s", command);
	return TCL_OK;
}

int
StoreCmd(ClientData clientData, Tcl_Interp *interp,
		int argc, const char *argv[])
{
	int rand, error;
	int range = 0;
	char command[200];

	if (argc > 2) {
		interp->result = "Usage: store  [file_name]";
		return TCL_ERROR;
	}
	if (argc == 2) {
	        sprintf(command,"store %s",argv[1]);

	} else {
	        sprintf(command,"store");
	}

	L_store(command);

	sprintf(interp->result, "%s", command);
	return TCL_OK;
}
int
LoadCmd(ClientData clientData, Tcl_Interp *interp,
		int argc, const char *argv[])
{
	int rand, error;
	int range = 0;
	char command[200];

	if (argc > 2 || argc <2) {
		interp->result = "Usage: load file_name";
		return TCL_ERROR;
	}
	if (argc == 2) {
	        sprintf(command,"load %s",argv[1]);

	}

	L_load(command);

	sprintf(interp->result, "%s", command);
	return TCL_OK;
}





/*
 *    The format is:   'arg' argnum argtype argval "argprompt"
 *    The (optional) prompt must be in double quotes.
 *    NOTE: Only argtypes allowed are: int, float, or file.
 *    The line 'arg -1' is interpreted as 'no args for this galaxy'.
 *    The line 'arg 2 NULL' (e.g.) means 'eliminate arg #2'.
 *
 */




int
ArgCmd(ClientData clientData, Tcl_Interp *interp,
		int argc, const char *argv[])
{
	int error;
	char command[200];

//	if (argc > 2) {
//		interp->result = "Usage: block block_model";
//		return TCL_ERROR;
//	}

	switch (argc) {
	   case 2:
	       sprintf(command,"arg -1");
	       break;

	   case 5:
	       sprintf(command,"arg %s %s %s %s",argv[1],argv[2],argv[3],argv[4]);
	       break;
	   case 3:
	       sprintf(command,"arg %s %s",argv[1],argv[2]);
	       break;

	   default:
               interp->result = "Usage: 'arg' argnum argtype argval \"argprompt\"";
  	       return TCL_ERROR;
	       break;
       }



	L_arg(command);

	sprintf(interp->result, "%s", command);
	return TCL_OK;
}


int
ChpCmd(ClientData clientData, Tcl_Interp *interp,
		int argc,const  char *argv[])
{
	int error;

	char command[200];
#if 1
//	if (argc > 2) {
//		interp->result = "Usage: block block_model";
//		return TCL_ERROR;
//	}

	switch (argc) {
	   case 2:
	       sprintf(command,"chp %s",argv[1]);
	       break;

	   case 3:
	       sprintf(command,"chp %s %s",argv[1],argv[2]);
	       break;
	   case 1:
	       sprintf(command,"chp");
	       break;

	   default:
               interp->result = "Usage: chp [param number] [paramvalue]";
  	       return TCL_ERROR;
	       break;
       }

#endif

	L_chp(command);

	sprintf(interp->result, "%s", command);
	return TCL_OK;
}



int
ParamByNameCmd(ClientData clientData, Tcl_Interp *interp,
		int argc, const char *argv[])
{
	int error;

	char command[200];
#if 1
//	if (argc > 2) {
//		interp->result = "Usage: block block_model";
//		return TCL_ERROR;
//	}

	switch (argc) {

	   case 3:
	       sprintf(command,"parambyname %s %s",argv[1],argv[2]);
	       break;

	   default:
               interp->result = "Usage: parambyname name value";
  	       return TCL_ERROR;
	       break;
       }

#endif

	L_paramName(command);

	sprintf(interp->result, "%s", command);
	return TCL_OK;
}


int
DisplayCmd(ClientData clientData, Tcl_Interp *interp,
		int argc, const char *argv[])
{
	int rand, error;
	int range = 0;
	char command[200];

	if (argc > 2) {
		interp->result = "Usage: display [g or s]";
		return TCL_ERROR;
	}
	if (argc != 2) {
	        sprintf(command,"display");

	} else {
	        sprintf(command,"display %s",argv[1]);
	}

	L_display(command);

	sprintf(interp->result, "");
	return TCL_OK;
}

int
ToCmd(ClientData clientData, Tcl_Interp *interp,
		int argc, const char *argv[])
{
	int  error;

	char command[200];

	if (argc > 2 || argc ==1 ) {
		interp->result = "Usage: to path_to_block";
		return TCL_ERROR;
	}
        else {
	        sprintf(command,"to %s",argv[1]);
	}

	L_to(command);

	sprintf(interp->result, "%s",command);
	return TCL_OK;
}



int
ConnectCmd(ClientData clientData, Tcl_Interp *interp,
		int argc, const char *argv[])
{
	int rand, error;
	int range = 0;
	char command[200];


	switch(argc) {
	  case 3:
	     sprintf(command,"connect %s %s",argv[1],argv[2]);
	     break;
	  case 5:
	     sprintf(command,"connect %s %s %s %s",argv[1],argv[2],argv[3], argv[4]);
	     break;
	  default:
		interp->result = "Usage: connect blockNameSrc [port] blockNameDest [port]";
		return TCL_ERROR;

	     break;

	}


	L_connect(command);

	sprintf(interp->result, "%s", command);
	return TCL_OK;
}



int
DisConnectCmd(ClientData clientData, Tcl_Interp *interp,
		int argc, const char *argv[])
{
	int rand, error;
	int range = 0;
	char command[200];


	switch(argc) {
	  case 3:
	     sprintf(command,"disconnect %s %s",argv[1],argv[2]);
	     break;
	  case 5:
	     sprintf(command,"disconnect %s %s %s %s",argv[1],argv[2],argv[3], argv[4]);
	     break;
	  default:
		interp->result = "Usage: disconnect blockNameSrc [port] blockNameDest [port]";
		return TCL_ERROR;

	     break;

	}


	L_disconnect(command);

	sprintf(interp->result, "%s", command);
	return TCL_OK;
}



/*
 * CapsimInit is called when the package is loaded.
 */

int CapsimInit(Tcl_Interp *interp) {
	/*
	 * Initialize the stub table interface, which is
	 * described in Chapter 46.
	 */

	krn_TCL_Interp=interp;

	if (Tcl_InitStubs(interp, "8.1", 0) == NULL) {
		return TCL_ERROR;
	}
	/*
	 * Register two variations of random.
	 * The orandom command uses the object interface.
	 */

	Tcl_CreateCommand(interp, "display",  DisplayCmd,
			(ClientData)NULL, (Tcl_CmdDeleteProc *)NULL);

	Tcl_CreateCommand(interp, "block", BlockCmd,
			(ClientData)NULL, (Tcl_CmdDeleteProc *)NULL);

	Tcl_CreateCommand(interp, "replace", ReplaceCmd,
			(ClientData)NULL, (Tcl_CmdDeleteProc *)NULL);

	Tcl_CreateCommand(interp, "hblock", HBlockCmd,
			(ClientData)NULL, (Tcl_CmdDeleteProc *)NULL);


	Tcl_CreateCommand(interp, "chp", ChpCmd,
			(ClientData)NULL, (Tcl_CmdDeleteProc *)NULL);

	Tcl_CreateCommand(interp, "connect", ConnectCmd,
			(ClientData)NULL, (Tcl_CmdDeleteProc *)NULL);

	Tcl_CreateCommand(interp, "disconnect", DisConnectCmd,
			(ClientData)NULL, (Tcl_CmdDeleteProc *)NULL);


	Tcl_CreateCommand(interp, "run", RunCmd,
			(ClientData)NULL, (Tcl_CmdDeleteProc *)NULL);

	Tcl_CreateCommand(interp, "new", NewCmd,
			(ClientData)NULL, (Tcl_CmdDeleteProc *)NULL);

	Tcl_CreateCommand(interp, "to", ToCmd,
			(ClientData)NULL, (Tcl_CmdDeleteProc *)NULL);

	Tcl_CreateCommand(interp, "capstore", StoreCmd,
			(ClientData)NULL, (Tcl_CmdDeleteProc *)NULL);

	Tcl_CreateCommand(interp, "capload", LoadCmd,
			(ClientData)NULL, (Tcl_CmdDeleteProc *)NULL);

	Tcl_CreateCommand(interp, "arg", ArgCmd,
			(ClientData)NULL, (Tcl_CmdDeleteProc *)NULL);

	Tcl_CreateCommand(interp, "up", UpCmd,
			(ClientData)NULL, (Tcl_CmdDeleteProc *)NULL);

	Tcl_CreateCommand(interp, "down", DownCmd,
			(ClientData)NULL, (Tcl_CmdDeleteProc *)NULL);


	Tcl_CreateCommand(interp, "back", BackCmd,
			(ClientData)NULL, (Tcl_CmdDeleteProc *)NULL);


	Tcl_CreateCommand(interp, "forward", ForwardCmd,
			(ClientData)NULL, (Tcl_CmdDeleteProc *)NULL);

	Tcl_CreateCommand(interp, "setCellInc", SetCellIncCmd,
			(ClientData)NULL, (Tcl_CmdDeleteProc *)NULL);

	Tcl_CreateCommand(interp, "setMaxSeg", SetMaxSegCmd,
			(ClientData)NULL, (Tcl_CmdDeleteProc *)NULL);

	Tcl_CreateCommand(interp, "path", PathCmd,
			(ClientData)NULL, (Tcl_CmdDeleteProc *)NULL);

	Tcl_CreateCommand(interp, "remove", RemoveCmd,
			(ClientData)NULL, (Tcl_CmdDeleteProc *)NULL);

	Tcl_CreateCommand(interp, "delete", DeleteCmd,
			(ClientData)NULL, (Tcl_CmdDeleteProc *)NULL);

	Tcl_CreateCommand(interp, "insert", InsertCmd,
			(ClientData)NULL, (Tcl_CmdDeleteProc *)NULL);

	Tcl_CreateCommand(interp, "signame", SigNameCmd,
			(ClientData)NULL, (Tcl_CmdDeleteProc *)NULL);

	Tcl_CreateCommand(interp, "inform", InformCmd,
			(ClientData)NULL, (Tcl_CmdDeleteProc *)NULL);

	Tcl_CreateCommand(interp, "makecontig", MakeContigCmd,
			(ClientData)NULL, (Tcl_CmdDeleteProc *)NULL);

	Tcl_CreateCommand(interp, "state", StateCmd,
			(ClientData)NULL, (Tcl_CmdDeleteProc *)NULL);

	Tcl_CreateCommand(interp, "getinfo", InfoCmd,
			(ClientData)NULL, (Tcl_CmdDeleteProc *)NULL);

	Tcl_CreateCommand(interp, "man", ManCmd,
			(ClientData)NULL, (Tcl_CmdDeleteProc *)NULL);

	Tcl_CreateCommand(interp, "parambyname", ParamByNameCmd,
			(ClientData)NULL, (Tcl_CmdDeleteProc *)NULL);



	/*
	 * Declare that we implement the random package
	 * so scripts that do "package require random"
	 * can load the library automatically.
	 */
	Tcl_PkgProvide(interp, "display", "1.1");
	return TCL_OK;
}

