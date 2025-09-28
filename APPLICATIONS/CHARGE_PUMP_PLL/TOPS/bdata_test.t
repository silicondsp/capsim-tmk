
# topology file:  bdata_test.t

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

param int 0    code_type   "Code type:0-Binary(NRZ),1-Biphase(Manchester),2-2B1Q,3-RZ-AMI(Alternate mark inversion)"
param int 8    smplbd   "Samples per baud"
block linecode0 linecode

param int 128    npts   "Number of points in each plot (dynamic window size)"
param int 0    skip   "Points to skip before first plot"
param file LINECODE0    title   "Plot title"
param file Samples    x_axis   "X Axis label"
param file Y    y_axis   "Y-Axis label"
param int 1    plotStyleParam   "Plot Style: 1=Line,2=Points,5=Bar Chart"
param int 1    control   "Control: 1=On, 0=Off"
param int 0    mode   "0=Static,1=Dynamic"
param int 1    samplingRate   "Sampling Rate"
block prbplot0840 plottxt

param int 128    npts   "Number of points in each plot (dynamic window size)"
param int 0    skip   "Points to skip before first plot"
param file LINECODE1    title   "Plot title"
param file Samples    x_axis   "X Axis label"
param file Y    y_axis   "Y-Axis label"
param int 1    plotStyleParam   "Plot Style: 1=Line,2=Points,5=Bar Chart"
param int 1    control   "Control: 1=On, 0=Off"
param int 0    mode   "0=Static,1=Dynamic"
param int 1    samplingRate   "Sampling Rate"
block prbplot0394 plot

connect bdata0 0 linecode0 0  	{bdata0:NULL:NULL,linecode0:bindata:float}
connect linecode0 0 prbplot0840 0  	
connect linecode0 1 prbplot0394 0  	

