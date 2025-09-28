
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
#
# Block Makefile Builder 
# Other operations necessary for building executable
#


set capsim  $env(CAPSIM)
puts $capsim

 


# Scrolled listbox for custom block list.
listbox .list -height 10 -yscrollcommand ".scrl set"

# Scrolled listbox for custom block list.
listbox .listSupplied -height 10 -yscrollcommand ".scrlSupplied set"

# Scrolled listbox for custom blocks in current directory  list.
listbox .listUserStars -height 10 -yscrollcommand ".scrlUserStars set"


button .addButton -text "Add Block" -command { add_star }
button .delButton -text "Delete Block" -command { delete_star { .list } }
button .addSuppliedButton -text "<- Add" -command { supplied_to_custom $capsim }
button .viewSourceButton -text "View Source Code" -command { view_star_source }
button .viewCCodeButton -text "View C  Code" -command { view_star_ccode }
button .refreshButton -text "Refresh" -command { refresh_star_list $capsim }
button .makeButton -text "Make Library" -command { make_library $capsim }
button .refreshStarCodeButton -text "Refresh Blocks" -command { refresh_star_code_list }



entry .starNameEntry -width 20

entry .editorNameEntry -width 20




label  .labelTitle -text "Block Management"
label  .labelCopyright -text ""
label  .labelWeb -text ""



label  .labelSupplied -text "Supplied Blocks"
label  .labelCustom -text " Custom Build Blocks"
label  .labelStarName -text "Star Name"
label  .labelUserStars -text "Current Directory Blocks"

label  .labelEditor -text "Editor"



bind  all <<ListboxSelect>> { list_select_event }


# Procedure to launch commands, Foster and Johnson

proc exec_cmd { command} {
  set result ""
  
  #Grab first argument as command.
  
  set check_cmd [lindex $command 0]
  
  set cmd [info commands $check_cmd]
  
  if { [string length $cmd] > 0} {
     # Command is a Tcl procedure.
        set result [eval $command]
  } else {
         # not a Tcl procedure, so exec it.
           set result [eval exec $command]
  }
  return $result
 
}
           
# cmdexec.tcl


# Procedure to return selected list item, Foster and Johnson

proc list_selected { listname} {
  global .list
  set indx [.list curselection]
  if { $indx != "" } {
      set item [.list get $indx]
      return $item
  } else {
    return "";
  }
}

# Procedure to return selected list item,

proc delete_star  { listname} {
  global .list
  set star [list_selected  $listname ]
  if { $star == "" } {return}
  
  puts "Hey this is what you want to delete ->"
  puts $star
  set theCommand $capsim
  append theCommand "/TOOLS/blockmaint.pl"
  
  set theBlockMaintCommand $theCommand
  append theCommand $star > result.txt
  puts $theCommand 
  
#  exec_cmd { perl $theCommand > result.txt}
  eval exec perl { $theBlockMaintCommand d $star > result.txt }
  eval exec perl { $theBlockMaintCommand g  }



#
# This is a double check to see if blockmaint.pl was really able to delete
#

set fileName result.txt
if { [file readable $fileName ] } {
   set fileid [open $fileName "r"]
   # are we at the end of the file
   set found 0
   while { [ gets $fileid data ] >= 0 } {
       # Process data
       #
       if { [regexp $data /Found:$star/] } { 
          set found 1
           break 
       }   
       
   }
   close $fileid
}

  if { $found == 1} {
     set indx [.list curselection]
    .list  delete $indx
  }
  
  

}
  
# Procedure to add a star in the text entry field

proc add_star  { } {
  global .list
  global .starNameEntry
  
  set star [.starNameEntry get ]
  
  if { $star == "" } {return}
  
  set theCommand $capsim
  append theCommand "/TOOLS/blockmaint.pl"
  
  set theBlockMaintCommand $theCommand
  
  eval exec perl { $theBlockMaintCommand a $star > result.txt }
  eval exec perl { $theBlockMaintCommand g  }



  puts "Hey this is what you want to add ->"
  puts $star
#
# This is a double check to see if starmaint.pl was really able to add
#
set fileName result.txt

if { [file readable $fileName ] } {
   set fileid [open $fileName "r"]
   # are we at the end of the file
   set found 0
   while { [ gets $fileid data ] >= 0 } {
       # Process data
       #
       if {[ regexp $data /Added:$star/ ]}   {
         set found 1
         break
       }   
       puts $data
       
   }
   close $fileid
}

if { $found == 1}  {
     # add star to  the list
     .list insert 0 $star
    
     lsort .list
    
    
  }  

}
# Procedure to add a block from supplied to custom

proc supplied_to_custom  { capsim } {
  global .list
  global .listSupplied
  
  set indx [.listSupplied curselection]
  if { $indx != "" } {
      set star [.listSupplied get $indx]
  } else {
  
  
      set star ""  
  }

  
  
  if { $star == "" } {return}
  
  puts "Hey this is what you want to add from supplied ->"
  puts $star
  
  set theBlockMaintCommand $capsim
  append theBlockMaintCommand "/TOOLS/blockmaint.pl a"
  append theBlockMaintCommand $star
   append theBlockMaintCommand { result.txt }
   set theCommand {perl }
   append theCommand $theBlockMaintCommand
    eval exec $theCommand
 # eval exec perl { $theBlockMaintCommand a $star > result.txt }



#
# This is a double check to see if starmaint.pl was really able to add
#
set fileName result.txt
set found 0
if { [file readable $fileName ] } {
   set fileid [open $fileName "r"]
   # are we at the end of the file
   set found 0
   while { [ gets $fileid data ] >= 0 } {
       # Process data
       #
       puts $data
       if {[ regexp $data /Added:$star/ ]}   {
         set found 1
         break
       }   
       
       
   }
   close $fileid
}

if { $found == 1}  {
     # add star to  the list
     .list insert 0 $star
    
     lsort .list
    
    
  }  

  
  

}

# Procedure to view star source code,

proc view_star_source  { } {
  global .list
  set star [list_selected  .list ]
  if { $star == "" } {
      set star [.starNameEntry get ]
             if { $star == "" } {
  
                    return
             }
      
      
  }
  
  puts "Hey this is what you want to view ->"
  puts $star
  

  
  append star ".s"
  puts $star



  set editor [.editorNameEntry get ]



  if { $editor == "" } {

     set editor "vi"

  }





  #editorNameEntry



  if { ![file readable $star ] } {
  
   set lib_star $capsim
   append lib_star "/BLOCKS"

  
     
     append lib_star $star

       eval exec { $editor }  {   $lib_star  } {& }

  } else {


        eval exec { $editor }  {   $star  } {& }

  }

}

# Procedure to view block C code,

proc view_star_ccode  { } {
  global .list
  set star [list_selected  .list ]
  if { $star == "" } {
      set star [.starNameEntry get ]
             if { $star == "" } {
  
                    return
             }
      
      
  }
  
  puts "Hey this is what you want to view ->"
  puts $star
  
  set starC $star
  
  append star ".s"
  puts $star

  set theBlockMaintCommand $capsim
  append theBlockMaintCommand "/TOOLS/blockmaint.pl"
   
  eval exec perl { $theBlockMaintCommand  $star > result.txt }
  
  append starC ".c"
 

  set editor [.editorNameEntry get ]



  if { $editor == "" } { 

     set editor "vi"

  }



 

  
  eval exec { $editor }  {   $starC  } {& }

}

# Procedure for listbox selection event
# what we do is set the block text entry name to the selected item
# if user block .s selected chop off the .s
#

proc list_select_event  { } {
  global .list
  
  # use %W for widget name
  
  set indx [.listUserStars curselection]
  if { $indx != "" } {
      set star [.listUserStars get $indx]
  } else {
  
  
      set star "" 
      return; 
  }
  
  set starSplit [split $star .]
  set starName [lindex $starSplit 0]
  puts $starName
  
      .starNameEntry delete 0 end
      .starNameEntry insert  0 $starName
      
 
  

}


#
# populate list with blocks custum database (blockdatabase.dat in current directory)
#

proc refresh_star_list  { capsim } {
 
 set theBlockMaintCommand $capsim
  append theBlockMaintCommand "/TOOLS/blockmaint.pl 1 > zzz.dat"
   set theCommand {perl  }
   append theCommand $theBlockMaintCommand

exec_cmd $theCommand

.list delete 0 end

set filename "zzz.dat"

if { [file readable $filename ] } {
   set fileid [open $filename "r"]
   # are we at the end of the file
   while { [ gets $fileid data ] >= 0 } {
       # Process data
       #
       .list insert end $data
       puts $data
       
   }
   close $fileid
}

}

proc make_library  { capsim } {

   #
   # create Makefile for libstar
   # based on all stars in directory
   #
  set theBlockMaintCommand $capsim
  append theBlockMaintCommand "/TOOLS/blockmaint.pl  " 

   set filename "libstar.mak"
   set make_F  [open $filename w]

   puts  $make_F "all: libstar.a"
   puts $make_F " "

   set objects "OBJECTS="
   set libobjs ""


   set files [glob -nocomplain *.s]
   if { $files != "" } {
        foreach filename $files {

		     set starSplit [split $filename .]
             set starName [lindex $starSplit 0]

		     set obj $starName
			 append obj ".o"

		     set ccode $starName
			 append ccode ".c"

			 set ccodedep $ccode

			 append ccodedep " : "
			 append ccodedep  $filename
			 puts $make_F $ccodedep

			 set command {\tperl } 
			 append command $theBlockMaintCommand
			 append command $filename
			 puts $make_F $command
			 puts $make_F " "


             set objdep $obj
			 append objdep  " : "
			 append objdep  $ccode
			 puts $make_F $objdep
			 set command "\tcc -c -g  "
			 append command $ccode
			 puts $make_F $command
			 puts $make_F " "

		     append objects $obj
			 append objects " "

			 set objdep $obj
			 append objdep " : "
			 append objdep  $ccode
			 
			 append libobjs $obj
			 append libobjs " " 

        }
		puts $make_F $objects
		puts $make_F " "

		puts $make_F "libstar.a: \$(OBJECTS)"
		set command "\tar  rv libstar.a "
		append command $libobjs
		puts $make_F $command
		puts $make_F " "

		
		close $make_F
   }






    set theCommand { perl }
    append theCommand $theBlockMaintCommand
    append theCommand { g }
    exec_cmd $theCommand

   # exec_cmd { perl $theBlockMaintCommand g }

    exec_cmd { cc -c -g  krn_blocklib.c      }
    exec_cmd { make  -f libstar.mak }

}


proc refresh_star_code_list { } {
global .listUserStars

.listUserStars delete 0 end


#
# Populate list of user >s files in current directory
#
set files [glob -nocomplain *.s]
if { $files != "" } {
   foreach filename $files {
             puts $filename
             .listUserStars insert end $filename


   }
}


}

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#   Begin Main
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++


#
# check if necessary files are in the directory.
# if not copy them from /usr/local/CAPSIM_TMK 
#

# check for blockdatabase.dat

 
if { ![file readable "blockdatabase.dat" ] } {
set theBlocksPath $capsim
    append theBlocksPath "/BLOCKS/blockdatabase.dat"
    puts "THE BLOCK PATH IS:"
    puts $theBlocksPath


    puts "need to copy blockdatabase.dat"
    set theCommand {cp  }
    append theCommand $theBlocksPath
    append theCommand "  blockdatabase.dat"
    exec_cmd $theCommand

}

 set theMakefilePath $capsim
  append theMakefilePath "/TOOLS/Makefile"

if { ![file readable "Makefile" ] } {
   set theCommand {cp  }
    append theCommand $theMakefilePath
    append theCommand "  Makefile"
    exec_cmd $theCommand


   

}


# check for .capsimrc
 set theCapsimrcPath $capsim
  append theCapsimrcPath "/TOOLS/FILES/.capsimrc"

if { ![file readable ".capsimrc" ] } {

   set theCommand {cp  }
    append theCommand $theCapsimrcPath
    append theCommand "  .capsimrc"
    exec_cmd $theCommand

    

}


# check for Makefile

if { ![file readable "Makefile" ] } {

   set theMakefilePath $capsim
  append theMakefilePath "/TOOLS/Makefile"

    exec_cmd { cp $theMakefilePath  "Makefile"}

}

# check for SUBS directory

if { ![file isdirectory "SUBS" ] } {
    exec_cmd { mkdir  "SUBS" }
    
  set theSUBSPath $capsim
  append theSUBSPath "/TOOLS/SUBS/Makefile SUBS/."
  set theCommand {cp }
  append theCommand $theSUBSPath

    exec_cmd $theCommand
  set theSUBSPath $capsim
  append theSUBSPath "/TOOLS/SUBS/dummy.c SUBS/."
  set theCommand {cp }
  append theCommand $theSUBSPath
    
   exec_cmd $theCommand

}





refresh_star_list $capsim 


#
# populate list with blocks in Supplied database (blocks.dat in Capsim Directory)
#
  set theBlockmaintPath $capsim
  append theBlockmaintPath "/TOOLS/blockmaint.pl l > zzz.dat"
  set theCommand {perl }
  append theCommand $theBlockmaintPath
exec_cmd $theCommand

 set theBlockPath $capsim
  append theBlockPath "/BLOCKS/blocks.dat"


set filename $theBlockPath

if { [file readable $filename ] } {
   set fileid [open $filename "r"]
   # are we at the end of the file
   while { [ gets $fileid data ] >= 0 } {
       # Process data
       #
       .listSupplied insert end $data


   }
   close $fileid
}

#
# Populate list of user >s files in current directory
#
refresh_star_code_list



scrollbar .scrl -command ".list yview"

scrollbar .scrlSupplied -command ".listSupplied yview"


scrollbar .scrlUserStars -command ".listUserStars yview"


#pack .addButton -side top
#pack .delButton -side top

#pack .scrl -side right -fill y
#pack .list -side left

#pack .scrlSupplied -side right -fill y
#pack .listSupplied -side left




grid config .labelTitle -column 0 -row 0 -sticky w
grid config .labelCopyright -column 0 -row 1 -sticky w
grid config .labelWeb -column 0 -row 2 -sticky w

set rowOffset 4

grid config .labelCustom -column 0 -row 3 -sticky e

grid config .labelSupplied -column 3 -row 3 -sticky e

grid config .labelUserStars -column 5 -row 3 -sticky e



grid config .list -column 0 -row 4 -sticky e
grid config .scrl -column 1 -row 4 -sticky nsw

grid  config .addSuppliedButton -column 2 -row 4 -sticky w



grid config .listSupplied -column 3 -row 4 -sticky e
grid config .scrlSupplied -column 4 -row 4 -sticky ns

grid config .listUserStars -column 5 -row 4 -sticky e
grid config .scrlUserStars -column 6 -row 4 -sticky ns

grid  config .refreshButton -column 0 -row 5 -sticky w

grid  config .addButton -column 0 -row 6 -sticky w
grid config .delButton -column 0 -row 7 -sticky w

grid config .refreshStarCodeButton -column 8 -row 5 -sticky w


grid config .labelStarName -column 2 -row 8 -sticky e
grid  config .starNameEntry -column 3 -row 8 -sticky w


grid  config .viewSourceButton -column 0 -row 9 -sticky w
grid config .viewCCodeButton -column 3 -row 9 -sticky w
grid config .makeButton -column 5 -row 9 -sticky w



grid config .labelEditor -column 2 -row 10 -sticky w

grid config .editorNameEntry -column 3 -row 10 -sticky w











# scrlist.tcl


