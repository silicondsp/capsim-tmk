
# topology file:  fmmod.t

#--------------------------------------------------- 
# Title:  Simple FM Modulation 
# Author:    Sasan Ardalan 
# Date:     
# Description:    
#--------------------------------------------------- 

inform title  Simple FM Modulation 
inform author    Sasan Ardalan 
inform date     
inform descrip    

arg 0 int 1024 "Number of samples"

param int 1024
param float 0.2
param float 100
param float 1
param float 0
param float 1
param int 128
block sine0 sine

param float 100
param float 10
param float 1
block dco0 dco

block sink1 sink

param int 1024
param int 0
param file FM
param int 0
param int 0
param int 1
param int 1
param float 100
param int 1
block spectrum0 spectrumtxt

block sink0 sink

connect sine0 0 dco0 0  	
connect dco0 0 spectrum0 0  	
connect dco0 1 sink1 0  	
connect spectrum0 0 sink0 0  	

