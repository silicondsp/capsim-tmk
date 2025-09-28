#
# Precapsim shell script
#
# written by Sasan H. Ardalan
# June 6, 1989.
#
# usage: precapsim flag star1 star2 star3 ...
# where flag is one of the following:
#
#  no flag: stargaze and compile each star and add to library. 
#	    Create custom capsim with stars included.
#  -s:	    stargaze and compile only.
#  -a: 	    add star object file  to library and create custom capsim
#  -l:	    link only. Creates custom capsim.
#  -d:	    delete the stars.
#  -dl:	    delete the stars and create custom capsim
#
# Note: stars should not have suffix. Example,
# 	precapsim -s add mixer filter
#

CC=gcc 
#CFLAG=  -m64
#CFLAG= -m32 
CFLAG= 

let delFlag=0
let gazeOnlyFlag=0
let addFlag=0
#LOAD =  -m elf_i386 --libdir=/usr/lib -L/usr/lib  -L$(top_srcdir)/lib-linux   -lm /usr/lib/libm.a
#LOAD = -L/usr/lib64 -lm .configure --prefix=/usr   --libdir=/usr/lib64    
LOAD =  -L$CAPSIM/LIBS -lm     

LDX11_MOTIF= -dn   -L/usr/X11R6/lib64/  -lXm   -lXt -lXext -lX11  

SUBS=  
echo $CAPSIM

#
# check to see if STARS directory present. If not create it and put a star in it.
#
if [ -e STARS ]; then
        echo STARS directory exists
else
        echo Creating STARS directory
        mkdir STARS
        cp $CAPSIM/TOOLS/FILES/zdummy.s ./STARS/zdummy.s
fi

#
# check to see if sm.dat present. If not copy it from $CAPSIM/STARS
#
if [ -e STARS/sm.dat ]; then
        echo STARS/sm.dat exists
else
        echo Since star data base does not exist it will be copied
        echo from the STARS directory
        cp $CAPSIM/STARS/sm.dat ./STARS
fi


#
# check to see if libstar.a exists
#

if [ -e STARS/libstar.a ]; then
        echo STARS/libstar.a exists
else
        echo Create libstar.a
        cd STARS
        perl $CAPSIM/TOOLS/starmake.pl *.s
        make -f stars.mak
fi


#
# check to see if krn_starlib.c is  present. If not create it.
#
if [ -e STARS/krn_starlib.c ]; then
        echo krn_starlib.c exists
#	cp STARS/krn_starlib.c .
else
        echo Creating krn_starlib.c
	cd STARS
        perl $CAPSIM/TOOLS/starmaint.pl g 
#	cp krn_starlib.c ..
        cd ..
fi



#
# check to see if libstar.a is  present. If it is not create an empty one 
#
if [ -e STARS/libstar.a ]; then
	LIBSTAR=STARS/libstar.a
else
	LIBSTAR=
fi

#
# check to see if SUBS directory is  present. If not 
# make it and copy contents of  $CAPSIM/TOOLS/SUBS to it.
#
if [ -e SUBS ]; then
        echo SUBS directory exists
else
        echo Since SUBS dircetory does not exist  it will be created
        echo and files copied to it 
        mkdir SUBS
       cp $CAPSIM/TOOLS/SUBS/dummy2.c  SUBS/.
       cp $CAPSIM/TOOLS/SUBS/Makefile  SUBS/.
        cd SUBS
        make
        cd ..
fi

#
# check to see if  Makefile is present. If not copy it. 
#
if [ -e Makefile ]; then
        echo Makefile exists
else
        echo  Makefile will be copied
       echo cp $CAPSIM/TOOLS/Makefile .
       cp $CAPSIM/TOOLS/Makefile .
fi


#
# check to make sure no .s extentions are used
# also check to see if star source exists
#
for i in "$@" ; do  
	if [ $i == "*.s" ];  then
	    echo \.s extension not allowed in $i.
	    exit
	fi
#	if [ $i != -* ] && [ $i != *.[oa] ]; then
	if  [ -n $(echo $i | grep  '^-*' ) ] && [ -n $(echo $i | grep '*.o' ) ] && [ -n $(echo $i || grep '*.a' ) ];  then
            echo ;
                
        else 

	 	if ! [ -e $i.s ];  then
		      echo The star source $i.s does not exist!
		      exit
		fi

	fi
	if [ $i = "*.[oa]" ]; then
		SUBS="$SUBS"' '$i
		echo $SUBS
	fi

done

for i in "$@" ; do  

	case $i in 
           -l)
		echo link only 
		let gazeOnlyFlag=0;;
	   -s)
		echo stargaze and compile only 
		let gazeOnlyFlag=1;;
	   -d)
		echo delete stars 
		let gazeOnlyFlag=1
		set delFlag = 1;;

	  -dl)
		echo delete stars and link 
		delFlag=1;;

	  -a)
		echo add star object file to library and link 
		addFlag=1;;
	
          *)	
		if( ($i =~ -*) ) then
		    echo Bad flag: $i
		    exit
		fi
		if( $i =~ *.[ao]) then
			echo also linking to: $i 
                fi
		if ($delFlag == 1) then 
			echo $CAPSIM/TOOLS/starmaint delete $i
			perl $CAPSIM/TOOLS/starmaint.pl d $i
			ar dv libstar.a $i.o
			ranlib libstar.a
                fi
		if ($addFlag != 1) then
		   perl $CAPSIM/TOOLS/stargazem.pl $i.s
		   echo $CC -g -c $i.c
		   $CC $CFLAG  -g -c  $i.c
		   if ( $status ) then
			echo C compilation errors in $1.c
			exit
		   fi
		fi

		if [ $gazeOnlyFlag -eq 1 ];  then
			perl $CAPSIM/TOOLS/starmaint.pl a $i
			ar rv libstar.a $i.o
			ranlib libstar.a
			/bin/rm $i.c $i.o
			LIBSTAR=STARS/libstar.a
                fi ;;
     esac 
done


if [ $gazeOnlyFlag -eq  0 ]; then
      LIBSTAR=./STARS/libstar.a      
      cd SUBS
      make
      cd ../STARS
      perl $CAPSIM/TOOLS/starmake.pl *.s
      make -f stars.mak 
      cd ..
      $CC $CFLAG -g  -c  -I$CAPSIM/include 
	echo creating custom capsim "->capsim"
#	$CC  $CFLAG -o capsim -g krn_starlib.o \
#	$CAPSIM/LIBS/libkrn.a   $LIBSTAR   SUBS/libsubs.a $SUBS   $CAPSIM/STARS/libstar.a $CAPSIM/LIBS/libsubs.a $CAPSIM/LIBS/libfftw.a $CAPSIM/LIBS/librfftw.a  $CAPSIM/CLAPACK/lapack_LINUX.a $CAPSIM/CLAPACK/blas_LINUX.a $CAPSIM/CLAPACK/tmglib_LINUX.a $CAPSIM/CLAPACK/libI77.a $CAPSIM/CLAPACK/libF77.a $LOAD  
	$CC  $CFLAG -o capsim -g krn_starlib.o $CAPSIM/LIBS/libkrn.a \
	$CAPSIM/STARS/libstar.a ../GRAPHIC/libxcs.a ../ADVUSR/advusr.a \
	../XSTARS/libstar.a \
	../IIP/iip.a ../IIP/plt.a ../IIP/pz.a ../IIP/dsp.a ../IIP/spice.a \
	../IIP/JPEG/libjpeg.a ../IIP/krn.a ../IIP/iipadv.a \
	$LIBSTAR   SUBS/libsubs.a $SUBS    $CAPSIM/LIBS/libsubs.a \
	 ../TRANET/libcn.a $LOAD -ltk8.4 -ltcl8.4   -dn   -L/usr/X11R6/lib64/ -L/usr/lib64/ -ltiff  -lXm   -lXt -lXext -lX11   -lm 
	chmod +x capsim

fi


#	../IIP/TIFF/libtiff.a ../IIP/JPEG/libjpeg.a ../IIP/krn.a ../IIP/iipadv.a \
