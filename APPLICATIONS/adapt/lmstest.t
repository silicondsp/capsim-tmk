
# topology file:  lmstest.t

#--------------------------------------------------- 
# Title:       LMS Test using unnormalized LMS Algorithm      
# Author:             
# Date:             
# Description:       System Identification      
#--------------------------------------------------- 

inform title       LMS Test using unnormalized LMS Algorithm      
inform author             
inform date             
inform descrip       System Identification      

arg -1 (none)

param int 500
param float 1
param int 3759
param float 1
param int 128
block gauss0 gauss

block node0 node

param file imp.dat
param int 8
block convolve0 convolve

block node1 node

param int 10
param float 0.1
param int 0
block lms0 lms

param array 2  1  -1
block sum0 sum

param int 500
param int 0
param file lmserror
param file X
param file Y
param int 1
param int 1
block plot0 plottxt

block sink0 sink

connect gauss0 0 node0 0  	
connect node0 0 convolve0 0  	
connect node0 1 lms0 0  	
connect convolve0 0 node1 0  	
connect node1 0 lms0 1  	
connect node1 1 sum0 0  	
connect lms0 0 sum0 1  	
connect sum0 0 plot0 0  	
connect plot0 0 sink0 0  	

