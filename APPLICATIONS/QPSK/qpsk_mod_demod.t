
# topology file:  qpsk_mod_demod.t

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

arg 0 float 0.1 "Rolloff Factor"
arg 1 float 4000 "tx center frequency"
arg 2 float 3999 "rx center frequency"
arg 3 int 1024 "number of bits"

param arg 3
param int 12
param float 1
param int 128
block bdata0 bdata

param int 10000
param float 1
param float 32000
param arg 1
param float 0
param float 1
param int 128
block sine0 sine

block qpsk0 qpsk

param int 8
block stc0 stc

param int 8
param int 8
param arg 0
block sqrtnyq0 sqrtnyq

block mixer0 mixer

param int 8
block stc1 stc

param int 8
param int 8
param arg 0
block sqrtnyq1 sqrtnyq

block mixer1 mixer

block add0 add

block node0 node

param int 10000
param float 1
param float 32000
param arg 2
param float 0
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
param int 1
param int 0
param int 0
block scatter0 scatter

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
connect add0 0 node0 0  	
connect node0 0 mixer2 0  	
connect node0 1 mixer3 0  	
connect sine1 0 mixer2 1  	
connect sine1 1 mixer3 1  	
connect mixer2 0 sqrtnyq2 0  	
connect mixer3 0 sqrtnyq3 0  	
connect sqrtnyq2 0 scatter0 0  	
connect sqrtnyq3 0 scatter0 1  	

