
# topology file:  codec.t

#--------------------------------------------------- 
# Title: Voice Band Codec Simulation   
# Author: Sasan Ardalan   
# Date: November 1990   
# Description: Simulate 8 bit mu-law Codec at 8 kHz Sampling Rate   
#--------------------------------------------------- 

inform title Voice Band Codec Simulation  
inform author Sasan Ardalan  
inform date November 1990  
inform descrip Simulate 8 bit mu-law Codec at 8 kHz Sampling Rate  

arg 0 int 1240 "Number of samples"
arg 1 float 64000 "Sampling Rate"

param arg 0    num_of_samples   "Number of samples"
param float 2    magnitude   "Enter Magnitude"
param arg 1    fs   "Sampling Rate"
param float 1004    freq   "Enter Frequency"
param float 0    phase   "Enter Phase"
param float 1    pace_rate   "pace rate to determine how many samples to output"
param int 128    samples_first_time   "number of samples on the first call if paced"
block sine0 sine

param int 2200    (null)   "Number of samples"
param float 64000    (null)   "Sampling Rate"
hblock TxCodec0 TxCodec.t

param int 2200    (null)   "Number of samples"
param float 64000    (null)   "Sampling Rate"
hblock RxCodec0 RxCodec.t

param int 1024    npts   "Number of points ( dynamic window size )"
param int 200    skip   "Number of points to skip"
param file output    title   "Plot title"
param int 1    dbFlag   "Linear = 0, dB = 1"
param int 0    windFlag   "Window:0= Rec.,1=Hamm,2=Hann,3=Blackman"
param int 1    plotStyleParam   "Plot Style: 1=Line,2=Points,5=Bar Chart"
param int 1    timeFlag   "Time Domain On/Off (1/0)"
param float 64000    sampFreq   "Sampling Rate (Bin Number if zero,Normalized if Negative"
param int 1    control   "Control: 1=On, 0=Off"
param int 0    bufferType   "Buffer type:0= Float,1= Complex, 2=Integer"
param int 0    mode   "0=Static,1=Dynamic"
param string "Frequency, Hz"    xLabelSpectrum   "Spectrum X Axis  Label "
param string "Time, Sec"    xLabelTime   "Time X Axis  Label "
block spectrum0 spectrumtxt

param int 1024    npts   "Number of points to collect"
param int 1024    skip   "Number of points to skip"
param file sdr.res    sdrRes   "File to store SDR results"
param int 1    windFlag   "Window: 0=Rect., 1=Hamming"
block sdr0 sdr

param int 2000    npts   "Number of points ( dynamic plot window)"
param int 100    skip   "Number of points to skip"
param file scatter    title   "Title"
param file X    x_axis   "x Axis"
param file Y    y_axis   "y Axis"
param int 1    plotStyleParam   "Plot Style: 1=Line,2=Points,5=Bar Chart"
param int 0    fixed   "Fixed Bounds ( 0=none, 1=fixed)"
param float -1.2    minx   "Minimum x"
param float 1.2    maxx   "Maximum x"
param float -1.2    miny   "Minimum y"
param float 1.2    maxy   "Maximum y"
param int 0    markerType   "Marker type:0=dot,1=O,2=+,3=X,4=*,5=square,6=diamond,7=triangle"
param int 1    control   "Control: 1=On, 0=Off"
param int 0    bufferType   "Buffer type:0= Float,1= Complex, 2=Integer"
param int 0    mode   "0=Static,1=Dynamic"
block xyscope scattertxt

connect sine0 0 TxCodec0 0  	
connect sine0 1 xyscope 1  	
connect TxCodec0 0 RxCodec0 0  	
connect RxCodec0 0 spectrum0 0  	
connect spectrum0 0 sdr0 0  	
connect sdr0 0 xyscope 0  	

