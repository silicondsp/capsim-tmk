# Graphics info for galaxy fskdemod

zoomFactor: 1.000000 
Vertical Scroll Bar: 0
Horizontal Scroll Bar: 0
Scroll Window Width: 767
Scroll Window Height: 502


gblock node1
	xLoc: 129  	yLoc: 109
	xDel: 16  	yDel: 16


gblock mixer0
	xLoc: 183  	yLoc: 214
	xDel: 35  	yDel: 35


gblock lpf0
	xLoc: 242  	yLoc: 213
	xDel: 30  	yDel: 30


gblock gain0
	xLoc: 320  	yLoc: 210
	xDel: 35  	yDel: 15


gblock node0
	xLoc: 389  	yLoc: 256
	xDel: 16  	yDel: 16


gblock dco1
	xLoc: 317  	yLoc: 310
	xDel: 30  	yDel: 30


gblock delay0
	xLoc: 164  	yLoc: 312
	xDel: 35  	yDel: 15


gblock iirfil0
	xLoc: 465  	yLoc: 252
	xDel: 60  	yDel: 30


gblock sink0
	xLoc: 319  	yLoc: 376
	xDel: 40  	yDel: 30


gconnect input 0  node1 0
	termType: -1  	probeType: 0 	pacerFlag: 0 
	pathPts(x,y): 4
	302  	70
	271  	70
	271  	107
	129  	107


gconnect node1 0  mixer0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	129  	111
	129  	111
	129  	204
	163  	204


gconnect mixer0 0  lpf0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	203  	213
	227  	213


gconnect lpf0 0  gain0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	257  	213
	271  	213
	288  	210
	300  	210


gconnect gain0 0  node0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	337  	220
	351  	220
	351  	246
	381  	246


gconnect node0 0  dco1 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	389  	264
	389  	278
	389  	300
	332  	300


gconnect node0 1  iirfil0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	397  	256
	411  	256
	411  	252
	435  	252


gconnect dco1 0  delay0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	303  	310
	189  	310


gconnect dco1 1  sink0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	317  	328
	317  	360


gconnect delay0 0  mixer0 1
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	140  	311
	111  	311
	111  	220
	164  	220


gconnect iirfil0 0  output 0
	termType: 1  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	495  	252
	509  	252
	543  	254
	557  	254


