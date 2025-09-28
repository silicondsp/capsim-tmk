
# topology file:  filtertest.t

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

param file lady.tif    fileName   " File that contains floating point TIFF image "
block imgrdfptiff0 imgrdtiff

param int 2    type   "Noise Type:0=none,1=uniform,2=normal,3=spike"
param file dfjklj    expression   "Expression for seed generation"
param float 3    param1   "param1: a(uniform), mean (normal) trigger(spike)"
param float 20    param2   "param2: b(uniform), std (normal) multiplier(spike)"
block imgaddnoise0 imgaddnoise




param file noisy_image.tif    
param file lin.map    
block imgdisp0 imgwrtiff





param file gauss.krn    filterKernel   "Filter Kernel"
param int 0    freeImageFlag   "1=free input image, 0= don't"
block imgfilter0 imgfilter





param file filtered_gauss_kernel.tif    
param file lin.map    
block ximgdisp1 imgwrtiff


connect imgrdfptiff0 0 imgaddnoise0 0  	{imgrdfptiff0:NULL:NULL,imgaddnoise0:x:image_t}
connect imgaddnoise0 0 imgdisp0 0  	
connect imgdisp0 0 imgfilter0 0  	{imgdisp0:NULL:NULL,imgfilter0:x:image_t}
connect imgfilter0 0 ximgdisp1 0  	

