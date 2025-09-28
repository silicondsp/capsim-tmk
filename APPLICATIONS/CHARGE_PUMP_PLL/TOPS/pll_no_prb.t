
# topology file:  pll_no_prb.t

#--------------------------------------------------- 
# Title:  
# Author:  
# Date:  
# Description:  
#--------------------------------------------------- 

inform title 
inform author 
inform date 
inform descrip 

arg 0 int 1000 "number of samples"
arg 1 int 9000 "number to skip"
arg 2 int 10000 "total samples"

param int 3000000    num_of_samples   "total number of samples to output"
param float 1    magnitude   "Magnitude"
param int 6400    np   "Period in samples"
param int 3200    nw   "Pulse width in samples"
param int 0    nd   "Initial delay in samples"
param float 0    dcOffset   "DC offset"
param float 1    pace_rate   "pace rate to determine how many samples to output"
param int 128    samples_first_time   "number of samples on the first call if paced"
block pulse0 pulse

param int 1000    (null)   "number of samples"
param int 9000    (null)   "number to skip"
param int 10000    (null)   "total samples"
hblock pll0 pll.t

connect pulse0 0 pll0 0  	

