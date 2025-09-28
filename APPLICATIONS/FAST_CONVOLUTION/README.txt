
Fast Convolution.

First run (MSYS2):

 winpty   ../../BIN/MSYS2/capsim.exe fastconvimp.t
 
 This will produce fastconv.tim and fastconv.fre which is the impulse response and frequency response of the filter.
 
 Then run xplot by typimg:
      source xplot
      
      
 
 Next  run:
 
  winpty   ../../BIN/MSYS2/capsim.exe fastconvtest.t
  
  Then run xplot by typimg:
      source xplot
  The plots will show the spectrum of filtered noise.
  