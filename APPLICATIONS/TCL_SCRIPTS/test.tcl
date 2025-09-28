

block sine
block prfile
block stats
connect sine0 prfile0
connect prfile0 stats0

to sine
chp 1 [ expr {sin(3.1415926/4)}]


set x {Done loading script. Type run}
puts $x


