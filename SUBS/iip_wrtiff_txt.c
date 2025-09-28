


/*  Capsim (r) Text Mode Kernel (TMK) Star Library (Blocks)
    Copyright (C) 1989-2017   Silicon DSP  Corporation

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
*/



/*
 * iip_wrtiff.c
 * 
 */
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#include "dsp.h"
#include "tiffio.h"

#define false 0
#define true 1

#define MIN(x, y) (((x) < (y)) ? (x) : (y))
#define MAX(x, y) (((x) > (y)) ? (x) : (y))

#define SELECT_STANDARD_CMAP 0
#define SELECT_CUSTOM_CMAP 1

#define EXTRAFUDGE	128		/* some people write BAD .gif files */
#define GIFGAMMA        (1.5)           /* smaller makes output img brighter */
#define IMAX            ((1<<16)-1)     /* max intensity value */


#define TIFF_GAMMA      "2.2"     /* default gamma from the TIFF 5.0 spec */
#define ROUND(x)        (u_short) ((x) + 0.5)
#define SCALE(x, s)     (((x) * 65535L) / (s))
#define MCHECK(m)       if (!m) { fprintf(stderr, "malloc failed\n"); exit(0); }
#define VIEWPORT_WIDTH  700
#define VIEWPORT_HEIGHT 500
#define KEY_TRANSLATE   20



extern	int	plt_depth;
extern  int 	iip_colormapFlag;




#define COLSIZE 256

typedef struct {
    unsigned long pixel;
    unsigned short red, green, blue;
    char flags;                      /* DoRed, DoGreen, DoBlue */
    char pad;
} XColor;

static unsigned short red[COLSIZE];
static unsigned short green[COLSIZE];
static unsigned short blue[COLSIZE];




/*
 * Get color map RGB values
 */
static  int GetRGBColormap(char* colorMapFile)
{


int i, k;

int screen;

int depth;
int pixel;
int red1, green1, blue1;
FILE *fp;




fp= fopen(colorMapFile,"r");
if(!fp) {

     fprintf(stderr,"Could not open Color Mpa File: %s\n",colorMapFile);
     return(1);
}

for(i=0; i<256; i++) {

   fscanf(fp,"%d %d %d %d",&pixel,&red1,&green1,&blue1);
 //  iip_colors_A[i].pixel=pixel;
   red[i]   =red1 << 8;
   green[i] = green1 <<8;
   blue[i]  = blue1 <<8 ;

   printf("TIFFWrite: Colormap red=%d green=%d blue=%d index=%d\n", red[i], green[i], blue[i],i);


}


fclose(fp);


return(0);
}






int IIP_WriteMatrixFloatingPointTIFFText(float**		matrix_PP,unsigned int	width,unsigned int	height,char*	fileName, char* colorMapFile)
{
#if 111111 //XXXXXXX
int	i,j;

float	*buffer;



int row, col;
 unsigned char *rr;
TIFF *tif;


if(1)
	if(GetRGBColormap(colorMapFile)) return(1);


    tif = TIFFOpen(fileName, "w");
    if (!tif) {
	         TIFFError(fileName,"Can not open output image");
	         return(1);
    }

    printf("Writing Floating Point TIFF File:%s  Colormap: %s\n",fileName,colorMapFile);
     printf("Writing Floating Point TIFF Width=%d Height=%d\n",width,height);
#if 0000
    TIFFSetField(tif, TIFFTAG_IMAGEWIDTH, width);
    TIFFSetField(tif, TIFFTAG_IMAGELENGTH, height);
    TIFFSetField(tif, TIFFTAG_COMPRESSION, COMPRESSION_NONE);

    	TIFFSetField(tif, TIFFTAG_PHOTOMETRIC, PHOTOMETRIC_PALETTE);
    TIFFSetField(tif, TIFFTAG_PLANARCONFIG, PLANARCONFIG_CONTIG);
    TIFFSetField(tif, TIFFTAG_SAMPLESPERPIXEL, 1);
    TIFFSetField(tif, TIFFTAG_BITSPERSAMPLE, 32);  //Note 32 for Floating Point
    TIFFSetField(tif, TIFFTAG_SAMPLEFORMAT, SAMPLEFORMAT_IEEEFP);

	    TIFFSetField(tif, TIFFTAG_COLORMAP, red, green, blue);
    TIFFSetField(tif, TIFFTAG_ORIENTATION, ORIENTATION_TOPLEFT);
#endif

    TIFFSetField(tif, TIFFTAG_IMAGEWIDTH, width);
    TIFFSetField(tif, TIFFTAG_IMAGELENGTH, height);
    TIFFSetField(tif, TIFFTAG_COMPRESSION, COMPRESSION_NONE);
    TIFFSetField(tif, TIFFTAG_PHOTOMETRIC, PHOTOMETRIC_PALETTE);

    TIFFSetField(tif, TIFFTAG_PLANARCONFIG, PLANARCONFIG_CONTIG);

    TIFFSetField(tif, TIFFTAG_SAMPLESPERPIXEL, 1);

    TIFFSetField(tif, TIFFTAG_BITSPERSAMPLE, 32);
   TIFFSetField(tif, TIFFTAG_SAMPLEFORMAT, SAMPLEFORMAT_IEEEFP);
   TIFFSetField(tif, TIFFTAG_COLORMAP, red, green, blue);

    TIFFSetField(tif, TIFFTAG_ORIENTATION, ORIENTATION_TOPLEFT);







    buffer=(float*)calloc(width,sizeof(float));
    if(buffer == NULL) {
	      fprintf(stderr,"IIP Write Floating Point TIFF could not allocate space\n");
	       return(1);
    }
    for(row=0; row<height; row++) {
	for(j=0; j<width; j++)
		buffer[j]=matrix_PP[row][j];
	if (TIFFWriteScanline(tif, buffer, row, 0) < 0)
	    break;
    }
    TIFFClose(tif);
    free(buffer);

#endif

return(0);
}





int IIP_WriteMatrixTIFFText(float**	matrix_PP,unsigned int	width,unsigned int	height,char*	fileName, char* colorMapFile)
{
#if 111111 //XXXXXXX
int	i,j;

char	*buffer;

unsigned int	xOffset,yOffset;


int  row, col;
 unsigned char *rr;
TIFF *tif;





if(GetRGBColormap(colorMapFile)) return(1);



    tif = TIFFOpen(fileName, "w");
    if (!tif) {
	TIFFError(fileName,"Can not open output image");
	return(1);
    }
    TIFFSetField(tif, TIFFTAG_IMAGEWIDTH, width);
    TIFFSetField(tif, TIFFTAG_IMAGELENGTH, height);
    TIFFSetField(tif, TIFFTAG_COMPRESSION, COMPRESSION_NONE);
    TIFFSetField(tif, TIFFTAG_PHOTOMETRIC, PHOTOMETRIC_PALETTE);
    TIFFSetField(tif, TIFFTAG_PLANARCONFIG, PLANARCONFIG_CONTIG);
    TIFFSetField(tif, TIFFTAG_SAMPLESPERPIXEL, 1);
    TIFFSetField(tif, TIFFTAG_BITSPERSAMPLE, 8);
    TIFFSetField(tif, TIFFTAG_COLORMAP, red, green, blue);
    TIFFSetField(tif, TIFFTAG_ORIENTATION, ORIENTATION_TOPLEFT);

    buffer=(char*)calloc(width,sizeof(char));
    if(buffer == NULL) {
	fprintf(stderr,"IIP Write TIFF could not allocate space\n");
	return(1);
    }
    for(row=0; row<height; row++) {
	     for(j=0; j<width; j++)
		       buffer[j]=(unsigned char)matrix_PP[row][j];
	     if (TIFFWriteScanline(tif, buffer, row, 0) < 0)
	            break;
    }
    TIFFClose(tif);
    free(buffer);


#endif //XXXXXX

return(0);
}



