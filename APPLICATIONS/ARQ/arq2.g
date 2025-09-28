# Graphics info for galaxy arq2

zoomFactor: 1.000000 
Vertical Scroll Bar: 0
Horizontal Scroll Bar: 0
Scroll Window Width: 1014
Scroll Window Height: 644


gblock datagen0
	xLoc: 1091  	yLoc: 144
	xDel: 100  	yDel: 30


gblock xlogican1
	xLoc: 60  	yLoc: 452
	xDel: 50  	yDel: 40


gblock txhdlc0
	xLoc: 225  	yLoc: 162
	xDel: 89  	yDel: 30


gblock v29codec0
	xLoc: 364  	yLoc: 207
	xDel: 110  	yDel: 30


gblock rxhdlc0
	xLoc: 490  	yLoc: 160
	xDel: 89  	yDel: 30


gblock v2b0
	xLoc: 635  	yLoc: 120
	xDel: 60  	yDel: 30


gblock xlogican0
	xLoc: 752  	yLoc: 117
	xDel: 50  	yDel: 40


gblock fxdelay0
	xLoc: 677  	yLoc: 219
	xDel: 100  	yDel: 30


gblock itf1
	xLoc: 822  	yLoc: 216
	xDel: 60  	yDel: 30


gblock itf0
	xLoc: 811  	yLoc: 357
	xDel: 60  	yDel: 30


gblock xplot0
	xLoc: 946  	yLoc: 252
	xDel: 80  	yDel: 30


gblock xplot1
	xLoc: 967  	yLoc: 329
	xDel: 80  	yDel: 30


gconnect datagen0 0  xlogican1 0
	termType: 0  	probeType: 1 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	1141  	144
	1150  	144
	1150  	482
	20  	482
	20  	452
	35  	452


gconnect xlogican1 0  txhdlc0 0
	termType: 0  	probeType: 0 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	85  	452
	94  	452
	94  	143
	166  	143
	166  	143
	181  	143


gconnect txhdlc0 0  v29codec0 0
	termType: 0  	probeType: 0 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	270  	162
	294  	162
	294  	207
	294  	207
	294  	207
	309  	207


gconnect v29codec0 0  rxhdlc0 0
	termType: 0  	probeType: 1 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	419  	207
	428  	207
	428  	207
	431  	207
	431  	160
	446  	160


gconnect rxhdlc0 0  v2b0 0
	termType: 0  	probeType: 0 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	535  	141
	544  	141
	544  	141
	590  	141
	590  	120
	605  	120


gconnect rxhdlc0 1  fxdelay0 0
	termType: 0  	probeType: 0 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	535  	169
	549  	169
	549  	219
	612  	219
	612  	219
	627  	219


gconnect v2b0 0  xlogican0 0
	termType: 0  	probeType: 0 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	665  	120
	674  	120
	674  	120
	712  	120
	712  	117
	727  	117


gconnect fxdelay0 0  txhdlc0 1
	termType: 0  	probeType: 1 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	727  	190
	736  	190
	736  	110
	162  	110
	162  	170
	181  	170


gconnect fxdelay0 1  itf1 0
	termType: 0  	probeType: 0 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	727  	217
	741  	217
	741  	217
	777  	217
	777  	216
	792  	216


gconnect fxdelay0 2  itf0 0
	termType: 0  	probeType: 0 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	727  	244
	746  	244
	746  	357
	766  	357
	766  	357
	781  	357


gconnect itf1 0  xplot1 0
	termType: 0  	probeType: 1 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	852  	216
	861  	216
	861  	329
	912  	329
	912  	329
	927  	329


gconnect itf0 0  xplot0 0
	termType: 0  	probeType: 0 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	841  	357
	850  	357
	850  	357
	891  	357
	891  	252
	906  	252


gconnect xplot1 0  datagen0 0
	termType: 0  	probeType: 0 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	1007  	329
	1016  	329
	1016  	329
	1026  	329
	1026  	144
	1041  	144


