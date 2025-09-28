all:libblock.a 

buildvec.c:buildvec.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar buildvec.s $(CAPSIM)/TOOLS/blockgen.xsl>buildvec.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a buildvec.s

buildvec.o:buildvec.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include buildvec.c

MLP_NN.c:MLP_NN.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar MLP_NN.s $(CAPSIM)/TOOLS/blockgen.xsl>MLP_NN.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a MLP_NN.s

MLP_NN.o:MLP_NN.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include MLP_NN.c

prvec.c:prvec.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar prvec.s $(CAPSIM)/TOOLS/blockgen.xsl>prvec.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a prvec.s

prvec.o:prvec.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include prvec.c

libblock.a:buildvec.o MLP_NN.o prvec.o 
	ar -r libblock.a buildvec.o MLP_NN.o prvec.o 
	ranlib libblock.a
