
# topology file:  test_lady_wr_tiff.t

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

param file lady_linux.img    fileName   "File that contains image. Note width and height must be first line."
block imgrdasc0 imgrdasc

param file output.tif    fileName   " Name of output file "
param file ther.map    colorMapFile   " Color Map File "
block imgwrtiff0 imgwrtiff

connect imgrdasc0 0 imgwrtiff0 0  	{imgrdasc0:NULL:NULL,imgwrtiff0: x : image_t }

