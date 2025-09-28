# Graphics info for galaxy arial_histogram_equalization

zoomFactor: 1.000000 
Vertical Scroll Bar: 0
Horizontal Scroll Bar: 0
Scroll Window Width: 800
Scroll Window Height: 400


gblock imgrdtiff0
	xLoc: 100  	yLoc: 100
	xDel: 120  	yDel: 30


gblock imghisteq0
	xLoc: 280  	yLoc: 220
	xDel: 120  	yDel: 30


gblock ximgdisp1
	xLoc: 440  	yLoc: 280
	xDel: 110  	yDel: 30


gconnect imgrdtiff0 0  imghisteq0 0
	termType: 0  	probeType: 80 	pacerFlag: 0	autoConnect: 0
	pathPts(x,y): 6
	160  	100
	205  	100
	205  	220
	205  	220
	205  	220
	220  	220


gconnect imghisteq0 0  ximgdisp1 0
	termType: 0  	probeType: 16 	pacerFlag: 0	autoConnect: 0
	pathPts(x,y): 6
	340  	220
	370  	220
	370  	280
	370  	280
	370  	280
	385  	280


