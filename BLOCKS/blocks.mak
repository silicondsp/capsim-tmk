all:libblock.a 

add.c:add.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar add.s $(CAPSIM)/TOOLS/blockgen.xsl>add.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a add.s

add.o:add.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include add.c

addnoise.c:addnoise.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar addnoise.s $(CAPSIM)/TOOLS/blockgen.xsl>addnoise.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a addnoise.s

addnoise.o:addnoise.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include addnoise.c

and.c:and.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar and.s $(CAPSIM)/TOOLS/blockgen.xsl>and.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a and.s

and.o:and.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include and.c

ang.c:ang.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar ang.s $(CAPSIM)/TOOLS/blockgen.xsl>ang.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a ang.s

ang.o:ang.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include ang.c

arprocess.c:arprocess.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar arprocess.s $(CAPSIM)/TOOLS/blockgen.xsl>arprocess.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a arprocess.s

arprocess.o:arprocess.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include arprocess.c

atod.c:atod.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar atod.s $(CAPSIM)/TOOLS/blockgen.xsl>atod.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a atod.s

atod.o:atod.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include atod.c

autoxcorr.c:autoxcorr.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar autoxcorr.s $(CAPSIM)/TOOLS/blockgen.xsl>autoxcorr.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a autoxcorr.s

autoxcorr.o:autoxcorr.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include autoxcorr.c

avrow.c:avrow.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar avrow.s $(CAPSIM)/TOOLS/blockgen.xsl>avrow.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a avrow.s

avrow.o:avrow.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include avrow.c

bdata.c:bdata.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar bdata.s $(CAPSIM)/TOOLS/blockgen.xsl>bdata.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a bdata.s

bdata.o:bdata.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include bdata.c

bitmanip.c:bitmanip.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar bitmanip.s $(CAPSIM)/TOOLS/blockgen.xsl>bitmanip.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a bitmanip.s

bitmanip.o:bitmanip.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include bitmanip.c

bitvec.c:bitvec.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar bitvec.s $(CAPSIM)/TOOLS/blockgen.xsl>bitvec.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a bitvec.s

bitvec.o:bitvec.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include bitvec.c

blindadapt.c:blindadapt.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar blindadapt.s $(CAPSIM)/TOOLS/blockgen.xsl>blindadapt.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a blindadapt.s

blindadapt.o:blindadapt.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include blindadapt.c

bpf.c:bpf.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar bpf.s $(CAPSIM)/TOOLS/blockgen.xsl>bpf.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a bpf.s

bpf.o:bpf.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include bpf.c

cable.c:cable.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar cable.s $(CAPSIM)/TOOLS/blockgen.xsl>cable.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a cable.s

cable.o:cable.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include cable.c

casfil.c:casfil.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar casfil.s $(CAPSIM)/TOOLS/blockgen.xsl>casfil.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a casfil.s

casfil.o:casfil.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include casfil.c

clip.c:clip.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar clip.s $(CAPSIM)/TOOLS/blockgen.xsl>clip.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a clip.s

clip.o:clip.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include clip.c

clkdly.c:clkdly.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar clkdly.s $(CAPSIM)/TOOLS/blockgen.xsl>clkdly.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a clkdly.s

clkdly.o:clkdly.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include clkdly.c

cmplxfft.c:cmplxfft.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar cmplxfft.s $(CAPSIM)/TOOLS/blockgen.xsl>cmplxfft.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a cmplxfft.s

cmplxfft.o:cmplxfft.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include cmplxfft.c

cmux.c:cmux.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar cmux.s $(CAPSIM)/TOOLS/blockgen.xsl>cmux.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a cmux.s

cmux.o:cmux.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include cmux.c

cmxfft.c:cmxfft.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar cmxfft.s $(CAPSIM)/TOOLS/blockgen.xsl>cmxfft.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a cmxfft.s

cmxfft.o:cmxfft.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include cmxfft.c

cmxfftfile.c:cmxfftfile.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar cmxfftfile.s $(CAPSIM)/TOOLS/blockgen.xsl>cmxfftfile.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a cmxfftfile.s

cmxfftfile.o:cmxfftfile.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include cmxfftfile.c

cmxifft.c:cmxifft.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar cmxifft.s $(CAPSIM)/TOOLS/blockgen.xsl>cmxifft.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a cmxifft.s

cmxifft.o:cmxifft.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include cmxifft.c

convolve.c:convolve.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar convolve.s $(CAPSIM)/TOOLS/blockgen.xsl>convolve.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a convolve.s

convolve.o:convolve.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include convolve.c

cstime.c:cstime.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar cstime.s $(CAPSIM)/TOOLS/blockgen.xsl>cstime.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a cstime.s

cstime.o:cstime.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include cstime.c

cubepoly.c:cubepoly.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar cubepoly.s $(CAPSIM)/TOOLS/blockgen.xsl>cubepoly.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a cubepoly.s

cubepoly.o:cubepoly.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include cubepoly.c

cxadd.c:cxadd.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar cxadd.s $(CAPSIM)/TOOLS/blockgen.xsl>cxadd.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a cxadd.s

cxadd.o:cxadd.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include cxadd.c

cxaddnoise.c:cxaddnoise.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar cxaddnoise.s $(CAPSIM)/TOOLS/blockgen.xsl>cxaddnoise.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a cxaddnoise.s

cxaddnoise.o:cxaddnoise.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include cxaddnoise.c

cxconj.c:cxconj.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar cxconj.s $(CAPSIM)/TOOLS/blockgen.xsl>cxconj.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a cxconj.s

cxconj.o:cxconj.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include cxconj.c

cxcorr.c:cxcorr.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar cxcorr.s $(CAPSIM)/TOOLS/blockgen.xsl>cxcorr.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a cxcorr.s

cxcorr.o:cxcorr.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include cxcorr.c

cxdelay.c:cxdelay.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar cxdelay.s $(CAPSIM)/TOOLS/blockgen.xsl>cxdelay.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a cxdelay.s

cxdelay.o:cxdelay.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include cxdelay.c

cxgain.c:cxgain.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar cxgain.s $(CAPSIM)/TOOLS/blockgen.xsl>cxgain.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a cxgain.s

cxgain.o:cxgain.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include cxgain.c

cxmag.c:cxmag.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar cxmag.s $(CAPSIM)/TOOLS/blockgen.xsl>cxmag.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a cxmag.s

cxmag.o:cxmag.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include cxmag.c

cxmakecx.c:cxmakecx.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar cxmakecx.s $(CAPSIM)/TOOLS/blockgen.xsl>cxmakecx.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a cxmakecx.s

cxmakecx.o:cxmakecx.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include cxmakecx.c

cxmakereal.c:cxmakereal.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar cxmakereal.s $(CAPSIM)/TOOLS/blockgen.xsl>cxmakereal.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a cxmakereal.s

cxmakereal.o:cxmakereal.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include cxmakereal.c

cxmult.c:cxmult.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar cxmult.s $(CAPSIM)/TOOLS/blockgen.xsl>cxmult.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a cxmult.s

cxmult.o:cxmult.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include cxmult.c

cxnode.c:cxnode.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar cxnode.s $(CAPSIM)/TOOLS/blockgen.xsl>cxnode.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a cxnode.s

cxnode.o:cxnode.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include cxnode.c

cxphase.c:cxphase.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar cxphase.s $(CAPSIM)/TOOLS/blockgen.xsl>cxphase.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a cxphase.s

cxphase.o:cxphase.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include cxphase.c

cxrdfile.c:cxrdfile.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar cxrdfile.s $(CAPSIM)/TOOLS/blockgen.xsl>cxrdfile.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a cxrdfile.s

cxrdfile.o:cxrdfile.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include cxrdfile.c

cxreal.c:cxreal.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar cxreal.s $(CAPSIM)/TOOLS/blockgen.xsl>cxreal.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a cxreal.s

cxreal.o:cxreal.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include cxreal.c

cxreim.c:cxreim.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar cxreim.s $(CAPSIM)/TOOLS/blockgen.xsl>cxreim.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a cxreim.s

cxreim.o:cxreim.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include cxreim.c

cxsetsnr.c:cxsetsnr.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar cxsetsnr.s $(CAPSIM)/TOOLS/blockgen.xsl>cxsetsnr.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a cxsetsnr.s

cxsetsnr.o:cxsetsnr.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include cxsetsnr.c

cxsink.c:cxsink.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar cxsink.s $(CAPSIM)/TOOLS/blockgen.xsl>cxsink.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a cxsink.s

cxsink.o:cxsink.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include cxsink.c

cxskip.c:cxskip.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar cxskip.s $(CAPSIM)/TOOLS/blockgen.xsl>cxskip.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a cxskip.s

cxskip.o:cxskip.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include cxskip.c

cxsum.c:cxsum.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar cxsum.s $(CAPSIM)/TOOLS/blockgen.xsl>cxsum.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a cxsum.s

cxsum.o:cxsum.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include cxsum.c

datagen.c:datagen.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar datagen.s $(CAPSIM)/TOOLS/blockgen.xsl>datagen.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a datagen.s

datagen.o:datagen.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include datagen.c

dco.c:dco.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar dco.s $(CAPSIM)/TOOLS/blockgen.xsl>dco.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a dco.s

dco.o:dco.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include dco.c

dco2.c:dco2.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar dco2.s $(CAPSIM)/TOOLS/blockgen.xsl>dco2.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a dco2.s

dco2.o:dco2.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include dco2.c

dec_qpsk.c:dec_qpsk.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar dec_qpsk.s $(CAPSIM)/TOOLS/blockgen.xsl>dec_qpsk.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a dec_qpsk.s

dec_qpsk.o:dec_qpsk.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include dec_qpsk.c

decbin.c:decbin.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar decbin.s $(CAPSIM)/TOOLS/blockgen.xsl>decbin.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a decbin.s

decbin.o:decbin.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include decbin.c

decimate.c:decimate.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar decimate.s $(CAPSIM)/TOOLS/blockgen.xsl>decimate.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a decimate.s

decimate.o:decimate.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include decimate.c

delay.c:delay.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar delay.s $(CAPSIM)/TOOLS/blockgen.xsl>delay.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a delay.s

delay.o:delay.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include delay.c

demux.c:demux.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar demux.s $(CAPSIM)/TOOLS/blockgen.xsl>demux.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a demux.s

demux.o:demux.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include demux.c

dff.c:dff.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar dff.s $(CAPSIM)/TOOLS/blockgen.xsl>dff.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a dff.s

dff.o:dff.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include dff.c

dffil.c:dffil.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar dffil.s $(CAPSIM)/TOOLS/blockgen.xsl>dffil.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a dffil.s

dffil.o:dffil.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include dffil.c

divby2.c:divby2.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar divby2.s $(CAPSIM)/TOOLS/blockgen.xsl>divby2.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a divby2.s

divby2.o:divby2.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include divby2.c

divider.c:divider.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar divider.s $(CAPSIM)/TOOLS/blockgen.xsl>divider.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a divider.s

divider.o:divider.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include divider.c

divider2.c:divider2.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar divider2.s $(CAPSIM)/TOOLS/blockgen.xsl>divider2.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a divider2.s

divider2.o:divider2.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include divider2.c

ds2.c:ds2.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar ds2.s $(CAPSIM)/TOOLS/blockgen.xsl>ds2.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a ds2.s

ds2.o:ds2.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include ds2.c

ds3.c:ds3.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar ds3.s $(CAPSIM)/TOOLS/blockgen.xsl>ds3.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a ds3.s

ds3.o:ds3.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include ds3.c

dtoa.c:dtoa.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar dtoa.s $(CAPSIM)/TOOLS/blockgen.xsl>dtoa.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a dtoa.s

dtoa.o:dtoa.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include dtoa.c

ecount.c:ecount.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar ecount.s $(CAPSIM)/TOOLS/blockgen.xsl>ecount.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a ecount.s

ecount.o:ecount.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include ecount.c

ecountfap.c:ecountfap.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar ecountfap.s $(CAPSIM)/TOOLS/blockgen.xsl>ecountfap.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a ecountfap.s

ecountfap.o:ecountfap.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include ecountfap.c

encoder.c:encoder.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar encoder.s $(CAPSIM)/TOOLS/blockgen.xsl>encoder.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a encoder.s

encoder.o:encoder.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include encoder.c

ethline.c:ethline.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar ethline.s $(CAPSIM)/TOOLS/blockgen.xsl>ethline.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a ethline.s

ethline.o:ethline.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include ethline.c

expr.c:expr.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar expr.s $(CAPSIM)/TOOLS/blockgen.xsl>expr.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a expr.s

expr.o:expr.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include expr.c

fade.c:fade.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar fade.s $(CAPSIM)/TOOLS/blockgen.xsl>fade.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a fade.s

fade.o:fade.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include fade.c

fconv.c:fconv.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar fconv.s $(CAPSIM)/TOOLS/blockgen.xsl>fconv.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a fconv.s

fconv.o:fconv.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include fconv.c

filtnyq.c:filtnyq.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar filtnyq.s $(CAPSIM)/TOOLS/blockgen.xsl>filtnyq.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a filtnyq.s

filtnyq.o:filtnyq.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include filtnyq.c

fir.c:fir.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar fir.s $(CAPSIM)/TOOLS/blockgen.xsl>fir.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a fir.s

fir.o:fir.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include fir.c

firfil.c:firfil.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar firfil.s $(CAPSIM)/TOOLS/blockgen.xsl>firfil.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a firfil.s

firfil.o:firfil.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include firfil.c

fm.c:fm.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar fm.s $(CAPSIM)/TOOLS/blockgen.xsl>fm.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a fm.s

fm.o:fm.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include fm.c

freq_meter.c:freq_meter.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar freq_meter.s $(CAPSIM)/TOOLS/blockgen.xsl>freq_meter.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a freq_meter.s

freq_meter.o:freq_meter.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include freq_meter.c

freqimp.c:freqimp.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar freqimp.s $(CAPSIM)/TOOLS/blockgen.xsl>freqimp.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a freqimp.s

freqimp.o:freqimp.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include freqimp.c

fti.c:fti.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar fti.s $(CAPSIM)/TOOLS/blockgen.xsl>fti.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a fti.s

fti.o:fti.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include fti.c

fxadd.c:fxadd.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar fxadd.s $(CAPSIM)/TOOLS/blockgen.xsl>fxadd.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a fxadd.s

fxadd.o:fxadd.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include fxadd.c

fxdelay.c:fxdelay.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar fxdelay.s $(CAPSIM)/TOOLS/blockgen.xsl>fxdelay.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a fxdelay.s

fxdelay.o:fxdelay.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include fxdelay.c

fxgain.c:fxgain.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar fxgain.s $(CAPSIM)/TOOLS/blockgen.xsl>fxgain.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a fxgain.s

fxgain.o:fxgain.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include fxgain.c

fxnl.c:fxnl.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar fxnl.s $(CAPSIM)/TOOLS/blockgen.xsl>fxnl.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a fxnl.s

fxnl.o:fxnl.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include fxnl.c

fxnode.c:fxnode.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar fxnode.s $(CAPSIM)/TOOLS/blockgen.xsl>fxnode.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a fxnode.s

fxnode.o:fxnode.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include fxnode.c

gain.c:gain.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar gain.s $(CAPSIM)/TOOLS/blockgen.xsl>gain.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a gain.s

gain.o:gain.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include gain.c

gauss.c:gauss.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar gauss.s $(CAPSIM)/TOOLS/blockgen.xsl>gauss.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a gauss.s

gauss.o:gauss.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include gauss.c

hilbert.c:hilbert.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar hilbert.s $(CAPSIM)/TOOLS/blockgen.xsl>hilbert.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a hilbert.s

hilbert.o:hilbert.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include hilbert.c

histtxt.c:histtxt.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar histtxt.s $(CAPSIM)/TOOLS/blockgen.xsl>histtxt.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a histtxt.s

histtxt.o:histtxt.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include histtxt.c

hold.c:hold.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar hold.s $(CAPSIM)/TOOLS/blockgen.xsl>hold.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a hold.s

hold.o:hold.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include hold.c

iirfil.c:iirfil.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar iirfil.s $(CAPSIM)/TOOLS/blockgen.xsl>iirfil.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a iirfil.s

iirfil.o:iirfil.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include iirfil.c

img_sar_azimuth_compress.c:img_sar_azimuth_compress.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar img_sar_azimuth_compress.s $(CAPSIM)/TOOLS/blockgen.xsl>img_sar_azimuth_compress.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a img_sar_azimuth_compress.s

img_sar_azimuth_compress.o:img_sar_azimuth_compress.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include img_sar_azimuth_compress.c

img_sar_create.c:img_sar_create.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar img_sar_create.s $(CAPSIM)/TOOLS/blockgen.xsl>img_sar_create.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a img_sar_create.s

img_sar_create.o:img_sar_create.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include img_sar_create.c

img_sar_range_compress.c:img_sar_range_compress.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar img_sar_range_compress.s $(CAPSIM)/TOOLS/blockgen.xsl>img_sar_range_compress.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a img_sar_range_compress.s

img_sar_range_compress.o:img_sar_range_compress.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include img_sar_range_compress.c

imgaddnoise.c:imgaddnoise.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar imgaddnoise.s $(CAPSIM)/TOOLS/blockgen.xsl>imgaddnoise.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a imgaddnoise.s

imgaddnoise.o:imgaddnoise.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include imgaddnoise.c

imgbreakup.c:imgbreakup.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar imgbreakup.s $(CAPSIM)/TOOLS/blockgen.xsl>imgbreakup.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a imgbreakup.s

imgbreakup.o:imgbreakup.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include imgbreakup.c

imgbuild.c:imgbuild.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar imgbuild.s $(CAPSIM)/TOOLS/blockgen.xsl>imgbuild.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a imgbuild.s

imgbuild.o:imgbuild.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include imgbuild.c

imgcalc.c:imgcalc.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar imgcalc.s $(CAPSIM)/TOOLS/blockgen.xsl>imgcalc.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a imgcalc.s

imgcalc.o:imgcalc.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include imgcalc.c

imgcxmag.c:imgcxmag.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar imgcxmag.s $(CAPSIM)/TOOLS/blockgen.xsl>imgcxmag.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a imgcxmag.s

imgcxmag.o:imgcxmag.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include imgcxmag.c

imgcxtrl.c:imgcxtrl.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar imgcxtrl.s $(CAPSIM)/TOOLS/blockgen.xsl>imgcxtrl.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a imgcxtrl.s

imgcxtrl.o:imgcxtrl.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include imgcxtrl.c

imgfft.c:imgfft.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar imgfft.s $(CAPSIM)/TOOLS/blockgen.xsl>imgfft.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a imgfft.s

imgfft.o:imgfft.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include imgfft.c

imgfilter.c:imgfilter.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar imgfilter.s $(CAPSIM)/TOOLS/blockgen.xsl>imgfilter.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a imgfilter.s

imgfilter.o:imgfilter.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include imgfilter.c

imggen.c:imggen.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar imggen.s $(CAPSIM)/TOOLS/blockgen.xsl>imggen.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a imggen.s

imggen.o:imggen.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include imggen.c

imghisteq.c:imghisteq.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar imghisteq.s $(CAPSIM)/TOOLS/blockgen.xsl>imghisteq.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a imghisteq.s

imghisteq.o:imghisteq.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include imghisteq.c

imginterp.c:imginterp.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar imginterp.s $(CAPSIM)/TOOLS/blockgen.xsl>imginterp.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a imginterp.s

imginterp.o:imginterp.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include imginterp.c

imgmanip.c:imgmanip.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar imgmanip.s $(CAPSIM)/TOOLS/blockgen.xsl>imgmanip.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a imgmanip.s

imgmanip.o:imgmanip.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include imgmanip.c

imgmux.c:imgmux.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar imgmux.s $(CAPSIM)/TOOLS/blockgen.xsl>imgmux.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a imgmux.s

imgmux.o:imgmux.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include imgmux.c

imgnode.c:imgnode.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar imgnode.s $(CAPSIM)/TOOLS/blockgen.xsl>imgnode.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a imgnode.s

imgnode.o:imgnode.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include imgnode.c

imgnonlinfil.c:imgnonlinfil.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar imgnonlinfil.s $(CAPSIM)/TOOLS/blockgen.xsl>imgnonlinfil.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a imgnonlinfil.s

imgnonlinfil.o:imgnonlinfil.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include imgnonlinfil.c

imgnormalize.c:imgnormalize.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar imgnormalize.s $(CAPSIM)/TOOLS/blockgen.xsl>imgnormalize.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a imgnormalize.s

imgnormalize.o:imgnormalize.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include imgnormalize.c

imgprasc.c:imgprasc.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar imgprasc.s $(CAPSIM)/TOOLS/blockgen.xsl>imgprasc.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a imgprasc.s

imgprasc.o:imgprasc.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include imgprasc.c

imgprbin.c:imgprbin.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar imgprbin.s $(CAPSIM)/TOOLS/blockgen.xsl>imgprbin.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a imgprbin.s

imgprbin.o:imgprbin.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include imgprbin.c

imgproc.c:imgproc.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar imgproc.s $(CAPSIM)/TOOLS/blockgen.xsl>imgproc.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a imgproc.s

imgproc.o:imgproc.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include imgproc.c

imgrdasc.c:imgrdasc.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar imgrdasc.s $(CAPSIM)/TOOLS/blockgen.xsl>imgrdasc.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a imgrdasc.s

imgrdasc.o:imgrdasc.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include imgrdasc.c

imgrdbin.c:imgrdbin.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar imgrdbin.s $(CAPSIM)/TOOLS/blockgen.xsl>imgrdbin.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a imgrdbin.s

imgrdbin.o:imgrdbin.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include imgrdbin.c

imgrdfptiff.c:imgrdfptiff.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar imgrdfptiff.s $(CAPSIM)/TOOLS/blockgen.xsl>imgrdfptiff.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a imgrdfptiff.s

imgrdfptiff.o:imgrdfptiff.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include imgrdfptiff.c

imgrdtiff.c:imgrdtiff.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar imgrdtiff.s $(CAPSIM)/TOOLS/blockgen.xsl>imgrdtiff.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a imgrdtiff.s

imgrdtiff.o:imgrdtiff.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include imgrdtiff.c

imgrtcx.c:imgrtcx.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar imgrtcx.s $(CAPSIM)/TOOLS/blockgen.xsl>imgrtcx.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a imgrtcx.s

imgrtcx.o:imgrtcx.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include imgrtcx.c

imgserin.c:imgserin.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar imgserin.s $(CAPSIM)/TOOLS/blockgen.xsl>imgserin.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a imgserin.s

imgserin.o:imgserin.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include imgserin.c

imgserout.c:imgserout.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar imgserout.s $(CAPSIM)/TOOLS/blockgen.xsl>imgserout.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a imgserout.s

imgserout.o:imgserout.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include imgserout.c

imgshrink.c:imgshrink.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar imgshrink.s $(CAPSIM)/TOOLS/blockgen.xsl>imgshrink.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a imgshrink.s

imgshrink.o:imgshrink.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include imgshrink.c

imgsink.c:imgsink.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar imgsink.s $(CAPSIM)/TOOLS/blockgen.xsl>imgsink.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a imgsink.s

imgsink.o:imgsink.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include imgsink.c

imgsubimg.c:imgsubimg.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar imgsubimg.s $(CAPSIM)/TOOLS/blockgen.xsl>imgsubimg.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a imgsubimg.s

imgsubimg.o:imgsubimg.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include imgsubimg.c

imgwrfptiff.c:imgwrfptiff.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar imgwrfptiff.s $(CAPSIM)/TOOLS/blockgen.xsl>imgwrfptiff.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a imgwrfptiff.s

imgwrfptiff.o:imgwrfptiff.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include imgwrfptiff.c

imgwrtiff.c:imgwrtiff.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar imgwrtiff.s $(CAPSIM)/TOOLS/blockgen.xsl>imgwrtiff.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a imgwrtiff.s

imgwrtiff.o:imgwrtiff.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include imgwrtiff.c

impulse.c:impulse.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar impulse.s $(CAPSIM)/TOOLS/blockgen.xsl>impulse.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a impulse.s

impulse.o:impulse.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include impulse.c

intcntrl.c:intcntrl.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar intcntrl.s $(CAPSIM)/TOOLS/blockgen.xsl>intcntrl.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a intcntrl.s

intcntrl.o:intcntrl.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include intcntrl.c

intdmp.c:intdmp.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar intdmp.s $(CAPSIM)/TOOLS/blockgen.xsl>intdmp.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a intdmp.s

intdmp.o:intdmp.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include intdmp.c

integrate.c:integrate.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar integrate.s $(CAPSIM)/TOOLS/blockgen.xsl>integrate.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a integrate.s

integrate.o:integrate.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include integrate.c

invcust.c:invcust.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar invcust.s $(CAPSIM)/TOOLS/blockgen.xsl>invcust.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a invcust.s

invcust.o:invcust.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include invcust.c

inventory.c:inventory.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar inventory.s $(CAPSIM)/TOOLS/blockgen.xsl>inventory.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a inventory.s

inventory.o:inventory.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include inventory.c

inverse.c:inverse.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar inverse.s $(CAPSIM)/TOOLS/blockgen.xsl>inverse.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a inverse.s

inverse.o:inverse.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include inverse.c

invert.c:invert.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar invert.s $(CAPSIM)/TOOLS/blockgen.xsl>invert.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a invert.s

invert.o:invert.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include invert.c

itf.c:itf.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar itf.s $(CAPSIM)/TOOLS/blockgen.xsl>itf.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a itf.s

itf.o:itf.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include itf.c

jitter.c:jitter.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar jitter.s $(CAPSIM)/TOOLS/blockgen.xsl>jitter.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a jitter.s

jitter.o:jitter.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include jitter.c

jkfade.c:jkfade.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar jkfade.s $(CAPSIM)/TOOLS/blockgen.xsl>jkfade.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a jkfade.s

jkfade.o:jkfade.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include jkfade.c

jkff.c:jkff.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar jkff.s $(CAPSIM)/TOOLS/blockgen.xsl>jkff.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a jkff.s

jkff.o:jkff.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include jkff.c

limiter.c:limiter.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar limiter.s $(CAPSIM)/TOOLS/blockgen.xsl>limiter.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a limiter.s

limiter.o:limiter.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include limiter.c

linecode.c:linecode.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar linecode.s $(CAPSIM)/TOOLS/blockgen.xsl>linecode.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a linecode.s

linecode.o:linecode.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include linecode.c

lms.c:lms.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar lms.s $(CAPSIM)/TOOLS/blockgen.xsl>lms.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a lms.s

lms.o:lms.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include lms.c

lpc.c:lpc.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar lpc.s $(CAPSIM)/TOOLS/blockgen.xsl>lpc.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a lpc.s

lpc.o:lpc.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include lpc.c

lpf.c:lpf.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar lpf.s $(CAPSIM)/TOOLS/blockgen.xsl>lpf.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a lpf.s

lpf.o:lpf.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include lpf.c

mau.c:mau.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar mau.s $(CAPSIM)/TOOLS/blockgen.xsl>mau.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a mau.s

mau.o:mau.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include mau.c

mbset.c:mbset.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar mbset.s $(CAPSIM)/TOOLS/blockgen.xsl>mbset.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a mbset.s

mbset.o:mbset.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include mbset.c

mixer.c:mixer.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar mixer.s $(CAPSIM)/TOOLS/blockgen.xsl>mixer.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a mixer.s

mixer.o:mixer.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include mixer.c

more.c:more.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar more.s $(CAPSIM)/TOOLS/blockgen.xsl>more.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a more.s

more.o:more.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include more.c

mulaw.c:mulaw.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar mulaw.s $(CAPSIM)/TOOLS/blockgen.xsl>mulaw.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a mulaw.s

mulaw.o:mulaw.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include mulaw.c

multiply.c:multiply.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar multiply.s $(CAPSIM)/TOOLS/blockgen.xsl>multiply.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a multiply.s

multiply.o:multiply.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include multiply.c

mux.c:mux.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar mux.s $(CAPSIM)/TOOLS/blockgen.xsl>mux.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a mux.s

mux.o:mux.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include mux.c

nand.c:nand.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar nand.s $(CAPSIM)/TOOLS/blockgen.xsl>nand.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a nand.s

nand.o:nand.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include nand.c

nl.c:nl.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar nl.s $(CAPSIM)/TOOLS/blockgen.xsl>nl.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a nl.s

nl.o:nl.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include nl.c

node.c:node.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar node.s $(CAPSIM)/TOOLS/blockgen.xsl>node.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a node.s

node.o:node.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include node.c

nonlin.c:nonlin.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar nonlin.s $(CAPSIM)/TOOLS/blockgen.xsl>nonlin.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a nonlin.s

nonlin.o:nonlin.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include nonlin.c

nor.c:nor.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar nor.s $(CAPSIM)/TOOLS/blockgen.xsl>nor.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a nor.s

nor.o:nor.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include nor.c

null.c:null.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar null.s $(CAPSIM)/TOOLS/blockgen.xsl>null.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a null.s

null.o:null.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include null.c

offset.c:offset.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar offset.s $(CAPSIM)/TOOLS/blockgen.xsl>offset.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a offset.s

offset.o:offset.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include offset.c

operate.c:operate.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar operate.s $(CAPSIM)/TOOLS/blockgen.xsl>operate.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a operate.s

operate.o:operate.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include operate.c

or.c:or.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar or.s $(CAPSIM)/TOOLS/blockgen.xsl>or.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a or.s

or.o:or.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include or.c

phi_meter.c:phi_meter.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar phi_meter.s $(CAPSIM)/TOOLS/blockgen.xsl>phi_meter.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a phi_meter.s

phi_meter.o:phi_meter.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include phi_meter.c

pllfilt.c:pllfilt.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar pllfilt.s $(CAPSIM)/TOOLS/blockgen.xsl>pllfilt.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a pllfilt.s

pllfilt.o:pllfilt.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include pllfilt.c

plottxt.c:plottxt.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar plottxt.s $(CAPSIM)/TOOLS/blockgen.xsl>plottxt.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a plottxt.s

plottxt.o:plottxt.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include plottxt.c

pngen.c:pngen.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar pngen.s $(CAPSIM)/TOOLS/blockgen.xsl>pngen.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a pngen.s

pngen.o:pngen.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include pngen.c

pngen2.c:pngen2.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar pngen2.s $(CAPSIM)/TOOLS/blockgen.xsl>pngen2.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a pngen2.s

pngen2.o:pngen2.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include pngen2.c

powmeter.c:powmeter.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar powmeter.s $(CAPSIM)/TOOLS/blockgen.xsl>powmeter.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a powmeter.s

powmeter.o:powmeter.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include powmeter.c

prbinimage.c:prbinimage.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar prbinimage.s $(CAPSIM)/TOOLS/blockgen.xsl>prbinimage.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a prbinimage.s

prbinimage.o:prbinimage.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include prbinimage.c

predftf.c:predftf.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar predftf.s $(CAPSIM)/TOOLS/blockgen.xsl>predftf.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a predftf.s

predftf.o:predftf.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include predftf.c

predlms.c:predlms.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar predlms.s $(CAPSIM)/TOOLS/blockgen.xsl>predlms.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a predlms.s

predlms.o:predlms.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include predlms.c

prfile.c:prfile.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar prfile.s $(CAPSIM)/TOOLS/blockgen.xsl>prfile.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a prfile.s

prfile.o:prfile.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include prfile.c

pri.c:pri.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar pri.s $(CAPSIM)/TOOLS/blockgen.xsl>pri.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a pri.s

pri.o:pri.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include pri.c

primage.c:primage.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar primage.s $(CAPSIM)/TOOLS/blockgen.xsl>primage.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a primage.s

primage.o:primage.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include primage.c

pulse.c:pulse.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar pulse.s $(CAPSIM)/TOOLS/blockgen.xsl>pulse.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a pulse.s

pulse.o:pulse.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include pulse.c

pump.c:pump.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar pump.s $(CAPSIM)/TOOLS/blockgen.xsl>pump.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a pump.s

pump.o:pump.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include pump.c

qpsk.c:qpsk.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar qpsk.s $(CAPSIM)/TOOLS/blockgen.xsl>qpsk.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a qpsk.s

qpsk.o:qpsk.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include qpsk.c

quot.c:quot.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar quot.s $(CAPSIM)/TOOLS/blockgen.xsl>quot.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a quot.s

quot.o:quot.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include quot.c

radar.c:radar.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar radar.s $(CAPSIM)/TOOLS/blockgen.xsl>radar.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a radar.s

radar.o:radar.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include radar.c

rangen.c:rangen.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar rangen.s $(CAPSIM)/TOOLS/blockgen.xsl>rangen.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a rangen.s

rangen.o:rangen.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include rangen.c

rdaiff.c:rdaiff.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar rdaiff.s $(CAPSIM)/TOOLS/blockgen.xsl>rdaiff.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a rdaiff.s

rdaiff.o:rdaiff.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include rdaiff.c

rdbinimg.c:rdbinimg.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar rdbinimg.s $(CAPSIM)/TOOLS/blockgen.xsl>rdbinimg.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a rdbinimg.s

rdbinimg.o:rdbinimg.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include rdbinimg.c

rdfile.c:rdfile.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar rdfile.s $(CAPSIM)/TOOLS/blockgen.xsl>rdfile.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a rdfile.s

rdfile.o:rdfile.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include rdfile.c

rdimage.c:rdimage.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar rdimage.s $(CAPSIM)/TOOLS/blockgen.xsl>rdimage.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a rdimage.s

rdimage.o:rdimage.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include rdimage.c

rdmulti.c:rdmulti.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar rdmulti.s $(CAPSIM)/TOOLS/blockgen.xsl>rdmulti.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a rdmulti.s

rdmulti.o:rdmulti.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include rdmulti.c

repeater.c:repeater.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar repeater.s $(CAPSIM)/TOOLS/blockgen.xsl>repeater.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a repeater.s

repeater.o:repeater.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include repeater.c

replicate.c:replicate.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar replicate.s $(CAPSIM)/TOOLS/blockgen.xsl>replicate.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a replicate.s

replicate.o:replicate.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include replicate.c

resmpl.c:resmpl.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar resmpl.s $(CAPSIM)/TOOLS/blockgen.xsl>resmpl.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a resmpl.s

resmpl.o:resmpl.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include resmpl.c

roundi.c:roundi.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar roundi.s $(CAPSIM)/TOOLS/blockgen.xsl>roundi.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a roundi.s

roundi.o:roundi.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include roundi.c

rxhdlc.c:rxhdlc.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar rxhdlc.s $(CAPSIM)/TOOLS/blockgen.xsl>rxhdlc.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a rxhdlc.s

rxhdlc.o:rxhdlc.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include rxhdlc.c

sampler1.c:sampler1.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar sampler1.s $(CAPSIM)/TOOLS/blockgen.xsl>sampler1.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a sampler1.s

sampler1.o:sampler1.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include sampler1.c

sar_azimuth_ref.c:sar_azimuth_ref.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar sar_azimuth_ref.s $(CAPSIM)/TOOLS/blockgen.xsl>sar_azimuth_ref.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a sar_azimuth_ref.s

sar_azimuth_ref.o:sar_azimuth_ref.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include sar_azimuth_ref.c

sar_chirp.c:sar_chirp.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar sar_chirp.s $(CAPSIM)/TOOLS/blockgen.xsl>sar_chirp.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a sar_chirp.s

sar_chirp.o:sar_chirp.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include sar_chirp.c

sar_range.c:sar_range.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar sar_range.s $(CAPSIM)/TOOLS/blockgen.xsl>sar_range.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a sar_range.s

sar_range.o:sar_range.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include sar_range.c

sar_range_compress.c:sar_range_compress.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar sar_range_compress.s $(CAPSIM)/TOOLS/blockgen.xsl>sar_range_compress.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a sar_range_compress.s

sar_range_compress.o:sar_range_compress.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include sar_range_compress.c

scattertxt.c:scattertxt.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar scattertxt.s $(CAPSIM)/TOOLS/blockgen.xsl>scattertxt.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a scattertxt.s

scattertxt.o:scattertxt.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include scattertxt.c

scrambler.c:scrambler.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar scrambler.s $(CAPSIM)/TOOLS/blockgen.xsl>scrambler.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a scrambler.s

scrambler.o:scrambler.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include scrambler.c

sdet.c:sdet.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar sdet.s $(CAPSIM)/TOOLS/blockgen.xsl>sdet.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a sdet.s

sdet.o:sdet.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include sdet.c

sdr.c:sdr.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar sdr.s $(CAPSIM)/TOOLS/blockgen.xsl>sdr.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a sdr.s

sdr.o:sdr.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include sdr.c

secord.c:secord.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar secord.s $(CAPSIM)/TOOLS/blockgen.xsl>secord.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a secord.s

secord.o:secord.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include secord.c

seqgen.c:seqgen.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar seqgen.s $(CAPSIM)/TOOLS/blockgen.xsl>seqgen.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a seqgen.s

seqgen.o:seqgen.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include seqgen.c

server.c:server.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar server.s $(CAPSIM)/TOOLS/blockgen.xsl>server.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a server.s

server.o:server.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include server.c

setsnr.c:setsnr.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar setsnr.s $(CAPSIM)/TOOLS/blockgen.xsl>setsnr.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a setsnr.s

setsnr.o:setsnr.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include setsnr.c

sine.c:sine.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar sine.s $(CAPSIM)/TOOLS/blockgen.xsl>sine.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a sine.s

sine.o:sine.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include sine.c

sink.c:sink.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar sink.s $(CAPSIM)/TOOLS/blockgen.xsl>sink.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a sink.s

sink.o:sink.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include sink.c

skip.c:skip.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar skip.s $(CAPSIM)/TOOLS/blockgen.xsl>skip.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a skip.s

skip.o:skip.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include skip.c

skipold.c:skipold.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar skipold.s $(CAPSIM)/TOOLS/blockgen.xsl>skipold.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a skipold.s

skipold.o:skipold.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include skipold.c

slice.c:slice.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar slice.s $(CAPSIM)/TOOLS/blockgen.xsl>slice.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a slice.s

slice.o:slice.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include slice.c

slidefft.c:slidefft.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar slidefft.s $(CAPSIM)/TOOLS/blockgen.xsl>slidefft.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a slidefft.s

slidefft.o:slidefft.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include slidefft.c

sn74ls93.c:sn74ls93.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar sn74ls93.s $(CAPSIM)/TOOLS/blockgen.xsl>sn74ls93.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a sn74ls93.s

sn74ls93.o:sn74ls93.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include sn74ls93.c

spectrogramtxt.c:spectrogramtxt.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar spectrogramtxt.s $(CAPSIM)/TOOLS/blockgen.xsl>spectrogramtxt.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a spectrogramtxt.s

spectrogramtxt.o:spectrogramtxt.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include spectrogramtxt.c

spectrumtxt.c:spectrumtxt.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar spectrumtxt.s $(CAPSIM)/TOOLS/blockgen.xsl>spectrumtxt.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a spectrumtxt.s

spectrumtxt.o:spectrumtxt.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include spectrumtxt.c

spiceprb.c:spiceprb.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar spiceprb.s $(CAPSIM)/TOOLS/blockgen.xsl>spiceprb.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a spiceprb.s

spiceprb.o:spiceprb.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include spiceprb.c

spread.c:spread.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar spread.s $(CAPSIM)/TOOLS/blockgen.xsl>spread.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a spread.s

spread.o:spread.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include spread.c

sqr.c:sqr.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar sqr.s $(CAPSIM)/TOOLS/blockgen.xsl>sqr.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a sqr.s

sqr.o:sqr.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include sqr.c

sqrtnyq.c:sqrtnyq.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar sqrtnyq.s $(CAPSIM)/TOOLS/blockgen.xsl>sqrtnyq.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a sqrtnyq.s

sqrtnyq.o:sqrtnyq.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include sqrtnyq.c

srff.c:srff.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar srff.s $(CAPSIM)/TOOLS/blockgen.xsl>srff.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a srff.s

srff.o:srff.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include srff.c

srlatch.c:srlatch.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar srlatch.s $(CAPSIM)/TOOLS/blockgen.xsl>srlatch.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a srlatch.s

srlatch.o:srlatch.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include srlatch.c

stats.c:stats.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar stats.s $(CAPSIM)/TOOLS/blockgen.xsl>stats.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a stats.s

stats.o:stats.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include stats.c

stc.c:stc.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar stc.s $(CAPSIM)/TOOLS/blockgen.xsl>stc.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a stc.s

stc.o:stc.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include stc.c

stcode.c:stcode.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar stcode.s $(CAPSIM)/TOOLS/blockgen.xsl>stcode.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a stcode.s

stcode.o:stcode.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include stcode.c

str.c:str.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar str.s $(CAPSIM)/TOOLS/blockgen.xsl>str.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a str.s

str.o:str.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include str.c

strch.c:strch.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar strch.s $(CAPSIM)/TOOLS/blockgen.xsl>strch.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a strch.s

strch.o:strch.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include strch.c

stretch.c:stretch.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar stretch.s $(CAPSIM)/TOOLS/blockgen.xsl>stretch.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a stretch.s

stretch.o:stretch.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include stretch.c

sum.c:sum.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar sum.s $(CAPSIM)/TOOLS/blockgen.xsl>sum.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a sum.s

sum.o:sum.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include sum.c

symimp.c:symimp.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar symimp.s $(CAPSIM)/TOOLS/blockgen.xsl>symimp.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a symimp.s

symimp.o:symimp.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include symimp.c

target.c:target.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar target.s $(CAPSIM)/TOOLS/blockgen.xsl>target.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a target.s

target.o:target.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include target.c

tee.c:tee.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar tee.s $(CAPSIM)/TOOLS/blockgen.xsl>tee.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a tee.s

tee.o:tee.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include tee.c

tff.c:tff.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar tff.s $(CAPSIM)/TOOLS/blockgen.xsl>tff.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a tff.s

tff.o:tff.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include tff.c

threshold.c:threshold.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar threshold.s $(CAPSIM)/TOOLS/blockgen.xsl>threshold.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a threshold.s

threshold.o:threshold.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include threshold.c

toggle.c:toggle.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar toggle.s $(CAPSIM)/TOOLS/blockgen.xsl>toggle.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a toggle.s

toggle.o:toggle.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include toggle.c

transpose.c:transpose.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar transpose.s $(CAPSIM)/TOOLS/blockgen.xsl>transpose.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a transpose.s

transpose.o:transpose.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include transpose.c

trig.c:trig.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar trig.s $(CAPSIM)/TOOLS/blockgen.xsl>trig.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a trig.s

trig.o:trig.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include trig.c

txhdlc.c:txhdlc.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar txhdlc.s $(CAPSIM)/TOOLS/blockgen.xsl>txhdlc.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a txhdlc.s

txhdlc.o:txhdlc.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include txhdlc.c

unitf.c:unitf.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar unitf.s $(CAPSIM)/TOOLS/blockgen.xsl>unitf.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a unitf.s

unitf.o:unitf.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include unitf.c

v29decoder.c:v29decoder.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar v29decoder.s $(CAPSIM)/TOOLS/blockgen.xsl>v29decoder.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a v29decoder.s

v29decoder.o:v29decoder.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include v29decoder.c

v29encoder.c:v29encoder.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar v29encoder.s $(CAPSIM)/TOOLS/blockgen.xsl>v29encoder.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a v29encoder.s

v29encoder.o:v29encoder.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include v29encoder.c

v2b.c:v2b.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar v2b.s $(CAPSIM)/TOOLS/blockgen.xsl>v2b.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a v2b.s

v2b.o:v2b.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include v2b.c

vcm.c:vcm.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar vcm.s $(CAPSIM)/TOOLS/blockgen.xsl>vcm.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a vcm.s

vcm.o:vcm.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include vcm.c

vecbit.c:vecbit.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar vecbit.s $(CAPSIM)/TOOLS/blockgen.xsl>vecbit.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a vecbit.s

vecbit.o:vecbit.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include vecbit.c

wave.c:wave.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar wave.s $(CAPSIM)/TOOLS/blockgen.xsl>wave.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a wave.s

wave.o:wave.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include wave.c

wraiff.c:wraiff.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar wraiff.s $(CAPSIM)/TOOLS/blockgen.xsl>wraiff.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a wraiff.s

wraiff.o:wraiff.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include wraiff.c

xdco.c:xdco.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar xdco.s $(CAPSIM)/TOOLS/blockgen.xsl>xdco.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a xdco.s

xdco.o:xdco.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include xdco.c

xnor.c:xnor.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar xnor.s $(CAPSIM)/TOOLS/blockgen.xsl>xnor.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a xnor.s

xnor.o:xnor.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include xnor.c

xor.c:xor.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar xor.s $(CAPSIM)/TOOLS/blockgen.xsl>xor.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a xor.s

xor.o:xor.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include xor.c

xygen.c:xygen.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar xygen.s $(CAPSIM)/TOOLS/blockgen.xsl>xygen.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a xygen.s

xygen.o:xygen.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include xygen.c

zc.c:zc.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar zc.s $(CAPSIM)/TOOLS/blockgen.xsl>zc.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a zc.s

zc.o:zc.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include zc.c

zdummy.c:zdummy.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar zdummy.s $(CAPSIM)/TOOLS/blockgen.xsl>zdummy.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a zdummy.s

zdummy.o:zdummy.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include zdummy.c

zero.c:zero.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar zero.s $(CAPSIM)/TOOLS/blockgen.xsl>zero.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a zero.s

zero.o:zero.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include zero.c

zlpf.c:zlpf.s
	java -jar $(CAPSIM)/TOOLS/saxon.jar zlpf.s $(CAPSIM)/TOOLS/blockgen.xsl>zlpf.c
	perl $(CAPSIM)/TOOLS/blockmaint.pl a zlpf.s

zlpf.o:zlpf.c
	cc -c -g  -I$(CAPSIM)/include -I$(CAPSIM)/include/TCL -I../include zlpf.c

libblock.a:add.o addnoise.o and.o ang.o arprocess.o atod.o autoxcorr.o avrow.o bdata.o bitmanip.o bitvec.o blindadapt.o bpf.o cable.o casfil.o clip.o clkdly.o cmplxfft.o cmux.o cmxfft.o cmxfftfile.o cmxifft.o convolve.o cstime.o cubepoly.o cxadd.o cxaddnoise.o cxconj.o cxcorr.o cxdelay.o cxgain.o cxmag.o cxmakecx.o cxmakereal.o cxmult.o cxnode.o cxphase.o cxrdfile.o cxreal.o cxreim.o cxsetsnr.o cxsink.o cxskip.o cxsum.o datagen.o dco.o dco2.o dec_qpsk.o decbin.o decimate.o delay.o demux.o dff.o dffil.o divby2.o divider.o divider2.o ds2.o ds3.o dtoa.o ecount.o ecountfap.o encoder.o ethline.o expr.o fade.o fconv.o filtnyq.o fir.o firfil.o fm.o freq_meter.o freqimp.o fti.o fxadd.o fxdelay.o fxgain.o fxnl.o fxnode.o gain.o gauss.o hilbert.o histtxt.o hold.o iirfil.o img_sar_azimuth_compress.o img_sar_create.o img_sar_range_compress.o imgaddnoise.o imgbreakup.o imgbuild.o imgcalc.o imgcxmag.o imgcxtrl.o imgfft.o imgfilter.o imggen.o imghisteq.o imginterp.o imgmanip.o imgmux.o imgnode.o imgnonlinfil.o imgnormalize.o imgprasc.o imgprbin.o imgproc.o imgrdasc.o imgrdbin.o imgrdfptiff.o imgrdtiff.o imgrtcx.o imgserin.o imgserout.o imgshrink.o imgsink.o imgsubimg.o imgwrfptiff.o imgwrtiff.o impulse.o intcntrl.o intdmp.o integrate.o invcust.o inventory.o inverse.o invert.o itf.o jitter.o jkfade.o jkff.o limiter.o linecode.o lms.o lpc.o lpf.o mau.o mbset.o mixer.o more.o mulaw.o multiply.o mux.o nand.o nl.o node.o nonlin.o nor.o null.o offset.o operate.o or.o phi_meter.o pllfilt.o plottxt.o pngen.o pngen2.o powmeter.o prbinimage.o predftf.o predlms.o prfile.o pri.o primage.o pulse.o pump.o qpsk.o quot.o radar.o rangen.o rdaiff.o rdbinimg.o rdfile.o rdimage.o rdmulti.o repeater.o replicate.o resmpl.o roundi.o rxhdlc.o sampler1.o sar_azimuth_ref.o sar_chirp.o sar_range.o sar_range_compress.o scattertxt.o scrambler.o sdet.o sdr.o secord.o seqgen.o server.o setsnr.o sine.o sink.o skip.o skipold.o slice.o slidefft.o sn74ls93.o spectrogramtxt.o spectrumtxt.o spiceprb.o spread.o sqr.o sqrtnyq.o srff.o srlatch.o stats.o stc.o stcode.o str.o strch.o stretch.o sum.o symimp.o target.o tee.o tff.o threshold.o toggle.o transpose.o trig.o txhdlc.o unitf.o v29decoder.o v29encoder.o v2b.o vcm.o vecbit.o wave.o wraiff.o xdco.o xnor.o xor.o xygen.o zc.o zdummy.o zero.o zlpf.o 
	ar -r libblock.a add.o addnoise.o and.o ang.o arprocess.o atod.o autoxcorr.o avrow.o bdata.o bitmanip.o bitvec.o blindadapt.o bpf.o cable.o casfil.o clip.o clkdly.o cmplxfft.o cmux.o cmxfft.o cmxfftfile.o cmxifft.o convolve.o cstime.o cubepoly.o cxadd.o cxaddnoise.o cxconj.o cxcorr.o cxdelay.o cxgain.o cxmag.o cxmakecx.o cxmakereal.o cxmult.o cxnode.o cxphase.o cxrdfile.o cxreal.o cxreim.o cxsetsnr.o cxsink.o cxskip.o cxsum.o datagen.o dco.o dco2.o dec_qpsk.o decbin.o decimate.o delay.o demux.o dff.o dffil.o divby2.o divider.o divider2.o ds2.o ds3.o dtoa.o ecount.o ecountfap.o encoder.o ethline.o expr.o fade.o fconv.o filtnyq.o fir.o firfil.o fm.o freq_meter.o freqimp.o fti.o fxadd.o fxdelay.o fxgain.o fxnl.o fxnode.o gain.o gauss.o hilbert.o histtxt.o hold.o iirfil.o img_sar_azimuth_compress.o img_sar_create.o img_sar_range_compress.o imgaddnoise.o imgbreakup.o imgbuild.o imgcalc.o imgcxmag.o imgcxtrl.o imgfft.o imgfilter.o imggen.o imghisteq.o imginterp.o imgmanip.o imgmux.o imgnode.o imgnonlinfil.o imgnormalize.o imgprasc.o imgprbin.o imgproc.o imgrdasc.o imgrdbin.o imgrdfptiff.o imgrdtiff.o imgrtcx.o imgserin.o imgserout.o imgshrink.o imgsink.o imgsubimg.o imgwrfptiff.o imgwrtiff.o impulse.o intcntrl.o intdmp.o integrate.o invcust.o inventory.o inverse.o invert.o itf.o jitter.o jkfade.o jkff.o limiter.o linecode.o lms.o lpc.o lpf.o mau.o mbset.o mixer.o more.o mulaw.o multiply.o mux.o nand.o nl.o node.o nonlin.o nor.o null.o offset.o operate.o or.o phi_meter.o pllfilt.o plottxt.o pngen.o pngen2.o powmeter.o prbinimage.o predftf.o predlms.o prfile.o pri.o primage.o pulse.o pump.o qpsk.o quot.o radar.o rangen.o rdaiff.o rdbinimg.o rdfile.o rdimage.o rdmulti.o repeater.o replicate.o resmpl.o roundi.o rxhdlc.o sampler1.o sar_azimuth_ref.o sar_chirp.o sar_range.o sar_range_compress.o scattertxt.o scrambler.o sdet.o sdr.o secord.o seqgen.o server.o setsnr.o sine.o sink.o skip.o skipold.o slice.o slidefft.o sn74ls93.o spectrogramtxt.o spectrumtxt.o spiceprb.o spread.o sqr.o sqrtnyq.o srff.o srlatch.o stats.o stc.o stcode.o str.o strch.o stretch.o sum.o symimp.o target.o tee.o tff.o threshold.o toggle.o transpose.o trig.o txhdlc.o unitf.o v29decoder.o v29encoder.o v2b.o vcm.o vecbit.o wave.o wraiff.o xdco.o xnor.o xor.o xygen.o zc.o zdummy.o zero.o zlpf.o 
	ranlib libblock.a
