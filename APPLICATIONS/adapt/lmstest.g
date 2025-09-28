# Graphics info for galaxy lmstest

zoomFactor: 1.000000 
Vertical Scroll Bar: 0
Horizontal Scroll Bar: 0
Scroll Window Width: 705
Scroll Window Height: 208


gblock gauss0
	xLoc: 110  	yLoc: 74
	xDel: 49  	yDel: 30


gblock node0
	xLoc: 226  	yLoc: 73
	xDel: 16  	yDel: 16


gblock convolve0
	xLoc: 296  	yLoc: 73
	xDel: 60  	yDel: 30


gblock node1
	xLoc: 373  	yLoc: 74
	xDel: 16  	yDel: 16


gblock lms0
	xLoc: 284  	yLoc: 164
	xDel: 30  	yDel: 30


gblock sum0
	xLoc: 466  	yLoc: 74
	xDel: 35  	yDel: 35


gblock sink0
	xLoc: 575  	yLoc: 74
	xDel: 40  	yDel: 30


gconnect gauss0 0  node0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	134  	74
	158  	74
	194  	73
	218  	73


gconnect node0 0  convolve0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	234  	73
	248  	73
	242  	73
	266  	73


gconnect node0 1  lms0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 3
	225  	77
	225  	168
	269  	168


gconnect convolve0 0  node1 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	326  	73
	350  	73
	341  	74
	365  	74


gconnect node1 0  lms0 1
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	374  	78
	374  	135
	285  	135
	285  	149


gconnect node1 1  sum0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	379  	75
	448  	75


gconnect lms0 0  sum0 1
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 3
	299  	164
	465  	165
	465  	93


gconnect sum0 0  sink0 0
	termType: 0  	probeType: 4 	pacerFlag: 0
	pathPts(x,y): 2
	482  	74
	555  	74


