# Graphics info for galaxy predlmstest

zoomFactor: 1.000000 
Vertical Scroll Bar: 0
Horizontal Scroll Bar: 0
Scroll Window Width: 712
Scroll Window Height: 202


gblock gauss0
	xLoc: 56  	yLoc: 58
	xDel: 49  	yDel: 30


gblock node0
	xLoc: 176  	yLoc: 58
	xDel: 16  	yDel: 16


gblock convolve0
	xLoc: 296  	yLoc: 58
	xDel: 80  	yDel: 30


gblock sum0
	xLoc: 536  	yLoc: 58
	xDel: 35  	yDel: 35


gblock predlms0
	xLoc: 295  	yLoc: 131
	xDel: 69  	yDel: 30


gblock sink0
	xLoc: 641  	yLoc: 59
	xDel: 40  	yDel: 30


gconnect gauss0 0  node0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	80  	58
	104  	58
	144  	58
	168  	58


gconnect node0 0  convolve0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	184  	58
	198  	58
	232  	58
	256  	58


gconnect node0 1  predlms0 1
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 3
	177  	62
	177  	128
	261  	128


gconnect convolve0 0  sum0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 6
	336  	58
	360  	58
	384  	58
	438  	58
	495  	58
	519  	58


gconnect sum0 0  sink0 0
	termType: 0  	probeType: 4 	pacerFlag: 0
	pathPts(x,y): 2
	552  	60
	621  	60


gconnect sum0 1  predlms0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 5
	546  	70
	566  	114
	566  	166
	295  	166
	295  	149


gconnect predlms0 0  sum0 1
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 3
	329  	131
	538  	130
	538  	77


