
# topology file:  fadesetup.t

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

arg 0 int 2048 "Number of Samples"
arg 1 float 2000 "Sampling Rate"

param arg 0    num_of_samples   "Number of Samples"
param float 1    magnitude   "Enter Magnitude"
param float 32000    fs   "Enter Sampling Rate"
param float 0    freq   "Enter Frequency"
param float 0    phase   "Enter Phase"
param float 1    pace_rate   "pace rate to determine how many samples to output"
param int 128    samples_first_time   "number of samples on the first call if paced"
block sine0 sine

param arg 0    npts   "Number of Samples"
param int 0    type   "Doppler Spectrum, only Ez supported at this time."
param arg 1    fs   "Sampling Rate"
param float 5e+09    fc   "Carrier frequency"
param float 10    v   "Vehicle Velocity, m/s"
param float 1    p   "Power"
param array 1  0    delays   "Array of multipath delays microsec: number_of_paths t0 t1  ... "
param array 1  1    powers   "Array of multipath powers: number_of_paths p0 p1  ... "
param int 40    numberArrivals   "Number of Plane Waves arriving plane waves, N where N >=34"
block jkfade0 jkfade

block node0 node

param int 30000    N   "Number of samples to output"
param int 0    first   "First sample to start from"
param float 1    gain   "Gain"
param float 0    offset   "DC Offset"
param int 2    operation   "Operation:0=none,1=abs,2=square,3=sqrt,4=dB"
block square1 operate

param arg 0    npts   "Number of Samples"
block autoxcorr0 autoxcorr

param int 128    npts   "Number of points ( dynamic window size )"
param int 0    skip   "Number of points to skip"
param file Autocorrelation    title   "Plot title"
param int 0    dbFlag   "Linear = 0, dB = 1"
param int 0    windFlag   "Window:0= Rec.,1=Hamm,2=Hann,3=Blackman"
param int 1    plotStyleParam   "Plot Style: 1=Line,2=Points,5=Bar Chart"
param int 1    timeFlag   "Time Domain On/Off (1/0)"
param arg 1    sampFreq   "Sampling Rate"
param int 1    control   "Control: 1=On, 0=Off"
param int 0    bufferType   "Buffer type:0= Float,1= Complex, 2=Integer"
param int 0    mode   "0=Static,1=Dynamic"
param string "Frequency"    xLabelSpectrum   "Spectrum X Axis  Label "
param string "Time"    xLabelTime   "Time X Axis  Label "
block prbspectrum0394 spectrumtxt

param int 128    npts   "Number of points in each plot (dynamic window size)"
param int 0    skip   "Points to skip before first plot"
param file In-Phase    title   "Plot title"
param file Samples    x_axis   "X Axis label"
param file Y    y_axis   "Y-Axis label"
param int 1    plotStyleParam   "Plot Style: 1=Line,2=Points,5=Bar Chart"
param int 1    control   "Control: 1=On, 0=Off"
param int 0    mode   "0=Static,1=Dynamic"
param int 1    samplingRate   "Sampling Rate"
block plot1 plottxt

param int 30000    N   "Number of samples to output"
param int 0    first   "First sample to start from"
param float 1    gain   "Gain"
param float 0    offset   "DC Offset"
param int 2    operation   "Operation:0=none,1=abs,2=square,3=sqrt,4=dB"
block square0 operate

block add0 add

param int 30000    N   "Number of samples to output"
param int 0    first   "First sample to start from"
param float 1    gain   "Gain"
param float 0    offset   "DC Offset"
param int 3    operation   "Operation:0=none,1=abs,2=square,3=sqrt,4=dB"
block sqrt0 operate

param int 128    npts   "Number of points in each plot (dynamic window size)"
param int 0    skip   "Points to skip before first plot"
param file Envelope    title   "Plot title"
param file Samples    x_axis   "X Axis label"
param file Y    y_axis   "Y-Axis label"
param int 1    plotStyleParam   "Plot Style: 1=Line,2=Points,5=Bar Chart"
param int 1    control   "Control: 1=On, 0=Off"
param int 0    mode   "0=Static,1=Dynamic"
param int 1    samplingRate   "Sampling Rate"
block plot0 plottxt

param float 0    start   "Starting point of left most bin"
param float 5    stop   "Ending point of right  most bin"
param int 100    numberOfBins   "Number of bins"
param file none    file_spec   "File name for output"
param int 1000    npts   "Number of points to collect"
param int 0    skip   "Points to skip before first plot"
param file Histogram    graphTitle   "Title"
param file Bins    x_axis   "X axis label"
param file Histogram    y_axis   "Y axis label"
param int 5    plotStyleParam   "Plot Style: 1=Line,2=Points,5=Bar Chart"
param int 1    control   "Control: 1=On, 0=Off"
param int 0    bufferType   "Buffer Type: 0= float, 1=image"
block prbhist0840 histtxt

connect sine0 0 jkfade0 0  	{sine0:NULL:NULL,jkfade0:inPhaseIn:float}
connect sine0 1 jkfade0 1  	{sine0:NULL:NULL,jkfade0:quadPhaseIn:float}
connect jkfade0 0 plot1 0  	
connect jkfade0 1 node0 0  	
connect node0 0 square1 0  	{node0:NULL:NULL,square1:x:float}
connect node0 1 autoxcorr0 0  	
connect square1 0 add0 1  	
connect autoxcorr0 0 prbspectrum0394 0  	
connect plot1 0 square0 0  	{plot1:NULL:NULL,square0:x:float}
connect square0 0 add0 0  	
connect add0 0 sqrt0 0  	{add0:NULL:NULL,sqrt0:x:float}
connect sqrt0 0 plot0 0  	
connect plot0 0 prbhist0840 0  	

