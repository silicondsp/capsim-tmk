
# topology file:  firfloattest.t

#--------------------------------------------------- 
# Title:  
# Author:  
# Date:  
# Description:  
#--------------------------------------------------- 

inform title 
inform author 
inform date 
inform descrip 

arg -1 (none)

param int 2048    length   "Enter number of samples"
block impulse0 impulse

param int 1    filterType   "Filter Type:1=LowPass,2=HighPass,3=BandPass,4=BandStop"
param int 3    windType   "Window Type:1=Rect,2=Tri,3=Hamm,4=GenHamm,5=Hann,6=Kaiser,7=Cheb,8=Parz"
param int 128    ntap   "Number of Taps"
param float                   0.25    fc   "Cut Off Freq. (LowPass/HighPass Only)"
param float                   0.25    fl   "Lower cutoff freq. 0<=fl<=0.5"
param float   0.400000005960464478    fh   "Upper cutoff freq. 0<=fh<=0.5"
param float                    0.5    alpha   "Alpha parameter for generalized Hamming window <=1.0"
param float                    0.5    dbripple   "Ripple, dB for Chebyshev Window"
param float   0.100000001490116119    twidth   "Transition Width Chebyshev Window"
param float                     30    att   "Attenuation for Kaiser Window"
block firfil0 firfil

param int 128    npts   "Number of points ( dynamic window size )"
param int 0    skip   "Number of points to skip"
param file SpectrumFloat    title   "Plot title"
param int 1    dbFlag   "Linear = 0, dB = 1"
param int 0    windFlag   "Window:0= Rec.,1=Hamm,2=Hann,3=Blackman"
param int 1    plotStyleParam   "Plot Style: 1=Line,2=Points,5=Bar Chart"
param int 1    timeFlag   "Time Domain On/Off (1/0)"
param float                      0    sampFreq   "Sampling Rate (Bin Number if zero,Normalized if Negative"
param int 1    control   "Control: 1=On, 0=Off"
param int 0    bufferType   "Buffer type:0= Float,1= Complex, 2=Integer"
param int 0    mode   "0=Static,1=Dynamic"
block spectrumtxt0 spectrumtxt

connect impulse0 0 firfil0 0  	{impulse0:NULL:NULL,firfil0:x:float}
connect firfil0 0 spectrumtxt0 0  	

