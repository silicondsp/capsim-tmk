all:libblock.a 

eigen.c:eigen.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar eigen.s $(CAPSIM)/TOOLS/blockgen.xsl>eigen.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a eigen.s

eigen.o:eigen.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include eigen.c

imgrdasc.c:imgrdasc.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar imgrdasc.s $(CAPSIM)/TOOLS/blockgen.xsl>imgrdasc.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a imgrdasc.s

imgrdasc.o:imgrdasc.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include imgrdasc.c

singvaldec.c:singvaldec.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar singvaldec.s $(CAPSIM)/TOOLS/blockgen.xsl>singvaldec.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a singvaldec.s

singvaldec.o:singvaldec.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include singvaldec.c

zdummy.c:zdummy.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar zdummy.s $(CAPSIM)/TOOLS/blockgen.xsl>zdummy.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a zdummy.s

zdummy.o:zdummy.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include zdummy.c

libblock.a:eigen.o imgrdasc.o singvaldec.o zdummy.o 
	ar -r libblock.a eigen.o imgrdasc.o singvaldec.o zdummy.o 
	ranlib libblock.a
