
# topology file:  test_wr_fp_tiff_baboon.t

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

param file baboon512.tif    fileName   " File that contains  TIFF image "
block imgrdtiff0 imgrdtiff

param file baboonfp.tif    fileName   " Name of output file "
param file lin.map    colorMapFile   " Color Map File "
block imgwrfptiff0 imgwrfptiff

connect imgrdtiff0 0 imgwrfptiff0 0  	{imgrdtiff0:NULL:NULL,imgwrfptiff0: x : image_t }

