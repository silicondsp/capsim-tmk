
# topology file:  impresp.t

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

param int 128
star impulse0 impulse

param file conv.dat
param int 9
star convolve0 convolve

param file stdout
param int 1
param int 0
star prfile0 prfile

connect impulse0 0 convolve0 0  	
connect convolve0 0 prfile0 0  	




