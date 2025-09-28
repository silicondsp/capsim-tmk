 #
#	Makefile for libsub.a
#	  ljfaber 7/88



CFLAGS = 

 
libfxsubs.a : *.c
	gcc -c    $(CFLAGS) $?
	ar rv  libfxsubs.a  *.o
	ranlib libfxsubs.a
	cp libfxsubs.a ../LIBS/
	rm *.o	

	

