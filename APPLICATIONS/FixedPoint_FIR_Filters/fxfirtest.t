
# topology file:  fxfirtest.t

#--------------------------------------------------- 
# Title:  
# Author:  
# Date:  
# Description:  
#--------------------------------------------------- 

inform title 
inform author 
inform date 
inform descrip set qbits 8 bits or 12 bits to compare to floating point 

arg -1 (none)

param file tmp.tap    fileName   "File with Taps (first line # of taps)"
param int 8    qbits   "Number of bits to represent fraction"
param int 32    size   "Word length"
param int 12    roundoff_bits   "Accumulator Roundoff bits"
param int 32    accumSizeRound   "Accumulator Word length"
param int 1    saturation_mode   "saturation mode"
param int 1    errorControl   "Error Out (1=error 0=floating point response)"
block fxfirtaps0 fxfirtaps

param int 2048    length   "Enter number of samples"
block impulse0 impulse

param int 128    npts   "Number of points ( dynamic window size )"
param int 0    skip   "Number of points to skip"
param file SpectrumFxp8    title   "Plot title"
param int 1    dbFlag   "Linear = 0, dB = 1"
param int 0    windFlag   "Window:0= Rec.,1=Hamm,2=Hann,3=Blackman"
param int 1    plotStyleParam   "Plot Style: 1=Line,2=Points,5=Bar Chart"
param int 1    timeFlag   "Time Domain On/Off (1/0)"
param float                      0    sampFreq   "Sampling Rate (Bin Number if zero,Normalized if Negative"
param int 1    control   "Control: 1=On, 0=Off"
param int 0    bufferType   "Buffer type:0= Float,1= Complex, 2=Integer"
param int 0    mode   "0=Static,1=Dynamic"
block spectrumtxt0 spectrumtxt

param float                      4096    factor   "Gain factor"
block gain0 gain

block fti0 fti

block itf0 itf

param int 128    npts   "Number of points in each plot (dynamic window size)"
param int 0    skip   "Points to skip before first plot"
param file errorfir    title   "Plot title"
param file Samples    x_axis   "X Axis label"
param file Y    y_axis   "Y-Axis label"
param int 1    plotStyleParam   "Plot Style: 1=Line,2=Points,5=Bar Chart"
param int 1    control   "Control: 1=On, 0=Off"
param int 0    mode   "0=Static,1=Dynamic"
param int 1    samplingRate   "Sampling Rate"
block plottxt0 plottxt

connect fxfirtaps0 0 itf0 0  	{fxfirtaps0:y:int,itf0:x:int}
connect fxfirtaps0 1 plottxt0 0  	
connect impulse0 0 gain0 0  	{impulse0:NULL:NULL,gain0:x:float}
connect gain0 0 fti0 0  	{gain0:NULL:NULL,fti0:x:float}
connect fti0 0 fxfirtaps0 0  	{fti0:NULL:NULL,fxfirtaps0:x:int}
connect itf0 0 spectrumtxt0 0  	

