
# topology file:  zz.t

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

param file speech8.aif    fileName   "Name of AIFF File"
block rdaiff0 rdaiff

param file speech_text.dat    file_name   "Name of output file"
param int 1    control   "Print output control (0/Off, 1/On)"
param int 0    bufferType   "Buffer type:0= Float,1= Complex, 2=Integer"
block prfile0 prfile

param file out_speech.aif    fileName   "Name of output file"
param int 8    bits   "Number of bits"
param float                   8000    samplingRate   "Sampling Rate Hz"
param float                    255    range   "Range"
param float                      0    dcOffset   "Add Constant"
param float                      1    scale   "Multiplication Factor"
param int 0    bufferType   "Buffer type:0= Float, 1=Integer"
param int 0    playFlag   "Play AIFF File:0=No,1=Yes"
block wraiff0 wraiff

connect rdaiff0 0 prfile0 0  	
connect prfile0 0 wraiff0 0  	

