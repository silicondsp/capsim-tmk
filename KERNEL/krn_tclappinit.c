
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


#include <tcl.h>
#include "capsim.h"




#ifdef TCL_SUPPORT

/*
 * Tcl_AppInit is called from Tcl_Main
 * after the Tcl interpreter has been created,
 * and before the script file
 * or interactive command loop is entered.
 */
int
Tcl_AppInit(Tcl_Interp *interp) {
char command[1024];
        /*
         * Tcl_Init reads init.tcl from the Tcl script library.
         */
        if (Tcl_Init(interp) == TCL_ERROR) {
                return TCL_ERROR;
        }
        /*
         * Register application-specific commands.
         */
        CapsimInit(interp);
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


        if(krn_tclScriptFile) {
                   printf("Script File %s\n",krn_tclScriptFile);
                   sprintf(command,"source %s",krn_tclScriptFile);
                   Tcl_EvalEx(interp,command,strlen(command),NULL );
        }
        else
		   printf("No Script file\n");

//        if(krn_tclScriptFile)
//           Tcl_Invoke(interp, "source",krn_tclScriptFile , "", NULL);
        return TCL_OK;
}



#endif
