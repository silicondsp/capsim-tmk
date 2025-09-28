
while (<>) {
  split;
  $x=$_[0];
  $y=$_[1];
  if($x <= 0) { $x=256-$x; }
  else  { $x=256+$x; }
  if($y <= 0) { $y=256-$y; } 
  else { $y=256+$y; }

  print $x,"\t",$y,"\n";

}
