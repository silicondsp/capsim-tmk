all: design

design.o: design.c
	gcc -c design.c  -I/mingw/include 


remez.o: remez.c
	gcc -c remez.c -I/mingw/include 

design: design.o remez.o 
	gcc -o design design.o remez.o -lm



