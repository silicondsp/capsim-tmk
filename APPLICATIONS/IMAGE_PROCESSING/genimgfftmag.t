
# topology file:  genimgfftmag.t

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

param float 1    pixel   "Pixel Value"
param int 128    pwidth   "Image Width"
param int 128    pheight   "Image Height"
param int 32    rectWidth   "Rectangle Width"
param int 32    rectHeight   "Rectangle Height"
param int 64    widthOffset   "Rectangle Width Offset"
param int 64    heightOffset   "Rectangle Height Offset"
param int 0    complexFlag   "Complex Flag"
param int 0    complementFlag   "Complement Flag"
block imggen0 imggen



param file gen.tif    
param file ther.map    
block imgdisp1 imgwrtiff



param int 0    fftType   " Operation: 0=Forward FFT, 1= Inverse FFT "
param int 1    centerFlag   " Center: 0=None , 1= Yes "
param int 0    freeImageFlag   " 1=free input image, 0= don't "
block imgfft0 imgfft

block imgcxmag0 imgcxmag


param file gen_fft.tif    
param file ther.map    
block ximgdisp0 imgwrtiff




connect imggen0 0 imgdisp1 0  	
connect imgdisp1 0 imgfft0 0  	{imgdisp1:NULL:NULL,imgfft0: x : image_t }
connect imgfft0 0 imgcxmag0 0  	{imgfft0: y : image_t ,imgcxmag0:xx:image_t}
connect imgcxmag0 0 ximgdisp0 0  	

