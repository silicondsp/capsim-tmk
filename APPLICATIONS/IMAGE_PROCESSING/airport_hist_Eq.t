
# topology file:  airport_hist_Eq.t

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

param file airport.tif    fileName   " File that contains floating point TIFF image "
block imgrdfptiff0 imgrdtiff

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
block hist0 hist

param float 0    thresh   "Threshold"
param float 0    dcOffset   "DC Offset applied before threshold"
param float 1    gain   "Gain"
param file Image    imageTitle   "Image title"
param file Image    x_axis   "X-Axis label"
param file Image    y_axis   "Y-Axis label"
param int 1    control   "Control: 1=On, 0=Off"
param int 1    displaySequence   "Display in same window (Animation) (1=TRUE)"
param int 0    fixedBoundsFlag   "Fixed Bounds:0= None 1=Use"
param float 0    xMin   "X Min"
param float 1    xMax   "X Max"
param float 0    yMin   "Y Min"
param float 1    yMax   "Y Max"
param int 0    enableLegend   "Enable Colormap Legend: 1=Enable, 0=Disable"
param file Legend    legendTitle   "Legend  Title"
param float 0    legendMin   "Legend  Min"
param float 256    legendMax   "Legend Max"
param float 0    axisDisplay   "Display Axis Flag: 0:Hide,1:Show"
block imgdisp0 imgdisp

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
block hist1 hist

param float 0    thresh   "Threshold"
param float 0    dcOffset   "DC Offset applied before threshold"
param float 1    gain   "Gain"
param file Histogram_Equalized    imageTitle   "Image title"
param file Histogram_Equalized    x_axis   "X-Axis label"
param file Histogram_Equalized    y_axis   "Y-Axis label"
param int 1    control   "Control: 1=On, 0=Off"
param int 1    displaySequence   "Display in same window (Animation) (1=TRUE)"
param int 0    fixedBoundsFlag   "Fixed Bounds:0= None 1=Use"
param float 0    xMin   "X Min"
param float 1    xMax   "X Max"
param float 0    yMin   "Y Min"
param float 1    yMax   "Y Max"
param int 0    enableLegend   "Enable Colormap Legend: 1=Enable, 0=Disable"
param file Legend    legendTitle   "Legend  Title"
param float 0    legendMin   "Legend  Min"
param float 256    legendMax   "Legend Max"
param float 0    axisDisplay   "Display Axis Flag: 0:Hide,1:Show"
block ximgdisp1 imgdisp

connect imgrdfptiff0 0 hist0 0  	
connect hist0 0 imgdisp0 0  	
connect imgdisp0 0 imghisteq0 0  	{imgdisp0:NULL:NULL,imghisteq0:x:image_t}
connect imghisteq0 0 hist1 0  	
connect hist1 0 ximgdisp1 0  	

