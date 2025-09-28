
$count=0;
$file=">c.mak";

open(MAKEFILE,$file) || die "Could not open $file \n";

print MAKEFILE "all:libxcs.a \n\n";


@cObjects= ();
foreach $i (@ARGV) {


  @cA= split /\./, $i;
  $cName = $cA[0];

  $cObj=$cName.".o";

  push(@cObjects, $cObj);

  print $cName,"\n";


  print MAKEFILE $cName,".o",":",$cName,".c","\n";
  print MAKEFILE "\tcc -c -g  -I\$(CAPSIM)/include -I\$(CAPSIM)/include/TCL  ",$cName,".c","\n";
  print MAKEFILE "\n";


} 
print MAKEFILE "libxcs.a:";
foreach $i (@cObjects) {
     print MAKEFILE $i," "; 
}
print MAKEFILE "\n";
print MAKEFILE "\tar -r libxcs.a ";
foreach $i (@cObjects) {
     print MAKEFILE $i," "; 
}
   
print MAKEFILE "\n";
close MAKEFILE;
   
