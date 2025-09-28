#
# convert mac file to unix file 
#
$cr = chr 0x0d;
$lf= chr 0x0a;

while(<>) {

$_ =~ s/$cr/$lf/g;

print $_,"\n";

}
