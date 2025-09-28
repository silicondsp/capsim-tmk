
$scale= 1.0;

while (<>) {
  split;
  $x=$_[0]*$scale;
  $y=$_[1]*$scale;

  $x=$x*256;
  $y=$y*256;




  if($x <= 0) { $x=256+$x; }
  else  { $x=256+$x; }
  if($y <= 0) { $y=256+$y; } 
  else { $y=256+$y; }

  print int($x),"\t",int($y),"\n";

}
