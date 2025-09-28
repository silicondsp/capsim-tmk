
# topology file:  pll.t

#--------------------------------------------------- 
# Title:  
# Author:  
# Date:  
# Description:  
#--------------------------------------------------- 

inform title "" 
inform author "" 
inform date "" 
inform descrip "" 

arg 0 int 1000 "number of samples"
arg 1 int 9000 "number to skip"
arg 2 int 10000 "total samples"

hblock phasedet1 phasedet.t

param int 1    b_length   "length of data in bits"
block invert1 invert

param int 1    b_length   "length of data in bits"
block invert0 invert

param float 10000    R   " R "
param float 100    C11   " C1  pF "
param float 10    C22   " C2  pF "
param float 1    UpCurrentValue   " UP Current micro amps "
param float 1    DnCurrentValue   " Down Current micro amps "
param float 1e+12    fs   " Sampling Rate "
param float 1    vdd   " VDD "
param float 0    vss   " VSS "
block CHP0 CHPStateSpace

param float 10    factor   "Gain factor"
block gain0 gain

param float 1e+12    fs   "Sampling Rate"
param float 4e+09    fo   "Center Frequency"
block VCO0 VCO

param int 20    N   " N  ( Divide by N ) "
param float 1    vdd   " VDD "
param float 0    vss   " VSS "
block DBN0 DBN

param int 1    samples_delay   "Enter number of samples to delay"
block delay0 delay

connect input 0 phasedet1 0   	
connect phasedet1 0 invert1 0  	
connect phasedet1 1 invert0 0  	
connect invert1 0 CHP0 0  	
connect invert0 0 CHP0 1  	
connect CHP0 0 gain0 0  	
connect gain0 0 VCO0 0  	
connect VCO0 0 DBN0 0  	
connect DBN0 0 delay0 0  	
connect delay0 0 phasedet1 1  	

