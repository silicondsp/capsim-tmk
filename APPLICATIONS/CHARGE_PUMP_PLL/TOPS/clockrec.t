
# topology file:  clockrec.t

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

arg 0 int 1000 "number to plot"
arg 1 int 9000 "number to skip"

block dff0 dff

param int 1    b_length   "length of data in bits"
block invert0 invert

param int 1    b_length   "length of data in bits"
block nand0 nand

param int 1    b_length   "length of data in bits"
block nand1 nand

param int 1    b_length   "length of data in bits"
block nand2 nand

param int 1    b_length   "length of data in bits"
block invert1 invert

block node0 node

block node1 node

block node2 node

block node3 node

block sn74ls930 sn74ls93

block node4 node

param int 1    b_length   "length of data in bits"
block nand3 nand

block node5 node

block node6 node

block node7 node

param int 1    b_length   "length of data in bits"
block invert2 invert

block srlatch0 srlatch

param int 1    b_length   "length of data in bits"
block nand4 nand

param int 1    b_length   "length of data in bits"
block and0 and

param int 1    b_length   "length of data in bits"
block invert3 invert

block sink0 sink

param int 1    samples_delay   "Enter number of samples to delay"
block delay0 delay

block node8 node

param int 1    b_length   "length of data in bits"
block nand5 nand

param int 1    b_length   "length of data in bits"
block nand6 nand

param int 1    b_length   "length of data in bits"
block nand7 nand

block node9 node

param int 1    b_length   "length of data in bits"
block invert4 invert



connect dff0 0 nand1 0 	
connect dff0 1 nand0 0  	
connect invert0 0 nand1 3  	
connect nand0 0 nand2 0  	
connect nand1 0 nand2 1  	
connect nand2 0  node3 0 	
connect invert1 0 node4 0  	 
connect input 0 node0 0   	
connect node0 0 dff0 0  	 
connect node0 1 invert0 0  	
connect node0 2 nand0 3   	
connect node1 0 nand0 1  	
connect node1 1 nand1 2  	
connect input 1 node2 0   	
connect node2 0 nand1 1  	
connect node2 1 nand0 2  	
connect node2 2 node6 0  	
connect node3 0 invert1 0  	 
connect node3 1 nand5 1  	
connect sn74ls930 0 nand4 0  	
connect sn74ls930 1 nand4 1  	
connect sn74ls930 2 nand4 2  	
connect sn74ls930 3 nand4 3  	
connect node4 0 nand3 1  	
connect node4 1 invert2 0  	
connect nand3 0    node5 0  	
connect node5 0 sn74ls930 1  	 
connect node5 1 sn74ls930 2  	 
connect node6 0 nand3 0  	
connect node6 1 node8 0  	
connect input 2 node7 0   	
connect node7 0 dff0 1  	 
connect node7 1 sn74ls930 0  	 
connect invert2 0 srlatch0 0   
connect srlatch0 0 sink0 0  	
connect srlatch0 1 delay0 0  	
connect nand4 0 and0 0 	
connect and0 0 invert3 0  	 
connect invert3 0 srlatch0 1   
connect delay0 0  node1 0 	
connect node8 0 and0 1  	
connect node8 1 node9 0  	
connect nand5 0 nand7 0  	
connect input 3 nand6 1   	
connect nand6 0 nand7 1  	
connect nand7 0  output 0   	
connect node9 0 nand5 0  	
connect node9 1 invert4 0  	
connect invert4 0 nand6 0  	
  	 
  	 
 	
  	 
 	
	
  	

