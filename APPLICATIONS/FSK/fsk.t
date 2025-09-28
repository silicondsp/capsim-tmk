
# topology file:  fsk.t

#--------------------------------------------------- 
# Title: Simple FM Modulation  
# Author: Sasan Ardalan  
# Date: Sasan Ar 
# Description: Sasan Ar 
#--------------------------------------------------- 

inform title Simple FM Modulation 
inform author Sasan Ardalan 
inform date Sasan Ar
inform descrip Sasan Ar

arg 0 int 128 "Samples per Symbol (determines bit rate)"
arg 1 float 32000 "Samples per SymSampling Rate"

param int 128
param int 12
param float 1
param int 128
block bdata0 bdata

param int 0
param arg 0
block linecode0 linecode

param arg 0
block unitf0 unitf

param int 128
param int 0
param file original
param file Samples
param file Y
param int 1
param int 1
param int 0
param int 1
block plot1 plottxt

param float 0.1
block gain0 gain

param arg 1
param float 1700
param float 1
block dco0 dco

block sink0 sink

param float 0
param int 333
block addnoise0 addnoise

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

param arg 1
param int 100
hblock fskdemod0 fskdemod.t

param int 128
param int 0
param file demod
param file Samples
param file Y
param int 1
param int 1
param int 0
param int 1
block plot0 plottxt

connect bdata0 0 linecode0 0  	
connect linecode0 0 unitf0 0  	
connect unitf0 0 plot1 0  	
connect plot1 0 gain0 0  	
connect gain0 0 dco0 0  	
connect dco0 0 addnoise0 0  	
connect dco0 1 sink0 0  	
connect addnoise0 0 spectrum0 0  	
connect spectrum0 0 fskdemod0 0  	
connect fskdemod0 0 plot0 0  	

