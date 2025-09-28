
# topology file:  carrierRecovery.t

#--------------------------------------------------- 
# Title:   Carrier Recovery 
# Author:   Sasan Ardalan 
# Date:    
# Description:  DSB-SC Carrier Recovery  
#--------------------------------------------------- 

inform title   Carrier Recovery 
inform author   Sasan Ardalan 
inform date    
inform descrip  DSB-SC Carrier Recovery  

arg 0 int 8000 "Number of samples"
arg 1 float 64000 "Sampling Rate"

param int 100
param int 12
param float 0.00125
param int 100
block bdata0 bdata

param int 0
param int 8
block linecode0 linecode

param int 8
param int 8
param float 0.5
block filtnyq0 filtnyq

param float 10
param float 0
param int 1
block resmpl0 resmpl

param arg 0
param int 0
param file Baseband
param file X
param file Y
param int 1
param int 1
block plot0 plottxt

block node1 node

param arg 0
param float 1
param arg 1
param float 1000
param float 0
param float 1
param int 128
block sine1 sine

block mixer0 mixer

param int 8000
param int 0
param file DSBSC
param int 0
param int 0
param int 1
param int 1
param float 64
param int 1
block spectrum1 spectrumtxt

block node0 node

param float 64000
param float 1000
param float 0.999
param float 2000
hblock carrec0 carrec.t

block mixer1 mixer

param int 3
param int 1
param float 64000
param float 0.1
param float 35
param float 900
param float 1000
param float 220
param float 3400
param float 10
param float 4400
param file tmp
block iirfil0 iirfil

param int 8000
param int 0
param file demodulated
param int 0
param int 0
param int 1
param int 1
param float 0
param int 1
block spectrum0 spectrumtxt

block sink0 sink

connect bdata0 0 linecode0 0  	
connect linecode0 0 filtnyq0 0  	
connect filtnyq0 0 resmpl0 0  	
connect resmpl0 0 plot0 0  	
connect plot0 0 node1 0  	
connect node1 0 mixer0 0  	
connect node1 1 sine1 0  	
connect node1 2 bdata0 0  	
connect sine1 0 mixer0 1  	
connect mixer0 0 spectrum1 0  	
connect spectrum1 0 node0 0  	
connect node0 0 carrec0 0  	
connect node0 1 mixer1 1  	
connect carrec0 0 mixer1 0  	
connect mixer1 0 iirfil0 0  	
connect iirfil0 0 spectrum0 0  	
connect spectrum0 0 sink0 0  	

