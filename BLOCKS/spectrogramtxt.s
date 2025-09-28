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
    Las Vegas, Nevada
*/
</LICENSE>
<BLOCK_NAME>
spectrogramtxt
</BLOCK_NAME> 

<DESC_SHORT>
This routine produces the spectrogram of the input buffer.
</DESC_SHORT>


<COMMENTS>
<![CDATA[ 

/* spectrogram.s */
/**********************************************************************
                                spectrogram()
***********************************************************************
        inputs:         (One channel)
        outputs:        (optional feed-through of input channels)
*************************************************************************
This routine produces the spectrogram 
of the input buffer.
Programmer: 	Sasan Ardalan
Date: 		Dec. 4, 1993	
*/
]]>
</COMMENTS> 

<INCLUDES>
<![CDATA[ 

#include "dsp.h"

]]>
</INCLUDES> 

<DEFINES> 

#define FLOAT_BUFFER 0
#define INTEGER_BUFFER 1
#define RECTANGULAR_WINDOW 0
#define HAMMING_WINDOW 1
 
#define BLOCK_SIZE 512

</DEFINES> 

<DECLARATIONS> 

       
	int samples;
	int numberPoints;
    	int i,j,ii;
	float tmp;
	complex val;
	int numberOfPoints;
	float wind;
	char title1[80];
	char fname[80];
        char curveSubTitle[80];
	float* mag_P;
	float* phase_P;
	FILE *time_F;
	FILE *freq_F;
	
	dsp_floatMatrix_Pt image_P;
	doubleVector_Pt vec_P;
	
	
	


</DECLARATIONS> 




<STATES>
	<STATE>
		<TYPE> int </TYPE>
		<NAME> numberInputBuffers </NAME>
	</STATE>
	<STATE>
		<TYPE> int </TYPE>
		<NAME> numberOutputBuffers </NAME>
	</STATE>
	<STATE>
		<TYPE> float* </TYPE>
		<NAME> xpts </NAME>
	</STATE>
	<STATE>
		<TYPE> float* </TYPE>
		<NAME> xTime_P </NAME>
	</STATE>
	<STATE>
		<TYPE> float* </TYPE>
		<NAME> ypts </NAME>
	</STATE>
	<STATE>
		<TYPE> float* </TYPE>
		<NAME> spect_P </NAME>
	</STATE>
	<STATE>
		<TYPE> int </TYPE>
		<NAME> count </NAME>
		<VALUE> 0 </VALUE>
	</STATE>
	<STATE>
		<TYPE> int </TYPE>
		<NAME> totalCount </NAME>
		<VALUE> 0 </VALUE>
	</STATE>
	<STATE>
		<TYPE> int </TYPE>
		<NAME> blockOff </NAME>
		<VALUE> 0 </VALUE>
	</STATE>
	<STATE>
		<TYPE> int </TYPE>
		<NAME> bufi </NAME>
		<VALUE> 0 </VALUE>
	</STATE>
	<STATE>
		<TYPE> float </TYPE>
		<NAME> dx </NAME>
	</STATE>
</STATES>



<PARAMETERS>
	<PARAM>
		<DEF> Number of points </DEF>
		<TYPE> int </TYPE>
		<NAME> npts </NAME>
		<VALUE> 128  </VALUE>
	</PARAM>
	<PARAM>
		<DEF> Number of points to skip </DEF>
		<TYPE> int </TYPE>
		<NAME> skip </NAME>
		<VALUE> 0  </VALUE>
	</PARAM>
	<PARAM>
		<DEF> Window size (samples) </DEF>
		<TYPE> int </TYPE>
		<NAME> windowLength </NAME>
		<VALUE> 128  </VALUE>
	</PARAM>
	<PARAM>
		<DEF> Overlap (samples) </DEF>
		<TYPE> int </TYPE>
		<NAME> overlap </NAME>
		<VALUE> 0  </VALUE>
	</PARAM>
	<PARAM>
		<DEF> Zero padding (samples) </DEF>
		<TYPE> int </TYPE>
		<NAME> zeropad </NAME>
		<VALUE> 0  </VALUE>
	</PARAM>
	<PARAM>
		<DEF> Threshold (DB) </DEF>
		<TYPE> float </TYPE>
		<NAME> threshold </NAME>
		<VALUE> 40 </VALUE>
	</PARAM>
	<PARAM>
		<DEF> Sampling Rate (KHz) </DEF>
		<TYPE> float </TYPE>
		<NAME> samplingRate </NAME>
		<VALUE> 8 </VALUE>
	</PARAM>
	<PARAM>
		<DEF> Window:0= Rec.,1=Hamming </DEF>
		<TYPE> int </TYPE>
		<NAME> windowType </NAME>
		<VALUE> 1 </VALUE>
	</PARAM>
	<PARAM>
		<DEF> Linear = 0, dB = 1 </DEF>
		<TYPE> int </TYPE>
		<NAME> dBFlag </NAME>
		<VALUE> 1 </VALUE>
	</PARAM>
	<PARAM>
		<DEF> Surface Plot: 1=True 0=False </DEF>
		<TYPE> int </TYPE>
		<NAME> surfaceFlag </NAME>
		<VALUE> 0 </VALUE>
	</PARAM>
	<PARAM>
		<DEF> Image: 1=True 0=False </DEF>
		<TYPE> int </TYPE>
		<NAME> imageFlag </NAME>
		<VALUE> 1 </VALUE>
	</PARAM>
	<PARAM>
		<DEF> Plot title </DEF>
		<TYPE> file </TYPE>
		<NAME> spectTitle </NAME>
		<VALUE> Spectrogram </VALUE>
	</PARAM>
	<PARAM>
		<DEF> Color Map File </DEF>
		<TYPE> file </TYPE>
		<NAME> colorMapFile </NAME>
		<VALUE> ther.map </VALUE>
	</PARAM>	

	<PARAM>
		<DEF> File Flag: 1=True 0=False </DEF>
		<TYPE> int </TYPE>
		<NAME> fileFlag </NAME>
		<VALUE> 1 </VALUE>
	</PARAM>
	<PARAM>
		<DEF> Time Domain On/Off (1/0) </DEF>
		<TYPE> int </TYPE>
		<NAME> timeFlag </NAME>
		<VALUE> 1 </VALUE>
	</PARAM>
	<PARAM>
		<DEF> Control: 1=On, 0=Off </DEF>
		<TYPE> int </TYPE>
		<NAME> control </NAME>
		<VALUE> 1 </VALUE>
	</PARAM>
	<PARAM>
		<DEF> Buffer type:0= Float,1=Integer </DEF>
		<TYPE> int </TYPE>
		<NAME> bufferType </NAME>
		<VALUE> 0 </VALUE>
	</PARAM>
</PARAMETERS>

<INIT_CODE>
<![CDATA[ 

/* store as state the number of input/output buffers */
if((numberInputBuffers = NO_INPUT_BUFFERS()) <= 0) {
	fprintf(stderr,"spectrogramtxt: no inputs connected\n");
	return(1);
}
if(numberInputBuffers > 1) {
	fprintf(stderr,"spectrogramtxt: only one  input allowed \n");
	return(2);
}
if((numberOutputBuffers = NO_OUTPUT_BUFFERS()) > numberInputBuffers) {
	fprintf(stderr,"spectrogramtxt: too many outputs connected\n");
	return(3);
}
if(samplingRate)
	dx=1.0/samplingRate;
else
	dx=1.0;
if (control) {
	/*                                                      
	 * allocate arrays                                      
	 */                                                     
	xpts = (float* )calloc(BLOCK_SIZE,sizeof(float));           
	ypts = (float* )calloc(BLOCK_SIZE,sizeof(float));           
	if(xpts==NULL  || ypts ==NULL) {
		fprintf(stderr,"Spectrogramtxt could not allocate space\n");
		return(4);
	}
}
count = 0;
totalCount = 0;
switch(bufferType) {
	case FLOAT_BUFFER: 
		SET_CELL_SIZE_IN(0,sizeof(float));
		if(numberOutputBuffers == 1)
			SET_CELL_SIZE_OUT(0,sizeof(float));
		break;
	case INTEGER_BUFFER: 
		SET_CELL_SIZE_IN(0,sizeof(int));
		if(numberOutputBuffers == 1)
			SET_CELL_SIZE_OUT(0,sizeof(int));
		break;
	default: 
		fprintf(stderr,"Bad buffer type specified in spectrogramtxt \n");
		return(5);
		break;
}

]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


for(samples = MIN_AVAIL(); samples > 0; --samples) {

  for(i=0; i<numberInputBuffers; ++i) {
   		IT_IN(i);
		if(numberOutputBuffers > i) {
			if(IT_OUT(i)) {
				KrnOverflow("spectrogram",i);
				return(99);
			}

			switch(bufferType) {
				case INTEGER_BUFFER:
	 				OUTI(i,0) = INI(i,0);
					break;
				case FLOAT_BUFFER:
	 				OUTF(i,0) = INF(i,0);
					break;
			}

		}
  }
  if(++totalCount > skip && control ) {
		count=blockOff + bufi;
		bufi++;
		if (bufi == BLOCK_SIZE) {
			blockOff += BLOCK_SIZE;
			xpts = (float *)realloc((char *) xpts, 
				sizeof(float) * (blockOff + BLOCK_SIZE));
			ypts = (float *)realloc((char *) ypts, 
				sizeof(float) * (blockOff + BLOCK_SIZE));
			bufi=0;
		}
		if(xpts == NULL || ypts==NULL) {
			fprintf(stderr,"spectrogram: could not allocate space\n");
			return(6);
		}

		switch(bufferType) {
			case INTEGER_BUFFER:
          	     		ypts[count] = INI(0,0);
				break;
			case FLOAT_BUFFER:
          	     		ypts[count] = INF(0,0);
				break;
		}
		xpts[count]=count*dx;

		
  }

} 

return(0);


]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 

if(control == 0) return(0);
if((totalCount - skip) > 0 ) {
//printf("Spectrogram  0000\n");
   /*
    * callup the plot routine 
    */
   
	/*
	 * if in graphic mode callup iip
	 */
	 xpts = (float *) realloc((char *) xpts, sizeof(float) *
				 (blockOff + bufi));
	 ypts = (float *) realloc((char *) ypts, sizeof(float) *
				 (blockOff + bufi));
	if(xpts == NULL || ypts==NULL) {
		fprintf(stderr,"spectrogram: could not allocate space\n");
		return(6);
	}
	
//	sprintf(title1,"%s_%s.img",spectTitle,SNAME(0));
   sprintf(title1,"%s.img",spectTitle );
	numberOfPoints=(blockOff + bufi);
	
	printf("Spectrogram Title=%s Number of Points=%d \n",title1,numberOfPoints);
	
	
	 
	vec_P= Dsp_AllocateVector( numberOfPoints);
	for(i=0; i< numberOfPoints; i++) {
	       vec_P->vector_P[i]=ypts[i];
	}
//	printf("Spectrogram  222\n");
				
	image_P=Dsp_Spectrogram(vec_P,windowLength,overlap,zeropad,samplingRate,
	         windowType,threshold,surfaceFlag,imageFlag,dBFlag,fileFlag,title1);
	         
//	 printf("Spectrogram  3333\n");        			
	sprintf(title1,"%s.tif",spectTitle );
	
//	printf("Spectrogram  44444\n");
				
	fprintf(stderr,"spectrogramtxt to produce %d x  %d TIFF image file\n",image_P->width,image_P->height);
	
	printf("Spectrogram  Creating TIFF File:%s\n",title1);
	
	if(IIP_WriteMatrixTIFFText(image_P->matrix_PP,image_P->width,image_P->height,title1,colorMapFile)) {
                fprintf(stderr,"spectrogramtxt: can't write TIFF image\n");
                return(4);
    }			
    printf("Spectrogram  Done Writing TIFF File\n");
				
	
    
}

]]>
</WRAPUP_CODE> 



</BLOCK> 

