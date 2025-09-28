#/usr/bin/perl
#
# written by: Sasan Ardalan
# date: October 19, 2001
#


system("rm packstats.dat");
for  ($i=0; $i<10000; $i++) {

   $seed=rand()*100000000;
   $seed=int($seed);
   print "Processing $i for seed: $seed \n";

   open(TEMPLATE,"fadechannel.template") || die "Could not open template!\n";
   open(TEMP_TOPOLOGY,">temp.t") || die "Could not open temp topology!\n";



   while (<TEMPLATE>) {
	s/CHANNEL_SEED/$seed/;
	print TEMP_TOPOLOGY $_;

   }

   close(TEMPLATE);
   close(TEMP_TOPOLOGY);

   system("../bcubed temp.t");

}





