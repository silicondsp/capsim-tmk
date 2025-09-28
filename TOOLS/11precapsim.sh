#
# Copyright (C) 1989-2017 Silicon DSP Corporation
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation; either version 2 of the License, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#
# http://www.silicondsp.com
#


#
# Precapsim shell script
#
# written by Sasan H. Ardalan
# June 6, 1989.
#
# usage: precapsim flag block1 block2 block3 ...
# where flag is one of the following:
#
#  no flag: blockGen and compile each block and add to library. 
#	    Create custom capsim with blocks included.
#  -s:	    blockGen and compile only.
#  -a: 	    add block object file  to library and create custom capsim
#  -l:	    link only. Creates custom capsim.
#  -d:	    delete the blocks.
#  -dl:	    delete the blocks and create custom capsim
#
# Note: blocks should not have suffix. Example,
# 	precapsim -s add mixer filter
#

CC=gcc 
#CFLAG=  -m64
#CFLAG= -m32 
CFLAG= 

let delFlag=0
let genCodeOnlyFlag=0
let addFlag=0
#LOAD =  -m elf_i386 --libdir=/usr/lib -L/usr/lib  -L$(top_srcdir)/lib-linux   -lm /usr/lib/libm.a
#LOAD = -L/usr/lib64 -lm .configure --prefix=/usr   --libdir=/usr/lib64    
LOAD =  -L$CAPSIM/LIBS -lm     

LDX11_MOTIF= -dn   -L/usr/X11R6/lib64/  -lXm   -lXt -lXext -lX11  

SUBS=  
echo $CAPSIM

#
# check to see if BLOCKS directory present. If not create it and put a block in it.
#
if [ -e BLOCKS ]; then
        echo BLOCKS directory exists
else
        echo Creating BLOCKS directory
        mkdir BLOCKS
        cp $CAPSIM/TOOLS/FILES/zdummy.s ./BLOCKS/zdummy.s
fi

#
# check to see if blockdatabase.dat present. If not copy it from $CAPSIM/BLOCKS
#
if [ -e BLOCKS/blockdatabase.dat ]; then
        echo BLOCKS/blockdatabase.dat exists
else
        echo Since block data base does not exist it will be copied
        echo from the BLOCKS directory
        cp $CAPSIM/BLOCKS/blockdatabase.dat ./BLOCKS
fi


#
# check to see if libblock.a exists
#

if [ -e BLOCKS/libblock.a ]; then
        echo BLOCKS/libblock.a exists
else
        echo Create libblock.a
        cd BLOCKS
        perl $CAPSIM/TOOLS/blockmake.pl *.s
        make -f blocks.mak
fi


#
# check to see if krn_blocklib.c is  present. If not create it.
#
if [ -e BLOCKS/krn_blocklib.c ]; then
        echo krn_blocklib.c exists
#	cp BLOCKS/krn_blocklib.c .
else
        echo Creating krn_blocklib.c
	cd BLOCKS
        perl $CAPSIM/TOOLS/blockmaint.pl g 
#	cp krn_blocklib.c ..
        cd ..
fi



#
# check to see if libblock.a is  present. If it is not create an empty one 
#
if [ -e BLOCKS/libblock.a ]; then
	LIBSTAR=BLOCKS/libblock.a
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
# also check to see if block source exists
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
		      echo The block source $i.s does not exist!
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
		let genCodeOnlyFlag=0;;
	   -s)
		echo blockGen and compile only 
		let genCodeOnlyFlag=1;;
	   -d)
		echo delete blocks 
		let genCodeOnlyFlag=1
		set delFlag = 1;;

	  -dl)
		echo delete blocks and link 
		delFlag=1;;

	  -a)
		echo add block object file to library and link 
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
			echo $CAPSIM/TOOLS/blockmaint delete $i
			perl $CAPSIM/TOOLS/blockmaint.pl d $i
			ar dv libblock.a $i.o
			ranlib libblock.a
                fi
		if ($addFlag != 1) then
		   perl $CAPSIM/TOOLS/blockGenm.pl $i.s
		   echo $CC -g -c $i.c
		   $CC $CFLAG  -g -c  $i.c
		   if ( $status ) then
			echo C compilation errors in $1.c
			exit
		   fi
		fi

		if [ $genCodeOnlyFlag -eq 1 ];  then
			perl $CAPSIM/TOOLS/blockmaint.pl a $i
			ar rv libblock.a $i.o
			ranlib libblock.a
			/bin/rm $i.c $i.o
			LIBSTAR=BLOCKS/libblock.a
                fi ;;
     esac 
done


if [ $genCodeOnlyFlag -eq  0 ]; then
      LIBSTAR=./BLOCKS/libblock.a      
      cd SUBS
      make
      cd ../BLOCKS
      perl $CAPSIM/TOOLS/blockmake.pl *.s
      make -f blocks.mak 
      cd ..
	echo creating custom capsim "->capsim"
	$CC  $CFLAG -o capsim -g  krn_blocklib.o $CAPSIM/LIBS/libkrn.a \
	$CAPSIM/BLOCKS/libblock.a \
	$LIBSTAR   SUBS/libsubs.a $SUBS    $CAPSIM/LIBS/libsubs.a \
	 $CAPSIM/CLAPACK/lapack_LINUX.a $CAPSIM/CLAPACK/blas_LINUX.a   $CAPSIM/CLAPACK/libf2c.a   \
	 $LOAD -L$CAPSIM/TCL_SUPPORT  $CAPSIM/TCL_SUPPORT/libtcl84.a $CAPSIM/MSYS2_LIBTIFF/tiff-3.8.2/libtiff.a   -L$CAPSIM/LIBS/   -ljpeg -lz  -lm 
# 	 $LOAD -L$CAPSIM/TCL_SUPPORT  ../TCL_SUPPORT/libtcl84.a ../LIBS/libtiff-3.dll   -L$CAPSIM/LIBS/ -lm 

	chmod +x capsim

fi

 
