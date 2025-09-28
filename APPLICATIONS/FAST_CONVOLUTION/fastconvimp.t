
# topology file:  fastconvtest.t

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

param int 18000    num_of_samples   "total number of samples to output"
block source impulse

param int 128    impl   "impl: length of impulse response in samples:"
param file fir.tap    impf_name   "(file)ASCII file which holds impulse response:"
param int 9    fftexp   "log2(fft length):"
block fconv0 fconv

param int 128    npts   "Number of points ( dynamic window size )"
param int 0    skip   "Number of points to skip"
param file fastconv    title   "Plot title"
param int 0    dbFlag   "Linear = 0, dB = 1"
param int 0    windFlag   "Window:0= Rec.,1=Hamm,2=Hann,3=Blackman"
param int 1    plotStyleParam   "Plot Style: 1=Line,2=Points,5=Bar Chart"
param int 1    timeFlag   "Time Domain On/Off (1/0)"
param float 0    sampFreq   "Sampling Rate (Bin Number if zero,Normalized if Negative"
param int 1    control   "Control: 1=On, 0=Off"
param int 0    bufferType   "Buffer type:0= Float,1= Complex, 2=Integer"
param int 0    mode   "0=Static,1=Dynamic"
block spectrum0 spectrumtxt

connect source 0 fconv0 0  	{gauss0: —ÿ¿:é„,fconv0:x:float}
connect fconv0 0 spectrum0 0  	

