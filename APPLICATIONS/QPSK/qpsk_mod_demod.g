# Graphics info for galaxy qpsk_mod_demod

zoomFactor: 1.000000 
Vertical Scroll Bar: 0
Horizontal Scroll Bar: 0
Scroll Window Width: 981
Scroll Window Height: 420


gblock bdata0
	xLoc: 43  	yLoc: 226
	xDel: 50  	yDel: 30


gblock sine0
	xLoc: 403  	yLoc: 225
	xDel: 35  	yDel: 35


gblock qpsk0
	xLoc: 134  	yLoc: 225
	xDel: 40  	yDel: 30


gblock stc0
	xLoc: 194  	yLoc: 165
	xDel: 30  	yDel: 30


gblock sqrtnyq0
	xLoc: 284  	yLoc: 165
	xDel: 40  	yDel: 30


gblock mixer0
	xLoc: 403  	yLoc: 166
	xDel: 35  	yDel: 35


gblock stc1
	xLoc: 194  	yLoc: 285
	xDel: 30  	yDel: 30


gblock sqrtnyq1
	xLoc: 283  	yLoc: 286
	xDel: 40  	yDel: 30


gblock mixer1
	xLoc: 404  	yLoc: 286
	xDel: 35  	yDel: 35


gblock add0
	xLoc: 494  	yLoc: 225
	xDel: 35  	yDel: 35


gblock node0
	xLoc: 584  	yLoc: 226
	xDel: 16  	yDel: 16


gblock sine1
	xLoc: 643  	yLoc: 226
	xDel: 35  	yDel: 35


gblock mixer2
	xLoc: 643  	yLoc: 164
	xDel: 35  	yDel: 35


gblock mixer3
	xLoc: 645  	yLoc: 285
	xDel: 35  	yDel: 35


gblock sqrtnyq2
	xLoc: 705  	yLoc: 163
	xDel: 40  	yDel: 30


gblock sqrtnyq3
	xLoc: 704  	yLoc: 284
	xDel: 40  	yDel: 30


gblock scatter0
	xLoc: 796  	yLoc: 225
	xDel: 50  	yDel: 30


gconnect bdata0 0  qpsk0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	68  	226
	82  	226
	82  	225
	114  	225


gconnect sine0 0  mixer0 1
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	404  	206
	404  	187


gconnect sine0 1  mixer1 1
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	405  	244
	405  	270


gconnect qpsk0 0  stc0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	154  	218
	165  	218
	165  	167
	178  	167


gconnect qpsk0 1  stc1 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	155  	234
	164  	234
	164  	286
	178  	286


gconnect stc0 0  sqrtnyq0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	209  	165
	223  	165
	223  	165
	264  	165


gconnect sqrtnyq0 0  mixer0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	304  	165
	318  	165
	318  	166
	386  	166


gconnect mixer0 0  add0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	420  	176
	434  	176
	434  	215
	477  	215


gconnect stc1 0  sqrtnyq1 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	209  	285
	223  	285
	223  	286
	263  	286


gconnect sqrtnyq1 0  mixer1 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	303  	286
	317  	286
	317  	286
	387  	286


gconnect mixer1 0  add0 1
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	421  	276
	435  	276
	435  	235
	477  	235


gconnect add0 0  node0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	511  	225
	525  	225
	525  	226
	576  	226


gconnect node0 0  mixer2 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	584  	218
	584  	204
	584  	174
	626  	174


gconnect node0 1  mixer3 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	584  	234
	584  	248
	584  	275
	628  	275


gconnect sine1 0  mixer2 1
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	643  	208
	643  	184


gconnect sine1 1  mixer3 1
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	643  	244
	644  	267


gconnect mixer2 0  sqrtnyq2 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	660  	164
	674  	164
	674  	163
	685  	163


gconnect mixer3 0  sqrtnyq3 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	662  	285
	676  	285
	676  	284
	684  	284


gconnect sqrtnyq2 0  scatter0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	725  	173
	739  	173
	739  	215
	771  	215


gconnect sqrtnyq3 0  scatter0 1
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	724  	274
	738  	274
	738  	235
	771  	235


