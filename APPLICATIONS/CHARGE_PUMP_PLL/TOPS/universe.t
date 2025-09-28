
# topology file:  universe.t

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
param int 12
param float 1
param int 128
block bdata0 bdata

param int 1
param int 8
block linecode0 linecode

param int 128
param int 0
param file PLOT
param file X
param file Y
param int 1
param int 1
block plot1 plot

param int 1024
param int 0
param file PLOT
param file X
param file Y
param int 1
param int 1
block plot0 plot

connect bdata0 0 linecode0 0  	
connect linecode0 0 plot0 0  	
connect linecode0 1 plot1 0  	

