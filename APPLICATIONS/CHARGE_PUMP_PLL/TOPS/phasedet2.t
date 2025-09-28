
# topology file:  phasedet2.t

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

block node0 node

param int 1
block invert0 invert

block node1 node

param int 1
block nand0 nand

param int 1
block nand1 nand

connect input 0 node0 0   	
connect node0 0 invert0 0  	
connect node0 1 nand1 1  	
connect invert0 0 nand0 0  	
connect input 1 node1 0   	
connect node1 0 nand1 0  	
connect node1 1 nand0 1  	
connect nand0 0 output 0  	
connect nand1 0 output 1  	

