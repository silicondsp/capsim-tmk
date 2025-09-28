
# topology file:  arial_histogram_equalization.t

#--------------------------------------------------- 
# Title:  
# Author:  
# Date:  
# Description:  
#--------------------------------------------------- 

inform title 
inform author 
inform date 
inform descrip 

arg -1 (none)

param file aerial4.tif    fileName   " File that contains  TIFF image "
block imgrdtiff0 imgrdtiff

param float 0    start   "Starting point of left most bin"
param float 255    stop   "Ending point of right  most bin"
param int 100    numberOfBins   "Number of bins"
param file none    file_spec   "File name for output"
param int 1000    npts   "Number of points to collect"
param int 0    skip   "Points to skip before first plot"
param file Histogram_Before    graphTitle   "Title"
param file Bins    x_axis   "X axis label"
param file Histogram    y_axis   "Y axis label"
param int 5    plotStyleParam   "Plot Style: 1=Line,2=Points,5=Bar Chart"
param int 1    control   "Control: 1=On, 0=Off"
param int 1    bufferType   "Buffer Type: 0= float, 1=image"
block hist0 histtxt

param file prehist.tif    
param file lin.map    
block imgdisp0 imgwrtiff



param int 256    levels   "Levels (Power of two)"
block imghisteq0 imghisteq

param float 0    start   "Starting point of left most bin"
param float 255    stop   "Ending point of right  most bin"
param int 100    numberOfBins   "Number of bins"
param file none    file_spec   "File name for output"
param int 1000    npts   "Number of points to collect"
param int 0    skip   "Points to skip before first plot"
param file Equilized    graphTitle   "Title"
param file Bins    x_axis   "X axis label"
param file Histogram    y_axis   "Y axis label"
param int 5    plotStyleParam   "Plot Style: 1=Line,2=Points,5=Bar Chart"
param int 1    control   "Control: 1=On, 0=Off"
param int 1    bufferType   "Buffer Type: 0= float, 1=image"
block hist1 histtxt


param file  histeq.tif    
param file lin.map    
block ximgdisp1 imgwrtiff




connect imgrdtiff0 0 hist0 0  	
connect hist0 0 imgdisp0 0  	
connect imgdisp0 0 imghisteq0 0  	{imgdisp0:NULL:NULL,imghisteq0:x:image_t}
connect imghisteq0 0 hist1 0  	
connect hist1 0 ximgdisp1 0  	

