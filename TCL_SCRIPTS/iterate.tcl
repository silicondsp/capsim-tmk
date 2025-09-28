#
# TCL Script that iterates a number of simulations
# The iirtest topology is a sine wave filtered by a low pass IIR filter
# The filtered samples are processed by the "stats" block which computes the 
# RMS value.
# The script stores the results of each run in a list.
# At the end of the iteration loop the results are tabulated.
#
# Author: Sasan Ardalan
# June 25th, 2006
#
 


new
capload iirtest

#turn the printer probe off
to prfile0
parambyname control 0

set freq 0
to sine0
set results [list {}]
for { set i 0}  { $i < 10 } { incr i} {
   set freq [expr $freq+1000]
   puts $freq
   parambyname freq $freq
   run
   puts $stats0_sigma
   lappend results [list $freq $stats0_sigma] 


}
puts -nonewline Freq
puts -nonewline "\t"
puts   RMS

foreach value $results {
   puts  -nonewline [lindex $value 0]
   puts  -nonewline "\t"
   puts   [lindex $value  1]

}

