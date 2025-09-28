
$count=0;
$file=">stars.mak";

open(MAKEFILE,$file) || die "Could not open $file \n";

print MAKEFILE "all:libstar.a \n\n";

@starObjects= ();
foreach $i (@ARGV) {


  @starA= split /\./, $i;
  $starName = $starA[0];

  $starObj=$starName.".o";

  push(@starObjects, $starObj);

  print $starName,"\n";


  print MAKEFILE $starName,".c",":",$starName,".s","\n";
  print MAKEFILE "\tperl /opt/BCUBED/TOOLS/stargazem.pl ",$starName,".s","\n";
  
  print MAKEFILE "\n";

  print MAKEFILE $starName,".o",":",$starName,".c","\n";
  print MAKEFILE "\tcc -c -I./include  ",$starName,".c","\n";
 
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
   
