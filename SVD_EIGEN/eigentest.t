
# topology file:  eigentest.t

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

param file matrix.dat
block imgrdasc0 imgrdasc

param file eigen.dat
block eigen0 eigen

connect imgrdasc0 0 eigen0 0  	

