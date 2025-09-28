
# topology file:  carrpulse.t

arg 0 int 12000 "Number of samples"
arg 1 float 64000 "Sampling Rate"

param arg 0
param float 1
param int 3600
param int 1200
param int 0
param float 0
param float 1
param int 128
block pulse0 pulse

param arg 0
param float 1
param arg 1
param float 1000
param float 0
param float 1
param int 128
block sine1 sine

param float 0.995
block lpf0 lpf

param arg 0
param int 0
param file Baseband
param file Samples
param file Amplitude
param int 1
param int 1
block plot0 plottxt

block mixer0 mixer

block node0 node

param float 64000
param float 1000
param float 0.99
param float 2000
hblock carrec0 carrec.t

block mixer1 mixer

param int 3
param int 1
param arg 1
param float 0.1
param float 35
param float 500
param float 800
param float 220
param float 3400
param float 10
param float 4400
block iirfil0 iirfil

param arg 0
param int 0
param file PLOT
param int 0
param int 0
param int 1
param int 1
param float 0
param int 1
block spectrum0 spectrumtxt

block sink0 sink

connect pulse0 0 lpf0 0  	
connect sine1 0 mixer0 1  	
connect lpf0 0 plot0 0  	
connect plot0 0 mixer0 0  	
connect mixer0 0 node0 0  	
connect node0 0 carrec0 0  	
connect node0 1 mixer1 1  	
connect carrec0 0 mixer1 0  	
connect mixer1 0 iirfil0 0  	
connect iirfil0 0 spectrum0 0  	
connect spectrum0 0 sink0 0  	

