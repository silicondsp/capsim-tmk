
# topology file:  zz.t

#--------------------------------------------------- 
# Title: Voice Band Codec Simulation   
# Author: Sasan Ardalan   
# Date: November 1990   
# Description: Simulate 8 bit mu-law Codec at 8 kHz Sampling Rate   
#--------------------------------------------------- 

inform title Voice Band Codec Simulation  
inform author Sasan Ardalan  
inform date November 1990  
inform descrip Simulate 8 bit mu-law Codec at 8 kHz Sampling Rate  

arg -1 (none)

param int 128    num_of_samples   "total number of samples to output"
param float 0.707107    magnitude   "Enter Magnitude"
param float 32000    fs   "Enter Sampling Rate"
param float 1000    freq   "Enter Frequency"
param float 0    phase   "Enter Phase"
param float 1    pace_rate   "pace rate to determine how many samples to output"
param int 128    samples_first_time   "number of samples on the first call if paced"
block sine0 sine

param file stdout    file_name   "Name of output file"
param int 1    control   "Print output control (0/Off, 1/On)"
param int 0    bufferType   "Buffer type:0= Float,1= Complex, 2=Integer"
block prfile0 prfile

connect sine0 0 prfile0 0  	

