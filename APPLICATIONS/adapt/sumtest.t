
# topology file:  sumtest.t

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

param int 128    num_of_samples   "total number of samples to output"
param float 1    magnitude   "Enter Magnitude"
param float 32000    fs   "Enter Sampling Rate"
param float 0    freq   "Enter Frequency"
param float 0    phase   "Enter Phase"
param float 1    pace_rate   "pace rate to determine how many samples to output"
param int 128    samples_first_time   "number of samples on the first call if paced"
block sine0 sine

param int 128    num_of_samples   "total number of samples to output"
param float 0    magnitude   "Enter Magnitude"
param float 32000    fs   "Enter Sampling Rate"
param float 0    freq   "Enter Frequency"
param float 0    phase   "Enter Phase"
param float 1    pace_rate   "pace rate to determine how many samples to output"
param int 128    samples_first_time   "number of samples on the first call if paced"
block sine1 sine

param array 2  1  -1    weights   "Array of weights: number_of_weights w0 w1 w2 ... "
block sum0 sum

param int 128    npts   "Number of points in each plot (dynamic window size)"
param int 0    skip   "Points to skip before first plot"
param file plot    title   "Plot title"
param file Samples    x_axis   "X Axis label"
param file Y    y_axis   "Y-Axis label"
param int 1    plotStyleParam   "Plot Style: 1=Line,2=Points,5=Bar Chart"
param int 1    control   "Control: 1=On, 0=Off"
param int 0    mode   "0=Static,1=Dynamic"
param int 1    samplingRate   "Sampling Rate"
block plot0 plot

param file stdout    file_name   "Name of output file"
param int 1    control   "Print output control (0/Off, 1/On)"
param int 0    bufferType   "Buffer type:0= Float,1= Complex, 2=Integer"
block prfile0 prfile

connect sine0 0 sum0 0  	
connect sine1 0 sum0 1  	
connect sum0 0 plot0 0  	
connect plot0 0 prfile0 0  	

