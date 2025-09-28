# Graphics info for galaxy v29codec

zoomFactor: 1.000000 
Vertical Scroll Bar: 0
Horizontal Scroll Bar: 0
Scroll Window Width: 915
Scroll Window Height: 420


gblock node0
	xLoc: 103  	yLoc: 165
	xDel: 5  	yDel: 5


gblock v29encoder0
	xLoc: 224  	yLoc: 164
	xDel: 130  	yDel: 30


gblock addnoise0
	xLoc: 388  	yLoc: 110
	xDel: 110  	yDel: 30


gblock addnoise1
	xLoc: 395  	yLoc: 225
	xDel: 110  	yDel: 30


gblock scatter0
	xLoc: 525  	yLoc: 154
	xDel: 50  	yDel: 30


gblock v29decoder0
	xLoc: 647  	yLoc: 155
	xDel: 130  	yDel: 30


gblock node1
	xLoc: 725  	yLoc: 156
	xDel: 5  	yDel: 5


gblock ecount0
	xLoc: 856  	yLoc: 36
	xDel: 90  	yDel: 30


gconnect input 0  node0 0
	termType: -1  	probeType: 0 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	96  	165
	106  	165
	106  	165
	86  	165
	86  	165
	101  	165


gconnect node0 0  v29encoder0 0
	termType: 0  	probeType: 0 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	106  	159
	115  	159
	115  	164
	144  	164
	144  	164
	159  	164


gconnect node0 1  ecount0 1
	termType: 0  	probeType: 0 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	106  	174
	120  	174
	120  	20
	792  	20
	792  	44
	811  	44


gconnect v29encoder0 0  addnoise0 0
	termType: 0  	probeType: 0 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	289  	145
	298  	145
	298  	145
	318  	145
	318  	110
	333  	110


gconnect v29encoder0 1  addnoise1 0
	termType: 0  	probeType: 0 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	289  	173
	303  	173
	303  	225
	325  	225
	325  	225
	340  	225


gconnect addnoise0 0  scatter0 0
	termType: 0  	probeType: 0 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	443  	110
	452  	110
	452  	141
	485  	141
	485  	141
	500  	141


gconnect addnoise1 0  scatter0 1
	termType: 0  	probeType: 0 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	450  	225
	459  	225
	459  	225
	481  	225
	481  	162
	500  	162


gconnect scatter0 0  v29decoder0 0
	termType: 0  	probeType: 0 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	550  	141
	559  	141
	559  	141
	567  	141
	567  	136
	582  	136


gconnect scatter0 1  v29decoder0 1
	termType: 0  	probeType: 0 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	550  	163
	564  	163
	564  	163
	563  	163
	563  	163
	582  	163


gconnect v29decoder0 0  node1 0
	termType: 0  	probeType: 0 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	712  	155
	721  	155
	721  	156
	708  	156
	708  	156
	723  	156


gconnect node1 0  ecount0 0
	termType: 0  	probeType: 0 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	728  	150
	737  	150
	737  	150
	796  	150
	796  	17
	811  	17


gconnect node1 1  output 0
	termType: 1  	probeType: 0 	pacerFlag: 0	autoConnect: 0 
	pathPts(x,y): 6
	728  	165
	742  	165
	742  	165
	800  	165
	800  	156
	815  	156


