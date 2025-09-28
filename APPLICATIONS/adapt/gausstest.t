
# topology file:  gausstest.t

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
param float 1    dev   "Noise Standard Deviation"
param int 333    seed   "Seed for random number generator"
param float 1    pace_rate   "pace rate to determine how many samples to output"
param int 128    samples_first_time   "number of samples on the first call if paced"
block gauss0 gauss

param file zz.dat    file_name   "Name of output file"
param int 1    control   "Print output control (0/Off, 1/On)"
param int 0    bufferType   "Buffer type:0= Float,1= Complex, 2=Integer"
block prfile0 prfile

connect gauss0 0 prfile0 0  	

