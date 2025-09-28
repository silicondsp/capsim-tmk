#/usr/bin/perl
#
# written by: Sasan Ardalan
# date: October 19, 2001
#
@noises=("0.2","0.25","0.3","0.4","0.5","0.6","0.7","0.8","0.9","1.0");
@bits=("1000000","1000000","1000000","1000000","1000000","1000000","1000000","100000","100000","100000");
$k=0;
foreach $noise (@noises) {
   print "Processing $noise  at total bits $bits[$k]\n";

   open(TEMPLATE,"sys-ete-ber.template") || die "Could not open template!\n";
   open(TEMP_TOPOLOGY,">temp.t") || die "Could not open temp topology!\n";



   while (<TEMPLATE>) {
	s/NOISE_LEVEL/$noise/;
	s/BITS/$bits[$k]/;
	print TEMP_TOPOLOGY $_;

   }

   close(TEMPLATE);
   close(TEMP_TOPOLOGY);

#   `../../BIN/capsim temp.t`;
   system("../../BIN/capsim temp.t");

   $k++;
}





