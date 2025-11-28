/*
 * iip_rdtiff.c
 * XCAD Corporation
 * The code in iip_rdtiff.c has been adopted  from xtiff.c
 * Sasan Ardalan: " xtiff has been hacked to support text mode. So it can be used in CapsimTMK or
 * in Capsim where we take care of graphics with imgdisp.s block.
 * Colormap extracted and stored in a file.
 * Image returned as a Matrix.
 * Therefore can be used in Capsim Buffer Connections and shipped around for processing.
 *
 *
 *
 * The original Copyright notice for xtiff appears below.
 *
 *
 *
 * xtiff - view a TIFF file in an X window
 *
 * Dan Sears
 * Chris Sears
 *
 * Copyright 1991 by Digital Equipment Corporation, Maynard, Massachusetts.
 *
 *                      All Rights Reserved
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose and without fee is hereby granted,
 * provided that the above copyright notice appear in all copies and that
 * both that copyright notice and this permission notice appear in
 * supporting documentation, and that the name of Digital not be
 * used in advertising or publicity pertaining to distribution of the
 * software without specific, written prior permission.
 *
 * DIGITAL DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING
 * ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO EVENT SHALL
 * DIGITAL BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR
 * ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
 * WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,
 * ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS
 * SOFTWARE.
 *
 * Revision 1.0  90/05/07
 *      Initial release.
 * Revision 2.0  90/12/20
 *      Converted to use the Athena Widgets and the Xt Intrinsics.
 *
 * Notes:
 *
 * According to the TIFF 5.0 Specification, it is possible to have
 * both a TIFFTAG_COLORMAP and a TIFFTAG_COLORRESPONSECURVE.  This
 * doesn't make sense since a TIFFTAG_COLORMAP is 16 bits wide and
 * a TIFFTAG_COLORRESPONSECURVE is tfBitsPerSample bits wide for each
 * channel.  This is probably a bug in the specification.
 * In this case, TIFFTAG_COLORRESPONSECURVE is ignored.
 * This might make sense if TIFFTAG_COLORMAP was 8 bits wide.
 *
 * TIFFTAG_COLORMAP is often incorrectly written as ranging from
 * 0 to 255 rather than from 0 to 65535.  CheckAndCorrectColormap()
 * takes care of this.
 *
 * Only ORIENTATION_TOPLEFT is supported correctly.  This is the
 * default TIFF and X orientation.  Other orientations will be
 * displayed incorrectly.
 *
 * There is no support for or use of 3/3/2 DirectColor visuals.
 * TIFFTAG_MINSAMPLEVALUE and TIFFTAG_MAXSAMPLEVALUE are not supported.
 *
 * Only TIFFTAG_BITSPERSAMPLE values that are 1, 2, 4 or 8 are supported.
 */
#include <math.h>
#include <stdio.h>
#include <stdlib.h>


#include "dsp.h"
#include "tiffio.h"

#define false 0
#define true 1




#define TIFF_GAMMA      "2.2"     /* default gamma from the TIFF 5.0 spec */
#define ROUND(x)        (u_short) ((x) + 0.5)
#define SCALE(x, s)     (((x) * 65535L) / (s))
#define MCHECK(m)       if (!m) { fprintf(stderr, "malloc failed\n"); exit(0); }
#define MIN(a, b)       (((a) < (b)) ? (a) : (b))
#define MAX(a, b)       (((a) > (b)) ? (a) : (b))
#define VIEWPORT_WIDTH  700
#define VIEWPORT_HEIGHT 500
#define KEY_TRANSLATE   20

#ifdef __STDC__
#define PP(args)    args
#else
#define PP(args)    ()
#endif



static int GetVisual();
static int OpenTIFFFile(char * fileName);
static int GetTIFFHeader(char * fileName);
static int SimpleGammaCorrection();
static int CheckAndCorrectColormap();
//xxxxx static int SearchVisualList(int image_depth, int visual_class, Visual **visual);
static int GetTIFFImage();

//xxxxxx static XtCallbackProc SelectProc PP((Widget w, caddr_t unused_1, caddr_t unused_2));
static void QuitProc PP((void));
static void NextProc PP((void));
static void PreviousProc PP((void));
static void PageProc PP((int direction));
//xxxxx static void EventProc PP((Widget widget, caddr_t unused, XEvent *event));
//xxxxx static void ResizeProc PP((void));
//xxxxx static int XTiffErrorHandler PP((Display *display, XErrorEvent *error_event));

static int PrintTIFF();


typedef short Boolean;
typedef unsigned char  u_char;
typedef unsigned long  u_long;
typedef unsigned short  u_short;
#define False false;
#define True true;

typedef struct {
    Boolean help;
    float gamma;
    Boolean usePixmap;
    int viewportWidth;
    int viewportHeight;
    int translate;
    Boolean verbose;
} AppData, *AppDataPtr;

static AppData appData;


typedef struct {
    unsigned long pixel;
    unsigned short red, green, blue;
    char flags;                      /* DoRed, DoGreen, DoBlue */
    char pad;
} XColor;




//xxxxx extern int iip_visualClass;



static int                 xImageDepth, xScreen, xRedMask, xGreenMask, xBlueMask,
                    xOffset = 0, yOffset = 0, grabX = -1, grabY = -1;
static u_char              basePixel = 0;

/*
 * TIFF data structures
 */
static TIFF *              tfFile = NULL;
static u_long              tfImageWidth, tfImageHeight;
static u_short             tfBitsPerSample, tfSamplesPerPixel, tfPlanarConfiguration,
                    tfPhotometricInterpretation, tfGrayResponseUnit,
                    tfImageDepth, tfBytesPerRow;
static int                 tfDirectory = 0, tfMultiPage = False;
static double              tfUnitMap, tfGrayResponseUnitMap[] = {
                        -1, -10, -100, -1000, -10000, -100000
                    };

static u_short             tfSampleFormat;
/*
 * display data structures
 */
static double              *dRed, *dGreen, *dBlue;

/*
 * shared data structures
 */
static u_short *           redMap = NULL, *greenMap = NULL, *blueMap = NULL,
                    *grayMap = NULL, colormapSize;
static u_char *            imageMemory;
//static char *              fileName;


static int	setColormap;


dsp_floatMatrix_Pt      IIP_ReadTIFFText(char *tiffFile) {
int	i,j;
    dsp_floatMatrix_Pt	image_P;

    setbuf(stdout, NULL); setbuf(stderr, NULL);

//XXXX    fileName=tiffFile;

fprintf(stderr,"IIP_ReadTIFF Filename %s\n",tiffFile);




    if(OpenTIFFFile(tiffFile)) return(NULL);
    if(PrintTIFF()) return(NULL);
    if(GetTIFFHeader(tiffFile)) return(NULL);
    if(SimpleGammaCorrection()) return(NULL);
    if(GetVisual()) return(NULL);
    if(GetTIFFImage()) return(NULL);

 fprintf(stderr,"IIP_ReadTIFF tfImageHeight=%d tfImageWidth=%d  \n",tfImageHeight,tfImageWidth);
    image_P=Dsp_AllocateMatrix(tfImageWidth,tfImageHeight);
	if(image_P == NULL) {
		fprintf(stderr,"TIFF Could not allocate space for image plot");
		return(NULL);
	}
	for(i=0; i< tfImageHeight; i++)
	   for(j=0; j<tfImageWidth; j++) {



		image_P->matrix_PP[i][j]=
		   (float)imageMemory[i*tfBytesPerRow+j];


	   }



}




static int OpenTIFFFile(char *fileName)
{
//BIG BUG FIXED 1/15/2007     if (tfFile != NULL)
//BIG BUG FIXED 1/15/2007         TIFFClose(tfFile);

    if ((tfFile = TIFFOpen(fileName, "r")) == NULL) {
	fprintf(stdout,
	    "xtiff: can't open %s as a TIFF file\n", fileName);
        return(1);
    }

    if (TIFFReadDirectory(tfFile) == true) {
        tfMultiPage = True;
       (void) TIFFSetDirectory(tfFile, tfDirectory = 0);
    } else
        tfMultiPage = False;
    return(0);
}

static int PrintTIFF()
{

TIFFPrintDirectory(tfFile, stdout, (int)NULL);

return(0);
}

static int GetTIFFHeader(char * fileName)
{
    register int i;

    if (!TIFFSetDirectory(tfFile, tfDirectory)) {
        fprintf(stderr, "xtiff: can't seek to directory %d in %s\n",
            tfDirectory, fileName);
        return(1);
    }

    TIFFGetField(tfFile, TIFFTAG_IMAGEWIDTH, &tfImageWidth);
    TIFFGetField(tfFile, TIFFTAG_IMAGELENGTH, &tfImageHeight);

    printf("GetTIFFHeader  width and height: %d   %d \n",tfImageWidth,tfImageHeight);


    /*
     * If the following tags aren't present then use the TIFF defaults.
     */
    TIFFGetFieldDefaulted(tfFile, TIFFTAG_BITSPERSAMPLE, &tfBitsPerSample);

    printf("GetTIFFHeader  tfBitsPerSample: %d   \n",tfBitsPerSample);

    TIFFGetFieldDefaulted(tfFile, TIFFTAG_SAMPLESPERPIXEL, &tfSamplesPerPixel);
     printf("GetTIFFHeader  tfSamplesPerPixel: %d   \n",tfSamplesPerPixel);
    TIFFGetFieldDefaulted(tfFile, TIFFTAG_PLANARCONFIG, &tfPlanarConfiguration);
    TIFFGetFieldDefaulted(tfFile, TIFFTAG_GRAYRESPONSEUNIT, &tfGrayResponseUnit);
    TIFFGetField(tfFile, TIFFTAG_SAMPLEFORMAT, &tfSampleFormat);
    printf("GetTIFFHeader  tfSampleFormat: %d   \n",tfSampleFormat);

    if(tfSampleFormat == SAMPLEFORMAT_IEEEFP &&
		tfBitsPerSample == 32) {
		fprintf(stderr,"TIFF File is floating point! Open as floating point");
		//return(1);
    }

    tfUnitMap = tfGrayResponseUnitMap[tfGrayResponseUnit];
    colormapSize = 1 << tfBitsPerSample;
    tfImageDepth = tfBitsPerSample * tfSamplesPerPixel;

    dRed = (double *) malloc(colormapSize * sizeof(double));
    dGreen = (double *) malloc(colormapSize * sizeof(double));
    dBlue = (double *) malloc(colormapSize * sizeof(double));
    MCHECK(dRed); MCHECK(dGreen); MCHECK(dBlue);

    /*
     * If TIFFTAG_PHOTOMETRIC is not present then assign a reasonable default.
     * The TIFF 5.0 specification doesn't give a default.
     */
    if (!TIFFGetField(tfFile, TIFFTAG_PHOTOMETRIC,
            &tfPhotometricInterpretation)) {
        if (tfSamplesPerPixel != 1)
            tfPhotometricInterpretation = PHOTOMETRIC_RGB;
        else if (tfBitsPerSample == 1)
            tfPhotometricInterpretation = PHOTOMETRIC_MINISBLACK;
        else if (TIFFGetField(tfFile, TIFFTAG_COLORMAP,
                &redMap, &greenMap, &blueMap)) {
            tfPhotometricInterpretation = PHOTOMETRIC_PALETTE;
            redMap = greenMap = blueMap = NULL;
        } else
            tfPhotometricInterpretation = PHOTOMETRIC_MINISBLACK;
    }

    /*
     * Given TIFFTAG_PHOTOMETRIC extract or create the response curves.
     */
    switch (tfPhotometricInterpretation) {
    case PHOTOMETRIC_RGB:
#ifdef SHA
        if (!TIFFGetField(tfFile, TIFFTAG_COLORRESPONSECURVE,
#endif
        if (!TIFFGetField(tfFile, TIFFTAG_COLORRESPONSEUNIT,
                &redMap, &greenMap, &blueMap)) {
            redMap = (u_short *) malloc(colormapSize * sizeof(u_short));
            greenMap = (u_short *) malloc(colormapSize * sizeof(u_short));
            blueMap = (u_short *) malloc(colormapSize * sizeof(u_short));
            MCHECK(redMap); MCHECK(greenMap); MCHECK(blueMap);
            for (i = 0; i < colormapSize; i++)
                dRed[i] = dGreen[i] = dBlue[i]
                    = (double) SCALE(i, colormapSize - 1);
        } else {
            CheckAndCorrectColormap();
            for (i = 0; i < colormapSize; i++) {
                dRed[i] = (double) redMap[i];
                dGreen[i] = (double) greenMap[i];
                dBlue[i] = (double) blueMap[i];
            }
        }
        break;
    case PHOTOMETRIC_PALETTE:
        if (!TIFFGetField(tfFile, TIFFTAG_COLORMAP,
                &redMap, &greenMap, &blueMap)) {
            redMap = (u_short *) malloc(colormapSize * sizeof(u_short));
            greenMap = (u_short *) malloc(colormapSize * sizeof(u_short));
            blueMap = (u_short *) malloc(colormapSize * sizeof(u_short));
            MCHECK(redMap); MCHECK(greenMap); MCHECK(blueMap);
            for (i = 0; i < colormapSize; i++)
                dRed[i] = dGreen[i] = dBlue[i]
                    = (double) SCALE(i, colormapSize - 1);
        } else {
            CheckAndCorrectColormap();
            for (i = 0; i < colormapSize; i++) {
                dRed[i] = (double) redMap[i];
                dGreen[i] = (double) greenMap[i];
                dBlue[i] = (double) blueMap[i];
            }
        }
        break;
    case PHOTOMETRIC_MINISWHITE:
        redMap = (u_short *) malloc(colormapSize * sizeof(u_short));
        greenMap = (u_short *) malloc(colormapSize * sizeof(u_short));
        blueMap = (u_short *) malloc(colormapSize * sizeof(u_short));
        MCHECK(redMap); MCHECK(greenMap); MCHECK(blueMap);
        if (!TIFFGetField(tfFile, TIFFTAG_GRAYRESPONSECURVE, &grayMap))
            for (i = 0; i < colormapSize; i++)
                dRed[i] = dGreen[i] = dBlue[i]
                    = (double) SCALE(colormapSize - 1 - i, colormapSize - 1);
        else {
            dRed[colormapSize - 1] = dGreen[colormapSize - 1]
                = dBlue[colormapSize - 1] = 0;
            for (i = 0; i < colormapSize - 1; i++)
                dRed[i] = dGreen[i] = dBlue[i] = 65535.0 -
                    (65535.0 * pow(10.0, (double) grayMap[i] / tfUnitMap));
        }
        break;
    case PHOTOMETRIC_MINISBLACK:
        redMap = (u_short *) malloc(colormapSize * sizeof(u_short));
        greenMap = (u_short *) malloc(colormapSize * sizeof(u_short));
        blueMap = (u_short *) malloc(colormapSize * sizeof(u_short));
        MCHECK(redMap); MCHECK(greenMap); MCHECK(blueMap);
        if (!TIFFGetField(tfFile, TIFFTAG_GRAYRESPONSECURVE, &grayMap))
            for (i = 0; i < colormapSize; i++) {
                dRed[i] = dGreen[i] = dBlue[i]
                    = (double) SCALE(i, colormapSize - 1);
            }
        else {
            dRed[0] = dGreen[0] = dBlue[0] = 0;
            for (i = 1; i < colormapSize; i++)
                dRed[i] = dGreen[i] = dBlue[i] =
                    (65535.0 * pow(10.0, (double) grayMap[i] / tfUnitMap));
        }
        break;
    default:
        fprintf(stderr,
            "xtiff: can't display photometric interpretation type %d\n",
            tfPhotometricInterpretation);
        return(1);
    }
return(0);
}

static int
SetNameLabel()
{
    char buffer[BUFSIZ];
#if 00000 //XXXXXXXX
    Arg args[1];

    if (tfMultiPage)
        sprintf(buffer, "%s - page %d", fileName, tfDirectory);
    else
        strcpy(buffer, fileName);
#if 00000
    XtSetArg(args[0], XtNlabel, buffer);
    XtSetValues(labelWidget, args, 1);
#endif
#endif


    return(0);
}

/*
 * Many programs get TIFF colormaps wrong.  They use 8-bit colormaps instead of
 * 16-bit colormaps.  This function is a heuristic to detect and correct this.
 */
static int CheckAndCorrectColormap()
{
    register int i;

    for (i = 0; i < colormapSize; i++)
        if ((redMap[i] > 255) || (greenMap[i] > 255) || (blueMap[i] > 255))
            return(0);

    for (i = 0; i < colormapSize; i++) {
        redMap[i] = SCALE(redMap[i], 255);
        greenMap[i] = SCALE(greenMap[i], 255);
        blueMap[i] = SCALE(blueMap[i], 255);
    }
    TIFFWarning("zzz.txt", "Assuming 8-bit colormap");
    return(0);
}

static int SimpleGammaCorrection()
{
    register int i;
    register double i_gamma = 1.0 / 1.0;

    for (i = 0; i < colormapSize; i++) {
        if (((tfPhotometricInterpretation == PHOTOMETRIC_MINISWHITE)
            && (i == colormapSize - 1))
            || ((tfPhotometricInterpretation == PHOTOMETRIC_MINISBLACK)
            && (i == 0)))
            redMap[i] = greenMap[i] = blueMap[i] = 0;
        else {
            redMap[i] = ROUND((pow(dRed[i] / 65535.0, i_gamma) * 65535.0));
            greenMap[i] = ROUND((pow(dGreen[i] / 65535.0, i_gamma) * 65535.0));
            blueMap[i] = ROUND((pow(dBlue[i] / 65535.0, i_gamma) * 65535.0));
        }
    }

    free(dRed); free(dGreen); free(dBlue);
    return(0);
}

static char* classNames[] = {
    "StaticGray",
    "GrayScale",
    "StaticColor",
    "PseudoColor",
    "TrueColor",
    "DirectColor"
};


int IIPStoreColorMap(char* fileName,   XColor *colors )
{

u_long pixel;
unsigned short red;
unsigned short green;
unsigned short blue;
char flags;
int i;

FILE *fp;

fp=fopen(fileName,"w");
if(!fp) return(0);
//fprintf(fp,"%d %d\n",colormapSize,tfImageDepth);

    for (i = 0; i < colormapSize; i++) {
            pixel= colors[i].pixel;
            red=colors[i].red  ;
            green=colors[i].green  ;
            blue=colors[i].blue  ;
            flags=colors[i].flags ;

            red  >>= 8;
            blue  >>= 8;
            green  >>= 8;


            fprintf(fp,"%ld\t%d\t%d\t%d\n",pixel,red,green,blue);

        }
        fclose(fp);
        return(1);

}


/*
 * Current limitation: the visual is set initially by the first file.
 * It cannot be changed.
 */
static int GetVisual()
{
#if 111111 //XXXXX
      XColor *colors = NULL;
    register u_long *pixels = NULL;
    register int i;

    int screen;

    int depth;

    xImageDepth=24;



 printf(" GetVisual tfImageDepth=%d setting to  32\n",tfImageDepth);

 tfImageDepth=24;

    switch (tfImageDepth) {
    /*
     * X really wants a 32-bit image with the fourth channel unused,
     * but the visual structure thinks it's 24-bit.  bitmap_unit is 32.
     */
    case 32:
    case 24:

        colors = (XColor *) malloc(3 * colormapSize * sizeof(XColor));
        MCHECK(colors);

        for (i = 0; i < colormapSize; i++) {
            colors[i].pixel = (u_long) (i << 16) + (i << 8) + i;
            colors[i].red = redMap[i];
            colors[i].green = greenMap[i];
            colors[i].blue = blueMap[i];
  //XXXX           colors[i].flags = DoRed | DoGreen | DoBlue;
             colors[i].flags = 0x0f;
        }
        printf(" GetVisual 32/24 Storing colormap in: tiff.cmap\n",tfImageDepth);
        IIPStoreColorMap("tiff.cmap",colors);




        break;
    case 8:
    case 4:
    case 2:
        /*
         * We assume that systems with 24-bit visuals also have 8-bit visuals.
         * We don't promote from 8-bit PseudoColor to 24/32 bit DirectColor.
         */
        switch (tfPhotometricInterpretation) {
        case PHOTOMETRIC_MINISWHITE:
        case PHOTOMETRIC_MINISBLACK:
#ifdef SHA
            if (SearchVisualList((int) tfImageDepth, GrayScale, &xVisual) == True)
                break;
#endif
        case PHOTOMETRIC_PALETTE:
 #if 00000 //XXXXXXX
            if (SearchVisualList((int) tfImageDepth, PseudoColor, &xVisual) == True)
                break;
            else {
                 /*
                  * looks like we dont support PseudoColor
                  * maybe we are TrueColor. In this case, unlike the
                  * original code we will still process the image within
                  * IIP's frame work.
                  */
  //XXXXX               iip_visualClass=vis->class;
#endif

                 break;



           }
        default:
            fprintf(stderr, "xtiff: Unsupported TIFF/X configuration\n");
            return(1);
        }

        colors = (XColor *) malloc(colormapSize * sizeof(XColor));
        MCHECK(colors);

        for (i = 0; i < colormapSize; i++) {
            colors[i].pixel = (u_long) i;
            colors[i].red = redMap[i];
            colors[i].green = greenMap[i];
            colors[i].blue = blueMap[i];
   //XXXX         colors[i].flags = DoRed | DoGreen | DoBlue;
             colors[i].flags = 0x0f;

 //XXXX           if(iip_visualClass == TrueColor) {
//XXXXX                XAllocColor(XtDisplay(toplevel),cmap,&colors[i]);
//XXXX                iip_colorMapEntries_A[i]=colors[i];
//XXXX            }


        }
         IIPStoreColorMap("tiff.cmap",colors);


#endif //XXXXXX

    if (colors != NULL)
        free(colors);
    if (grayMap != NULL)
        free(grayMap);
    if (redMap != NULL)
        free(redMap);
    if (greenMap != NULL)
        free(greenMap);
    if (blueMap != NULL)
        free(blueMap);

    colors = NULL; grayMap = redMap = greenMap = blueMap = NULL;


    return(0);
}



static int GetTIFFImage()
{
    int pixel_map[3], red_shift, green_shift, blue_shift;
    register u_char *scan_line, *output_p, *input_p;
    register int i, j, s;
#if 11111 //XXXXXXXX
    scan_line = (u_char *) malloc((tfBytesPerRow = TIFFScanlineSize(tfFile)));
    MCHECK(scan_line);

//    if ((tfImageDepth == 32) || (tfImageDepth == 24)) {
if (0) {
        output_p = imageMemory = (u_char *)
            malloc(tfImageWidth * tfImageHeight * 4);
        MCHECK(imageMemory);
        printf("11111 GetTIFFImage \n");

        /*
         * Handle different color masks for different frame buffers.
         */
 //XXXXX       if (ImageByteOrder(xDisplay) == LSBFirst) { /* DECstation 5000 */
          if (0) { /* DECstation 5000 */
            red_shift = pixel_map[0] = xRedMask == 0xFF000000 ? 3
                : (xRedMask == 0xFF0000 ? 2 : (xRedMask == 0xFF00 ? 1 : 0));
            green_shift = pixel_map[1] = xGreenMask == 0xFF000000 ? 3
                : (xGreenMask == 0xFF0000 ? 2 : (xGreenMask == 0xFF00 ? 1 : 0));
            blue_shift = pixel_map[2] = xBlueMask == 0xFF000000 ? 3
                : (xBlueMask == 0xFF0000 ? 2 : (xBlueMask == 0xFF00 ? 1 : 0));
        } else { /* Ardent */
        printf("22222 GetTIFFImage \n");
            red_shift = pixel_map[0] = xRedMask == 0xFF000000 ? 0
                : (xRedMask == 0xFF0000 ? 1 : (xRedMask == 0xFF00 ? 2 : 3));
            green_shift = pixel_map[0] = xGreenMask == 0xFF000000 ? 0
                : (xGreenMask == 0xFF0000 ? 1 : (xGreenMask == 0xFF00 ? 2 : 3));
            blue_shift = pixel_map[0] = xBlueMask == 0xFF000000 ? 0
                : (xBlueMask == 0xFF0000 ? 1 : (xBlueMask == 0xFF00 ? 2 : 3));
        }
         printf("323232 GetTIFFImage SHIFTS  %d %d %d \n",red_shift,blue_shift,green_shift);

        red_shift=0;
        blue_shift=1;
        green_shift=2;

        if (tfPlanarConfiguration == PLANARCONFIG_CONTIG) {

        printf("3333 GetTIFFImage tfSamplesPerPixel=%d\n",tfSamplesPerPixel);
            for (i = 0; i < tfImageHeight; i++) {
                if (TIFFReadScanline(tfFile, scan_line, i, 0) < 0)
                    break;
                for (input_p = scan_line, j = 0; j < tfImageWidth; j++) {
                    *(output_p + red_shift) = *input_p++;
                    *(output_p + green_shift) = *input_p++;
                    *(output_p + blue_shift) = *input_p++;
      //xxx              output_p += 4;
      output_p += 3;
                    if (tfSamplesPerPixel == 4) /* skip the fourth channel */
                        input_p++;
                }
            }
        } else {
        printf("44444 GetTIFFImage \n");
            for (s = 0; s < tfSamplesPerPixel; s++) {
                if (s == 3)             /* skip the fourth channel */
                    continue;
                for (i = 0; i < tfImageHeight; i++) {
                    if (TIFFReadScanline(tfFile, scan_line, i, s) < 0)
                        break;
                    input_p = scan_line;
                    output_p = imageMemory + (i*tfImageWidth*4) + pixel_map[s];
                    for (j = 0; j < tfImageWidth; j++, output_p += 4)
                        *output_p = *input_p++;
                }
            }
        }
    } else {
    printf("55555 GetTIFFImage \n");
        if (xImageDepth == tfImageDepth) {
        printf("66666 GetTIFFImage \n");
            output_p = imageMemory = (u_char *)
                malloc(tfBytesPerRow * tfImageHeight);
            MCHECK(imageMemory);

            for (i = 0; i < tfImageHeight; i++, output_p += tfBytesPerRow)
                if (TIFFReadScanline(tfFile, output_p, i, 0) < 0)
                    break;
//XXXX        } else if(xImageDepth > tfImageDepth && iip_visualClass == TrueColor ) {
           } else if(xImageDepth > tfImageDepth   ) {

           printf("77777 GetTIFFImage \n");

            /*
             * for this case just read 8 bit at a time will map to
             * 24 bit pixel later
             */
            output_p = imageMemory = (u_char *)
                malloc(tfBytesPerRow * tfImageHeight);
            MCHECK(imageMemory);

            for (i = 0; i < tfImageHeight; i++, output_p += tfBytesPerRow)
                if (TIFFReadScanline(tfFile, output_p, i, 0) < 0)
                    break;

      } else if ((xImageDepth == 8) && (tfImageDepth == 4)) {
         printf("88888  GetTIFFImage \n");
            output_p = imageMemory = (u_char *)
                malloc(tfBytesPerRow * 2 * tfImageHeight + 2);
            MCHECK(imageMemory);

            /*
             * If a scanline is of odd size the inner loop below will overshoot.
             * This is handled very simply by recalculating the start point at
             * each scanline and padding imageMemory a little at the end.
             */
            for (i = 0; i < tfImageHeight; i++) {
                if (TIFFReadScanline(tfFile, scan_line, i, 0) < 0)
                    break;
                output_p = &imageMemory[i * tfImageWidth];
                input_p = scan_line;
                for (j = 0; j < tfImageWidth; j += 2, input_p++) {
                    *output_p++ = (*input_p >> 4) + basePixel;
                    *output_p++ = (*input_p & 0xf) + basePixel;
                }
            }
        } else if ((xImageDepth == 8) && (tfImageDepth == 2)) {
        printf("999999 GetTIFFImage \n");
            output_p = imageMemory = (u_char *)
                malloc(tfBytesPerRow * 4 * tfImageHeight + 4);
            MCHECK(imageMemory);

            for (i = 0; i < tfImageHeight; i++) {
                if (TIFFReadScanline(tfFile, scan_line, i, 0) < 0)
                    break;
                output_p = &imageMemory[i * tfImageWidth];
                input_p = scan_line;
                for (j = 0; j < tfImageWidth; j += 4, input_p++) {
                    *output_p++ = (*input_p >> 6) + basePixel;
                    *output_p++ = ((*input_p >> 4) & 3) + basePixel;
                    *output_p++ = ((*input_p >> 2) & 3) + basePixel;
                    *output_p++ = (*input_p & 3) + basePixel;
                }
            }
        } else if ((xImageDepth == 4) && (tfImageDepth == 2)) {
            printf("101010101 GetTIFFImage \n");
            output_p = imageMemory = (u_char *)
                malloc(tfBytesPerRow * 2 * tfImageHeight + 2);
            MCHECK(imageMemory);

            for (i = 0; i < tfImageHeight; i++) {
                if (TIFFReadScanline(tfFile, scan_line, i, 0) < 0)
                    break;
                output_p = &imageMemory[i * tfBytesPerRow * 2];
                input_p = scan_line;
                for (j = 0; j < tfImageWidth; j += 4, input_p++) {
                    *output_p++ = (((*input_p>>6) << 4)
                        | ((*input_p >> 4) & 3)) + basePixel;
                    *output_p++ = ((((*input_p>>2) & 3) << 4)
                        | (*input_p & 3)) + basePixel;
                }
            }
        } else {
            fprintf(stderr,
                "xtiff: can't handle %d-bit TIFF file on an %d-bit display\n",
                tfImageDepth, xImageDepth);
            return(1);
        }
    }
#endif

    free(scan_line);
    return(0);
}




static int
Usage()
{
    fprintf(stderr, "Usage xtiff: [options] tiff-file\n");
    fprintf(stderr, "\tstandard Xt options\n");
    fprintf(stderr, "\t[-help]\n");
    fprintf(stderr, "\t[-gamma gamma]\n");
    fprintf(stderr, "\t[-usePixmap (True | False)]\n");
    fprintf(stderr, "\t[-viewportWidth pixels]\n");
    fprintf(stderr, "\t[-viewportHeight pixels]\n");
    fprintf(stderr, "\t[-translate pixels]\n");
    fprintf(stderr, "\t[-verbose (True | False)]\n");
    return(1);
}



static int
GetFloatTIFFHeader(char *fileName)
{
    register int i;

    if (!TIFFSetDirectory(tfFile, tfDirectory)) {
        fprintf(stderr, "xtiff: can't seek to directory %d in %s\n",
            tfDirectory, fileName);
        return(1);
    }

    TIFFGetField(tfFile, TIFFTAG_IMAGEWIDTH, &tfImageWidth);
    TIFFGetField(tfFile, TIFFTAG_IMAGELENGTH, &tfImageHeight);

    TIFFGetField(tfFile, TIFFTAG_SAMPLEFORMAT, &tfSampleFormat);

    if(tfSampleFormat != SAMPLEFORMAT_IEEEFP) return(1);

    /*
     * If the following tags aren't present then use the TIFF defaults.
     */
    TIFFGetFieldDefaulted(tfFile, TIFFTAG_BITSPERSAMPLE, &tfBitsPerSample);
    TIFFGetFieldDefaulted(tfFile, TIFFTAG_SAMPLESPERPIXEL, &tfSamplesPerPixel);
    TIFFGetFieldDefaulted(tfFile, TIFFTAG_PLANARCONFIG, &tfPlanarConfiguration);
    TIFFGetFieldDefaulted(tfFile, TIFFTAG_GRAYRESPONSEUNIT, &tfGrayResponseUnit);

return(0);
}




 dsp_floatMatrix_Pt IIP_ReadFloatingPointTIFFMatrixText(char *tiffFile)

{


    int	i,j;
    dsp_floatMatrix_Pt	image_P;
    float	*scan_line;

    setbuf(stdout, NULL); setbuf(stderr, NULL);

  //XXXX  fileName=tiffFile;
#if 11111  //XXXXXXXX

     printf("IIP_ReadFloatingPointTIFFMatrixText TIFF File:%s\n",tiffFile);

    if(OpenTIFFFile(tiffFile)) return(NULL);

    printf("IIP_ReadFloatingPointTIFFMatrixText OpenTIFFFile\n");

    if(PrintTIFF()) return(NULL);

    printf("IIP_ReadFloatingPointTIFFMatrixText PrintTIFF\n");

    if(GetFloatTIFFHeader(tiffFile)) return(NULL);

    printf("IIP_ReadFloatingPointTIFFMatrixText GetFloatTIFFHeader\n");


    image_P=Dsp_AllocateMatrix(tfImageWidth,tfImageHeight);
    if(image_P == NULL) {
	      fprintf(stderr,"Read Floating Point TIFF could not allocate space");
	      return(NULL);
    }

    scan_line = (float *) malloc(tfBytesPerRow = TIFFScanlineSize(tfFile));
    MCHECK(scan_line);


    for (i = 0; i < tfImageHeight; i++) {
                if (TIFFReadScanline(tfFile, scan_line, i, 1) < 0)
                    break;
		for(j=0; j<tfImageWidth; j++)
			image_P->matrix_PP[i][j]=scan_line[j];
    }

#endif //XXXXXX

return(image_P);

}



dsp_floatMatrix_Pt IIP_ReadTIFFMatrixText(char *tiffFile)
{


    int	i,j;
    dsp_floatMatrix_Pt	image_P;
    float	*scan_line;

    setbuf(stdout, NULL); setbuf(stderr, NULL);

 //XXXX   fileName=tiffFile;

#if 1111 //XXXXXX
//XXXX     xDisplay = XtDisplay(toplevel);
//XXXX     xScreen = DefaultScreen(xDisplay);

    if(OpenTIFFFile(tiffFile)) return(NULL);
    printf("IIP_ReadTIFFMatrixText  after OpenTIFFFile fileName=%s\n",tiffFile);

    if(PrintTIFF()) return(NULL);
       printf("IIP_ReadTIFFMatrixText  after PrintTIFF fileName=%s\n",tiffFile);
    if(GetTIFFHeader(tiffFile)) return(NULL);
         printf("IIP_ReadTIFFMatrixText  after GetTIFFHeader fileName=%s\n",tiffFile);

#if 1
    if(SimpleGammaCorrection()) return(NULL);
             printf("IIP_ReadTIFFMatrixText  after SimpleGammaCorrection fileName=%s\n",tiffFile);
    if(GetVisual()) return(NULL);
                printf("IIP_ReadTIFFMatrixText  after GetVisual fileName=%s\n",tiffFile);

    if(GetTIFFImage()) return(NULL);
                printf("IIP_ReadTIFFMatrixText  after GetTIFFImage fileName=%s\n",tiffFile);


#endif

    image_P=Dsp_AllocateMatrix(tfImageWidth,tfImageHeight);
    if(image_P == NULL) {
	fprintf(stderr,"Read  TIFF could not allocate space");
	return(NULL);
    }

    scan_line = (float *) malloc(tfBytesPerRow = TIFFScanlineSize(tfFile));
    MCHECK(scan_line);


    for (i = 0; i < tfImageHeight; i++) {
                if (TIFFReadScanline(tfFile, scan_line, i, 1) < 0)
                    break;
		for(j=0; j<tfImageWidth; j++)
			image_P->matrix_PP[i][j]=
		   		(float)imageMemory[i*tfBytesPerRow+j];
    }


free(imageMemory);
#endif //XXXXXX
return(image_P);

}



