
# topology file:  MLP_NN_Test.t

#--------------------------------------------------- 
# Title: ------   
# Author: ------   
# Date: ------   
# Description: ------   
#--------------------------------------------------- 

inform title ------  
inform author ------  
inform date ------  
inform descrip ------  

arg -1 (none)

param int 512    num_of_samples   "total number of samples to output"
param int 12    initialize   "Initialization for shift register"
param float 1    pace_rate   "pace rate to determine how many samples to output"
param int 128    samples_first_time   "number of samples on the first call if paced"
block bdata0 bdata

param int 512    num_of_samples   "total number of samples to output"
param int 11    initialize   "Initialization for shift register"
param float 1    pace_rate   "pace rate to determine how many samples to output"
param int 128    samples_first_time   "number of samples on the first call if paced"
block bdata1 bdata

block node0 node

block node1 node

block buildvec0 buildvec

param int 1    b_length   "length of data in bits"
block xorblk0 xor

param file stdout    file_name   "Name of output file"
param int 1    control   "Print output control (0/Off, 1/On)"
param int 0    bufferType   "Buffer type:0= Float,1= Complex, 2=Integer"
block prfile1 prfile

param int 3    numInputs   "  number of inputs (includes bias) "
param int 4    numPatterns   " number of patterns (includes bias)"
param float 0.7    LR_IH   " LR_IH"
param float 0.07    LR_HO   " LR_HO"
param int 4    numHidden   " number Hidden "
param float 1999.99    thisSampleParameter   " Sample Parameter Definition "
block MLP_NN0 MLP_NN

param file stdout    file_name   "Name of output file"
param int 1    control   "Print output control (0/Off, 1/On)"
param int 0    bufferType   "Buffer type:0= Float,1= Complex, 2=Integer"
block prbprfile00 prfile

param file stdout    file_name   "Name of output file"
param int 1    control   "Print output control (0/Off, 1/On)"
param int 0    bufferType   "Buffer type:0= Float,1= Complex, 2=Integer"
block prfile0 prfile

block sink0 sink

param int 128    npts   "Number of points in each plot (dynamic window size)"
param int 0    skip   "Points to skip before first plot"
param file plot    title   "Plot title"
param file Samples    x_axis   "X Axis label"
param file Y    y_axis   "Y-Axis label"
param int 1    plotStyleParam   "Plot Style: 1=Line,2=Points,5=Bar Chart"
param int 1    control   "Control: 1=On, 0=Off"
param int 0    mode   "0=Static,1=Dynamic"
param int 1    samplingRate   "Sampling Rate"
block plot0 plottxt

connect bdata0 0 node0 0  	{bdata0:NULL:NULL,node0:x:float}
connect bdata1 0 node1 0  	{bdata1:NULL:NULL,node1:x:float}
connect node0 0 buildvec0 0  	
connect node0 1 xorblk0 0  	
connect node1 0 buildvec0 1  	
connect node1 1 xorblk0 1  	
connect buildvec0 0 MLP_NN0 0  	{buildvec0:NULL:NULL,MLP_NN0: x : doubleVector_t }
connect xorblk0 0 prfile1 0  	
connect prfile1 0 MLP_NN0 1  	{prfile1:NULL:NULL,MLP_NN0: desired : float }
connect MLP_NN0 0 plot0 0  	
connect MLP_NN0 1 prfile0 0  	
connect prfile0 0 sink0 0  	
connect plot0 0 prbprfile00 0  	

