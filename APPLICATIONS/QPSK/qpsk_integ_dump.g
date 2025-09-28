# Graphics info for galaxy qpsk_integ_dump

zoomFactor: 1.000000 
Vertical Scroll Bar: 0
Horizontal Scroll Bar: 0
Scroll Window Width: 928
Scroll Window Height: 335


gblock bdata0
	xLoc: 43  	yLoc: 226
	xDel: 50  	yDel: 30


gblock qpsk0
	xLoc: 134  	yLoc: 225
	xDel: 40  	yDel: 30


gblock stc0
	xLoc: 194  	yLoc: 165
	xDel: 30  	yDel: 30


gblock unitf0
	xLoc: 284  	yLoc: 165
	xDel: 40  	yDel: 30


gblock stc1
	xLoc: 194  	yLoc: 285
	xDel: 30  	yDel: 30


gblock unitf1
	xLoc: 283  	yLoc: 286
	xDel: 40  	yDel: 30


gblock node1
	xLoc: 345  	yLoc: 286
	xDel: 16  	yDel: 16


gblock sine0
	xLoc: 403  	yLoc: 225
	xDel: 35  	yDel: 35


gblock mixer0
	xLoc: 403  	yLoc: 166
	xDel: 35  	yDel: 35


gblock mixer1
	xLoc: 404  	yLoc: 286
	xDel: 35  	yDel: 35


gblock add0
	xLoc: 494  	yLoc: 225
	xDel: 35  	yDel: 35


gblock addnoise0
	xLoc: 562  	yLoc: 227
	xDel: 80  	yDel: 30


gblock node0
	xLoc: 634  	yLoc: 226
	xDel: 16  	yDel: 16


gblock sine1
	xLoc: 693  	yLoc: 226
	xDel: 35  	yDel: 35


gblock mixer2
	xLoc: 693  	yLoc: 164
	xDel: 35  	yDel: 35


gblock mixer3
	xLoc: 695  	yLoc: 285
	xDel: 35  	yDel: 35


gblock intdmp0
	xLoc: 755  	yLoc: 163
	xDel: 40  	yDel: 30


gblock intdmp1
	xLoc: 754  	yLoc: 284
	xDel: 40  	yDel: 30


gblock scatter0
	xLoc: 846  	yLoc: 225
	xDel: 50  	yDel: 30


gconnect bdata0 0  qpsk0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	68  	226
	82  	226
	82  	225
	114  	225


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


gconnect stc0 0  unitf0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	209  	165
	223  	165
	223  	165
	264  	165


gconnect unitf0 0  mixer0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	304  	165
	318  	165
	318  	166
	386  	166


gconnect stc1 0  unitf1 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	209  	285
	223  	285
	223  	286
	263  	286


gconnect unitf1 0  node1 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	303  	286
	337  	286


gconnect node1 0  mixer1 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	353  	286
	387  	286


gconnect node1 1  sine0 0
	termType: 0  	probeType: 0 	pacerFlag: 1
	pathPts(x,y): 4
	345  	278
	345  	264
	345  	235
	386  	235


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


gconnect mixer0 0  add0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	420  	176
	434  	176
	434  	215
	477  	215


gconnect mixer1 0  add0 1
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	421  	276
	435  	276
	435  	235
	477  	235


gconnect add0 0  addnoise0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	511  	225
	522  	227


gconnect addnoise0 0  node0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	602  	227
	626  	226


gconnect node0 0  mixer2 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	634  	218
	634  	204
	634  	174
	676  	174


gconnect node0 1  mixer3 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	634  	234
	634  	248
	634  	275
	678  	275


gconnect node0 2  sine1 0
	termType: 0  	probeType: 0 	pacerFlag: 1
	pathPts(x,y): 4
	642  	226
	656  	226
	656  	226
	676  	226


gconnect sine1 0  mixer2 1
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	693  	208
	693  	184


gconnect sine1 1  mixer3 1
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	693  	244
	694  	267


gconnect mixer2 0  intdmp0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	710  	164
	724  	164
	724  	163
	735  	163


gconnect mixer3 0  intdmp1 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	712  	285
	726  	285
	726  	284
	734  	284


gconnect intdmp0 0  scatter0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	775  	173
	789  	173
	789  	215
	821  	215


gconnect intdmp1 0  scatter0 1
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	774  	274
	788  	274
	788  	235
	821  	235


