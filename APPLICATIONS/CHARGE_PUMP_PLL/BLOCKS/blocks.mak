all:libblock.a 

addpulse.c:addpulse.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar addpulse.s $(CAPSIM)/TOOLS/blockgen.xsl>addpulse.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a addpulse.s

addpulse.o:addpulse.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include addpulse.c

CHPStateSpace.c:CHPStateSpace.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar CHPStateSpace.s $(CAPSIM)/TOOLS/blockgen.xsl>CHPStateSpace.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a CHPStateSpace.s

CHPStateSpace.o:CHPStateSpace.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include CHPStateSpace.c

DBN.c:DBN.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar DBN.s $(CAPSIM)/TOOLS/blockgen.xsl>DBN.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a DBN.s

DBN.o:DBN.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include DBN.c

gensig.c:gensig.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar gensig.s $(CAPSIM)/TOOLS/blockgen.xsl>gensig.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a gensig.s

gensig.o:gensig.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include gensig.c

VCO.c:VCO.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar VCO.s $(CAPSIM)/TOOLS/blockgen.xsl>VCO.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a VCO.s

VCO.o:VCO.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include VCO.c

zdummy.c:zdummy.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar zdummy.s $(CAPSIM)/TOOLS/blockgen.xsl>zdummy.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a zdummy.s

zdummy.o:zdummy.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include zdummy.c

libblock.a:addpulse.o CHPStateSpace.o DBN.o gensig.o VCO.o zdummy.o 
	ar -r libblock.a addpulse.o CHPStateSpace.o DBN.o gensig.o VCO.o zdummy.o 
	ranlib libblock.a
