
# topology file:  test_tiff_write_fp.t

#--------------------------------------------------- 
# Title: ------   
# Author: ------   
# Date: ------   
# Description: ------   
#--------------------------------------------------- 

inform title ------  
inform author ------  
inform date ------  
inform descrip ------  

arg -1 (none)

param file lena512.tif    fileName   " File that contains  TIFF image "
block imgrdtiff0 imgrdtiff

param float 0    thresh   "Threshold"
param float 0    dcOffset   "DC Offset applied before threshold"
param float 1    gain   "Gain"
param file Image    imageTitle   "Image title"
param file x_axis    x_axis   "X-Axis label"
param file y_axis    y_axis   "Y-Axis label"
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
param file tiff.cmap    colorMap   "Color Map"
block prbimgdisp00 imgdisp

param file output_fp.tif    fileName   " Name of output file "
param file tiff.cmap    colorMapFile   " Color Map File "
block imgwrfptiff0 imgwrfptiff

connect imgrdtiff0 0 prbimgdisp00 0  	
connect prbimgdisp00 0 imgwrfptiff0 0  	{prbimgdisp00:NULL:NULL,imgwrfptiff0: x : image_t }

