# Graphics info for galaxy bitest

zoomFactor: 1.000000 
Vertical Scroll Bar: 0
Horizontal Scroll Bar: 0
Scroll Window Width: 800
Scroll Window Height: 400


gblock bdata0
	xLoc: 100  	yLoc: 100
	xDel: 80  	yDel: 30


gblock xlogican0
	xLoc: 220  	yLoc: 100
	xDel: 50  	yDel: 40


gblock node0
	xLoc: 307  	yLoc: 98
	xDel: 5  	yDel: 17


gblock bitmanip0
	xLoc: 479  	yLoc: 187
	xDel: 110  	yDel: 30


gblock xlogican1
	xLoc: 580  	yLoc: 187
	xDel: 50  	yDel: 40


gblock xprfile0
	xLoc: 666  	yLoc: 109
	xDel: 70  	yDel: 30


gconnect bdata0 0  xlogican0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 6
	140  	100
	149  	100
	149  	100
	180  	100
	180  	100
	195  	100


gconnect xlogican0 0  node0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 6
	245  	100
	254  	100
	254  	100
	290  	100
	290  	98
	305  	98


gconnect node0 0  bitmanip0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 6
	310  	92
	319  	92
	319  	187
	409  	187
	409  	187
	424  	187


gconnect node0 1  xprfile0 1
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 6
	310  	107
	324  	107
	324  	117
	612  	117
	612  	117
	631  	117


gconnect bitmanip0 0  xlogican1 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 6
	534  	187
	543  	187
	543  	187
	540  	187
	540  	187
	555  	187


gconnect xlogican1 0  xprfile0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 6
	605  	187
	614  	187
	614  	187
	616  	187
	616  	96
	631  	96


