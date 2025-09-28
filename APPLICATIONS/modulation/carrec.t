
# topology file:  carrec.t

#--------------------------------------------------- 
# Title:  Carrier Recovery Galaxy 
# Author:     Sasan Ardalan 
# Date:      
# Description:     
#--------------------------------------------------- 

inform title  Carrier Recovery Galaxy 
inform author     Sasan Ardalan 
inform date      
inform descrip     

arg 0 float 8000 "Sampling Rate"
arg 1 float 1000 "Center Frequency"
arg 2 float 0.99 "Modulus for BPF (Determines Q)"
arg 3 float 2000 "Twice carrier frequency"

block square sqr

param arg 0
param arg 3
param arg 2
block tunedFilter bpf

block divbytwo0 divby2

param arg 0
param arg 1
param arg 2
block bpf0 bpf

param int 8000
param int 0
param file Squared
param int 0
param int 0
param int 1
param int 0
param arg 0
param int 1
block spectrum0 spectrumtxt

connect input 0 square 0   	
connect square 0 spectrum0 0  	
connect tunedFilter 0 divbytwo0 0  	
connect divbytwo0 0 bpf0 0  	
connect bpf0 0 output 0  	
connect spectrum0 0 tunedFilter 0  	

