
Run the topology:

fadesetup.t

The block jkfade models doppler fading channel using Jake's method.
Change the speed v and check the Envelope.tim file to see the deep fades.

See the PDF file for details.



param arg 0    npts   "Number of Samples"
param int 0    type   "Doppler Spectrum, only Ez supported at this time."
param arg 1    fs   "Sampling Rate"
param float 5e+09    fc   "Carrier frequency"
param float 10    v   "Vehicle Velocity, m/s"
param float 1    p   "Power"
param array 1  0    delays   "Array of multipath delays microsec: number_of_paths t0 t1  ... "
param array 1  1    powers   "Array of multipath powers: number_of_paths p0 p1  ... "
param int 40    numberArrivals   "Number of Plane Waves arriving plane waves, N where N >=34"
block jkfade0 jkfade



