
# topology file:  fxnltest.t

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

param int 1024
block impulse0 impulse

param file tmp.lat
param int 16
param int 16
param int 10
param int 0
block fxnl0 fxnl

param int 1024
param int 0
param file Normalized_Lattice_Fixed_Point
param int 0
param int 0
param int 1
param int 1
param float 0
param int 1
param int 0
block spectrum0 spectrumtxt

connect impulse0 0 fxnl0 0  	
connect fxnl0 0 spectrum0 0  	

