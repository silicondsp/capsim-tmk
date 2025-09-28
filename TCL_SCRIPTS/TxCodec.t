
# topology file:  TxCodec.t

arg 0 int 2200 "Number of samples"
arg 1 float 64000 "Sampling Rate"

param arg 0
param float 1
param int 8
param int 2
param int 0
param float 0
param float 1
param int 128
block pulse0 pulse

param int 3
param int 3
param arg 1
param float 0.1
param float 35
param float 3400
param float 4400
param float 220
param float 3400
param float 10
param float 4400
block iirfil0 iirfil

param int 4
block hold0 hold

param int 13
param float 2
block atod0 atod

param int 0
block mulaw0 mulaw

connect pulse0 0 hold0 1  	
connect input 0 iirfil0 0   	
connect iirfil0 0 hold0 0  	
connect hold0 0 atod0 0  	
connect atod0 0 mulaw0 0  	
connect mulaw0 0 output 0  	

