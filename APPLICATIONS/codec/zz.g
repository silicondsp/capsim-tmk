# Graphics info for galaxy zz

zoomFactor: 1.000000 
Vertical Scroll Bar: 0
Horizontal Scroll Bar: 0
Scroll Window Width: 564
Scroll Window Height: 244


gblock pulse0
	xLoc: 239  	yLoc: 101
	xDel: 35  	yDel: 15


gblock iirfil0
	xLoc: 140  	yLoc: 37
	xDel: 60  	yDel: 30


gblock hold0
	xLoc: 240  	yLoc: 37
	xDel: 40  	yDel: 30


gblock atod0
	xLoc: 340  	yLoc: 37
	xDel: 40  	yDel: 30


gblock mulaw0
	xLoc: 440  	yLoc: 37
	xDel: 40  	yDel: 30


gblock mulaw1
	xLoc: 440  	yLoc: 177
	xDel: 40  	yDel: 30


gblock dtoa0
	xLoc: 340  	yLoc: 177
	xDel: 40  	yDel: 30


gblock spectrum0
	xLoc: 241  	yLoc: 178
	xDel: 70  	yDel: 30


gblock iirfil1
	xLoc: 140  	yLoc: 177
	xDel: 60  	yDel: 30


gconnect pulse0 0  hold0 1
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	240  	92
	240  	57


gconnect input 0  iirfil0 0
	termType: -1  	probeType: 0 	pacerFlag: 0 
	pathPts(x,y): 2
	36  	35
	110  	35


gconnect iirfil0 0  hold0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	170  	37
	217  	37


gconnect hold0 0  atod0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	260  	37
	317  	37


gconnect atod0 0  mulaw0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	360  	38
	414  	38


gconnect mulaw0 0  output 0
	termType: 1  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	460  	37
	484  	37
	495  	30
	509  	30


gconnect mulaw1 0  dtoa0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	415  	177
	362  	177


gconnect dtoa0 0  spectrum0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	319  	177
	280  	177


gconnect spectrum0 0  iirfil1 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	205  	177
	173  	177


