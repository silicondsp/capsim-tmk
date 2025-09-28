
# topology file:  vbmodel.t

arg 0 int 1024 "number of points"

param arg 0
block impulse0 impulse

param int 3
param int 3
param float 38400
param float 0.1
param float 35
param float 3400
param float 4400
param float 220
param float 3400
param float 10
param float 4400
block iirfil0 iirfil

param arg 0
param int 0
param file Filter
param int 1
param int 0
param int 1
param int 1
param float 38.4
param int 1
block spectrum0 spectrum

param float 0.25
param float 0
param int 1
block resmpl0 resmpl

param file vbresp.imp
param int 1
block prfile0 prfile

param int 256
param int 0
param file PLOT
param int 1
param int 0
param int 1
param int 1
param float 9.6
param int 1
block spectrum1 spectrum

connect impulse0 0 iirfil0 0  	
connect iirfil0 0 spectrum0 0  	
connect spectrum0 0 resmpl0 0  	
connect resmpl0 0 prfile0 0  	
connect prfile0 0 spectrum1 0  	

