
# topology file:  testmanip.t

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

arg -1 (none)

param file lady.tif    fileName   " File that contains  TIFF image "
block imgrdtiff0 imgrdtiff

param int 4    operation   "Operation:0=none,1=transpose,2=flipVert,4=flipHorz,3=inverse"
param int 256    levels   "Levels (for inverse)"
block imgmanip0 imgmanip

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

connect imgrdtiff0 0 imgmanip0 0  	{imgrdtiff0:NULL:NULL,imgmanip0:x:image_t}
connect imgmanip0 0 ximgdisp0 0  	

