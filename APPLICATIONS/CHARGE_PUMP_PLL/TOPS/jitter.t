
# topology file:  jitter.t

#--------------------------------------------------- 
# Title: Jitter Computation  
# Author: Pryason Pate 
# Date: 1988 
# Description: Compute Jitter using Reference Clock and Signal with Jitter  
#--------------------------------------------------- 

inform title Jitter Computation 
inform author Pryason Pate
inform date 1988
inform descrip Compute Jitter using Reference Clock and Signal with Jitter 

arg -1 (none)

param file dbn.dat    file_name   "File that contains data"
block rdfile0 rdfile

param array 2  0  1.2    level   "Array of decision levels: # of levels, levels"
block slice0 slice

param int 300000000    N   "Number of samples to output"
param int 0    first   "First sample to start from"
param float 1    gain   "Gain"
param float -0.6    offset   "DC Offset"
param int 0    operation   "Operation:0=none,1=abs,2=square,3=sqrt,4=dB"
block operate0 operate

param file zz    file_name   "Name of output file"
param int 1    control   "Print output control (0/Off, 1/On)"
param int 0    bufferType   "Buffer type:0= Float,1= Complex, 2=Integer"
block xprfile1 prfile

param file ref.dat    file_name   "File that contains data"
block rdfile1 rdfile

param int 300000000    N   "Number of samples to output"
param int 0    first   "First sample to start from"
param float 1    gain   "Gain"
param float -0.6    offset   "DC Offset"
param int 0    operation   "Operation:0=none,1=abs,2=square,3=sqrt,4=dB"
block operate1 operate

param int 1    edge   "Trigger edge: 1= Rising, 0=Falling"
param int 1    sync   "Output Rate. Synchronous/One per cycle"
block jitter0 jitter

param int 0    skip   "Points to skip"
param file stat.dat    stat_file   "File to store results"
block stats0 stats

param int 128    npts   "Number of points in each plot (dynamic window size)"
param int 0    skip   "Points to skip before first plot"
param file jitter    title   "Plot title"
param file Samples    x_axis   "X Axis label"
param file Y    y_axis   "Y-Axis label"
param int 1    plotStyleParam   "Plot Style: 1=Line,2=Points,5=Bar Chart"
param int 1    control   "Control: 1=On, 0=Off"
param int 0    mode   "0=Static,1=Dynamic"
param int 1    samplingRate   "Sampling Rate"
block plot0 plottxt

param file jitter.dat    file_name   "Name of output file"
param int 1    control   "Print output control (0/Off, 1/On)"
param int 0    bufferType   "Buffer type:0= Float,1= Complex, 2=Integer"
block xprfile0 prfile

connect rdfile0 0 slice0 0  	{rdfile0:NULL:NULL,slice0:x:float}
connect slice0 0 operate0 0  	{slice0:NULL:NULL,operate0:x:float}
connect operate0 0 xprfile1 0  	
connect xprfile1 0 jitter0 0  	{xprfile1:NULL:NULL,jitter0:x:float}
connect rdfile1 0 operate1 0  	{rdfile1:NULL:NULL,operate1:x:float}
connect operate1 0 jitter0 1  	{operate1:xmod:float,jitter0:ref:float}
connect jitter0 0 stats0 0  	{jitter0:phi:float,stats0:x:float}
connect stats0 0 plot0 0  	
connect plot0 0 xprfile0 0  	

