
# topology file:  fskdemod.t

#--------------------------------------------------- 
# Title: Ω@άμ@  
# Author: Ω@άμ@  
# Date: Ω@άμ@  
# Description: Ω@άμ@  
#--------------------------------------------------- 

inform title Ω@άμ@ 
inform author Ω@άμ@ 
inform date Ω@άμ@ 
inform descrip Ω@άμ@ 

arg 0 float 8000 "Sampling Rate"
arg 1 int 100 "Stretch"

block node1 node

block mixer0 mixer

param float 0.92
block lpf0 lpf

param float 0.5
block gain0 gain

block node0 node

param arg 0
param float 1700
param float 1
block dco1 dco

param int 1
block delay0 delay

param int 3
param int 1
param arg 0
param float 0.1
param float 45
param float 1500
param float 2000
param float 220
param float 3400
param float 10
param float 4400
param file tmp
block iirfil0 iirfil

block sink0 sink

connect input 0 node1 0   	
connect node1 0 mixer0 0  	
connect mixer0 0 lpf0 0  	
connect lpf0 0 gain0 0  	
connect gain0 0 node0 0  	
connect node0 0 dco1 0  	
connect node0 1 iirfil0 0  	
connect dco1 0 delay0 0  	
connect dco1 1 sink0 0  	
connect delay0 0 mixer0 1  	
connect iirfil0 0 output 0  	

