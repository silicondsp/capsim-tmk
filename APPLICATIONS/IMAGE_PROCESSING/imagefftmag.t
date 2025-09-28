
# topology file:  imagefftmag.t

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

param file lady.tif    fileName   " File that contains  TIFF image "
block imgrdtiff0 imgrdtiff


param int 0    fftType   " Operation: 0=Forward FFT, 1= Inverse FFT "
param int 1    centerFlag   " Center: 0=None , 1= Yes "
param int 0    freeImageFlag   " 1=free input image, 0= don't "
block imgfft0 imgfft

block imgcxmag0 imgcxmag



param file fft.tif    
param file lin.map    
block imgdisp0 imgwrtiff





connect imgrdtiff0 0 imgfft0 0  	{imgrdtiff0:NULL:NULL,imgserin0:x:float}
connect imgfft0 0 imgcxmag0 0  	{imgfft0: y : image_t ,imgcxmag0:xx:image_t}
connect imgcxmag0 0 imgdisp0 0  	

