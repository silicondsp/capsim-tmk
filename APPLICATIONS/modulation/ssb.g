# Graphics info for galaxy ssb

zoomFactor: 1.000000 
Vertical Scroll Bar: 0
Horizontal Scroll Bar: 0
Scroll Window Width: 800
Scroll Window Height: 600


gblock sine1
	xLoc: 376  	yLoc: 215
	xDel: 35  	yDel: 35


gblock gauss0
	xLoc: 52  	yLoc: 241
	xDel: 49  	yDel: 30


gblock iirfil0
	xLoc: 142  	yLoc: 240
	xDel: 60  	yDel: 30


gblock sine0
	xLoc: 515  	yLoc: 393
	xDel: 35  	yDel: 35


gblock node0
	xLoc: 227  	yLoc: 239
	xDel: 16  	yDel: 16


gblock hilbert0
	xLoc: 307  	yLoc: 242
	xDel: 69  	yDel: 30


gblock delay0
	xLoc: 315  	yLoc: 180
	xDel: 35  	yDel: 15


gblock mixer1
	xLoc: 423  	yLoc: 252
	xDel: 35  	yDel: 35


gblock gain0
	xLoc: 477  	yLoc: 252
	xDel: 35  	yDel: 15


gblock mixer0
	xLoc: 426  	yLoc: 179
	xDel: 35  	yDel: 35


gblock add0
	xLoc: 521  	yLoc: 215
	xDel: 35  	yDel: 35


gblock addnoise0
	xLoc: 597  	yLoc: 215
	xDel: 80  	yDel: 30


gblock node1
	xLoc: 675  	yLoc: 213
	xDel: 16  	yDel: 16


gblock mixer2
	xLoc: 512  	yLoc: 336
	xDel: 35  	yDel: 35


gblock delay1
	xLoc: 400  	yLoc: 334
	xDel: 35  	yDel: 15


gblock node2
	xLoc: 592  	yLoc: 391
	xDel: 16  	yDel: 16


gblock mixer3
	xLoc: 515  	yLoc: 459
	xDel: 35  	yDel: 35


gblock hilbert1
	xLoc: 405  	yLoc: 461
	xDel: 69  	yDel: 30


gblock gain1
	xLoc: 302  	yLoc: 463
	xDel: 35  	yDel: 15


gblock add1
	xLoc: 238  	yLoc: 398
	xDel: 35  	yDel: 35


gblock iirfil1
	xLoc: 166  	yLoc: 398
	xDel: 60  	yDel: 30


gblock sink0
	xLoc: 46  	yLoc: 400
	xDel: 40  	yDel: 30


gblock delay2
	xLoc: 273  	yLoc: 293
	xDel: 35  	yDel: 15


gblock sink1
	xLoc: 348  	yLoc: 290
	xDel: 40  	yDel: 30


gconnect sine1 0  mixer0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 3
	393  	208
	424  	208
	424  	197


gconnect sine1 1  mixer1 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 3
	389  	223
	422  	223
	424  	235


gconnect gauss0 0  iirfil0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	75  	242
	111  	241


gconnect iirfil0 0  node0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	172  	239
	224  	239


gconnect sine0 0  mixer2 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	514  	376
	514  	355


gconnect sine0 1  mixer3 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	514  	411
	515  	442


gconnect node0 0  hilbert0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	229  	239
	243  	239
	249  	242
	273  	242


gconnect node0 1  delay0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	227  	237
	227  	223
	267  	180
	291  	180


gconnect node0 2  delay2 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 3
	228  	243
	228  	291
	256  	291


gconnect hilbert0 0  mixer1 1
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 4
	342  	242
	361  	242
	361  	251
	407  	251


gconnect delay0 0  mixer0 1
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	333  	180
	408  	180


gconnect mixer1 0  gain0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	439  	253
	460  	252


gconnect gain0 0  add0 1
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 3
	493  	253
	521  	253
	521  	234


gconnect mixer0 0  add0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 3
	443  	179
	521  	179
	521  	199


gconnect add0 0  addnoise0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	537  	214
	557  	214


gconnect addnoise0 0  node1 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	637  	215
	671  	215


gconnect node1 0  node2 0
	termType: 0  	probeType: 8 	pacerFlag: 0
	pathPts(x,y): 5
	680  	214
	716  	213
	719  	383
	719  	388
	599  	388


gconnect node1 1  mixer2 1
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 3
	592  	386
	592  	331
	529  	331


gconnect mixer2 0  delay1 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	494  	337
	418  	337


gconnect delay1 0  add1 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 3
	382  	335
	237  	335
	237  	381


gconnect node2 0  mixer3 1
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 3
	591  	395
	591  	462
	535  	462


gconnect mixer3 0  hilbert1 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	498  	459
	438  	460


gconnect hilbert1 0  gain1 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	370  	460
	320  	460


gconnect gain1 0  add1 1
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 3
	284  	463
	239  	463
	239  	416


gconnect add1 0  iirfil1 0
	termType: 0  	probeType: 8 	pacerFlag: 0
	pathPts(x,y): 2
	220  	398
	197  	398


gconnect iirfil1 0  sink0 0
	termType: 0  	probeType: 8 	pacerFlag: 0
	pathPts(x,y): 2
	136  	398
	66  	398


gconnect delay2 0  sink1 0
	termType: 0  	probeType: 8 	pacerFlag: 0
	pathPts(x,y): 2
	289  	293
	328  	293


