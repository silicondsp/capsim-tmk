# topology file:  codec.t

#--------------------------------------------------- 
# Title:   Voice Band Codec Simulation  
# Author:   Sasan Ardalan  
# Date:   November 1990  
# Description:   Simulate 8 bit mu-law Codec at 8 kHz Sampling Rate  
#--------------------------------------------------- 

inform title   Voice Band Codec Simulation  
inform author   Sasan Ardalan  
inform date   November 1990  
inform descrip   Simulate 8 bit mu-law Codec at 8 kHz Sampling Rate  

arg 0 int 1240 "Number of samples"
arg 1 float 64000 "Sampling Rate"

param arg 0
param float 2
param arg 1
param float 1004
param float 0
param float 1
param int 128
block sine0 sine

param int 2200
param float 64000
hblock TxCodec0 TxCodec.t

param int 2200
param float 64000
hblock RxCodec0 RxCodec.t

param int 1024
param int 200
param file output
param int 1
param int 0
param int 1
param int 1
param float 64000
param int 1
block spectrum0 spectrumtxt

param int 1024
param int 1024
param file sdr.res
param int 1
block sdr0 sdr

param int 2000
param int 100
param file scatter
param file X
param file Y
param int 1
param int 0
param float -1.2
param float 1.2
param float -1.2
param float 1.2
param int 0
param int 1
block scatter0 scattertxt

connect sine0 0 TxCodec0 0  	
connect sine0 1 scatter0 1  	
connect TxCodec0 0 RxCodec0 0  	
connect RxCodec0 0 spectrum0 0  	
connect spectrum0 0 sdr0 0  	
connect sdr0 0 scatter0 0  	

