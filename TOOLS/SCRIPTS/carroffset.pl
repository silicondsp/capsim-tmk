$i=0;
$carrOffset=0;
while (<>) {
  $carrOffset=$i*10000.0;
  split;
  print $carrOffset,"\t", abs($carrOffset+$_[0]),"\n";
  $i=$i+1;

}
