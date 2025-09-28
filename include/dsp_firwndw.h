/* Module firwndw.h
 *
 * This is the include file for firwndw.c
 *
 * Author   : Harish P. Hiriyannaiah
 *            Department of Electrical & Computer Engineering
 *            North Carolina State University
 *            Raleigh, NC 27695.
 *
 * Created  : July 31, 1987.
 *
 * Revision : 1.0   HPH  Jul/31/87  VMS 4.4  Initial release.
 *
 * Other include files needed  : [grad.harish.release]ctools.h,math.h,stdio.h,
 *                               curses.h
 *
 * For description, see firwndw.c
 *
 */
 /*
     Capsim (r) Text Mode Kernel (TMK)
     Copyright (C) 1989-2017  Silicon DSP  Corporation

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


#include <stdio.h>
#include <math.h>

#define   VERT   1    /* Vertical menus only.              */
#define   ROW    5    /* Starting row of menus.            */
#define   COL    15   /* Starting column of menus.          */
#define   EXIT   0

#define   LPASS  1
#define   HPASS  2
#define   BPASS  3
#define   BSTOP  4


#define   RECTW   1
#define   RECT   1
#define   TRIAN  2
#define   HAMM   3
#define   GHAM   4
#define   HANN   5
#define   KAIS   6
#define   CHEB   7
#define   PARZ   8

#define   PLOT   1
#define   BEGIN  2


char      tapfile[32],specfile[32];  /*  i/o files.                    */


char           *winmenu[] = {
            "Exit",
            "Rectangular",
            "Triangular",
            "Hamming",
            "Generalised Hamming",
            "Hanning",
            "Kaiser",
            "Chebyshev",
            "Parzen",
            0
         },

          *filtmenu[] =  {
            "Exit",
            "Lowpass",
            "Highpass",
            "Bandpass",
            "Bandstop",
            0
          },

          *endmenu[] = {
            "Exit",
            "Begin New Window",
            0
          };

#if 0
struct    _scan   lphpfiltscan[] = {
     {5,1,"%s@*^|\040[XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX","Filter specs file : ",
     "Enter name of file where filter specifications will be stored.",
     specfile,32},
     {7,1,"%s@*^|\040[XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX","Filter tap file : ",
     "Enter name of file where filter taps will be stored.",
     tapfile,32},
     {9,1,"%d@*^|\040[999999999999999","# of filter taps : ",
     "Enter the number of filter taps in your filter. Positive integer.",
     (char *)&ntap,15},
     {11,1,"%f@*^|\040[999999999999999","Cutoff frequency : ",
     "Enter normalised cutoff frequency. 0 < fc < 0.5. Positive real #.",
     (char *)&fc,15},
     {END}
     },

                  bpbsscan[] = {
     {5,1,"%s@*^|\040[XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX","Filter specs file : ",
     "Enter name of file where filter specifications will be stored.",
     specfile,32},
     {7,1,"%s@*^|\040[XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX","Filter tap file : ",
     "Enter name of file where filter taps will be stored.",
     tapfile,32},
     {9,1,"%d@*^|\040[999999999999999","# of filter taps : ",
     "Enter the number of filter taps in your filter. Positive integer.",
     (char *)&ntap,15},
     {11,1,"%f@*^|\040[999999999999999","Lower cutoff frequency : ",
     "Enter normalised lower cutoff frequency. 0 < fl < 0.5. Positive real #.",
     (char *)&fl,15},
     {13,1,"%f@*^|\040[999999999999999","Upper cutoff frequency : ",
     "Enter normalised upper cutoff frequency. 0 < fh < 0.5. Positive real #.",
     (char *)&fh,15},
     {END}
     },
                  chebyscan[] = {
     {5,1,"%f@*^|\040[999999999999999","Ripple (db) : ",
     "Enter ripple in decibels. Positive real #.",
     (char *)&dbripple,15},
     {7,1,"%f@*^|\040[999999999999999","Transition width : ",
     "Enter transition width. 0 < twidth < 0.5. Positive real #.",
     (char *)&twidth,15},
     {END}
     },

                  ghammingscan[] = {
     {5,1,"%f@*^|\040[999999999999999","Alpha : ",
     "Enter alpha for Hamming window. 0 <= alpha <= 1.0. Positive real #.",
     (char *)&alpha,15},
     {END}
     },

                  kaiserscan[] = {
     {5,1,"%f@*^|\040[999999999999999","Attenuation (db) : ",
     "Enter attenuation in decibels. Positive real #.",
     (char *)&att,15},
     {END}
     };

#endif
