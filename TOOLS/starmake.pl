
$count=0;
$file=">stars.mak";

open(MAKEFILE,$file) || die "Could not open $file \n";

print MAKEFILE "all:libstar.a \n\n";

#print MAKEFILE "\$CAPSIM=\$(CAPSIM)\n\n";

$XSL= "\tjava -jar saxon.jar ";
$XSL= "\t\$(CAPSIM)/BIN/Xalan ";


@starObjects= ();
foreach $i (@ARGV) {


  @starA= split /\./, $i;
  $starName = $starA[0];

  $starObj=$starName.".o";

  push(@starObjects, $starObj);

  print $starName,"\n";


  print MAKEFILE $starName,".c",":",$starName,".s","\n";
  print MAKEFILE "\tjava -jar \$(CAPSIM)/TOOLS/saxon.jar ",$starName,".s"," \$(CAPSIM)/TOOLS/blockgen.xsl",">",$starName,".c", "\n";
#  print MAKEFILE $XSL,$starName,".s"," blockgen.xsl",">",$starName,".c", "\n";
  print MAKEFILE "\tperl \$(CAPSIM)/TOOLS/starmaint.pl a ",$starName,".s","\n";
  
  print MAKEFILE "\n";

  print MAKEFILE $starName,".o",":",$starName,".c","\n";
  print MAKEFILE "\tcc -c -g  -I\$(CAPSIM)/include -I\$(CAPSIM)/include -I../include ",$starName,".c","\n";
 
  print MAKEFILE "\n";


} 
print MAKEFILE "libstar.a:";
foreach $i (@starObjects) {
     print MAKEFILE $i," "; 
}
print MAKEFILE "\n";
print MAKEFILE "\tar -r libstar.a ";
foreach $i (@starObjects) {
     print MAKEFILE $i," "; 
}
   
print MAKEFILE "\n";
close MAKEFILE;
   
