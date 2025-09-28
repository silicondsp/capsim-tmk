
# topology file:  aifftest.t

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

connect rdaiff0 0 prfile0 0  	

