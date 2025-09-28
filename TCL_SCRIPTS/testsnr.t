
# topology file:  testsnr.t

#--------------------------------------------------- 
# Title: Èb 
# Author: Èb 
# Date: Èb 
# Description: Èb 
#--------------------------------------------------- 

inform title Èb
inform author Èb
inform date Èb
inform descrip Èb

arg -1 (none)

param int 2000    num_of_samples   "total number of samples to output"
param float 1    magnitude   "Enter Magnitude"
param float 32000    fs   "Enter Sampling Rate"
param float 1000    freq   "Enter Frequency"
param float 0    phase   "Enter Phase"
param float 1    pace_rate   "pace rate to determine how many samples to output"
param int 128    samples_first_time   "number of samples on the first call if paced"
block sine0 sine

param float 20    snr   "SNR, dB"
param int 200    preambleSize   "Preamble Size"
param int 100    windowSize   "Window Size"
param float 1e-06    silenceThreshold   "Silence Threshold"
param int 333    seed   "Seed for random number generator"
param int 0    verbose   "Verbose"
block setsnr0 setsnr

param int 1024    npts   "Number of points to collect"
param int 0    skip   "Number of points to skip"
param file sdr.dat    sdrRes   "File to store SDR results"
param int 0    windFlag   "Window: 0=Rect., 1=Hamming"
block sdr0 sdr

param int 0    skip   "Points to skip"
param file stat.dat    stat_file   "File to store results"
block stats0 stats

connect sine0 0 setsnr0 0  	{sine0:À¬ÿ¿:é„,setsnr0:inp:float}
connect setsnr0 0 sdr0 0  	
connect sdr0 0 stats0 0  	{sdr0:out:float,stats0:x:float}

