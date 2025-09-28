
# topology file:  testinterp.t

#--------------------------------------------------- 
# Title: ”Ñ0ž¤1@ 
# Author: ”Ñ0ž¤1@ 
# Date: ”Ñ0ž¤1@ 
# Description: ”Ñ0ž¤1@ 
#--------------------------------------------------- 

inform title ”Ñ0ž¤1@
inform author ”Ñ0ž¤1@
inform date ”Ñ0ž¤1@
inform descrip ”Ñ0ž¤1@

arg -1 (none)

param file lady.tif    fileName   " File that contains floating point TIFF image "
block imgrdfptiff0 imgrdtiff

param int 4    widthFactor   "width factor"
param int 2    heightFactor   "heightFactor"
block imginterp0 imginterp

param float 0    thresh   "Threshold"
param float 0    dcOffset   "DC Offset applied before threshold"
param float 1    gain   "Gain"
param file Image    imageTitle   "Image title"
param file X    x_axis   "X-Axis label"
param file Y    y_axis   "Y-Axis label"
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
block ximgdisp0 imgdisp

connect imgrdfptiff0 0 imginterp0 0  	{imgrdfptiff0:NULL:NULL,imginterp0:x:image_t}
connect imginterp0 0 ximgdisp0 0  	

