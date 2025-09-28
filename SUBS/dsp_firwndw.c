

/*  Capsim (r) Text Mode Kernel (TMK) Star Library (Blocks)
    Copyright (C) 1989-2017  Silicon DSP Corporation Corporation 

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
 * Module firwndw.c
 * 
 * This program calculates the filter taps of an FIR filter using the 
 * window method of FIR filter design. This program is a modification of
 * the C translation by Won Rae Lee of the original FORTRAN program written
 * by Lawrence Rabiner and Carol McGonegal of Bell Labs, Murray Hill, NJ.
 * This program has a better i/o interface and, hopefully, better documen-
 * tation than the previous two versions. 
 *
 *
 * Created   :  July 28, 1987
 *
 * Version   :  1.0  Jul/28/87  HPH   VAX/VMS 4.4  Initial release.
 *
 * The source for the functions used in this program can be found in
 * wndwsubs.c and the object code in the binary library wndwsubs. This
 * program needs the library wndwsubs for linking.
 */
#include <string.h>
#include <stdlib.h>


#include "dsp_firwndw.h"
#include "dsp.h"
#define PI 3.14159265358979323846
#define WMAX1 512                     /* Max # of filter taps    */
#define WMAX2 1026                    

int FIRDesign(float fc,float fl,float fh,float alphag,float dbripple,float twidth,float att,
 int ntapin,int windType,int filterType, char *fileNamePrefix)
/* fc cut off frequency for low pass */
/* and high pass*/

/* fl,fh lower and upper cut off frequency */
/* bandpass and stop band filters.   */

/* alphag For generalized hamming window */

/* dbripple For Chebyshev window */
/* twidth ripple and transition width */

/*att Kaiser window attenuation */

/* ntapin  Window size */
/* windType, filterType Determines window & filter types.             */

{
	float alpha,beta;
	float win[WMAX1],htap[WMAX2],hmag[WMAX2],/* Arrays for window taps */
              gideal[WMAX1],xdata[WMAX2];        /* and mag. response.     */
	float hdbmax,hdb,x0,xn,c1,cval,c3,ripple;

	int i,j,k;        /* needed for loop control & array indexing.     */
	int ntap2,ntap,two,ndata,npdata,remain,select;

	FILE  *fp1,*fp2;  /* Pointers for i/o files.                       */
        char buffer[256];

start:
ntap=ntapin;
printf("FIRDesign ntap=%d windType=%d filterType=%d\n",ntap,windType,filterType);  
  for(i=0; i<WMAX1; i++) {
	  win[i]=0;
	  gideal[i]=0.0;
  }
  for(i=0; i<WMAX2; i++) {
	  htap[i]=0;
	  hmag[i]=0.0;
	  xdata[i]=0.0;
  }

  switch(filterType) {
     case LPASS:
     case HPASS:
                  if (fc >= 0.5) {
                    printf("Value of fc out of bounds. Has to be less \n");
                    printf("than 0.5.\n ");
                  }
                  break;
                     
     case BPASS:
     case BSTOP:
                  if (fl >= 0.5) {        
                    printf("Value of fl out of bounds. Has to be less \n");
                    printf("than 0.5.\n ");
		    return(1);
                  }
                  if(fh >= 0.5) {
                    printf("Value of fh out of bounds. Has to be less \n");
                    printf("than 0.5.\n ");
		    return(1);
                  }
                  if(fl>fh) {
                    printf("fl is greater than fh. \n");
		    return(1);
                  }
                  break;
  }   /* End switch  */
#if 0
  if (ntap > 1024)  {
     printf("Number of taps should not exceed 1024.\n");
     return(1);
  }
#endif
  strcpy(buffer,fileNamePrefix);
  strcat(buffer,".tap");
  fp1 = fopen(buffer,"w");
  
  strcpy(buffer,fileNamePrefix);
  strcat(buffer,".spec");
  fp2 = fopen(buffer,"w");
  
  if((fp1 == NULL) || (fp2 == NULL)) {
     printf("Error in opening one of the output files.\n");
     return(1);
  }
 
  if((windType==CHEB) && (ntap < 3)) {
     printf("# of window taps has to be >= 3 for Chebyshev window.\n");
     return(1);
  }
  else if ((windType!=CHEB)&&(ntap<=3)) {
     printf("The range of window values is : 3 < # of taps <= 1024.\n\n");
     return(1);
  }

  if(windType == CHEB)  {
#if 0
     scan(chebyscan);
#endif
     ripple = pow(10.0,(-dbripple/20.0));
     printf("ripple=%f dbripple=%f \n",ripple,dbripple);
     Chebc(&ntap,&ripple,&twidth,&ntap2,&x0,&xn);
     printf("after ripple=%f dbripple=%f \n",ripple,dbripple);
  }

  remain = ntap % 2;
  ntap2 = ntap/2;
  if ( (remain == 0) && (filterType == HPASS || filterType == BSTOP)) {
    ++ntap;
    ++remain;
    ntap2 = (1+ntap)/2;
    printf("# of taps must be an odd number for high pass & bandstop filters.\n");
    printf("\n # of taps being increased by one. \n");
  }
  
  printf("\n. Hey, wait a minute. \nGive me some time to do the job ......\n");
  /* Compute ideal (unwindowed) impulse response for filter.  */
  c1 = fc;
  if(filterType == BPASS || filterType == BSTOP)
     c1 = fh-fl;
  if (remain == 1)
     gideal[0] = 2.0*c1;
  for(i=remain;i<ntap2+remain;i++)  {
     xn = i;
     if ( remain == 0)
        xn += 0.5;
     cval = xn*PI;
     c3 = c1*cval;
     if (filterType == LPASS || filterType == HPASS)
        c3 *= 2.0;
     gideal[i] = sin(c3)/cval;
     if (filterType == BPASS || filterType == BSTOP)
        gideal[i] *= (2.0*cos(cval*(fl+fh)));
  }

 /* Calculate the window values based on selected window    */
  
  switch(windType) {
     
     case RECTW  :
                fprintf(fp2,"Rectangular Window. Filter length = %d\n\n",ntap);
                for(i=0;i<ntap2+remain;++i)
                   win[i] = 1.0;
                break;

     case TRIAN :
                fprintf(fp2,"Triangular Window. Filter length = %d\n\n",ntap);
    		Triang(ntap,win,ntap2,remain);
#ifdef DEBUG
		printf("TRIAN ntap=%d ntap2=%d remain=%d\n",ntap,ntap2,remain);
		for(i=0;i<ntap2+remain; i++) {
			printf("i=%d win[i]=%f\n",i,win[i]);
		}
#endif
                break;

     case HAMM  :
                alpha = 0.54;
                beta = 1 - alpha;
                fprintf(fp2,"Hamming Window. Filter length = %d\n\n",ntap);
                fprintf(fp2,"Alpha = %f.\n\n",alpha);
                fprintf(fp2,"Alpha = %f.\n\n",alpha);
                Hammin(ntap,win,ntap2,remain,alpha,beta);
#ifdef DEBUG		
		printf("HAMM ntap=%d ntap2=%d remain=%d\n",ntap,ntap2,remain);
		for(i=0;i<ntap2+remain; i++) {
			printf("i=%d win[i]=%f\n",i,win[i]);
		}
#endif		
                Hammin(ntap,win,ntap2,remain,alpha,beta);
                break;
     
     case GHAM  :
#if 0
                scan(ghammingscan);
#endif
		alpha = alphag;
                fprintf(fp2,"Generalised Hamming Window. Alpha = %f\n\n",alpha);
                fprintf(fp2,"Filter length = %d\n\n",ntap);
                beta = 1-alpha;
                Hammin(ntap,win,ntap2,remain,alpha,beta);
                break;

     case PARZ  :
                fprintf(fp2,"Parzen Window. Filter length = %d\n\n",ntap);
                Parzen(ntap,win,ntap2,remain);
                break;

     case HANN  :
                fprintf(fp2,"Hanning Window. Filter length = %d\n\n",ntap);
                ntap += 2; /* This is done to make sure that zero       */
                ++ntap2;    /* endpoints are not part of the window.     */
                alpha = beta = 0.5;
                fprintf(fp2,"Alpha = %f.\n\n",alpha);
                Hammin(ntap,win,ntap2,remain,alpha,beta);
                ntap -= 2; /* Back to the specified window size.        */
                --ntap2;
                break;
     
     case KAIS  :
                fprintf(fp2,"Kaiser window. Filter length = %d\n\n",ntap);
#if 0
                scan(kaiserscan);       
#endif
                if (att>50.0)
                   beta = 0.1102*(att-8.7);
                else if(att>=20.96)
                   beta = pow(0.58417*(att-20.96),0.4)+0.07886*(att-20.96);
                else
                   beta = 0.0;
                Kaiser(ntap,win,ntap2,remain,beta);
                fprintf(fp2,"Attenuation = %f, Beta = %f\n\n",att,beta);
                break;

     case CHEB  :
                Cheby(ntap,win,ntap2,remain,ripple,twidth,x0,xn);
                fprintf(fp2,"Chebyshev Window. Filter length = %d\n\n",ntap);
                fprintf(fp2,"ripple = %f,transition width = %f",ripple,twidth);                                 
                fprintf(fp2,"\n\n");
		
#if 000
		printf("CHEB ntap=%d ntap2=%d remain=%d\n",ntap,ntap2,remain);
		for(i=0;i<ntap2+remain; i++) {
			printf("i=%d win[i]=%f\n",i,win[i]);
		}
#endif		
		
		
                break;
  }     /* End switch   */

  for (i=0;i<ntap2+remain;++i)
     gideal[i] *= win[i];  /* Get the windowed ideal response.      */

  switch(filterType)  {
 
     case LPASS:
                fprintf(fp2,"  ** Lowpass filter design ** \n");
                fprintf(fp2,"  Ideal lowpass cutoff. fc = %f\n",fc);
                break;

     case HPASS:
                fprintf(fp2,"  ** Highpass filter design ** \n");
                fprintf(fp2,"  Ideal highpass cutoff. fc = %f\n",fc);
                break;

     case BPASS:
                fprintf(fp2,"  ** Bandpass filter design ** \n");
                fprintf(fp2," Ideal lowpass cutoff. fl = %f",fl);
                fprintf(fp2," Ideal highpass cutoff. fh = %f\n",fh);
                break;

     case BSTOP:
                fprintf(fp2,"  ** Bandstop filter design ** \n");
                fprintf(fp2," Ideal lowpass cutoff. fl = %f",fl);
                fprintf(fp2," Ideal highpass cutoff. fh = %f\n",fh);
                break;
  }   /* End switch  */

  if (filterType == HPASS || filterType == BSTOP) {
     for(i=1;i<ntap2;++i)
        gideal[i] = -gideal[i];
     gideal[0] = 1 - gideal[0];
  }

  fprintf(fp2,"\n\n\n");
  fprintf(fp2," ** Window values **                     ** Filter taps **\n\n");
  for(i=0;i<ntap2+remain;++i)   {
     j = ntap2-i-1+remain;
     k = ntap-i-1;
     htap[i] = htap[k] = gideal[j];
     fprintf(fp2," W[%4d] = %10f = W[%4d]     H[%4d] = %10f = H[%4d]\n",
                 i,win[j],k,i,gideal[j],k);
  }

  fprintf(fp1,"%d\n",ntap);
  for(i=0;i<ntap;++i)
     fprintf(fp1,"%f\n",htap[i]);
  FilterCharact(ntap,windType,filterType,fc,fl,fh,ntap2,remain,gideal,fp2);

  fclose(fp1);
  fclose(fp2);
  return(0);

} /* end main   */             
