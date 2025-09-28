# Graphics info for galaxy carrierRecovery

zoomFactor: 1.000000 
Vertical Scroll Bar: 0
Horizontal Scroll Bar: 0
Scroll Window Width: 844
Scroll Window Height: 197


gblock bdata0
	xLoc: 58  	yLoc: 63
	xDel: 50  	yDel: 30


gblock linecode0
	xLoc: 138  	yLoc: 65
	xDel: 50  	yDel: 30


gblock filtnyq0
	xLoc: 201  	yLoc: 64
	xDel: 40  	yDel: 30


gblock resmpl0
	xLoc: 257  	yLoc: 63
	xDel: 30  	yDel: 20


gblock node1
	xLoc: 307  	yLoc: 65
	xDel: 16  	yDel: 16


gblock sine1
	xLoc: 350  	yLoc: 141
	xDel: 35  	yDel: 35


gblock mixer0
	xLoc: 351  	yLoc: 66
	xDel: 35  	yDel: 35


gblock node0
	xLoc: 404  	yLoc: 65
	xDel: 16  	yDel: 16


gblock carrec0
	xLoc: 472  	yLoc: 64
	xDel: 50  	yDel: 32


gblock mixer1
	xLoc: 560  	yLoc: 64
	xDel: 35  	yDel: 35


gblock iirfil0
	xLoc: 645  	yLoc: 63
	xDel: 60  	yDel: 30


gblock sink0
	xLoc: 753  	yLoc: 58
	xDel: 40  	yDel: 30


gconnect bdata0 0  linecode0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	81  	64
	113  	64


gconnect linecode0 0  filtnyq0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	162  	64
	181  	64


gconnect filtnyq0 0  resmpl0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	219  	63
	242  	63


gconnect resmpl0 0  node1 0
	termType: 0  	probeType: 4 	pacerFlag: 0
	pathPts(x,y): 2
	271  	64
	301  	64


gconnect node1 0  mixer0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	313  	65
	333  	65


gconnect node1 1  sine1 0
	termType: 0  	probeType: 0 	pacerFlag: 1
	pathPts(x,y): 3
	307  	68
	307  	138
	332  	138


gconnect node1 2  bdata0 0
	termType: 0  	probeType: 0 	pacerFlag: 1
	pathPts(x,y): 4
	306  	59
	306  	11
	58  	11
	58  	49


gconnect sine1 0  mixer0 1
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	351  	125
	351  	85


gconnect mixer0 0  node0 0
	termType: 0  	probeType: 8 	pacerFlag: 0
	pathPts(x,y): 2
	368  	65
	397  	67


gconnect node0 0  carrec0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	406  	65
	420  	65
	423  	64
	447  	64


gconnect node0 1  mixer1 1
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	404  	63
	404  	24
	556  	24
	556  	46


gconnect carrec0 0  mixer1 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	497  	64
	521  	64
	519  	64
	543  	64


gconnect mixer1 0  iirfil0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	577  	66
	615  	66


gconnect iirfil0 0  sink0 0
	termType: 0  	probeType: 8 	pacerFlag: 0
	pathPts(x,y): 4
	675  	63
	699  	63
	709  	58
	733  	58


