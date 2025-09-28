
# topology file:  vcm_test.t

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

param int 1000000    num_of_samples   "total number of samples to output"
param float 0    magnitude   "Enter Magnitude"
param float 32000    fs   "Enter Sampling Rate"
param float 1000    freq   "Enter Frequency"
param float 0    phase   "Enter Phase"
param float 1    pace_rate   "pace rate to determine how many samples to output"
param int 128    samples_first_time   "number of samples on the first call if paced"
block sine0 sine

param float 1e+12    fs   "Sampling Rate"
param float 1e+09    fo   "Center Frequency"
block vcm0 vcm

param int 128    npts   "Number of points in each plot (dynamic window size)"
param int 0    skip   "Points to skip before first plot"
param file plot    title   "Plot title"
param file Samples    x_axis   "X Axis label"
param file Y    y_axis   "Y-Axis label"
param int 1    plotStyleParam   "Plot Style: 1=Line,2=Points,5=Bar Chart"
param int 1    control   "Control: 1=On, 0=Off"
param int 0    mode   "0=Static,1=Dynamic"
param int 1    samplingRate   "Sampling Rate"
block prbplot0840 plottxt

connect sine0 0 vcm0 0  	{sine0:NULL:NULL,vcm0:lambda:float}
connect vcm0 0 prbplot0840 0  	

