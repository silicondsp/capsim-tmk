#!/bin/csh
#
# starmaint.csh shell script
#
# written by Sasan H. Ardalan
# October 19, 2001.
# Copyright (c) 1989-2001 XCAD Corporation,
# Raleigh, NC All Rights Reserved
#
# usage: starmaint.csh flag star1 star2 star3 ...
# where flag is one of the following:
#

#  a:      add star  to database
#  l:      list all stars in database
#  d:      delete the stars from database.
#  c:     create a new cs_starlib.c from database
#

set list=0
set add=0
set delete=0
set create=0


foreach i ($argv)

    switch ($i)
        case l:
                echo list
                set list=1
                breaksw
        case a:
        	echo adding stars
        	set add=1
        	breaksw
        case d:
        	echo deleting stars
        	set delete=1
        	breaksw
        case c:
        	echo creating cs_starlib.c
        	set create=1
        	breaksw
        	
        default:

                if($list) then
                	echo    $CAPSIM/starmaint/starmaint l
                	perl $CAPSIM/STARMAINT/starmaint.pl l
                endif

                if($add) then
                        echo  $CAPSIM/starmaint/starmaint a $i
                        perl $CAPSIM/STARMAINT/starmaint.pl a $i
                endif

                if($delete) then
                	echo     $CAPSIM/starmaint/starmaint d $i
                        perl $CAPSIM/STARMAINT/starmaint.pl d $i
                endif
                breaksw

                	
        	
        	

    endsw
end

