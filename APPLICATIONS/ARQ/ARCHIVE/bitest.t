
# topology file:  bitest.t

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

arg 0 int 64 "Number bits per info frame"

param int 128    num_of_samples   "total number of samples to output"
param int 12    initialize   "Initialization for shift register"
param float 1    pace_rate   "pace rate to determine how many samples to output"
param int 128    samples_first_time   "number of samples on the first call if paced"
block bdata0 bdata

param int 1000    npts   "Number of points to collect(ignored collects all samples for now)"
param int 0    skip   "Points to skip before first plot"
param file LogicAnalyzer    graphTitle   "Title"
param file LogicAnalyzer    graphLabel   "Graph label"
param file LogicAnalyzer    y_axis   "Y axis label"
param float 0    dcOffset   "DC Offset"
param float 1    gain   "Gain applied after DC Offset"
param int 1    control   "Control: 1=On, 0=Off"
block xlogican0 logican

block node0 node

param int 16    numberOfBits   "Number of bits per frame (Info Only)"
param int 1    debugFlag   "Debug:1=true,0=false"
block bitmanip0 bitmanip

param int 1000    npts   "Number of points to collect(ignored collects all samples for now)"
param int 0    skip   "Points to skip before first plot"
param file rx    graphTitle   "Title"
param file LogicAnalyzer    graphLabel   "Graph label"
param file LogicAnalyzer    y_axis   "Y axis label"
param float 0    dcOffset   "DC Offset"
param float 1    gain   "Gain applied after DC Offset"
param int 1    control   "Control: 1=On, 0=Off"
block xlogican1 logican

param file rx.dat    file_name   "Name of output file"
param int 1    control   "Print output control (0/Off, 1/On)"
param int 0    bufferType   "Buffer type:0= Float,1= Complex, 2=Integer"
block xprfile0 prfile

connect bdata0 0 xlogican0 0  	
connect xlogican0 0 node0 0  	{xlogican0:NULL:NULL,node0:x:float}
connect node0 0 bitmanip0 0  	{node0:NULL:NULL,bitmanip0:x:float}
connect node0 1 xprfile0 1  	
connect bitmanip0 0 xlogican1 0  	
connect xlogican1 0 xprfile0 0  	

