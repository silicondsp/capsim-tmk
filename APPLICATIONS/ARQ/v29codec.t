
# topology file:  v29codec.t

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

arg 0 float 0 "Noise Variance"

block node0 node

block v29encoder0 v29encoder

param arg 0    power   "Noise Variance"
param int 333    seed   "Seed for random number generator"
block addnoise0 addnoise

param arg 0    power   "Noise Variance"
param int 3557    seed   "Seed for random number generator"
block addnoise1 addnoise

param int 128    npts   "Number of points ( dynamic plot window)"
param int 0    skip   "Number of points to skip"
param file Scatter    title   "Title"
param file X    x_axis   "x Axis"
param file Y    y_axis   "y Axis"
param int 2    plotStyleParam   "Plot Style: 1=Line,2=Points,5=Bar Chart"
param int 0    fixed   "Fixed Bounds ( 0=none, 1=fixed)"
param float -1.2    minx   "Minimum x"
param float 1.2    maxx   "Maximum x"
param float -1.2    miny   "Minimum y"
param float 1.2    maxy   "Maximum y"
param int 0    markerType   "Marker type:0=dot,1=O,2=+,3=X,4=*,5=square,6=diamond,7=triangle"
param int 1    control   "Control: 1=On, 0=Off"
param int 0    bufferType   "Buffer type:0= Float,1= Complex, 2=Integer"
param int 0    mode   "0=Static,1=Dynamic"
block scatter0 scattertxt

block v29decoder0 v29decoder

block node1 node

param int 0    ignore   "Number of samples to ignore for final error tally"
param int 30000    err_msg   "Index after which each error is printed to terminal"
block ecount0 ecount

connect input 0 node0 0   	
connect node0 0 v29encoder0 0  	{node0:NULL:NULL,v29encoder0:data:float}
connect node0 1 ecount0 1  	{node0:NULL:NULL,ecount0:x:float}
connect v29encoder0 0 addnoise0 0  	{v29encoder0:inPhase:float,addnoise0:inp:float}
connect v29encoder0 1 addnoise1 0  	
connect addnoise0 0 scatter0 0  	
connect addnoise1 0 scatter0 1  	
connect scatter0 0 v29decoder0 0  	{scatter0:NULL:NULL,v29decoder0:inPhase:float}
connect scatter0 1 v29decoder0 1  	{scatter0:NULL:NULL,v29decoder0:quadPhase:float}
connect v29decoder0 0 node1 0  	{v29decoder0:data:float,node1:x:float}
connect node1 0 ecount0 0  	{node1:NULL:NULL,ecount0:w:float}
connect node1 1 output 0  	

