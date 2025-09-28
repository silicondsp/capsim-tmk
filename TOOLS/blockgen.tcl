
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
#
#
# Block Generator
#

set capsim  $env(CAPSIM)
puts $capsim

toplevel .params


radiobutton .typeSource -text "Source" -value "source" -variable types
radiobutton .typeProcessor -text "Processor" -value "processor" -variable types
radiobutton .typeTerm -text "Terminator" -value "term" -variable types
radiobutton .typeProbe -text "Probe" -value "probe" -variable types





radiobutton .bufferFloat -text "Float" -value "float" -variable buffers
radiobutton .bufferComplex -text "Complex" -value "complex" -variable buffers
radiobutton .bufferInt -text "Integer (32 bit)" -value "int" -variable buffers
radiobutton .bufferFx -text "Fixed Point (64 bit variable)" -value "fx" -variable buffers
radiobutton .bufferImage -text "Image" -value "image" -variable buffers


button      .generate -text "Generate" -command { generate_proc $capsim }

label  .labelTitle -text "Capsim Simple Block Generation"
label  .labelCopyright -text ""
label  .labelWeb -text ""

label  .labelType -text "Block Type"
label  .labelBuffer -text "Buffer Type"

label  .labelBlockName -text "Enter Block Name:"
entry .blockNameEntry -width 20

#
# Parameter Dialog
#

# Scrolled listbox for parameters list.
listbox .params.paramList -height 10 -width 60 -yscrollcommand ".params.scrl set"

scrollbar .params.scrl -command ".params.paramList yview"

label  .params.labelPrompt -text "Enter Parameter Prompt:"
entry .params.paramPromptEntry -width 60
label  .params.labelValue -text "Enter Default Parameter Value:"
entry .params.paramValueEntry -width 60
label  .params.labelName -text "Enter Parameter Name:"
entry .params.paramNameEntry -width 20


label  .params.labelType -text "Parameter Type"


radiobutton .params.float -text "float" -value "float" -variable paramType
radiobutton .params.int -text "int" -value "int" -variable paramType
radiobutton .params.string -text "string" -value "string" -variable paramType
radiobutton .params.file -text "file" -value "file" -variable paramType
radiobutton .params.array -text "array" -value "array" -variable paramType

button      .params.add -text "Add Parameter" -command { addParam_proc }
button      .params.delete -text "Delete Parameter" -command { deleteParam_proc }

button      .params.save -text "Save" -command { saveParams_proc}
button      .params.restore -text "Restore" -command {restoreParams_proc }



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


proc addParam_proc { } {
global .params.paramList
global .params.paramValueEntry
global .params.paramPromptEntry
global paramType

puts $paramType


puts [.params.paramPromptEntry get]
puts [.params.paramValueEntry get]

set listElement $paramType
append listElement ";"
append listElement [.params.paramNameEntry get]
append listElement ";"
append listElement [.params.paramValueEntry get]
append listElement ";"
append listElement [.params.paramPromptEntry get]

.params.paramList insert end $listElement


}

proc generate_check_proc { } {
global types
global buffers

puts $types

puts $buffers
puts [.blockNameEntry get]


}


proc saveParams_proc { } {
global .params.paramList

set fileid [ open "params.sav" "w"]

set listSize [.params.paramList size]

for { set i 0} { $i < $listSize} { incr i} {
      set paramItems [.params.paramList get $i]

      puts $fileid $paramItems



}

close $fileid

}

proc deleteParam_proc { } {
global .params.paramList

  set indx [.params.paramList curselection]

  .params.paramList delete $indx

}



proc restoreParams_proc { } {
global .params.paramList

set filename "params.sav"

if { [file readable $filename ] } {
   set fileid [open $filename "r"]
   while { [ gets $fileid data ] >= 0 } {
       # Process data
       #
       .params.paramList insert end $data
       puts $data

   }
   close $fileid
}

}


proc generate_proc { capsim_path } {
global types
global buffers
global .params.paramList

set fileid [ open "blockgen.dat" "w"]


set line "block="
append line  [.blockNameEntry get]
puts $fileid $line


set line "type="
append line $types
puts $fileid $line

set line "buffer="
append line $buffers
puts $fileid $line

set listSize [.params.paramList size]

puts $fileid "parameters"

puts $fileid $listSize
for { set i 0} { $i < $listSize} { incr i} {
      set paramItems [.params.paramList get $i]

      puts $fileid $paramItems
}

close $fileid



#exec_cmd { perl "/usr/local/CAPSIM/TOOLS/blockgen.pl" }
set blockgenscript $capsim_path 
append blockgenscript "/TOOLS/blockgen.pl"
puts $blockgenscript
set thecommand "perl "
append thecommand $blockgenscript
puts $thecommand
exec_cmd  $thecommand 

set fileName [.blockNameEntry get]
append fileName  ".s"

if { [file readable $fileName ] } {

tk_messageBox -icon info -message "Block was generated" \
   -parent . -title "BlockGen Result" -type ok


}

}




grid config .labelTitle -column 0 -row 0 -sticky w
grid config .labelCopyright -column 0 -row 1 -sticky w
grid config .labelWeb -column 0 -row 2 -sticky w

grid config .labelType -column 0 -row 3 -sticky w

grid  config .typeSource -column 0 -row 4 -sticky w
grid  config .typeProcessor -column 0 -row 5 -sticky w
grid  config .typeTerm -column 0 -row 6 -sticky w
grid  config .typeProbe -column 0 -row 7 -sticky w

grid config .labelBuffer -column 0 -row 8 -sticky w

grid  config .bufferFloat -column 0 -row 9 -sticky w
grid  config .bufferComplex -column 0 -row 10 -sticky w
grid  config .bufferInt -column 0 -row 11 -sticky w
grid  config .bufferFx -column 0 -row 12 -sticky w
grid  config .bufferImage -column 0 -row 13 -sticky w


grid config .labelBlockName -column 0 -row 14 -sticky w
grid  config .blockNameEntry -column 0 -row 15 -sticky w


grid  config .generate -column 0 -row 16 -sticky w


grid config .params.paramList -column 0 -row 0 -sticky w
grid config .params.scrl -column 1 -row 0 -sticky wns

grid  config  .params.add -column 0 -row 1 -sticky w
grid  config  .params.delete -column 2 -row 1 -sticky w

grid config .params.labelPrompt -column 0 -row 2 -sticky w
grid  config .params.paramPromptEntry -column 0 -row 3 -sticky w

grid config .params.labelValue -column 0 -row 4 -sticky w
grid  config .params.paramValueEntry -column 0 -row 5 -sticky w

grid config .params.labelName -column 0 -row 6 -sticky w
grid  config .params.paramNameEntry -column 0 -row 7 -sticky w



grid config .params.labelType -column 0 -row 8 -sticky w

grid  config .params.float -column 0 -row 9 -sticky w
grid  config .params.int -column 0 -row 10 -sticky w
grid  config .params.string -column 0 -row 11 -sticky w
grid  config .params.file -column 0 -row 12 -sticky w
grid  config .params.array -column 0 -row 13 -sticky w



grid  config  .params.save -column 0 -row 14 -sticky w
grid  config  .params.restore -column 2 -row 15 -sticky w



