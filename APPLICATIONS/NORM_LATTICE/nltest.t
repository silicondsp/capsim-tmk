
# topology file:  nltest.t

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
block nl0 nl

param int 1024
param int 0
param file Normalized_Lattice
param int 0
param int 0
param int 1
param int 1
param float 0
param int 1
block spectrum0 spectrumtxt

connect impulse0 0 nl0 0  	
connect nl0 0 spectrum0 0  	

