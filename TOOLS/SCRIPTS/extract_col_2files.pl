foreach $file (@ARGV) {

     print "FILE $file is it \n";

}


if($#ARGV != 1 ) {
    print "Need two files \n";

}

$file1= $ARGV[0];
$file2= $ARGV[1];

print "Reading $file1 and $file2 \n";
print "args=",$#ARGV," \n";


   open(FILE1,$file1) || die "Could not open file1!\n";
   open(FILE2,$file2) || die "Could not open file2!\n";
#   open(TEMP_TOPOLOGY,">temp.t") || die "Could not open temp topology!\n";

@col1_f1=();
@col1_f2=();
while(<FILE1>) {
     split;
     push(@col1_f1,$_[0]);
}

while(<FILE2>) {
     split;
     push(@col1_f2,$_[0]);
}

for($i=0; $i<=$#col1_f1; $i++) {

  print $col1_f1[$i],"\t",$col1_f2[$i],"\n";

}


close(FILE1);
close(FILE2);


