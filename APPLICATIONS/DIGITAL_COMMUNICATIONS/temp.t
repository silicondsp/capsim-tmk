# topology file:  sys-ete-ber.t

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

arg 0 float 0.5 "Rolloff Factor"
arg 1 float 1.5e+06 "tx center frequency"
arg 2 float 1.5e+06 "rx center frequency"
arg 3 int 100000 "number of bits"
arg 4 float 0 "rx phase"
arg 5 int 4 "Timing Sample"

param arg 3
param int 12
param float 1
param int 128
block bdata0 bdata

block qpsk0 qpsk

param int 8
block stc0 stc

param int 8
param int 8
param arg 0
block sqrtnyq0 sqrtnyq

param int 8
block stc1 stc

param int 8
param int 8
param arg 0
block sqrtnyq1 sqrtnyq

block node1 node

param int -1
param float 1
param float 1e+07
param arg 1
param float 0
param float 1
param int 128
block sine0 sine

block mixer0 mixer

block mixer1 mixer

block add0 add

param float 1.0 
param int 333
block addnoise0 addnoise

block node0 node

param int -1
param float 1
param float 1e+07
param arg 2
param arg 4
param float 1
param int 128
block sine1 sine

block mixer2 mixer

block mixer3 mixer

param int 8
param int 8
param arg 0
block sqrtnyq2 sqrtnyq

param int 8
param int 8
param arg 0
block sqrtnyq3 sqrtnyq

param int 8
param array 1  0
block demux0 demux

param int 8
param array 1  0
block demux1 demux

param int 128
param int 0
param file Scatter
param file X
param file Y
param int 2
param int 0
param float -1.2
param float 1.2
param float -1.2
param float 1.2
param int 0
param int 0
param int 0
param int 0
block scatter1 scattertxt

param float 1
block dec_qpsk1 dec_qpsk

block node2 node

param int 24
block delay0 delay

param int 100
param int 1000000
param file ecount.dat
block ecountfap0 ecountfap

connect bdata0 0 qpsk0 0  	
connect bdata0 1 delay0 0  	
connect qpsk0 0 stc0 0  	
connect qpsk0 1 stc1 0  	
connect stc0 0 sqrtnyq0 0  	
connect sqrtnyq0 0 mixer0 0  	
connect stc1 0 sqrtnyq1 0  	
connect sqrtnyq1 0 node1 0  	
connect node1 0 mixer1 0  	
connect node1 1 sine0 0  	
connect sine0 0 mixer0 1  	
connect sine0 1 mixer1 1  	
connect mixer0 0 add0 0  	
connect mixer1 0 add0 1  	
connect add0 0 addnoise0 0  	
connect addnoise0 0 node0 0  	
connect node0 0 mixer2 0  	
connect node0 1 mixer3 0  	
connect node0 2 sine1 0  	
connect sine1 0 mixer2 1  	
connect sine1 1 mixer3 1  	
connect mixer2 0 sqrtnyq2 0  	
connect mixer3 0 sqrtnyq3 0  	
connect sqrtnyq2 0 demux0 0  	
connect sqrtnyq3 0 demux1 0  	
connect demux0 0 scatter1 0  	
connect demux1 0 scatter1 1  	
connect scatter1 0 dec_qpsk1 0  	
connect scatter1 1 dec_qpsk1 1  	
connect dec_qpsk1 0 node2 0  	
connect node2 0 ecountfap0 1  	
connect delay0 0 ecountfap0 0  	


