
# topology file:  circuit.t

#--------------------------------------------------- 
# Title:  
# Author:  
# Date:  
# Description:  
#--------------------------------------------------- 

inform title  
inform author  Kassel
inform date  1991
inform descrip  

arg 0 int 1000 "number of samples"
arg 1 int 9000 "number to skip"
arg 2 int 10000 "total samples"

param arg 2    num_of_samples   "total samples"
param float 1    pace_rate   "pace rate to determine how many samples to output"
param int 128    samples_first_time   "number of samples on the first call if paced"
block zero0 zero

param float 2.304e+07    fs   "Sampling Rate"
param float 115000    fo   "Center Frequency"
block vcm0 vcm

param arg 2    num_of_samples   "total samples"
param float 1    magnitude   "Magnitude"
param arg 2    np   "total samples"
param arg 2    nw   "total samples"
param int 20    nd   "Initial delay in samples"
param float 0    dcOffset   "DC offset"
param float 1    pace_rate   "pace rate to determine how many samples to output"
param int 128    samples_first_time   "number of samples on the first call if paced"
block pulse0 pulse

param arg 2    num_of_samples   "total samples"
param float 1    pace_rate   "pace rate to determine how many samples to output"
param int 128    samples_first_time   "number of samples on the first call if paced"
block zero1 zero

param int 52    num_of_samples   "total number of samples to output"
param int 15    initialize   "Initialization for shift register"
param float 1    pace_rate   "pace rate to determine how many samples to output"
param int 128    samples_first_time   "number of samples on the first call if paced"
block bdata0 bdata

param int 1    code_type   "Code type:0-Binary(NRZ),1-Biphase(Manchester),2-2B1Q,3-RZ-AMI(Alternate mark inversion)"
param int 192    smplbd   "Samples per baud"
block linecode0 linecode

block sink0 sink

param file rect96    filename   "File name containing impulse response samples"
param int 96    N   "Order of impulse response"
block convolve0 convolve

param int 20    samples_delay   "Enter number of samples to delay"
block delay1 delay

param float 0    min   "minimum value"
param float 1    max   "maximum value"
block limiter0 limiter

param float 2.304e+07    fs   "Sampling Rate"
param float 2.88e+06    fo   "Center Frequency"
block vcm2 vcm

param int 1000    (null)   "number to plot"
param int 9000    (null)   "number to skip"
hblock clockrec0 clockrec.t

hblock phasedet0 phasedet.t

param float 1e-04    g1   "Integrate gain"
param float 0.01    vs   "Voltage step"
block pump0 pump

param int 10000    npts   "Number of points in each plot (dynamic window size)"
param int 0    skip   "Points to skip before first plot"
param file PUMP    title   "Plot title"
param file X    x_axis   "X Axis label"
param file Y    y_axis   "Y-Axis label"
param int 1    plotStyleParam   "Plot Style: 1=Line,2=Points,5=Bar Chart"
param int 1    control   "Control: 1=On, 0=Off"
param int 0    mode   "0=Static,1=Dynamic"
param int 1    samplingRate   "Sampling Rate"
block plot0 plottxt

param float 2.304e+07    fs   "Sampling Rate"
param float 120000    fo   "Center Frequency"
block vcm1 vcm

param int 1    samples_delay   "Enter number of samples to delay"
block delay0 delay



connect zero0 0 vcm0 0  	{zero0:NULL:NULL,vcm0:lambda:float}
connect vcm0 0 clockrec0 3  	initial
connect pulse0 0 clockrec0 1  	DGATE
connect zero1 0 vcm2 0  	{zero1:NULL:NULL,vcm2:lambda:float}
connect bdata0 0 linecode0 0  	{bdata0:NULL:NULL,linecode0:bindata:float}
connect linecode0 0 convolve0 0  	{linecode0:NULL:NULL,convolve0:x:float}
connect linecode0 1 sink0 0  	
connect convolve0 0 delay1 0  	{convolve0:y:float,delay1:x:float}
connect delay1 0 limiter0 0  	{delay1:NULL:NULL,limiter0:x:float}
connect limiter0 0 clockrec0 0  	Data
connect vcm2 0 clockrec0 2  	Clock
connect clockrec0 0 phasedet0 0  	10
connect phasedet0 0 pump0 0  	{phasedet0:NULL:NULL,pump0:up:float}
connect phasedet0 1 pump0 1  	{phasedet0:NULL:NULL,pump0:down:float}
connect pump0 0 plot0 0  	
connect plot0 0 vcm1 0  	{plot0:NULL:NULL,vcm1:lambda:float}
connect vcm1 0 delay0 0  	{vcm1:data_out:float,delay0:x:float}
connect delay0 0 phasedet0 1  	 

