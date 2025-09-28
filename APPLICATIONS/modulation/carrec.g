# Graphics info for galaxy carrec

zoomFactor: 1.000000 
Vertical Scroll Bar: 358
Horizontal Scroll Bar: 660
Scroll Window Width: 673
Scroll Window Height: 185


gblock square
	xLoc: 177  	yLoc: 116
	xDel: 24  	yDel: 24


gblock tunedFilter
	xLoc: 297  	yLoc: 116
	xDel: 40  	yDel: 40


gblock divbytwo0
	xLoc: 387  	yLoc: 116
	xDel: 32  	yDel: 32


gblock bpf0
	xLoc: 490  	yLoc: 116
	xDel: 40  	yDel: 40


gconnect input 0  square 0
	termType: -1  	probeType: 0 	pacerFlag: 0 
	pathPts(x,y): 4
	105  	112
	119  	112
	138  	116
	162  	116


gconnect square 0  tunedFilter 0
	termType: 0  	probeType: 8 	pacerFlag: 0
	pathPts(x,y): 2
	187  	115
	277  	116


gconnect tunedFilter 0  divbytwo0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	316  	116
	370  	117


gconnect divbytwo0 0  bpf0 0
	termType: 0  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	401  	116
	470  	116


gconnect bpf0 0  output 0
	termType: 1  	probeType: 0 	pacerFlag: 0
	pathPts(x,y): 2
	509  	116
	573  	116


