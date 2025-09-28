all:libkrn.a 

CAPSIM= ..

#ARCH=-m64

krn_arguments.o:krn_arguments.c ../include/capsim.h
	cc -c -g $(ARCH) -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL  krn_arguments.c

krn_block.o:krn_block.c ../include/capsim.h
	cc -c -g $(ARCH) -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL  krn_block.c

krn_buffer.o:krn_buffer.c ../include/capsim.h
	cc -c -g $(ARCH) -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL  krn_buffer.c

krn_command.o:krn_command.c ../include/capsim.h
	cc -c -g $(ARCH) -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL  krn_command.c

krn_connect.o:krn_connect.c ../include/capsim.h
	cc -c -g $(ARCH) -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL  krn_connect.c

krn_eqneval.o:krn_eqneval.c ../include/capsim.h
	cc -c -g $(ARCH) -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL  krn_eqneval.c

krn_eqninit.o:krn_eqninit.c ../include/capsim.h
	cc -c -g $(ARCH) -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL  krn_eqninit.c

krn_eqnmath.o:krn_eqnmath.c ../include/capsim.h
	cc -c -g $(ARCH) -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL  krn_eqnmath.c

krn_eqnsymbol.o:krn_eqnsymbol.c ../include/capsim.h
	cc -c -g $(ARCH) -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL  krn_eqnsymbol.c

krn_expeval.o:krn_expeval.c ../include/capsim.h
	cc -c -g $(ARCH) -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL  krn_expeval.c

krn_file.o:krn_file.c ../include/capsim.h
	cc -c -g $(ARCH) -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL  krn_file.c

krn_getfile.o:krn_getfile.c ../include/capsim.h
	cc -c -g $(ARCH) -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL  krn_getfile.c


krn_main.o:krn_main.c ../include/capsim.h
	cc -c -g $(ARCH) -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL  krn_main.c

krn_parameter.o:krn_parameter.c ../include/capsim.h
	cc -c -g $(ARCH) -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL  krn_parameter.c

krn_prinfo.o:krn_prinfo.c ../include/capsim.h
	cc -c -g $(ARCH) -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL  krn_prinfo.c

krn_run.o:krn_run.c ../include/capsim.h
	cc -c -g $(ARCH) -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL  krn_run.c

krn_star.o:krn_star.c ../include/capsim.h
	cc -c -g $(ARCH) -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL  krn_star.c


krn_sys_calls.o:krn_sys_calls.c ../include/capsim.h
	cc -c -g $(ARCH) -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL  krn_sys_calls.c

krn_list.o:krn_list.c ../include/capsim.h
	cc -c -g $(ARCH) -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL  krn_list.c

krn_tclappinit.o:krn_tclappinit.c ../include/capsim.h
	cc -c -g $(ARCH) -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL  krn_tclappinit.c

krn_tcl.o:krn_tcl.c ../include/capsim.h
	cc -c -g $(ARCH) -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL  krn_tcl.c

krn_tclinvoke.o:krn_tclinvoke.c ../include/capsim.h
	cc -c -g $(ARCH) -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL  krn_tclinvoke.c




krn_traverse.o:krn_traverse.c ../include/capsim.h
	cc -c -g $(ARCH) -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL  krn_traverse.c



libkrn.a:krn_arguments.o krn_block.o krn_buffer.o krn_command.o krn_connect.o krn_eqneval.o krn_eqninit.o krn_eqnmath.o krn_eqnsymbol.o krn_expeval.o krn_file.o krn_getfile.o  krn_main.o krn_parameter.o krn_prinfo.o krn_run.o krn_star.o  krn_sys_calls.o krn_tclappinit.o krn_tcl.o krn_tclinvoke.o    krn_traverse.o  krn_list.o
	ar -r libkrn.a krn_arguments.o krn_block.o krn_buffer.o krn_command.o krn_connect.o krn_eqneval.o krn_eqninit.o krn_eqnmath.o krn_eqnsymbol.o krn_expeval.o krn_file.o krn_getfile.o krn_main.o krn_parameter.o krn_prinfo.o krn_run.o krn_star.o  krn_sys_calls.o krn_tclappinit.o krn_tcl.o krn_tclinvoke.o    krn_traverse.o  krn_list.o
	ranlib  libkrn.a 
	cp libkrn.a ../LIBS


clean:
	rm *.o ; rm *.a
