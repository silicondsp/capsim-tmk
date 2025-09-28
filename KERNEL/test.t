
# topology file:  test.t

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
param int 128
star zero0 zero

param file stdout
param int 1
param int 0
star prfile0 prfile

connect zero0 0 prfile0 0  	

