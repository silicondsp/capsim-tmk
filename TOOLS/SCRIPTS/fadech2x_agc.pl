#/usr/bin/perl
#
# written by: Sasan Ardalan
# date: October 19, 2001
#
for  ($i=0; $i<1000; $i++) {

   $seed00=rand()*100000000;
   $seed00=int($seed00);
   print "Processing $i for seed: $seed00 \n";

   $seed01=rand()*100000000;
   $seed01=int($seed01);
   print "Processing $i for seed: $seed01 \n";

   $seed10=rand()*100000000;
   $seed10=int($seed10);
   print "Processing $i for seed: $seed10 \n";

   $seed11=rand()*100000000;
   $seed11=int($seed11);
   print "Processing $i for seed: $seed11 \n";

   open(TEMPLATE,"rmsagc2x.template") || die "Could not open template!\n";
   open(TEMP_TOPOLOGY,">temp.t") || die "Could not open temp topology!\n";



   while (<TEMPLATE>) {
	s/CHANNEL_SEED_00/$seed00/;
	s/CHANNEL_SEED_01/$seed01/;
	s/CHANNEL_SEED_10/$seed10/;
	s/CHANNEL_SEED_11/$seed11/;
	print TEMP_TOPOLOGY $_;

   }

   close(TEMPLATE);
   close(TEMP_TOPOLOGY);

   system("./bcubed temp.t");

}





