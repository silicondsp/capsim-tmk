$i=0;
while (<>) {
  split;
  print $i,"\t";
  foreach (@_) {

       print $_,"\t";
  }
  print "\n";
  $i=$i+1;

}
