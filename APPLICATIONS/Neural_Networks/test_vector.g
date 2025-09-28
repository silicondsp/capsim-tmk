# Graphics info for galaxy test_vector

zoomFactor: 1.000000 
Vertical Scroll Bar: 0
Horizontal Scroll Bar: 0
Scroll Window Width: 0
Scroll Window Height: 0


gblock bdata0
	xLoc: 96  	yLoc: 91
	xDel: 80  	yDel: 30


gblock bdata1
	xLoc: 102  	yLoc: 163
	xDel: 80  	yDel: 30


gblock bdata2
	xLoc: 88  	yLoc: 249
	xDel: 80  	yDel: 30


gblock buildvec0
	xLoc: 282  	yLoc: 167
	xDel: 110  	yDel: 30


gblock prvec0
	xLoc: 452  	yLoc: 165
	xDel: 80  	yDel: 30


gblock prvec1
	xLoc: 649  	yLoc: 161
	xDel: 80  	yDel: 30


gconnect bdata0 0  buildvec0 0
	termType: 0  	probeType: 0 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	136  	91
	145  	91
	145  	138
	212  	138
	212  	138
	227  	138


gconnect bdata1 0  buildvec0 1
	termType: 0  	probeType: 0 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	142  	163
	151  	163
	151  	164
	208  	164
	208  	164
	227  	164


gconnect bdata2 0  buildvec0 2
	termType: 0  	probeType: 0 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	128  	249
	137  	249
	137  	249
	204  	249
	204  	190
	227  	190


gconnect buildvec0 0  prvec0 0
	termType: 0  	probeType: 0 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	337  	167
	346  	167
	346  	167
	397  	167
	397  	165
	412  	165


gconnect prvec0 0  prvec1 0
	termType: 0  	probeType: 0 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	492  	165
	501  	165
	501  	165
	594  	165
	594  	161
	609  	161


