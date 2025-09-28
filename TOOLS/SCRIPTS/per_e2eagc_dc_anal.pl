#/usr/bin/perl
#
# written by: Sasan Ardalan
# date: October 8, 2004
#
system("rm rxhdlc.dat");
system("rm coarse.dat");
system("rm finecoarse.dat");

#$noisePower=0.000000000002;
$noisePower=0.00000000000;

$snr=100;
$dataRate=24;
$carrierOffset=500.0;
$carrierOffsetCorrectionOn=1;
$dcr=20;
$dci=.0;
$autocorrThreshold=0.12;

for  ($i=0; $i<201; $i++) {

   $carrierOffset=$i*1000.0;

   $seed00=rand()*100000000;
   $seed00=int($seed00);

   print "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ \n";
   print "Processing $i for seed: $seed00 \n";
   print "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ \n";


   open(TEMPLATE,"e2eagc.template") || die "Could not open template!\n";
   open(TEMP_TOPOLOGY,">temp.t") || die "Could not open temp topology!\n";



   while (<TEMPLATE>) {
	s/NOISE_SEED/$seed00/;
      s/SNR/$snr/;
      s/DATA_RATE/$dataRate/;
      s/CARRIER_OFFSET/$carrierOffset/;
      s/TURN_OFFSET_CORR_ON/$carrierOffsetCorrectionOn/;
      s/DC_R/$dcr/;
      s/DC_I/$dcr/;
      s/AUTOCORR_THRESHOLD/$autocorrThreshold/;



	print TEMP_TOPOLOGY $_;

   }

   close(TEMPLATE);
   close(TEMP_TOPOLOGY);

   system("../bcubed temp.t");

}





