
# topology file:  pll_chp_state_space_4GHz_jitter.t

#--------------------------------------------------- 
# Title:  
# Author:  
# Date:  
# Description:  
#--------------------------------------------------- 

inform title Cahre Pumb PLL based on State Space Solution 
inform author Sasan Ardalan 
inform date  Based on Work in 1991 extended to State Space Chare Pump. See CHPStateSpace.s
inform descrip Extened original charge pump PLL to using CHP based on State Space Model. 

arg 0 int 1000 "number of samples"
arg 1 int 9000 "number to skip"
arg 2 int 10000 "total samples"

param int 2000000    num_of_samples   "total number of samples to output"
param float 1    magnitude   "Magnitude"
param int 250    np   "Period in samples"
param int 125    nw   "Pulse width in samples"
param int 0    nd   "Initial delay in samples"
param float 0    dcOffset   "DC offset"
param float 1    pace_rate   "pace rate to determine how many samples to output"
param int 128    samples_first_time   "number of samples on the first call if paced"
block pulse0 pulse

param int 128    npts   "Number of points in each plot (dynamic window size)"
param int 0    skip   "Points to skip before first plot"
param file Ref_Clock    title   "Plot title"
param file Time,ns    x_axis   "X Axis label"
param file Y    y_axis   "Y-Axis label"
param int 1    plotStyleParam   "Plot Style: 1=Line,2=Points,5=Bar Chart"
param int 1    control   "Control: 1=On, 0=Off"
param int 0    mode   "0=Static,1=Dynamic"
param int 1000    samplingRate   "Sampling Rate"
block plot2 plottxt

param file ref.dat    file_name   "Name of output file"
param int 1    control   "Print output control (0/Off, 1/On)"
param int 0    bufferType   "Buffer type:0= Float,1= Complex, 2=Integer"
block prfile0 prfile

hblock phasedet1 phasedet.t

param int 1    b_length   "length of data in bits"
block invert0 invert

param int 1    b_length   "length of data in bits"
block invert1 invert

param float 10000    R   " R "
param float 100    C11   " C1  pF "
param float 10    C22   " C2  pF "
param float 1    UpCurrentValue   " UP Current micro amps "
param float 1    DnCurrentValue   " Down Current micro amps "
param float 1e+12    fs   " Sampling Rate "
param float 1    vdd   " VDD "
param float 0    vss   " VSS "
block CHPStateSpace0 CHPStateSpace

param float 1e+12    fs   "Sampling Rate"
param float 8e+09    fo   "Center Frequency"
block VCO0 VCO

param int 128    npts   "Number of points in each plot (dynamic window size)"
param int 0    skip   "Points to skip before first plot"
param file VCO    title   "Plot title"
param file Samples    x_axis   "X Axis label"
param file Y    y_axis   "Y-Axis label"
param int 1    plotStyleParam   "Plot Style: 1=Line,2=Points,5=Bar Chart"
param int 1    control   "Control: 1=On, 0=Off"
param int 0    mode   "0=Static,1=Dynamic"
param int 1    samplingRate   "Sampling Rate"
block plot5 plottxt

param int 2    N   " N  ( Divide by N ) "
param float 1    vdd   " VDD "
param float 0    vss   " VSS "
block DBN0 DBN

param int 1    samples_delay   "Enter number of samples to delay"
block delay0 delay

param int 128    npts   "Number of points in each plot (dynamic window size)"
param int 0    skip   "Points to skip before first plot"
param file PLL_FB    title   "Plot title"
param file Time,ns    x_axis   "X Axis label"
param file Y    y_axis   "Y-Axis label"
param int 1    plotStyleParam   "Plot Style: 1=Line,2=Points,5=Bar Chart"
param int 1    control   "Control: 1=On, 0=Off"
param int 0    mode   "0=Static,1=Dynamic"
param int 1000    samplingRate   "Sampling Rate"
block plot1 plottxt

param file dbn.dat    file_name   "Name of output file"
param int 1    control   "Print output control (0/Off, 1/On)"
param int 0    bufferType   "Buffer type:0= Float,1= Complex, 2=Integer"
block prfile1 prfile

param int 128    npts   "Number of points in each plot (dynamic window size)"
param int 0    skip   "Points to skip before first plot"
param file VCO_Input    title   "Plot title"
param file Samples    x_axis   "X Axis label"
param file Y    y_axis   "Y-Axis label"
param int 1    plotStyleParam   "Plot Style: 1=Line,2=Points,5=Bar Chart"
param int 1    control   "Control: 1=On, 0=Off"
param int 0    mode   "0=Static,1=Dynamic"
param int 1    samplingRate   "Sampling Rate"
block plot0 plottxt

connect pulse0 0 plot2 0  	
connect plot2 0 prfile0 0  	
connect prfile0 0 phasedet1 0  	
connect phasedet1 0 invert0 0  	{phasedet1:NULL:NULL,invert0:x:float}
connect phasedet1 1 invert1 0  	{phasedet1:NULL:NULL,invert1:x:float}
connect invert0 0 CHPStateSpace0 0  	{invert0:NULL:NULL,CHPStateSpace0: upsig : float }
connect invert1 0 CHPStateSpace0 1  	{invert1:NULL:NULL,CHPStateSpace0: dnsig : float }
connect CHPStateSpace0 0 plot0 0  	
connect VCO0 0 plot5 0  	
connect plot5 0 DBN0 0  	{plot5:NULL:NULL,DBN0: x : float }
connect DBN0 0 delay0 0  	{DBN0: y : float ,delay0:x:float}
connect delay0 0 plot1 0  	
connect plot1 0 prfile1 0  	
connect prfile1 0 phasedet1 1  	
connect plot0 0 VCO0 0  	{plot0:NULL:NULL,VCO0:lambda:float}

