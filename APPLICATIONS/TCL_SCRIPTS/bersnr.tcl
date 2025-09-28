#
# TCL Script that tabulates the BER for various SNR's
# The sys-ete-ber.t topology implements a QPSK digital communications link
# The number of bits is different for each SNR 
# The script demonstrates coupling of two different paramters per simulation.
# The script stores the results of each run in a list.
# At the end of the iteration loop the results are tabulated.
#
# Author: Sasan Ardalan
# June 25th, 2006
#

new


set snr { -2 0 2 5  7 }
set bits { 10000 10000 100000 100000 10000000 }


capload sys-ete-snr.t

set berResults [list {}]
foreach snrVal  $snr numbits $bits {
    

    arg 3 int $numbits  "number of bits"
    to setsnr0
    parambyname snr $snrVal
    
    run
    puts -nonewline "$snrVal : $numbits "
    puts "BER=$ecountfap0_ber"
    
    lappend berResults [list $snrVal $ecountfap0_ber ]
    

}

puts [ llength $berResults ]
puts -nonewline SNR
puts -nonewline "\t"
puts   BER

foreach value $berResults {
   puts  -nonewline [lindex $value 0]
   puts  -nonewline "\t"
   puts   [lindex $value  1]

}
