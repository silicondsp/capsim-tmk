# Graphics info for galaxy airport_hist_Eq

zoomFactor: 1.000000 
Vertical Scroll Bar: 0
Horizontal Scroll Bar: 0
Scroll Window Width: 800
Scroll Window Height: 400


gblock imgrdfptiff0
	xLoc: 100  	yLoc: 100
	xDel: 140  	yDel: 30


gblock imghisteq0
	xLoc: 283  	yLoc: 104
	xDel: 120  	yDel: 30


gblock ximgdisp1
	xLoc: 463  	yLoc: 103
	xDel: 110  	yDel: 30


gconnect imgrdfptiff0 0  imghisteq0 0
	termType: 0  	probeType: 80 	pacerFlag: 0	autoConnect: 0
	pathPts(x,y): 6
	170  	100
	179  	100
	179  	104
	208  	104
	208  	104
	223  	104


gconnect imghisteq0 0  ximgdisp1 0
	termType: 0  	probeType: 16 	pacerFlag: 0	autoConnect: 0
	pathPts(x,y): 6
	343  	104
	352  	104
	352  	104
	393  	104
	393  	103
	408  	103


