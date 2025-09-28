
# topology file:  phasedet.t

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

param int 1    b_length   "length of data in bits"
block nand0 nand

block node0 node

block node1 node

param int 1    b_length   "length of data in bits"
block invert0 invert

block srlatch0 srlatch

block node4 node

param int 1    b_length   "length of data in bits"
block nand1 nand

block node8 node

param int 1    b_length   "length of data in bits"
block nand2 nand

block node6 node

block node9 node

param int 1    samples_delay   "Enter number of samples to delay"
block delay1 delay

param int 1    samples_delay   "Enter number of samples to delay"
block delay3 delay

block node10 node

param int 1    b_length   "length of data in bits"
block invert1 invert

param int 1    b_length   "length of data in bits"
block invert2 invert

block srlatch1 srlatch

block node5 node

block sink0 sink

param int 1    b_length   "length of data in bits"
block nand3 nand

block node7 node

param int 1    samples_delay   "Enter number of samples to delay"
block delay2 delay

param int 1    b_length   "length of data in bits"
block nand4 nand

block node2 node

block node3 node

param int 1    b_length   "length of data in bits"
block invert3 invert

connect input 0 nand0 0   	
connect nand0 0 node0 0  	{nand0:NULL:NULL,node0:x:float}
connect node0 0 node1 0  	{node0:NULL:NULL,node1:x:float}
connect node0 1 invert0 0  	{node0:NULL:NULL,invert0:x:float}
connect node1 0 nand2 0  	
connect node1 1 nand1 0  	
connect invert0 0 srlatch0 0  	{invert0:NULL:NULL,srlatch0:s:float}
connect srlatch0 0 node4 0  	{srlatch0:q:float,node4:x:float}
connect srlatch0 1 sink0 0  	
connect node4 0 nand2 1  	
connect node4 1 nand1 1  	
connect nand1 0 node8 0  	{nand1:NULL:NULL,node8:x:float}
connect node8 0 nand2 2  	
connect node8 1 node9 0  	{node8:NULL:NULL,node9:x:float}
connect nand2 0 node6 0  	{nand2:NULL:NULL,node6:x:float}
connect node6 0 delay1 0  	{node6:NULL:NULL,delay1:x:float}
connect node6 1 output 0  	
connect node9 0 nand3 0  	
connect node9 1 delay3 0  	{node9:NULL:NULL,delay3:x:float}
connect delay1 0 nand0 1  	
connect delay3 0 node10 0  	{delay3:NULL:NULL,node10:x:float}
connect node10 0 invert1 0  	{node10:NULL:NULL,invert1:x:float}
connect node10 1 invert2 0  	{node10:NULL:NULL,invert2:x:float}
connect invert1 0 srlatch0 1  	{invert1:NULL:NULL,srlatch0:r:float}
connect invert2 0 srlatch1 0  	{invert2:NULL:NULL,srlatch1:s:float}
connect srlatch1 0 sink0 1  	
connect srlatch1 1 node5 0  	{srlatch1:qp:float,node5:x:float}
connect node5 0 nand1 2  	
connect node5 1 nand3 1  	
connect nand3 0 node7 0  	{nand3:NULL:NULL,node7:x:float}
connect node7 0 delay2 0  	{node7:NULL:NULL,delay2:x:float}
connect node7 1 output 1  	
connect delay2 0 nand4 1  	
connect input 1 nand4 0   	
connect nand4 0 node2 0  	{nand4:NULL:NULL,node2:x:float}
connect node2 0 node3 0  	{node2:NULL:NULL,node3:x:float}
connect node2 1 invert3 0  	{node2:NULL:NULL,invert3:x:float}
connect node3 0 nand3 2  	
connect node3 1 nand1 3  	
connect invert3 0 srlatch1 1  	{invert3:NULL:NULL,srlatch1:r:float}

