
# topology file:  dcotest.t

#--------------------------------------------------- 
# Title:  
# Author:  
# Date:  
# Description:  
#--------------------------------------------------- 

inform title 
inform author 
inform date 
inform descrip 

arg -1 (none)

block dco0 dco

param int 128
param int 0
param file Spectrum
param int 0
param int 0
param int 1
param int 1
param float 0
param int 1
param int 0
param int 0
block spectrum0 spectrumtxt

param int 10000
param float 1
param float 32000
param float 10
param float 0
param float 1
param int 128
block sine0 sine

block sink0 sink

connect dco0 0 spectrum0 0  	
connect dco0 1 sink0 0  	
connect sine0 0 dco0 0  	

