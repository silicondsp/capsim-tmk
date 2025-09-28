
# topology file:  RxCodec.t

arg 0 int 2200 "Number of samples"
arg 1 float 64000 "Sampling Rate"

param int 1
block mulaw1 mulaw

param int 13
param float 2
block dtoa0 dtoa

param int 3
param int 1
param float 64000
param float 0.1
param float 35
param float 3400
param float 4400
param float 220
param float 3400
param float 10
param float 4400
block iirfil1 iirfil

param int 2200
param int 200
param file dtoa
param int 1
param int 0
param int 1
param int 1
param float 64000
param int 1
block spectrum0 spectrumtxt

connect input 0 mulaw1 0   	
connect mulaw1 0 dtoa0 0  	
connect dtoa0 0 spectrum0 0  	
connect iirfil1 0 output 0  	
connect spectrum0 0 iirfil1 0  	

