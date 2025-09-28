# topology file:  testsine.t

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
param float 1
param float 32000
param float 1000
param float 0
param float 1
param int 128
star sine0 sine

param file stdout
param int 1
param int 0
star prfile0 prfile

connect sine0 0 prfile0 0  	

