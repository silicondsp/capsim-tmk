
# topology file:  svdtest.t

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

param file svdtestmatrix.dat
block imgrdasc0 imgrdasc

param file svdresults.dat
block singvaldec0 singvaldec

connect imgrdasc0 0 singvaldec0 0  	

