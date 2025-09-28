
Use the perl script ber.pl to generate BER for a QPSK digital communication
link for various noise levels.
First erase ecount.dat.
Then run:

  perl ber.pl

Note that the perl script uses the topology template:
     sys-ete-ber.template 
To create the "temp.t" topology which is run in capsim in batch mode:
     ../../BIN/capsim temp.t

After each run, ecount.dat is apended with the new BER info.


To run the end to end QPSK digital link use:

    ./capsim -b

then load sys-ete.t as the topology.


