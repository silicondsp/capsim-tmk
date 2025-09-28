Charge Pump PLL
----------------


The main topology is:

pll_chp_state_space_4GHz_jitter-2.t

It is located in the TOPS directory.


For project Web Site see:

http://www.ccdsp.org/projects/charge_pump_pll.html

Use the Java Plotting Application IIPPlot to plot the results:

java -jar $CAPSIM/TOOLS/IIPPlot  VCO_Input.tim 


To BUILD type:


Build capsim in this directory using the command:
  bash $CAPSIM/TOOLS/precapsim_macosx.sh 
or
 
  bash $CAPSIM/TOOLS/precapsim_msys2.sh
or
  bash $CAPSIM/TOOLS/precapsim_linux.sh
depending on your platform.


Note the datasets are very large. It will take a while for the plot to show the results even though it pops up.

CCDSP.org


