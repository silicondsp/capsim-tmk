all:libstar.a 

*.c:*.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar *.s $(CAPSIM)/TOOLS/blockgen.xsl>*.c
	perl $(CAPSIM)/TOOLS/starmaint.pl a *.s

*.o:*.c
	cc -c -g  -I$(CAPSIM)/include  *.c

libstar.a:*.o 
	ar -r libstar.a *.o 
