
# topology file:  filter.t

arg -1 (none)

param int 512
block impulse0 impulse

param int 3
param int 3
param float 64000
param float 0.1
param float 35
param float 3400
param float 4400
param float 220
param float 3400
param float 10
param float 4400
block iirfil0 iirfil

param int 512
param int 0
param file Filter
param int 1
param int 0
param int 1
param int 1
param float 64
param int 1
block spectrum0 spectrum

connect impulse0 0 iirfil0 0  	
connect iirfil0 0 spectrum0 0  	

