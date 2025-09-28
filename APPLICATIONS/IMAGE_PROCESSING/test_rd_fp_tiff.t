
# topology file:  test_rd_fp_tiff.t

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

param file ladyfp.tif    fileName   " File that contains  TIFF image "
block imgrdfptiff0 imgrdfptiff

param file out_from_fp_lady.tif    fileName   " Name of output file "
param file lin.map    colorMapFile   " Color Map File "
block imgwrtiff0 imgwrtiff

connect imgrdfptiff0 0 imgwrtiff0 0  	{imgrdfptiff0:NULL:NULL,imgwrtiff0: x : image_t }

