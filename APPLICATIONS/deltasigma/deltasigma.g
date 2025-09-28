# Graphics info for galaxy deltasigma

zoomFactor: 1.000000 
Vertical Scroll Bar: 0
Horizontal Scroll Bar: 0
Scroll Window Width: 800
Scroll Window Height: 400


gblock sine0
	xLoc: 76  	yLoc: 157
	xDel: 35  	yDel: 35


gblock ds20
	xLoc: 189  	yLoc: 156
	xDel: 40  	yDel: 30


gblock decimate0
	xLoc: 310  	yLoc: 154
	xDel: 50  	yDel: 30


gblock iirfil0
	xLoc: 499  	yLoc: 155
	xDel: 60  	yDel: 30


gblock sdr0
	xLoc: 606  	yLoc: 154
	xDel: 40  	yDel: 30


gconnect sine0 0  ds20 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	93  	156
	167  	156


gconnect ds20 0  decimate0 0
	termType: 0  	probeType: 8 	pacerFlag: 0
	pathPts(x,y): 2
	208  	154
	288  	153


gconnect decimate0 0  iirfil0 0
	termType: 0  	probeType: 8 	pacerFlag: 0
	pathPts(x,y): 2
	339  	155
	467  	155


gconnect iirfil0 0  sdr0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	532  	155
	584  	153


