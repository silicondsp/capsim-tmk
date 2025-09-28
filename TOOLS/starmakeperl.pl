
$count=0;
$file=">stars.mak";

$capsim= $ENV{'CAPSIM'};

open(MAKEFILE,$file) || die "Could not open $file \n";

print MAKEFILE "all:libstar.a \n\n";

print MAKEFILE "CAPSIM=$capsim\n\n";

@starObjects= ();
foreach $i (@ARGV) {


  @starA= split /\./, $i;
  $starName = $starA[0];

  $starObj=$starName.".o";

  push(@starObjects, $starObj);

  print $starName,"\n";


  print MAKEFILE $starName,".c",":",$starName,".s","\n";
  print MAKEFILE "\tperl \$(CAPSIM)/TOOLS/stargazem.pl ",$starName,".s","\n";
  print MAKEFILE "\tperl \$(CAPSIM)/TOOLS/starmaint.pl a ",$starName,".s","\n";
  
  print MAKEFILE "\n";

  print MAKEFILE $starName,".o",":",$starName,".c","\n";
  print MAKEFILE "\tcc -c -g -m32 -I../include -I\$(CAPSIM)/include  ",$starName,".c","\n";
 
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
print MAKEFILE "\n\tranlib libstar.a ";
   
print MAKEFILE "\n";
close MAKEFILE;
   
