
# topology file:  arq2.t

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

arg 0 int 64 

param int 4096    num_of_samples   "total number of samples to output"
param int 128    payloadLength   "Payload Length"
param int 12    initialize   "Initialization for shift register"
param float 1    pace_rate   "pace rate to determine how many samples to output"
param int 64    samples_first_time   "number of samples on the first call if paced"
block datagen0 datagen

param file input.dat    file_name   "Name of output file"
param int 1    control   "Print output control (0/Off, 1/On)"
param int 0    bufferType   "Buffer type:0= Float,1= Complex, 2=Integer"
block prfile1 prfile


param arg 0
param int 1    debugFlag   "Debug:1=true,0=false"
block txhdlc0 txhdlc

param float 0.03    (null)   "Noise Variance"
hblock v29codec0 v29codec.t

param file rxin.dat    file_name   "Name of output file"
param int 1    control   "Print output control (0/Off, 1/On)"
param int 0    bufferType   "Buffer type:0= Float,1= Complex, 2=Integer"
block prfile3 prfile

param arg 0
param int 1    debugFlag   "Debug:1=true,0=false"
block rxhdlc0 rxhdlc

block v2b0 v2b


param int 0    samples_delay   "Enter number of samples to delay"
block fxdelay0 fxdelay

param file rxhdlc0.dat        "Name of output file"
param int 1    control   "Print output control (0/Off, 1/On)"
param int 2    bufferType   "Buffer type:0= Float,1= Complex, 2=Integer"
block prfile2 prfile

param file v2b0.dat    
param int 1    control   "Print output control (0/Off, 1/On)"
param int 2    bufferType   "Buffer type:0= Float,1= Complex, 2=Integer"
block prfile5 prfile

block itf1 itf

param file rts.dat    file_name   "Name of output file"
param int 1    control   "Print output control (0/Off, 1/On)"
param int 0    bufferType   "Buffer type:0= Float,1= Complex, 2=Integer"
block prfile4 prfile

block itf0 itf

param int 128    npts   "Number of points in each plot (dynamic window size)"
param int 0    skip   "Points to skip before first plot"
param file RX_Ack    title   "Plot title"
param file HDLC    x_axis   "X Axis label"
param file Cntrl    y_axis   "Y-Axis label"
param int 5    plotStyleParam   "Plot Style: 1=Line,2=Points,5=Bar Chart"
param int 1    control   "Control: 1=On, 0=Off"
param int 0    mode   "0=Static,1=Dynamic"
param int 1    samplingRate   "Sampling Rate"
block xplot0 plottxt

param int 128    npts   "Number of points in each plot (dynamic window size)"
param int 0    skip   "Points to skip before first plot"
param file Request_To_Send    title   "Plot title"
param file HDLC    x_axis   "X Axis label"
param file NR    y_axis   "Y-Axis label"
param int 5    plotStyleParam   "Plot Style: 1=Line,2=Points,5=Bar Chart"
param int 1    control   "Control: 1=On, 0=Off"
param int 0    mode   "0=Static,1=Dynamic"
param int 1    samplingRate   "Sampling Rate"
block xplot1 plottxt

connect datagen0 0 prfile1 0  	
connect prfile1 0 txhdlc0 0  
connect txhdlc0 0 v29codec0 0  	
connect v29codec0 0 prfile3 0  	
connect prfile3 0 rxhdlc0 0  	
connect rxhdlc0 0 v2b0 0  
connect rxhdlc0 1 fxdelay0 0 
connect v2b0 0 prfile5 0   	
connect fxdelay0 0 prfile2 0  	
connect fxdelay0 1 itf1 0  	
connect fxdelay0 2 itf0 0  	
connect prfile2 0 txhdlc0 1  	
connect itf1 0 prfile4 0  	
connect prfile4 0 xplot1 0  	
connect itf0 0 xplot0 0  	
connect xplot1 0 datagen0 0  	
