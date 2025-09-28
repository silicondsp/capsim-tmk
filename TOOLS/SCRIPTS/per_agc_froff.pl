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

$snr=100.0;
$dataRate=54;
$carrierOffset=100000.0;
$carrierOffsetCorrectionOn=1;
$dcr=0;
$dci=.0;
#$autocorrThreshold=0.16;
#$autocorrThreshold=0.03;
$autocorrThreshold= 4.e-4;
#$autocorrThreshold=8000;
$autocorrThreshold=8.e-3;
#$adcBits=10;
#$adcBits=9;
#$adcBits=18;
#$adcBits=6;
$adcBits=8;
$rxLevelGain=.1;   #100-0.001

$seed00=rand()*100000000;
$seed00=int($seed00);

for  ($i=0; $i<20; $i++) {

   $carrierOffset=$i*10000.0;

   # $seed00=rand()*100000000;
   # $seed00=int($seed00);

   print "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ \n";
   print "Processing $i for seed: $seed00 \n";
   print "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ \n";


   open(TEMPLATE,"e2eagc_new.template") || die "Could not open template!\n";
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
      s/ADC_BITS/$adcBits/;
      s/RX_LEVEL_GAIN/$rxLevelGain/;
 



	print TEMP_TOPOLOGY $_;

   }

   close(TEMPLATE);
   close(TEMP_TOPOLOGY);

   system("../bcubed temp.t");

}





