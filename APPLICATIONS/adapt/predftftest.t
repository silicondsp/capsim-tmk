
# topology file:  predftftest.t

#--------------------------------------------------- 
# Title:    Fast Transversal Filter (RLS) Adaptive Filter             
# Author:   Sasan Ardalan              
# Date:                 
# Description:   System Identification               
#--------------------------------------------------- 

inform title    Fast Transversal Filter (RLS) Adaptive Filter             
inform author   Sasan Ardalan              
inform date                 
inform descrip   System Identification               

arg -1 (none)

param int 1000
param float 1
param int 3759
param float 1
param int 128
block gauss0 gauss

block node0 node

param file imp.dat
param int 8
block convolve0 convolve

param array 2  1  -1
block sum0 sum

param file prfile
param file prfileo
param float 1
param float 0.0001
param int 0
param int -1
block predftf0 predftf

param int 256
param int 0
param file PLOT
param file X
param file Y
param int 1
param int 1
block plot0 plottxt

block sink0 sink

connect gauss0 0 node0 0  	
connect node0 0 convolve0 0  	
connect node0 1 predftf0 1  	
connect convolve0 0 sum0 0  	
connect sum0 0 plot0 0  	
connect sum0 1 predftf0 0  	
connect predftf0 0 sum0 1  	
connect plot0 0 sink0 0  	

