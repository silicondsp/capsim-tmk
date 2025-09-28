
# topology file:  fftforinv.t

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

param file lady.tif    fileName   " File that contains  TIFF image "
block imgrdtiff0 imgrdtiff

param int 0    fftType   " Operation: 0=Forward FFT, 1= Inverse FFT "
param int 0    centerFlag   " Center: 0=None , 1= Yes "
param int 0    freeImageFlag   " 1=free input image, 0= don't "
block imgfft0 imgfft

block imgnode0 imgnode

param int 1    fftType   " Operation: 0=Forward FFT, 1= Inverse FFT "
param int 0    centerFlag   " Center: 0=None , 1= Yes "
param int 0    freeImageFlag   " 1=free input image, 0= don't "
block imgfft1 imgfft

param int 0    freeImageFlag   "1=free input image, 0= don't"
block imgcxtrl0 imgcxtrl



param file fft_after_inverse.tif    
param file lin.map    
block ximgdisp0 imgwrtiff



block imgcxmag0 imgcxmag


param file  fft.tif    
param file lin.map    
block prbimgdisp0840 imgwrtiff




connect imgrdtiff0 0 imgfft0 0  	{imgrdtiff0:NULL:NULL,imgfft0: x : image_t }
connect imgfft0 0 imgnode0 0  	{imgfft0: y : image_t ,imgnode0:x:image_t}
connect imgnode0 0 imgfft1 0  	{imgnode0:NULL:NULL,imgfft1: x : image_t }
connect imgnode0 1 imgcxmag0 0  	
connect imgfft1 0 imgcxtrl0 0  	{imgfft1: y : image_t ,imgcxtrl0:xx:image_t}
connect imgcxtrl0 0 ximgdisp0 0  	
connect imgcxmag0 0 prbimgdisp0840 0  	

