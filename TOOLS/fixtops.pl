#!/bin/perl
#
#
#
# Written by Sasan Ardalan, Dec.2, 1997
#




print "\n$0\n$DateTime\nConvert PC to Unix!\n==============================================\n";


foreach $f (@ARGV) {


if($flagTrue ==0)  {
     $flag=$f;
}



   {
	#
	# Here we process an individual file
	#
	$file=$f;
	$f="";
	
	$fileFlag=1;



  }
        print "filename name is: $file\n";

#        `mv $file /tmp/zzzz`
        rename($file,"zzzz");

	open (INFILE, "zzzz") || die "could not open infile /tmp/zzzz";
	open (OUTFILE, ">$file") || die "could not open outfile $file";
	while(<INFILE>) {
             s/star/block/;
             s/galaxy/hblock/;
             print (OUTFILE  $_);

	}
   	close (INFILE);
   	close (OUTFILE);

	print "End of script.\n\nDone!\n";

}
	exit;

			

