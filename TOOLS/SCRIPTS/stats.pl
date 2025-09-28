
$n=0;
$sum=0;
while (<>) {
#  split;
#  $magsq=($_[0]*$_[0]+$_[1]*$_[1]);
  $magsq=$_*$_;
  $n=$n+1;
  $sum = $sum+$magsq;

}
 
  print "count=",$n, " sum=", $sum, " rms=", sqrt($sum/$n),"\n";

