$first=1;

foreach $f (@ARGV) {

#  if($first==1) {
#     $first=0;

# } else {
    print "perl ../../TOOLS/sxmlfix.pl  $f ","\n";
    system("perl ../../TOOLS/sxmlfix.pl $f");


#} 



}
