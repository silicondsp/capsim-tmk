
# topology file:  ssb.t

#--------------------------------------------------- 
# Title:  Single Side Band Modulation/Demodulation 
# Author:  Sasan Ardalan 
# Date:   
# Description:   
#--------------------------------------------------- 

inform title  Single Side Band Modulation/Demodulation 
inform author  Sasan Ardalan 
inform date   
inform descrip   

arg 0 int 1024 "Number of samples"

param arg 0
param float 1
param float 32000
param float 2000
param float 0
param float 1
param int 128
block sine1 sine

param arg 0
param float 1
param int 3759
param float 1
param int 128
block gauss0 gauss

param int 3
param int 1
param float 32000
param float 0.1
param float 35
param float 400
param float 600
param float 220
param float 3400
param float 10
param float 4400
param file tmp
block iirfil0 iirfil

param arg 0
param float 1
param float 32000
param float 2000
param float 0
param float 1
param int 128
block sine0 sine

block node0 node

param int 128
param float 0.5
param int 8
block hilbert0 hilbert

param int 64
block delay0 delay

block mixer1 mixer

param float -1
block gain0 gain

block mixer0 mixer

block add0 add

param float 0
param int 333
block addnoise0 addnoise

block node1 node

block mixer2 mixer

param int 64
block delay1 delay

param arg 0
param int 0
param file Modulated
param int 0
param int 0
param int 1
param int 1
param float 32
param int 1
block spectrum3 spectrumtxt

block node2 node

block mixer3 mixer

param int 128
param float 0.5
param int 8
block hilbert1 hilbert

param float 1
block gain1 gain

block add1 add

param arg 0
param int 0
param file demodbeforefilt
param int 0
param int 0
param int 1
param int 1
param float 32
param int 1
block spectrum2 spectrumtxt

param int 3
param int 1
param float 32000
param float 0.1
param float 35
param float 400
param float 600
param float 220
param float 3400
param float 10
param float 4400
param file tmp
block iirfil1 iirfil

param arg 0
param int 0
param file Demodulated
param int 0
param int 0
param int 1
param int 1
param float 32
param int 1
block spectrum1 spectrumtxt

block sink0 sink

param int 150
block delay2 delay

param arg 0
param int 0
param file Baseband
param int 0
param int 0
param int 1
param int 1
param float 32
param int 1
block spectrum0 spectrumtxt

block sink1 sink

connect sine1 0 mixer0 0  	
connect sine1 1 mixer1 0  	
connect gauss0 0 iirfil0 0  	
connect iirfil0 0 node0 0  	
connect sine0 0 mixer2 0  	
connect sine0 1 mixer3 0  	
connect node0 0 hilbert0 0  	
connect node0 1 delay0 0  	
connect node0 2 delay2 0  	
connect hilbert0 0 mixer1 1  	
connect delay0 0 mixer0 1  	
connect mixer1 0 gain0 0  	
connect gain0 0 add0 1  	
connect mixer0 0 add0 0  	
connect add0 0 addnoise0 0  	
connect addnoise0 0 node1 0  	
connect node1 0 spectrum3 0  	
connect node1 1 mixer2 1  	
connect mixer2 0 delay1 0  	
connect delay1 0 add1 0  	
connect spectrum3 0 node2 0  	
connect node2 0 mixer3 1  	
connect mixer3 0 hilbert1 0  	
connect hilbert1 0 gain1 0  	
connect gain1 0 add1 1  	
connect add1 0 spectrum2 0  	
connect spectrum2 0 iirfil1 0  	
connect iirfil1 0 spectrum1 0  	
connect spectrum1 0 sink0 0  	
connect delay2 0 spectrum0 0  	
connect spectrum0 0 sink1 0  	

