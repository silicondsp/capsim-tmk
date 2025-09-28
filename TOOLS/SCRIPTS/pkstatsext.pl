# preamble:variance=

@dataSigs=();
@preamSigs=();

while (<>) {
  chop;
  if(/preamble:variance=/) {
#     print $_;
     split(";");
     $_=$_[1];
     split("=");
#     print "extracted sigma=",$_[1];
     $sigmaPreamble=$_[1];
     push(@preamSigs,$sigmaPreamble);

  }
  if(/data:variance=/) {
#     print $_;
     split(";");
     $_=$_[1];
     split("=");
#     print "extracted data sigma=",$_[1];
     $sigmadata=$_[1];
     push(@dataSigs,$sigmadata);
                                                                                
  }

}
for ($j=0; $j<$#preamSigs; $j++) {
    print $preamSigs[$j],"\t",$dataSigs[$j],"\n";


}
