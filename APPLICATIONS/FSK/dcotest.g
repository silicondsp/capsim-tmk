# Graphics info for galaxy dcotest

zoomFactor: 0.000000 
Vertical Scroll Bar: 0
Horizontal Scroll Bar: 0
Scroll Window Width: 800
Scroll Window Height: 400


gblock dco0
	xLoc: 338  	yLoc: 223
	xDel: 30  	yDel: 30


gblock spectrum0
	xLoc: 492  	yLoc: 227
	xDel: 70  	yDel: 30


gblock sine0
	xLoc: 125  	yLoc: 229
	xDel: 35  	yDel: 35


gblock sink0
	xLoc: 426  	yLoc: 300
	xDel: 40  	yDel: 30


gconnect dco0 0  spectrum0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	353  	223
	367  	223
	367  	227
	457  	227


gconnect dco0 1  sink0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	353  	233
	377  	233
	377  	290
	406  	290


gconnect sine0 0  dco0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	142  	229
	156  	229
	156  	223
	323  	223


