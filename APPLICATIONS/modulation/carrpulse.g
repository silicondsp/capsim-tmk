# Graphics info for galaxy carrpulse

zoomFactor: 1.000000 
Vertical Scroll Bar: 0
Horizontal Scroll Bar: 0
Scroll Window Width: 719
Scroll Window Height: 194


gblock pulse0
	xLoc: 57  	yLoc: 65
	xDel: 35  	yDel: 15


gblock sine1
	xLoc: 181  	yLoc: 141
	xDel: 35  	yDel: 35


gblock lpf0
	xLoc: 125  	yLoc: 66
	xDel: 30  	yDel: 30


gblock mixer0
	xLoc: 182  	yLoc: 66
	xDel: 35  	yDel: 35


gblock node0
	xLoc: 235  	yLoc: 65
	xDel: 16  	yDel: 16


gblock carrec0
	xLoc: 303  	yLoc: 64
	xDel: 50  	yDel: 32


gblock mixer1
	xLoc: 391  	yLoc: 64
	xDel: 35  	yDel: 35


gblock iirfil0
	xLoc: 476  	yLoc: 63
	xDel: 60  	yDel: 30


gblock sink0
	xLoc: 584  	yLoc: 58
	xDel: 40  	yDel: 30


gconnect pulse0 0  lpf0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	73  	65
	109  	65


gconnect sine1 0  mixer0 1
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	182  	125
	182  	85


gconnect lpf0 0  mixer0 0
	termType: 0  	probeType: 4 	pacerFlag: 0
	pathPts(x,y): 2
	140  	66
	165  	66


gconnect mixer0 0  node0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	199  	65
	228  	67


gconnect node0 0  carrec0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	237  	65
	251  	65
	254  	64
	278  	64


gconnect node0 1  mixer1 1
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	235  	63
	235  	24
	387  	24
	387  	46


gconnect carrec0 0  mixer1 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	328  	64
	352  	64
	350  	64
	374  	64


gconnect mixer1 0  iirfil0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	408  	66
	446  	66


gconnect iirfil0 0  sink0 0
	termType: 0  	probeType: 8 	pacerFlag: 0
	pathPts(x,y): 4
	506  	63
	530  	63
	540  	58
	564  	58


