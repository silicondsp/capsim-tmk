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
<BLOCK_NAME>histtxt</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/* hist.s */
/**********************************************************************
                hist()
***********************************************************************
	inputs:		in, the signal of interest
	outputs:	none
	parameters:	float start, the start of the leftmost bin
			float stop, the end of the rightmost bin
			int numberOfBins
			file file_spec, the name of the output file
			int npts, how many points to wait before plotting
			number of samples to skip
			x axis label
			y axis label
			plot style ( line, bar chart)
			control to turn on and off
***********************************************************************
This program computes a histogram of the received data.  For a large no.
of data points this distribution should approach the probability dist. of
the signal . Any samples outside the range are put in the appropriate outer-
most bin.
-Parameter one is the starting point for the leftmost bin
-Parameter two is the ending point for the rightmost bin
-Parameter three is the number of bins (less than 2048)
-Parameter four is the filename for the output
-Parameter five is the number of points to obtain before plotting
Programmer: 	John T. Stonick
Date: 		January 1988
Modified:	March 29, 1988
Modified:	June 18, 1990 Sasan H. Ardalan
*/

]]>
</COMMENTS> 

<INCLUDES>
<![CDATA[ 


]]>
</INCLUDES> 

<DEFINES> 

#define IMAGE_BUFFER 1
#define FLOAT_BUFFER 0

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
		<NAME>bin</NAME>
	</STATE>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>plotbin</NAME>
	</STATE>
	<STATE>
		<TYPE>float*</TYPE>
		<NAME>xbin</NAME>
	</STATE>
	<STATE>
		<TYPE>float</TYPE>
		<NAME>binWidth</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>numberOfSamples</NAME>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>totalCount</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>total</NAME>
		<VALUE>0</VALUE>
	</STATE>
	<STATE>
		<TYPE>FILE*</TYPE>
		<NAME>histo_F</NAME>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	float x;
	int i;
	int ii;
	int j;
	int jj;
        int     widthImage;
        int     heightImage;
        image_t         img;
	char title[80];
	char	filename[100];
	FILE* file_F;

</DECLARATIONS> 

                           

<PARAMETERS>
<PARAM>
	<DEF>Starting point of left most bin</DEF>
	<TYPE>float</TYPE>
	<NAME>start</NAME>
	<VALUE>-5.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Ending point of right  most bin</DEF>
	<TYPE>float</TYPE>
	<NAME>stop</NAME>
	<VALUE>5.0</VALUE>
</PARAM>
<PARAM>
	<DEF>Number of bins</DEF>
	<TYPE>int</TYPE>
	<NAME>numberOfBins</NAME>
	<VALUE>100</VALUE>
</PARAM>
<PARAM>
	<DEF>File name for output</DEF>
	<TYPE>file</TYPE>
	<NAME>file_spec</NAME>
	<VALUE>none</VALUE>
</PARAM>
<PARAM>
	<DEF>Number of points to collect</DEF>
	<TYPE>int</TYPE>
	<NAME>npts</NAME>
	<VALUE>1000</VALUE>
</PARAM>
<PARAM>
	<DEF>Points to skip before first plot</DEF>
	<TYPE>int</TYPE>
	<NAME>skip</NAME>
	<VALUE>0</VALUE>
</PARAM>
<PARAM>
	<DEF>Title</DEF>
	<TYPE>file</TYPE>
	<NAME>graphTitle</NAME>
	<VALUE>Histogram</VALUE>
</PARAM>
<PARAM>
	<DEF>X axis label</DEF>
	<TYPE>file</TYPE>
	<NAME>x_axis</NAME>
	<VALUE>Bins </VALUE>
</PARAM>
<PARAM>
	<DEF>Y axis label</DEF>
	<TYPE>file</TYPE>
	<NAME>y_axis</NAME>
	<VALUE>Histogram</VALUE>
</PARAM>
<PARAM>
	<DEF>Plot Style: 1=Line,2=Points,5=Bar Chart</DEF>
	<TYPE>int</TYPE>
	<NAME>plotStyleParam</NAME>
	<VALUE>5</VALUE>
</PARAM>
<PARAM>
	<DEF>Control: 1=On, 0=Off</DEF>
	<TYPE>int</TYPE>
	<NAME>control</NAME>
	<VALUE>1</VALUE>
</PARAM>
<PARAM>
	<DEF>Buffer Type: 0= float, 1=image</DEF>
	<TYPE>int</TYPE>
	<NAME>bufferType</NAME>
	<VALUE>0</VALUE>
</PARAM>
</PARAMETERS>

<INIT_CODE>
<![CDATA[ 

/*
 * store as state the number of input/output buffers
 */
if((ibufs = NO_INPUT_BUFFERS()) <= 0) {
        fprintf(stderr,"hist: no inputs connected\n");
        return(2);
}
if((obufs = NO_OUTPUT_BUFFERS()) > ibufs) {
        fprintf(stderr,"hist: too many outputs connected\n");
        return(3);
}
binWidth=(stop-start)/((float)numberOfBins);
if(numberOfBins>512 || binWidth<0.)return(1);
if(control) {
	bin = (float *) malloc(numberOfBins * sizeof(float));  
	plotbin = (float *) malloc(numberOfBins * sizeof(float));  
	xbin = (float *) malloc(numberOfBins * sizeof(float));  
	if(bin == NULL || plotbin == NULL || xbin ==NULL) {
		fprintf(stderr,"hist could not allocate memory\n");
		return(4);
	}
}
for(i=0;i<numberOfBins;i++) {
	bin[i]=0.;
	xbin[i]= (float)i*binWidth + start + binWidth/2.;
}
numberOfSamples=0;
switch(bufferType) {
        case IMAGE_BUFFER:
                /*
                 * Image type
                 */
                for(i=0; i<ibufs; i++)
                        SET_CELL_SIZE_IN(i,sizeof(image_t));
                for(i=0; i<obufs; i++)
                        SET_CELL_SIZE_OUT(i,sizeof(image_t));
                break;
        case FLOAT_BUFFER:
                /*
                 * float
                 */
		break;
}

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 

for(ii=MIN_AVAIL();ii>0;--ii) {
	for(i=0; i<ibufs; ++i) {
                        IT_IN(i);
                        if(obufs > i) {
                                if(IT_OUT(i)) {
				    KrnOverflow("hist",i);
				    return(99);
				}
                                if(bufferType==IMAGE_BUFFER)
                                        OUTIMAGE(i,0) = INIMAGE(i,0);
                                else
                                        OUTF(i,0) = INF(i,0);
                        }
	}
	switch(bufferType) {
	  case IMAGE_BUFFER:
		img=INIMAGE(0,0);
                widthImage=img.width;
                heightImage=img.height;
		total = widthImage*heightImage;
                for(i=0; i<heightImage; i++)
                   for(jj=0; jj<widthImage; jj++) {
			x=img.image_PP[i][jj];
			x=(x-start)/binWidth;
		        j=(int)x;
                        if(j<0)
                            bin[0] = bin[0] +1.;
                        else if (j>=numberOfBins)
                           bin[numberOfBins-1] = bin[numberOfBins-1] + 1.;
                        else
			   bin[j] = bin[j] + 1.;
	
		   }	

	     break;
	  case FLOAT_BUFFER:
	     if(++totalCount > skip && control ) {
		if(total == npts) continue;
		x=INF(0,0);
		x=(x-start)/binWidth;
		j=(int)x;
		if(j<0)
			bin[0] = bin[0] +1.;
		else if (j>=numberOfBins)
			bin[numberOfBins-1] = bin[numberOfBins-1] + 1.;
		else
			bin[j] = bin[j] + 1.;
		total++;
	     }
	     break;
	}

}
return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

if((totalCount - skip) > 0  || bufferType==IMAGE_BUFFER ) {
if(total != npts && bufferType == FLOAT_BUFFER)
            total = totalCount -skip;
for(j=0;j<numberOfBins;j++)
	plotbin[j] = bin[j]/(float)(binWidth*total);
sprintf(title,"Histogram %s",SNAME(0));
{
     strcpy(filename,graphTitle);
     strcat(filename,".his");
     file_F = fopen(filename,"w");
     for(i=0; i<numberOfBins; i++)
          fprintf(file_F,"%e %e\n",xbin[i],plotbin[i]);
     fprintf(stderr,"hist created file: %s \n",filename);
     fclose(file_F);
}
if(strcmp(file_spec,"none")==0)return(0);
histo_F = fopen(file_spec,"w");
for(i=0;i<numberOfBins;i++)
	fprintf(histo_F,"%f  %f\n",start+binWidth/2.+(float)i*binWidth,
bin[i]/(float)total);
fclose(histo_F);
}

]]>
</WRAPUP_CODE> 



</BLOCK> 

