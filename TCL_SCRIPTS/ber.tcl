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

#set noiseLevel { 0.2 0.25 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 }
#set bits {1000000 1000000 1000000 1000000 1000000 1000000 1000000 100000 100000 100000}

set noiseLevel { 0.8  0.9 1.0 }
set bits { 100000 100000 100000}


capload sys-ete-ber.t

set berResults [list {}]
foreach noise  $noiseLevel numbits $bits {
    

    arg 3 int $numbits  "number of bits"
    to addnoise0
    parambyname power $noise
    
    run
    puts -nonewline "$noise : $numbits "
    puts "BER=$ecountfap0_ber"
    
    lappend berResults [list $noise $ecountfap0_ber ]
    

}

puts [ llength $berResults ]
puts -nonewline Noise
puts -nonewline "\t"
puts   BER

foreach value $berResults {
   puts  -nonewline [lindex $value 0]
   puts  -nonewline "\t"
   puts   [lindex $value  1]

}