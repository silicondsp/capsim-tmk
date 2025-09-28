# Graphics info for galaxy fsk

zoomFactor: 1.000000 
Vertical Scroll Bar: 0
Horizontal Scroll Bar: 0
Scroll Window Width: 919
Scroll Window Height: 322


gblock bdata0
	xLoc: 40  	yLoc: 133
	xDel: 50  	yDel: 30


gblock linecode0
	xLoc: 133  	yLoc: 136
	xDel: 50  	yDel: 30


gblock unitf0
	xLoc: 280  	yLoc: 135
	xDel: 40  	yDel: 30


gblock gain0
	xLoc: 352  	yLoc: 136
	xDel: 35  	yDel: 15


gblock dco0
	xLoc: 418  	yLoc: 136
	xDel: 30  	yDel: 30


gblock sink0
	xLoc: 423  	yLoc: 194
	xDel: 40  	yDel: 30


gblock addnoise0
	xLoc: 491  	yLoc: 136
	xDel: 80  	yDel: 30


gblock spectrum0
	xLoc: 590  	yLoc: 136
	xDel: 70  	yDel: 30


gblock fskdemod0
	xLoc: 721  	yLoc: 135
	xDel: 80  	yDel: 30


gblock plot0
	xLoc: 844  	yLoc: 135
	xDel: 40  	yDel: 30


gconnect bdata0 0  linecode0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	65  	133
	79  	133
	79  	136
	108  	136


gconnect linecode0 0  unitf0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	158  	136
	172  	136
	172  	135
	260  	135


gconnect unitf0 0  gain0 0
	termType: 0  	probeType: 4 	pacerFlag: 0
	pathPts(x,y): 2
	300  	135
	335  	136


gconnect gain0 0  dco0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	369  	136
	383  	136
	383  	136
	403  	136


gconnect dco0 0  addnoise0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	433  	136
	447  	136
	447  	136
	451  	136


gconnect dco0 1  sink0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	421  	153
	423  	179


gconnect addnoise0 0  spectrum0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	531  	136
	545  	136
	545  	136
	555  	136


gconnect spectrum0 0  fskdemod0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	625  	136
	639  	136
	639  	135
	681  	135


gconnect fskdemod0 0  plot0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	761  	135
	775  	135
	775  	135
	824  	135


