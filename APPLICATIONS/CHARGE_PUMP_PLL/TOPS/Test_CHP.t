
# topology file:  Test_CHP.t

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
param int 6400    np   "Period in samples"
param int 3200    nw   "Pulse width in samples"
param int 10    nd   "Initial delay in samples"
param float 0    dcOffset   "DC offset"
param float 1    pace_rate   "pace rate to determine how many samples to output"
param int 128    samples_first_time   "number of samples on the first call if paced"
block pulse0 pulse

param int 100000    num_of_samples   "total number of samples to output"
param float 1    magnitude   "Magnitude"
param int 6400    np   "Period in samples"
param int 3200    nw   "Pulse width in samples"
param int 10    nd   "Initial delay in samples"
param float 0    dcOffset   "DC offset"
param float 1    pace_rate   "pace rate to determine how many samples to output"
param int 128    samples_first_time   "number of samples on the first call if paced"
block pulse1 pulse

hblock phasedet1 phasedet.t

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

param int 1    b_length   "length of data in bits"
block invert0 invert

param int 128    npts   "Number of points in each plot (dynamic window size)"
param int 0    skip   "Points to skip before first plot"
param file plot    title   "Plot title"
param file Samples    x_axis   "X Axis label"
param file Y    y_axis   "Y-Axis label"
param int 1    plotStyleParam   "Plot Style: 1=Line,2=Points,5=Bar Chart"
param int 1    control   "Control: 1=On, 0=Off"
param int 0    mode   "0=Static,1=Dynamic"
param int 1    samplingRate   "Sampling Rate"
block plot1 plot

param int 1    b_length   "length of data in bits"
block invert1 invert

param float 10000    R   " R "
param float 100    C11   " C1  pF "
param float 10    C22   " C2  pF "
param float 10    UpCurrentValue   " UP Current micro amps "
param float 10    DnCurrentValue   " Down Current micro amps "
param float 1e+12    fs   " Sampling Rate "
param float 1    vdd   " VDD "
param float 0    vss   " VSS "
block CHP0 CHP

param int 128    npts   "Number of points in each plot (dynamic window size)"
param int 0    skip   "Points to skip before first plot"
param file plot    title   "Plot title"
param file Samples    x_axis   "X Axis label"
param file Y    y_axis   "Y-Axis label"
param int 1    plotStyleParam   "Plot Style: 1=Line,2=Points,5=Bar Chart"
param int 1    control   "Control: 1=On, 0=Off"
param int 0    mode   "0=Static,1=Dynamic"
param int 1    samplingRate   "Sampling Rate"
block prbplot0840 plot

connect pulse0 0 phasedet1 0  	
connect pulse1 0 phasedet1 1  	
connect phasedet1 0 plot0 0  	
connect phasedet1 1 plot1 0  	
connect plot0 0 invert0 0  	{plot0:NULL:NULL,invert0:x:float}
connect invert0 0 CHP0 0  	{invert0:NULL:NULL,CHP0: upsig : float }
connect plot1 0 invert1 0  	{plot1:NULL:NULL,invert1:x:float}
connect invert1 0 CHP0 1  	{invert1:NULL:NULL,CHP0: dnsig : float }
connect CHP0 0 prbplot0840 0  	

