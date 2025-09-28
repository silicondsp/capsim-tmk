
# topology file:  qpsk.t

#--------------------------------------------------- 
# Title: `­:@	 
# Author: `­:@	 
# Date: `­:@	 
# Description: `­:@	 
#--------------------------------------------------- 

inform title `­:@	
inform author `­:@	
inform date `­:@	
inform descrip `­:@	

arg -1 (none)

param int 1024
param int 12
param float 1
param int 128
block bdata0 bdata

param int 10000
param float 1
param float 32000
param float 2000
param float 0
param float 1
param int 128
block sine0 sine

block qpsk0 qpsk

param int 8
block stc0 stc

param int 8
param int 8
param float 0.2
block sqrtnyq0 sqrtnyq

block mixer0 mixer

param int 8
block stc1 stc

param int 8
param int 8
param float 0.2
block sqrtnyq1 sqrtnyq

block mixer1 mixer

block add0 add

param int 128
param int 0
param file Spectrum
param int 0
param int 0
param int 1
param int 1
param float 0
param int 1
param int 0
param int 0
block spectrum0 spectrumtxt

connect bdata0 0 qpsk0 0  	
connect sine0 0 mixer0 1  	
connect sine0 1 mixer1 1  	
connect qpsk0 0 stc0 0  	
connect qpsk0 1 stc1 0  	
connect stc0 0 sqrtnyq0 0  	
connect sqrtnyq0 0 mixer0 0  	
connect mixer0 0 add0 0  	
connect stc1 0 sqrtnyq1 0  	
connect sqrtnyq1 0 mixer1 0  	
connect mixer1 0 add0 1  	
connect add0 0 spectrum0 0  	

