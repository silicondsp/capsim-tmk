# Graphics info for galaxy fmmod

zoomFactor: 1.000000 
Vertical Scroll Bar: 0
Horizontal Scroll Bar: 0
Scroll Window Width: 466
Scroll Window Height: 165


gblock sine0
	xLoc: 100  	yLoc: 53
	xDel: 35  	yDel: 35


gblock dco0
	xLoc: 182  	yLoc: 50
	xDel: 30  	yDel: 30


gblock sink1
	xLoc: 181  	yLoc: 109
	xDel: 40  	yDel: 30


gblock sink0
	xLoc: 283  	yLoc: 50
	xDel: 40  	yDel: 30


gconnect sine0 0  dco0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	116  	53
	167  	53


gconnect dco0 0  sink0 0
	termType: 0  	probeType: 8 	pacerFlag: 0
	pathPts(x,y): 2
	196  	50
	262  	50


gconnect dco0 1  sink1 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	182  	65
	182  	94


