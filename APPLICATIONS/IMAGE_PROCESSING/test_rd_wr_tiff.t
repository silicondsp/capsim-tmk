
# topology file:  test_rd_tiff_1.t

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

param file baboon512.tif    
block imgrdtiff0 imgrdtiff

param file output2.tif    
param file ther.map    
block imgwrtiff0 imgwrtiff

connect imgrdtiff0 0 imgwrtiff0 0  	{imgrdtiff0:NULL:NULL,imgwrtiff0: x : image_t }

