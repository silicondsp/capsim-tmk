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

$count=0;
$file=">blocks.mak";

open(MAKEFILE,$file) || die "Could not open $file \n";

print MAKEFILE "all:libblock.a \n\n";

#print MAKEFILE "\$CAPSIM=\$(CAPSIM)\n\n";

$XSL= "\tjava -jar saxon.jar ";
$XSL= "\t\$(CAPSIM)/BIN/Xalan ";


@blockObjects= ();
foreach $i (@ARGV) {


  @blockA= split /\./, $i;
  $blockName = $blockA[0];

  $blockObj=$blockName.".o";

  push(@blockObjects, $blockObj);

  print $blockName,"\n";


  print MAKEFILE $blockName,".c",":",$blockName,".s","\n";
  print MAKEFILE "\tjava -jar \$(CAPSIM)/TOOLS/saxon.jar ",$blockName,".s"," \$(CAPSIM)/TOOLS/blockgen.xsl",">",$blockName,".c", "\n";
#  print MAKEFILE $XSL,$blockName,".s"," blockgen.xsl",">",$blockName,".c", "\n";
  print MAKEFILE "\tperl \$(CAPSIM)/TOOLS/blockmaint.pl a ",$blockName,".s","\n";
  
  print MAKEFILE "\n";

  print MAKEFILE $blockName,".o",":",$blockName,".c","\n";
  print MAKEFILE "\tcc -c -g  -I\$(CAPSIM)/include -I\$(CAPSIM)/include/TCL -I../include ",$blockName,".c","\n";
 
  print MAKEFILE "\n";


} 
print MAKEFILE "libblock.a:";
foreach $i (@blockObjects) {
     print MAKEFILE $i," "; 
}
print MAKEFILE "\n";
print MAKEFILE "\tar -r libblock.a ";
foreach $i (@blockObjects) {
     print MAKEFILE $i," "; 
}
   
print MAKEFILE "\n";
print MAKEFILE "\tranlib libblock.a\n";
close MAKEFILE;
   
