# Graphics info for galaxy MLP_NN_Test

zoomFactor: 1.000000 
Vertical Scroll Bar: 0
Horizontal Scroll Bar: 0
Scroll Window Width: 0
Scroll Window Height: 0


gblock bdata0
	xLoc: 96  	yLoc: 91
	xDel: 50  	yDel: 30


gblock bdata1
	xLoc: 102  	yLoc: 163
	xDel: 50  	yDel: 30


gblock node0
	xLoc: 174  	yLoc: 96
	xDel: 5  	yDel: 5


gblock node1
	xLoc: 166  	yLoc: 264
	xDel: 5  	yDel: 5


gblock buildvec0
	xLoc: 282  	yLoc: 167
	xDel: 110  	yDel: 30


gblock xorblk0
	xLoc: 458  	yLoc: 316
	xDel: 50  	yDel: 35


gblock MLP_NN0
	xLoc: 616  	yLoc: 165
	xDel: 90  	yDel: 30


gblock prbprfile00
	xLoc: 818  	yLoc: 146
	xDel: 70  	yDel: 30


gblock sink0
	xLoc: 788  	yLoc: 261
	xDel: 40  	yDel: 30


gconnect bdata0 0  node0 0
	termType: 0  	probeType: 0 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	121  	91
	130  	91
	130  	96
	157  	96
	157  	96
	172  	96


gconnect bdata1 0  node1 0
	termType: 0  	probeType: 0 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	127  	163
	136  	163
	136  	264
	149  	264
	149  	264
	164  	264


gconnect node0 0  buildvec0 0
	termType: 0  	probeType: 0 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	177  	90
	186  	90
	186  	148
	212  	148
	212  	148
	227  	148


gconnect node0 1  xorblk0 0
	termType: 0  	probeType: 0 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	177  	105
	191  	105
	191  	343
	418  	343
	418  	301
	433  	301


gconnect node1 0  buildvec0 1
	termType: 0  	probeType: 0 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	169  	258
	178  	258
	178  	258
	208  	258
	208  	175
	227  	175


gconnect node1 1  xorblk0 1
	termType: 0  	probeType: 0 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	169  	273
	183  	273
	183  	319
	414  	319
	414  	319
	433  	319


gconnect buildvec0 0  MLP_NN0 0
	termType: 0  	probeType: 0 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	337  	167
	346  	167
	346  	146
	556  	146
	556  	146
	571  	146


gconnect xorblk0 0  MLP_NN0 1
	termType: 0  	probeType: 1 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	483  	316
	492  	316
	492  	316
	552  	316
	552  	173
	571  	173


gconnect MLP_NN0 0  prbprfile00 0
	termType: 0  	probeType: 4 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	661  	146
	670  	146
	670  	146
	768  	146
	768  	146
	783  	146


gconnect MLP_NN0 1  sink0 0
	termType: 0  	probeType: 1 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	661  	174
	675  	174
	675  	261
	753  	261
	753  	261
	768  	261


