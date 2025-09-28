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

$snr=30;
$dataRate=24;
$carrierOffset=100000.0;
$carrierOffsetCorrectionOn=1;
$dcr=0;
$dci=.0;
$autocorrThreshold=0.16;
$adcBits=10;
$rxLevelGain=.1;   #100-0.001

open(AUTO_ANAL,">auto_offset.dat") || die "Could not open auto_offset.dat!\n";


for  ($i=0; $i<101; $i++) {

   $carrierOffset=$i*2000.0;

   $seed00=rand()*100000000;
   $seed00=int($seed00);

   print "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ \n";
   print "Processing $i for seed: $seed00 \n";
   print "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ \n";


   open(TEMPLATE,"corr_thresh_offset.template") || die "Could not open template!\n";
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

   open(AUTOCORR,"auto.dat") || die "Could not open auto.dat!\n";

   
   my $max=-100;
   my $count=0;
   while(<AUTOCORR>) {
      $count++;
      if($count < 160) {
           split;
           $x=$_[0];
           $y=$_[1];
           $mag=$x*$x+$y*$y;
           $mag= sqrt($mag);
           if($mag > $max) {
                $max=$mag;
           }
             #    print $_[0],"  ",$_[1],"\n";
      
      }
   }
   $count=0;
   print AUTO_ANAL $carrierOffset,"\t",$max,"\n";

   close(AUTOCORR);
  

   

}

 close(AUTO_ANAL);




