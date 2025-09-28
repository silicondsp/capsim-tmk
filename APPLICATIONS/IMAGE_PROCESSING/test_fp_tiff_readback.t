
# topology file:  test_fp_tiff_readback.t

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

param file output-asc.img    fileName   "Name of output file"
block imgprasc0 imgprasc

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
block prbimgdisp0755 imgdisp

param file output_fp.tif    fileName   " File that contains  TIFF image "
block imgrdfptiff0 imgrdfptiff

connect imgprasc0 0 prbimgdisp0755 0  	
connect imgrdfptiff0 0 imgprasc0 0  	{imgrdfptiff0:NULL:NULL,imgprasc0:x:image_t}

