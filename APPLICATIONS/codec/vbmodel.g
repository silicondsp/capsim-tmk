# Graphics info for galaxy vbmodel

zoomFactor: 1.000000 
Vertical Scroll Bar: 0
Horizontal Scroll Bar: 0
Scroll Window Width: 595
Scroll Window Height: 190


gblock impulse0
	xLoc: 58  	yLoc: 77
	xDel: 35  	yDel: 15


gblock iirfil0
	xLoc: 170  	yLoc: 79
	xDel: 60  	yDel: 30


gblock spectrum0
	xLoc: 296  	yLoc: 80
	xDel: 70  	yDel: 30


gblock resmpl0
	xLoc: 399  	yLoc: 81
	xDel: 30  	yDel: 20


gblock spectrum1
	xLoc: 497  	yLoc: 82
	xDel: 70  	yDel: 30


gconnect impulse0 0  iirfil0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	73  	77
	140  	77


gconnect iirfil0 0  spectrum0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	200  	79
	260  	79


gconnect spectrum0 0  resmpl0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	331  	79
	383  	79


gconnect resmpl0 0  spectrum1 0
	termType: 0  	probeType: 1 	pacerFlag: 0
	pathPts(x,y): 2
	412  	82
	461  	82


