 #
#	Makefile for libsub.a
#	  ljfaber 7/88



#CFLAGS = -m32  -I../include
CFLAGS =    -I../include

 
libsubs.a : *.c
	gcc -c -g  $(CFLAGS) $?
	ar rv libsubs.a  *.o
	ranlib libsubs.a
	cp libsubs.a ../LIBS/

	
clean:
	  rm *.o; rm *.a
