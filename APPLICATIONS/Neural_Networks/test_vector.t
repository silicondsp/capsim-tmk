
# topology file:  test_vector.t

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

param int 128    num_of_samples   "total number of samples to output"
param int 12    initialize   "Initialization for shift register"
param float 1    pace_rate   "pace rate to determine how many samples to output"
param int 128    samples_first_time   "number of samples on the first call if paced"
block bdata0 bdata

param int 128    num_of_samples   "total number of samples to output"
param int 11    initialize   "Initialization for shift register"
param float 1    pace_rate   "pace rate to determine how many samples to output"
param int 128    samples_first_time   "number of samples on the first call if paced"
block bdata1 bdata

param int 128    num_of_samples   "total number of samples to output"
param int 9    initialize   "Initialization for shift register"
param float 1    pace_rate   "pace rate to determine how many samples to output"
param int 128    samples_first_time   "number of samples on the first call if paced"
block bdata2 bdata

block buildvec0 buildvec

param file stdout    file_name   "Name of output file"
param int 0    display   "Display Block Name"
block prvec0 prvec

param file stdout    file_name   "Name of output file"
param int 0    display   "Display Block Name"
block prvec1 prvec

connect bdata0 0 buildvec0 0  	
connect bdata1 0 buildvec0 1  	
connect bdata2 0 buildvec0 2  	
connect buildvec0 0 prvec0 0  	
connect prvec0 0 prvec1 0  	

