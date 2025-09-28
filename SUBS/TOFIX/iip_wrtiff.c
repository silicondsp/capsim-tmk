


/*
 * IIP
 * The Integrated Interactive Plotting Package
 *
 * Copyright (c) 1989-2000 XCAD Corporation, Raleigh, NC All rights reserved.
 *
 * www.xcad.com
 *
 * Author: Sasan H. Ardalan
 */




/*
 * iip_wrtiff.c
 * XCAD Corporation
 */
#include <math.h>
#include <stdio.h>
#include "iip.h"
#include "dsp.h"
#include "../TIFF/tiffio.h"

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


extern	Colormap            plt_cmap;
extern	int	plt_depth;
extern  int 	iip_colormapFlag;




#define COLSIZE 256


static unsigned short red[COLSIZE];
static unsigned short green[COLSIZE];
static unsigned short blue[COLSIZE];

static  XColor iip_colors_A[256];

XColor iip_colorMapEntries_A[256];
int iip_visualClass;




/*
 * Get color map RGB values
 */
static int GetRGBColormap()
{
register i, k;
Colormap	cmap;
int screen;
Visual *vis;
int depth;

screen = DefaultScreen(XtDisplay(toplevel));
depth = DefaultDepth(XtDisplay(toplevel),screen);
vis = DefaultVisual(XtDisplay(toplevel),screen);
cmap=DefaultColormap(XtDisplay(toplevel),screen);

if(iip_visualClass != TrueColor) {

   switch(iip_colormapFlag) {
      case IIP_COLOR_MAP_ACTIVE:
	if(plt_cmap == NULL) {
		IIPInfo("No color map available");
		return(1);
	}
	cmap=plt_cmap;
	break;
      case IIP_STANDARD_COLOR_MAP_ACTIVE:
	if(iip_stdColormap == NULL) {
		IIPInfo("No color map available");
		return(1);
	}
	cmap=iip_stdColormap;
	break;
   }

   for(i=0; i<256; i++)
	iip_colors_A[i].pixel=i;
   XQueryColors(XtDisplay(toplevel), cmap, iip_colors_A,256);

   for(i=0; i<256; i++) {
        red[i]   = iip_colors_A[i].red;
        green[i] = iip_colors_A[i].green;
        blue[i]  = iip_colors_A[i].blue;
   }

} else {

   for(i=0; i<256; i++) {
        red[i]   = iip_colorMapEntries_A[i].red;
        green[i] = iip_colorMapEntries_A[i].green;
        blue[i]  = iip_colorMapEntries_A[i].blue;
   }

}

return(0);
}


int IIP_WriteTIFF(window,width,height,xOffset,yOffset,fileName)
Window	window;
unsigned int	width,height;
unsigned int	xOffset,yOffset;
char*	fileName;
{

int	i,j;
XImage	*image_P;
char	*buffer;



register row, col;
register unsigned char *rr;
TIFF *tif;
#if 0
if(plt_depth != 8) {
	IIPInfo("Write TIFF: Must be 8 bit color, Sorry");
	return(1);
}
#endif
    
if(GetRGBColormap()) return(1);

image_P=XGetImage(XtDisplay(toplevel),window,xOffset,yOffset,width,height, 0xffff,ZPixmap);

if(image_P == NULL) {
	IIPInfo("TIFF Write could not get x image");
	return(1);
}


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
		buffer[j]=(char)XGetPixel(image_P,j,row);
	if (TIFFWriteScanline(tif, buffer, row, 0) < 0)
	    break;
    }
    TIFFClose(tif);
    free(buffer);



return(0);
}





int IIP_WriteFloatTIFF(matrix_PP,width,height,fileName)
float**		matrix_PP;
unsigned int	width,height;
char*	fileName;
{
int	i,j;
XImage	*image_P;
float	*buffer;



register row, col;
register unsigned char *rr;
TIFF *tif;
#if 0
if(plt_depth != 8) {
	IIPInfo("Write TIFF: Must be 8 bit color, Sorry");
	return(1);
}
#endif
    
if(plt_depth != 1)
	if(GetRGBColormap()) return(1);

#if 0
image_P=XGetImage(XtDisplay(toplevel),window,xOffset,yOffset,width,height, 0xffff,ZPixmap);

if(image_P == NULL) {
	IIPInfo("TIFF Write could not get x image");
	return(1);
}

#endif


    tif = TIFFOpen(fileName, "w");
    if (!tif) {
	TIFFError(fileName,"Can not open output image");
	return(1);
    }
    TIFFSetField(tif, TIFFTAG_IMAGEWIDTH, width);
    TIFFSetField(tif, TIFFTAG_IMAGELENGTH, height);
    TIFFSetField(tif, TIFFTAG_COMPRESSION, COMPRESSION_NONE);
    if(plt_depth !=1)
    	TIFFSetField(tif, TIFFTAG_PHOTOMETRIC, PHOTOMETRIC_PALETTE);
    TIFFSetField(tif, TIFFTAG_PLANARCONFIG, PLANARCONFIG_CONTIG);
    TIFFSetField(tif, TIFFTAG_SAMPLESPERPIXEL, 1);
    TIFFSetField(tif, TIFFTAG_BITSPERSAMPLE, 32);
    TIFFSetField(tif, TIFFTAG_SAMPLEFORMAT, SAMPLEFORMAT_IEEEFP);
    if(plt_depth !=1)
	    TIFFSetField(tif, TIFFTAG_COLORMAP, red, green, blue);
    TIFFSetField(tif, TIFFTAG_ORIENTATION, ORIENTATION_TOPLEFT);

    buffer=(float*)calloc(width,sizeof(float));
    if(buffer == NULL) {
	fprintf(stderr,"IIP Write TIFF could not allocate space\n");
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



return(0);
}





int IIP_WriteImageTIFF(curve_P,fileName)
iip_Curve_Pt	curve_P;
char*	fileName;
{

int	i,j;
XImage	*image_P;
char	*buffer;
Window	window;
unsigned int	width,height;
unsigned int	xOffset,yOffset;


register row, col;
register unsigned char *rr;
TIFF *tif;

#if 0
if(plt_depth != 8) {
	IIPInfo("Write TIFF: Must be 8 bit color, Sorry");
	return(1);
}
#endif

window=XtWindow(curve_P->widget);
width=curve_P->xPoints;
height=curve_P->yPoints;
xOffset=curve_P->yOffsetLeft;
yOffset=curve_P->xOffsetTop;
    
if(GetRGBColormap()) return(1);



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
		buffer[j]=(unsigned char)curve_P->image_PP[row][j];
	if (TIFFWriteScanline(tif, buffer, row, 0) < 0)
	    break;
    }
    TIFFClose(tif);
    free(buffer);



return(0);
}



int IIP_WriteMatrixTIFF(matrix_PP,width,height,fileName)
float**	matrix_PP;
unsigned int	width,height;
char*	fileName;
{

int	i,j;
XImage	*image_P;
char	*buffer;
Window	window;
unsigned int	xOffset,yOffset;


register row, col;
register unsigned char *rr;
TIFF *tif;



#if 0
if(plt_depth != 8) {
	IIPInfo("Write TIFF: Must be 8 bit color, Sorry");
	return(1);
}
#endif

    
if(GetRGBColormap()) return(1);



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



return(0);
}



