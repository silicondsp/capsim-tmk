/*
 * Module  iirdesign.h
 *
 * Header file for iirdesign.c
 *
 * Author  :  Harish P. Hiriyannaiah
 *            Department of Electrical & Computer Engg
 *            North Carolina State University
 *            Raleigh, NC 27695.
 *
 * Created :  July 8, 1987.
 *
 * Revision : 1.0   HPH       Jul/8/87.              VMS 4.4
 *
 * Other include files needed : [grad.harish.release]ctools.h,math.h,stdio.h,
 *                              curses.h
 *
 * For description, see iirdesign.c
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

//#define   PI   3.14159265
#define   MTYPE     1                     /* Vertical menu            */
#define   M_ROW     5                     /* Menu begins at 5th row   */
#define   M_COL     15                    /* and 15th column          */
#define   EXIT      0
#define   HELP      1
#define   DESIGN    2

#define   BUTTERWORTH  1
#define   CHEBYSHEV    2
#define   ELLIPTIC     3

#define   LPASS        1
#define   HPASS        2
#define   BPASS        3
#define   BSTOP        4

char   *mainmenu[] =  {
           "Exit",
           "Help",
           "Design",
           0
       },

       *fkindmenu[] = {
           "Exit",
           "Butterworth",
           "Chebyshev",
           "Elliptic",
           0
       },

       *ftypemenu[] =  {
           "Exit",
           "Lowpass",
           "Highpass",
           "Bandpass",
           "Bandstop",
           0
       },

       filterdata[32] = "filt.dat",   /*  File where design specs are stored */
       pzdata[32]     = "filt.pz";    /* File where pole/zero data is stored */


#if 0
struct  _scan    mainscan[] = {
     {5,1,"%s*@^|\040[XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX","Filter specs file : ",
     "Enter name of file where filter specifications will be stored.",
     filterdata,32},
    {7,1,"%s*@^|\040[XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX","Pole/Zero data file : ",
     "Enter name of file where pole zero data will be stored. ",
     pzdata,32},
     {9,1,"%f*@^|\040[999999999999999","Sampling frequency [Hz] : ",
     "Enter sampling frequency in Hz.Real value.",
     (char *)&fs,15},
     {END}
     },

          lphpscan[] = {
     {5,1,"%f*@^|\040[999999999999999","Passband edge frequency [Hz] : ",
     "Enter passband edge frequency in Hz. Real value.",(char *)&fpb,15},
     {7,1,"%f*@^|\040[999999999999999","Stopband edge frequency [Hz] : ",
     "Enter stopband edge frequency in Hz. Real value.",(char *)&fsb,15},
     {9,1,"%f*@^|\040[999999999999999","Passband ripple [db] : ",
     "Enter maximum allowable passband ripple in db.Real value",
     (char *)&pbdb,15},
     {11,1,"%f*@^|\040[999999999999999","Stopband attenuation [db] : ",
     "Enter minimum stopband attenuation needed. [db] ",(char*)&sbdb,15},
     {END}
     } ,

            bpbsscan[] = {
     {5,1,"%f*@^|\040[999999999999999","Upper passband edge frequency [Hz] : ",
     "Enter upper passband edge frequency in Hz. Real value.",(char *)&fpu,15},
     {7,1,"%f*@^|\040[999999999999999","Upper stopband edge frequency [Hz] : ",
     "Enter upper stopband edge frequency in Hz. Real value.",(char *)&fsu,15},
     {9,1,"%f*@^|\040[999999999999999","Lower passband edge frequency [Hz] : ",
     "Enter lower passband edge frequency in Hz. Real value.",(char *)&fpl,15},
     {11,1,"%f*@^|\040[999999999999999","Lower stopband edge frequency [Hz] : ",
     "Enter lower stopband edge frequency in Hz. Real value.",(char *)&fsl,15},
     {13,1,"%f*@^|\040[999999999999999","Passband ripple [db] : ",
     "Enter maximum allowable passband ripple in db.Real value",
     (char *)&pbdb,15},
     {15,1,"%f*@^|\040[999999999999999","Stopband attenuation [db] : ",
     "Enter minimum stopband attenuation needed. [db] ",(char*)&sbdb,15},
     {END}
     };

#endif






