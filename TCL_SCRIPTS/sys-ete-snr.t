
# topology file:  sys-ete-snr.t

#--------------------------------------------------- 
# Title: Digital Communication QPSK  
# Author: Sasan Ardalan  
# Date: August 2002  
# Description: Computes BER of a QPSK Digital Communication Link	 
#--------------------------------------------------- 

inform title Digital Communication QPSK 
inform author Sasan Ardalan 
inform date August 2002 
inform descrip Computes BER of a QPSK Digital Communication Link	

arg 0 float 0.5 "Rolloff Factor"
arg 1 float 1.5e+06 "tx center frequency"
arg 2 float 1.5e+06 "rx center frequency"
arg 3 int 100000 "Number of bits"
arg 4 float 0 "rx phase"
arg 5 int 4 "Timing Sample"

param arg 3    num_of_samples   "Number of bits"
param int 12    initialize   "Initialization for shift register"
param float 1    pace_rate   "pace rate to determine how many samples to output"
param int 128    samples_first_time   "number of samples on the first call if paced"
block bdata0 bdata

block qpsk0 qpsk

param int 8    smplbd   "Samples per baud"
block stc0 stc

param int 8    smplbd   "samples per baud interval."
param int 8    expfft   "expfft: 2^expfft=fft length to use."
param arg 0    beta   "Rolloff Factor"
block sqrtnyq0 sqrtnyq

param int 8    smplbd   "Samples per baud"
block stc1 stc

param int 8    smplbd   "samples per baud interval."
param int 8    expfft   "expfft: 2^expfft=fft length to use."
param arg 0    beta   "Rolloff Factor"
block sqrtnyq1 sqrtnyq

block node1 node

param int -1    num_of_samples   "total number of samples to output"
param float 1    magnitude   "Enter Magnitude"
param float 1e+07    fs   "Enter Sampling Rate"
param arg 1    freq   "tx center frequency"
param float 0    phase   "Enter Phase"
param float 1    pace_rate   "pace rate to determine how many samples to output"
param int 128    samples_first_time   "number of samples on the first call if paced"
block sine0 sine

block mixer0 mixer

block mixer1 mixer

block add0 add

param float 5    snr   "SNR, dB"
param int 200    preambleSize   "Preamble Size"
param int 100    windowSize   "Window Size"
param float 1e-06    silenceThreshold   "Silence Threshold"
param int 333    seed   "Seed for random number generator"
param int 0    verbose   "Verbose"
block setsnr0 setsnr

block node0 node

param int -1    num_of_samples   "total number of samples to output"
param float 1    magnitude   "Enter Magnitude"
param float 1e+07    fs   "Enter Sampling Rate"
param arg 2    freq   "rx center frequency"
param arg 4    phase   "rx phase"
param float 1    pace_rate   "pace rate to determine how many samples to output"
param int 128    samples_first_time   "number of samples on the first call if paced"
block sine1 sine

block mixer2 mixer

block mixer3 mixer

param int 8    smplbd   "samples per baud interval."
param int 8    expfft   "expfft: 2^expfft=fft length to use."
param arg 0    beta   "Rolloff Factor"
block sqrtnyq2 sqrtnyq

param int 8    smplbd   "samples per baud interval."
param int 8    expfft   "expfft: 2^expfft=fft length to use."
param arg 0    beta   "Rolloff Factor"
block sqrtnyq3 sqrtnyq

param int 8    N   "Ratio input rate/output rate,N"
param array 1  0    phases   "Array: Specifies the phase (delay in samples relative to first input sample) for each output."
block demux0 demux

param int 8    N   "Ratio input rate/output rate,N"
param array 1  0    phases   "Array: Specifies the phase (delay in samples relative to first input sample) for each output."
block demux1 demux

param int 128    npts   "Number of points ( dynamic plot window)"
param int 0    skip   "Number of points to skip"
param file Scatter    title   "Title"
param file X    x_axis   "x Axis"
param file Y    y_axis   "y Axis"
param int 2    plotStyleParam   "Plot Style: 1=Line,2=Points,5=Bar Chart"
param int 0    fixed   "Fixed Bounds ( 0=none, 1=fixed)"
param float -1.2    minx   "Minimum x"
param float 1.2    maxx   "Maximum x"
param float -1.2    miny   "Minimum y"
param float 1.2    maxy   "Maximum y"
param int 0    markerType   "Marker type:0=dot,1=O,2=+,3=X,4=*,5=square,6=diamond,7=triangle"
param int 0    control   "Control: 1=On, 0=Off"
param int 0    bufferType   "Buffer type:0= Float,1= Complex, 2=Integer"
param int 0    mode   "0=Static,1=Dynamic"
block scatter1 scattertxt

param float 1    gain   "Normalizing Gain"
block dec_qpsk1 dec_qpsk

block node2 node

param int 24    samples_delay   "Enter number of samples to delay"
block delay0 delay

param int 100    ignore   "Number of samples to ignore for final error tally"
param int 1000000    err_msg   "Index after which each error is printed to terminal"
param file ecount.dat    fileName   "File name to append results"
block ecountfap0 ecountfap

connect bdata0 0 qpsk0 0  	{bdata0:¿¨ˇø:ãÖ»Òˇˇ…√UHâÂHÅÏ ,qpsk0:data:float}
connect bdata0 1 delay0 0  	
connect qpsk0 0 stc0 0  	{qpsk0:inPhase:float,stc0:bindata:float}
connect qpsk0 1 stc1 0  	
connect stc0 0 sqrtnyq0 0  	{stc0:quadPhase:float,sqrtnyq0:x:float}
connect sqrtnyq0 0 mixer0 0  	{sqrtnyq0:y:float,mixer0:x:float}
connect stc1 0 sqrtnyq1 0  	{stc1:y:float,sqrtnyq1:x:float}
connect sqrtnyq1 0 node1 0  	{sqrtnyq1:y:float,node1:x:float}
connect node1 0 mixer1 0  	{node1:y:float,mixer1:x:float}
connect node1 1 sine0 0  	
connect sine0 0 mixer0 1  	{sine0:y:float,mixer0:x:float}
connect sine0 1 mixer1 1  	{sine0:y:float,mixer1:y:float}
connect mixer0 0 add0 0  	
connect mixer1 0 add0 1  	
connect add0 0 setsnr0 0  	{add0:z:float,setsnr0:inp:float}
connect setsnr0 0 node0 0  	{setsnr0:out:float,node0:x:float}
connect node0 0 mixer2 0  	{node0:out:float,mixer2:x:float}
connect node0 1 mixer3 0  	{node0:out:float,mixer3:y:float}
connect node0 2 sine1 0  	
connect sine1 0 mixer2 1  	{sine1:out:float,mixer2:x:float}
connect sine1 1 mixer3 1  	{sine1:out:float,mixer3:y:float}
connect mixer2 0 sqrtnyq2 0  	{mixer2:z:float,sqrtnyq2:x:float}
connect mixer3 0 sqrtnyq3 0  	{mixer3:z:float,sqrtnyq3:x:float}
connect sqrtnyq2 0 demux0 0  	{sqrtnyq2:y:float,demux0:x:float}
connect sqrtnyq3 0 demux1 0  	{sqrtnyq3:y:float,demux1:x:float}
connect demux0 0 scatter1 0  	
connect demux1 0 scatter1 1  	
connect scatter1 0 dec_qpsk1 0  	{scatter1:y:float,dec_qpsk1:id:float}
connect scatter1 1 dec_qpsk1 1  	{scatter1:y:float,dec_qpsk1:qd:float}
connect dec_qpsk1 0 node2 0  	{dec_qpsk1:bits:float,node2:x:float}
connect node2 0 ecountfap0 1  	{node2:bits:float,ecountfap0:w:float}
connect delay0 0 ecountfap0 0  	{delay0:bits:float,ecountfap0:w:float}

