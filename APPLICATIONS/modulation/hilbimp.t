
# topology file:  hilbimp.t

arg -1 (none)

param int 1024
block impulse0 impulse

block node0 node

param int 8
block hilbert0 hilbert

param int 128
block delay0 delay

param int 1024
param int 0
param file PLOT
param int 0
param int 0
param int 1
param int 1
param float 0
param int 1
block spectrum0 spectrumtxt

param int 1024
param int 0
param file PLOT
param file X
param file Y
param int 1
param int 1
block plot0 plot

connect impulse0 0 node0 0  	
connect node0 0 hilbert0 0  	
connect node0 1 delay0 0  	
connect hilbert0 0 spectrum0 0  	
connect delay0 0 plot0 1  	
connect spectrum0 0 plot0 0  	

