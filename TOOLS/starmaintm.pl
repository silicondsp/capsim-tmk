$first=1;

foreach $f (@ARGV) {

  if($first==1) {
     $first=0;

  } else {

    print "perl starmaint.pl a $f","\n";
    system("perl ../TOOLS/starmaint.pl a $f");


  } 



}
