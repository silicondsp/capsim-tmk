# Graphics info for galaxy hilbimp

zoomFactor: 1.000000 
Vertical Scroll Bar: 0
Horizontal Scroll Bar: 0
Scroll Window Width: 800
Scroll Window Height: 600


gblock impulse0
	xLoc: 262  	yLoc: 240
	xDel: 35  	yDel: 15


gblock node0
	xLoc: 321  	yLoc: 239
	xDel: 5  	yDel: 5


gblock hilbert0
	xLoc: 401  	yLoc: 242
	xDel: 69  	yDel: 30


gblock delay0
	xLoc: 409  	yLoc: 180
	xDel: 35  	yDel: 15


gblock plot0
	xLoc: 575  	yLoc: 246
	xDel: 40  	yDel: 30


gconnect impulse0 0  node0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	282  	240
	306  	240
	295  	239
	319  	239


gconnect node0 0  hilbert0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	323  	239
	337  	239
	343  	242
	367  	242


gconnect node0 1  delay0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	321  	237
	321  	223
	361  	180
	385  	180


gconnect hilbert0 0  plot0 0
	termType: 0  	probeType: 8 	pacerFlag: 0
	pathPts(x,y): 2
	436  	243
	554  	244


gconnect delay0 0  plot0 1
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	433  	180
	457  	180
	541  	236
	555  	236


