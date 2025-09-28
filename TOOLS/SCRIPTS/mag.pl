
while (<>) {
  split;
  $mag=sqrt($_[0]*$_[0]+$_[1]*$_[1]);
  print $mag,"\n";

}
