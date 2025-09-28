
# topology file:  chp_pll.t

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

param int 100000    num_of_samples   "total number of samples to output"
param float 1    magnitude   "Magnitude"
param int 192    np   "Period in samples"
param int 96    nw   "Pulse width in samples"
param int 10    nd   "Initial delay in samples"
param float 0    dcOffset   "DC offset"
param float 1    pace_rate   "pace rate to determine how many samples to output"
param int 128    samples_first_time   "number of samples on the first call if paced"
block pulse0 pulse

param int 128    npts   "Number of points in each plot (dynamic window size)"
param int 0    skip   "Points to skip before first plot"
param file Ref_Clock    title   "Plot title"
param file Samples    x_axis   "X Axis label"
param file Y    y_axis   "Y-Axis label"
param int 1    plotStyleParam   "Plot Style: 1=Line,2=Points,5=Bar Chart"
param int 1    control   "Control: 1=On, 0=Off"
param int 0    mode   "0=Static,1=Dynamic"
param int 1    samplingRate   "Sampling Rate"
block plot2 plot

hblock phasedet0 pll_chp.t

param int 128    npts   "Number of points in each plot (dynamic window size)"
param int 0    skip   "Points to skip before first plot"
param file PFD_UP    title   "Plot title"
param file Samples    x_axis   "X Axis label"
param file Y    y_axis   "Y-Axis label"
param int 1    plotStyleParam   "Plot Style: 1=Line,2=Points,5=Bar Chart"
param int 1    control   "Control: 1=On, 0=Off"
param int 0    mode   "0=Static,1=Dynamic"
param int 1    samplingRate   "Sampling Rate"
block plot3 plot

param int 128    npts   "Number of points in each plot (dynamic window size)"
param int 0    skip   "Points to skip before first plot"
param file PFD_DN    title   "Plot title"
param file Samples    x_axis   "X Axis label"
param file Y    y_axis   "Y-Axis label"
param int 1    plotStyleParam   "Plot Style: 1=Line,2=Points,5=Bar Chart"
param int 1    control   "Control: 1=On, 0=Off"
param int 0    mode   "0=Static,1=Dynamic"
param int 1    samplingRate   "Sampling Rate"
block plot4 plot

param float 0.0001    g1   "Integrate gain"
param float 0.01    vs   "Voltage step"
block pump0 pump

param int 128    npts   "Number of points in each plot (dynamic window size)"
param int 0    skip   "Points to skip before first plot"
param file VCO_In    title   "Plot title"
param file Samples    x_axis   "X Axis label"
param file Y    y_axis   "Y-Axis label"
param int 1    plotStyleParam   "Plot Style: 1=Line,2=Points,5=Bar Chart"
param int 1    control   "Control: 1=On, 0=Off"
param int 0    mode   "0=Static,1=Dynamic"
param int 1    samplingRate   "Sampling Rate"
block plot0 plot

param float 2.304e+07    fs   "Sampling Rate"
param float 120000    fo   "Center Frequency"
block vcm1 vcm

param int 4    N   " N  ( Divide by N ) "
param float 1    vdd   " VDD "
param float 0    vss   " VSS "
block DBN0 DBN

param int 1    samples_delay   "Enter number of samples to delay"
block delay0 delay

param int 128    npts   "Number of points in each plot (dynamic window size)"
param int 0    skip   "Points to skip before first plot"
param file PLL_FB    title   "Plot title"
param file Samples    x_axis   "X Axis label"
param file Y    y_axis   "Y-Axis label"
param int 1    plotStyleParam   "Plot Style: 1=Line,2=Points,5=Bar Chart"
param int 1    control   "Control: 1=On, 0=Off"
param int 0    mode   "0=Static,1=Dynamic"
param int 1    samplingRate   "Sampling Rate"
block plot1 plot

connect pulse0 0 plot2 0  	
connect plot2 0 phasedet0 0  	
connect phasedet0 0 plot3 0  	
connect phasedet0 1 plot4 0  	
connect plot3 0 pump0 0  	{plot3:NULL:NULL,pump0:up:float}
connect plot4 0 pump0 1  	{plot4:NULL:NULL,pump0:down:float}
connect pump0 0 plot0 0  	
connect plot0 0 vcm1 0  	{plot0:NULL:NULL,vcm1:lambda:float}
connect vcm1 0 DBN0 0  	{vcm1:data_out:float,DBN0: x : float }
connect DBN0 0 delay0 0  	{DBN0: y : float ,delay0:x:float}
connect delay0 0 plot1 0  	
connect plot1 0 phasedet0 1  	

