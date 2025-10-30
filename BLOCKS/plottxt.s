<BLOCK>
<LICENSE>
/*  Capsim (r) Text Mode Kernel (TMK) Star Library (Blocks)
    Copyright (C) 1989-2017  Silicon DSP Corporation

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

    http://www.silicondsp.com
    Silicon DSP  Corporation
    Las Vegas, Nevada
*/
</LICENSE>
<BLOCK_NAME>plottxt</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* plottxt.s */
/**********************************************************************
                                plot()
***********************************************************************
	inputs:		(arbitrary number)
	outputs:	(optional feed-through of input channels)
	parameters:	int npts, the number of points to plot
			int skip, number of points to skip before first plot
			file title,  the title of the plot
			file x_axis, the title for the x_axis
			file y_axis, the title for the y_axis
			int plotQ plot quality flag 0 = high , 1 = low
*************************************************************************
This routine will produce a set of plots from an arbitrary number of input
channels.  Optionally, the input channel data can 'flow through' to the
correspondingly numbered output channel.  This is useful if this block is
to be placed in line in a simulation (e.g. probe).
The first parameter represents the number of points plotted from each channel.
EVERY TIME this number of points is input, a new set of plots will be generated.
Default is set to (int 500).
The second parameter is the number of points to skip before the first plot set
is presented.  This enables skipping of any transient period.
Default is set to (int 0).
The third parameter represents the title for the plot.
Default is set to "PLOT".
The fourth parameter represents the title for the x_axis.
Default is set to "X".
The fifth parameter represents the title for the y_axis.
Default is set to "Y".
Programmer:     Sasan H. Ardalan	
Date: 	 	June 18, 1990	
Modified: Sasan Ardalan, Added Dynamic Capability
*/

]]>
</COMMENTS> 


<DESC_SHORT>
Plot probe.
</DESC_SHORT>


<DEFINES> 

#define BLOCK_SIZE 1024
#define MAX_NUMBER_OF_PLOTS 10
#define STATIC 0
#define DYNAMIC 1

</DEFINES> 

             

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>ibufs</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>obufs</NAME>
	</STATE>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>xpts</NAME>
	</STATE>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>ypts[MAX_NUMBER_OF_PLOTS]</NAME>
	</STATE>
	<STATE>
		<TYPE>char*</TYPE>
		<NAME>legends[100]</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>count</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>totalCount</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>displayed</NAME>
		<VALUE>FALSE</VALUE>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>dt</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>blockOff</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>bufi</NAME>
		<VALUE>0</VALUE>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	int samples;
    	int i,j,k,ii;
	int	operState;
	char curveTitle[80];
	char curveSubTitle[80];
	char	fname[100];
	FILE *time_F;

</DECLARATIONS> 

                     

<PARAMETERS>
<PARAM>
	<DEF>Number of points in each plot (dynamic window size)</DEF>
	<TYPE>int</TYPE>
	<NAME>npts</NAME>
	<VALUE>128</VALUE>
</PARAM>
<PARAM>
	<DEF>Points to skip before first plot</DEF>
	<TYPE>int</TYPE>
	<NAME>skip</NAME>
	<VALUE>0</VALUE>
</PARAM>
<PARAM>
	<DEF>Plot title</DEF>
	<TYPE>file</TYPE>
	<NAME>title</NAME>
	<VALUE>plot</VALUE>
</PARAM>
<PARAM>
	<DEF>X Axis label</DEF>
	<TYPE>file</TYPE>
	<NAME>x_axis</NAME>
	<VALUE>Samples</VALUE>
</PARAM>
<PARAM>
	<DEF>Y-Axis label</DEF>
	<TYPE>file</TYPE>
	<NAME>y_axis</NAME>
	<VALUE>Y</VALUE>
</PARAM>
<PARAM>
	<DEF>Plot Style: 1=Line,2=Points,5=Bar Chart</DEF>
	<TYPE>int</TYPE>
	<NAME>plotStyleParam</NAME>
	<VALUE>1</VALUE>
</PARAM>
<PARAM>
	<DEF>Control: 1=On, 0=Off</DEF>
	<TYPE>int</TYPE>
	<NAME>control</NAME>
	<VALUE>1</VALUE>
</PARAM>
<PARAM>
	<DEF>0=Static,1=Dynamic</DEF>
	<TYPE>int</TYPE>
	<NAME>mode</NAME>
	<VALUE>0</VALUE>
</PARAM>
<PARAM>
	<DEF>Sampling Rate</DEF>
	<TYPE>int</TYPE>
	<NAME>samplingRate</NAME>
	<VALUE>1</VALUE>
</PARAM>
</PARAMETERS>

<INIT_CODE>
<![CDATA[ 

/* 
 * store as state the number of input/output buffers 
 */
if((ibufs = NO_INPUT_BUFFERS()) <= 0) {
	fprintf(stderr,"plot: no inputs connected\n");
	return(2);
}
if((obufs = NO_OUTPUT_BUFFERS()) > ibufs) {
	fprintf(stderr,"plot: too many outputs connected\n");
	return(3);
}
if(ibufs > MAX_NUMBER_OF_PLOTS) {
	fprintf(stderr,"plot: too many plots requested.  \n");
	return(4);
}
if(control && mode == DYNAMIC) {
	/*
	 * allocate arrays
	 */
	xpts = (float* )calloc(npts,sizeof(float));
	if(xpts==NULL) {
		fprintf(stderr,"Could not allocate space in plot \n");
		return(5);
	}
	for(i=0; i<ibufs; i++) {
	    ypts[i] = (float* )calloc(npts,sizeof(float));
	    if(ypts[i]==NULL) {
		fprintf(stderr,"Could not allocate space in plot \n");
		return(6);
	    }
	}
} else if(control && mode == STATIC) {
	/*
	 * allocate arrays
	 */
	xpts = (float* )calloc(BLOCK_SIZE,sizeof(float));
	if(xpts==NULL) {
		fprintf(stderr,"Could not allocate space in plot \n");
		return(5);
	}
	for(i=0; i<ibufs; i++) {
	    ypts[i] = (float* )calloc(BLOCK_SIZE,sizeof(float));
	    if(ypts[i]==NULL) {
		fprintf(stderr,"Could not allocate space in plot \n");
		return(6);
	    }
	}
 }
/* 
 * set up the legend first 
 */
for(i=0; i<ibufs; i++) 
	legends[i] = SNAME(i);
legends[ibufs] = NULL;
count = 0;
totalCount = 0;
dt=1.0/samplingRate;

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


for(samples = MIN_AVAIL(); samples > 0; --samples) {

    


    for(i=0; i<ibufs; ++i) {
	   		IT_IN(i);
			if(obufs > i) {
				if(IT_OUT(i)) {
					KrnOverflow("plot",i);
					return(99);
				}
	 			OUTF(i,0) = INF(i,0);
			}
    }
    if(++totalCount > skip && control ) {
	if(mode == STATIC)
		count=blockOff + bufi;
	bufi++;

	if (bufi == BLOCK_SIZE && mode==STATIC) {
		blockOff += BLOCK_SIZE;
		xpts = (float *)realloc((char *) xpts,
			sizeof(float) * (blockOff + BLOCK_SIZE));
	        if(xpts==NULL) {
		         fprintf(stderr,"Could not allocate space in plot \n");
		         return(7);
	        }
		for(i=0; i<ibufs; i++) {
	    	     ypts[i] = (float* )realloc((char*)ypts[i],
				(blockOff+BLOCK_SIZE)*sizeof(float));
	             if(ypts[i]==NULL) {
		         fprintf(stderr,"Could not allocate space in plot \n");
		         return(8);
	             }
		}	
		bufi=0;

	}

	

	for(i=0; i<ibufs; ++i) 
       			ypts[i][count] = INF(i,0);


	xpts[count] = count*dt;
	if(mode == DYNAMIC) count++;
    }
}

return(0);


]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

if(control == 0) return(0);
if((totalCount - skip) > 0 ) {
   {
        	strcpy(fname,title);
       	 	strcat(fname,".tim");
        	time_F = fopen(fname,"w");
			for(k=0; k<ibufs; ++k) 
			   for(i=0; i<count; i++)
                	fprintf(time_F,"%e %e\n",xpts[i],ypts[k][i]);
		fclose(time_F);
		fprintf(stderr,"plot created file: %s \n",fname);
		free(xpts);
//		free(ypts);
	}
}

]]>
</WRAPUP_CODE> 



</BLOCK> 

