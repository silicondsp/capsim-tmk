First run firfloattest.t
This will generate tmp.tap which contain the taps for the FIR filter.
Then run fxfirtest.t
This will implement a fixed point FIR filter. The Spectrum will show the 
fixed point FIR filter response, Compare to the floating point spectrum.

Use the command:
       java -jar $CAPSIM/TOOLS/IIPPlot.jar SpectrumFloat.fre
To plot the floating point spectrum. Shown in dBs.

Use 
java -jar $CAPSIM/TOOLS/IIPPlot.jar SpectrumFxp8.fre
To plot the spectrum for the fixed point FIR filter. Note set to 8 bits.

Edit fxfirtest.t and set qbits parameter to 12. Also set Spectrum title to SpectrumFxp12.

Run again and plot:
     java -jar $CAPSIM/TOOLS/IIPPlot.jar SpectrumFxp12.fre

Note if you don't have a capsim executable, just run:

     bash $CAPSIM/precapsim_linux.sh
In this directory. Ignore warning then type:
     make
Twice.

This will create a local capsim executable.
To run, type
    ./capsim fxfirtest.t



