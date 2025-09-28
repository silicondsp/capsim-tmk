
# topology file:  nonlineartest.t

#--------------------------------------------------- 
# Title:  
# Author:  
# Date:  
# Description:  
#--------------------------------------------------- 

inform title 
inform author 
inform date 
inform descrip 

arg -1 (none)

param file lady.tif    fileName   " File that contains floating point TIFF image "
block imgrdfptiff0 imgrdtiff

param int 3    type   "Noise Type:0=none,1=uniform,2=normal,3=spike"
param file dfjklj    expression   "Expression for seed generation"
param float 3    param1   "param1: a(uniform), mean (normal) trigger(spike)"
param float 100    param2   "param2: b(uniform), std (normal) multiplier(spike)"
block imgaddnoise0 imgaddnoise


param int 3    type   "Nonliner Filter Type:2=min,3=median,4=max"
param int 3    order   "Order"
param int 0    freeImageFlag   "1=free input image, 0= don't"
block imgnonlinfil0 imgnonlinfil



param file pre.tif    
param file lin.map    
block imgdisp0 imgwrtiff


param file post.tif    
param file lin.map    
block ximgdisp1 imgwrtiff



connect imgrdfptiff0 0 imgaddnoise0 0
connect imgaddnoise0 0 imgdisp0 0
connect imgdisp0 0 imgnonlinfil0 0
connect imgnonlinfil0 0 ximgdisp1 0

