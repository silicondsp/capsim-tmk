
new

block sine
block stats
connect sine0 stats0

to sine
chp 1 [ expr {sin(3.1415926/4)}]


set x {Done loading script. Type run}
puts $x

for { set i 0} { $i <1000 } {incr i}  {
    chp 1 $i 

    run
    puts $i

}




