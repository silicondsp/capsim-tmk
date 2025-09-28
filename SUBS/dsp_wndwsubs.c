

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
 * Module wndwsubs.c
 *
 * This module contains the functions needed by firwndw.c. I have not
 * dealt with the algorithms, written by Won Rae Lee. However, I have
 * modified the i/o wherever necessary, to suit the format I have been
 * using all along.
 *
 *                                 Harish P. Hiriyannaiah.
 */
#include <stdio.h>
#include <math.h>


float Ino(float X);
void Ripple(int NR,float RIDEAL,float FLOW,float FHI,float RESP[],float *FA,float *FB,float *DB);


/*......................................................................*/
/* FUNCTION: ABS							*/
/*......................................................................*/
float ABS(float X)

{
	if(X<0) X=X/-1.;
	return(X);
}
/*......................................................................*/
/* FUNCTION: COSHIN							*/
/*......................................................................*/
float COSHIN(float X)

{
	float Y;
	Y = log(X+sqrt(X*X-1.0));
	return(Y);
}

/* ---------------------------------------------------------------------*/
/* Triangular Window							*/
/*----------------------------------------------------------------------*/
void Triang(int NF,float W[],int N,int IEO)

{
	int i,FN;
	float XI;
	FN=N;
	for (i=0; i<N;++i){
		XI=i;
		if (IEO==0) XI=XI+0.5;
		W[i] = 1.0 - XI/FN;
	}
	return;
}

/* ---------------------------------------------------------------------*/
/* Hamming Window							*/
/* ---------------------------------------------------------------------*/
void Hammin(int NF,float W[],int N,int IEO,float ALPHA,float BETA)

{
	int i,FN;
	float PI2,XI;
	PI2= 8.0*atan(1.0);
	FN = NF-1;
	for (i=0;i<N;++i){
		XI = i;
		if (IEO==0) XI=XI+0.5;
		W[i] = ALPHA + BETA*cos((PI2*XI)/FN);
	}
	return;
}

/* ---------------------------------------------------------------------*/
/* Parzen Window							*/
/*----------------------------------------------------------------------*/
void Parzen(int NF,float W[],int N,int IEO)

{
	int i;
	float XI,FN;

	FN=N;
	for(i=0;i<N;++i){
		XI=i;
		if(IEO==0) XI=XI+0.5;
		if(i<=N/2) W[i]=1.0-6.*pow(XI/FN,2.)+6.*pow(XI/FN,3.);
		else W[i]=2.*pow(1.0-XI/FN,3.0);
	}
	return;
}

/* ---------------------------------------------------------------------*/
/* Kaiser Window							*/
/* ---------------------------------------------------------------------*/
void Kaiser (int NF,float W[],int N,int IEO,float BETA)

{
	int i;
	float BES,XIND,XI,DUM;
	BES = Ino(BETA);
	DUM = NF-1;
	XIND = DUM*DUM;
	for(i=0;i<N;++i){
		XI = i;
		if(IEO==0) XI=XI+0.5;
		XI=4.*XI*XI;
		W[i]=Ino(BETA*sqrt(1.0-XI/XIND));
		W[i]=W[i]/BES;
	}
	return;
}

/*......................................................................*/
/* FUNCTION: Ino							*/
/*......................................................................*/
float Ino(float X)

{
	int i;
	float Y,T,E,DE,XI,SDE;
	Y = X/2.;
	T = 1.e-08;
	E = DE = 1.0;
	for(i=1;i<=25;++i){
		XI=i;
		DE = DE*Y/XI;
		SDE = DE*DE;
		E = E + SDE;
		if (E*T - SDE>0.0) goto id20;
	}
id20:   return(E);
}

/* -------------------------------------------------------------------- */
/* SUBROUTINE: CHEBC							*/
/* SUBROUTINE TO GENERATE CHEBYSHEV WINDOW PARAMETER WHEN		*/
/* ONE OF THE THREE PARAMETERS NF,DP AND DF IS UNSPECIFIED		*/
/* -------------------------------------------------------------------- */
void Chebc (int *NF,float *DP,float *DF,int *N,float *X0,float *XN)

{
float CA,CB,CC,PIx,XX;
	PIx=4.0*atan(1.);
	if (*NF != 0) goto id1;
/* DF,DP SPECIFIED, DETERMINE NF ..................................... */
	CB = COSHIN((1.0+(*DP))/(*DP));
	CA = cos((*DF)*PIx);
	XX = 1.0 + CB/COSHIN(1.0/CA);
/* INCREMENT BY 1 TO GIVE NF WHICH MEETS OR EXCEEDS SPECS ON DP AND DF  */
	*NF = XX + 1.0;
	*N = ((*NF)+1)/2;
	*XN = (*NF)-1;
	goto id3;
id1:	if (*DF != 0.0) goto id2;
/* NF,DP SPECIFIED, DETERMINE DP......................................  */
	*XN = (*NF) - 1;
	CB = COSHIN((1.0+(*DP))/(*DP));
	CC = cosh(CB/(*XN));
	*DF = acos(1./CC)/PIx;
	goto id3;
/* NF,DF SPECIFIED, DETERMINE DP ...................................... */
id2:	*XN = (*NF) - 1;
	CA = cos(PIx*(*DF));
	CB = (*XN)*COSHIN(1./CA);
	*DP = 1.0/(cosh(CB)-1.0);
id3:	*X0 = (3.0-cos(2.0*PIx*(*DF)))/(1.0+cos(2.0*PIx*(*DF)));
	return;
}


/* -------------------------------------------------------------------- */
/* SUBROUTINE CHEBY							*/
/* DOLPH CHEBYSHEV WINDOW DESIGN					*/
/*									*/
/* NF = FILTER LENGTH IN SAMPLES					*/
/*  W = WINDOW ARRAY IN SIZE N						*/
/*  N = HALF LENGTH OF FILTER = (NF+1)/2				*/
/* IEO= EVEN-ODD INDICATOR -- IEO=0 FOR NF EVEN				*/
/* DP = WINDOW RIPPLE ON AN ABSOLUTE SCALE				*/
/* DF = NORMALIZED TRANSITION WIDTH OF WINDOW				*/
/* X0 = WINDOW PARAMETER RELATED TO TRANSITION WIDTH			*/
/* XN = NF-1								*/
void Cheby (int NF,float W[],int N,int IEO,float DP,float DF,float X0,float XN)

{
	int i,j;
	float PR[1024],PIE[1024],ALPHA,BETA,PIx,TWOPIx,TWN,SUM;
	float C1,C2,X,XI,XJ,P,F,FNF;

	PIx = 4.*atan(1.0);
	XN=NF-1;
	FNF = NF;
	ALPHA = (X0+1.0)/2.0;
	BETA = (X0-1.0)/2.0;
	TWOPIx = 2.*PIx;
	C2 = XN/2.;
	for (i=0;i<NF;++i){
		XI = i;
		F = XI/FNF;
		X = ALPHA*cos(TWOPIx*F) + BETA;
		if (ABS(X)-1.0<=0.0) goto id1; else goto id2;
id1:		P = DP*cos(C2*acos(X));
		goto id3;
id2:		P = DP*cosh(C2*COSHIN(X));
id3:		PIE[i]=0.0;
		PR[i]=P;
/* FOR ENEV LENGTH FILTER USE A ONE-HALF SAMPLE DELAY.................. */
/* ALSO THE FREQUENCY RESONSE IS ANTISYMMETRIC IN FREQUENCY............ */
		if (IEO==1) goto id4;
		PR[i]=P*cos(PIx*F);
		PIE[i]=P*sin(PIx*F)/-1.;
		if (i > NF/2) PR[i]=PR[i]/-1.0;
		if (i > NF/2) PIE[i]=PIE[i]/-1.0;
id4:		;
	}
/* USE DFT TO GIVE WINDOW ............................................. */
	TWN = TWOPIx/FNF;
	for (i=0;i<N;++i){
		XI = i;
		SUM=0.0;
		for (j=0;j<NF;++j){
			XJ = j;
			SUM=SUM+(PR[j]*cos(TWN*XJ*XI) + PIE[j]*sin(TWN*XJ*XI));
		}
		W[i]=SUM;
	}
	C1=W[0];
	for (i=0;i<N;++i)
		W[i]=W[i]/C1;
	return;
}

/*----------------------------------------------------------------------*/
/* SUBROUTINE: 	FilterCharact							*/
/* SUBROUTINE TO DETERMINE FILTER CHARACTERISTICS			*/
/*    NF=FILTER LENGTH IN SAMPLES					*/
/* WTYPE=WINDOW TYPE							*/
/* FTYPE=FILTER TYPE							*/
/*    FC=IDEAL CUTOFF OF LP OR HP FILTER				*/
/*    FL=LOWER CUTOFF OF BP OR BS FILTER				*/
/*    FH=UPPER CUTOFF OF BP OR BS FILTER				*/
/*     N=FILTER HALF LENGTH = (NF+1)/2					*/
/*   IEO=EVEN ODD INDICATOR						*/
/*     G=FILTER ARRAY OF SIZE N						*/
/*   fp1=FILE POINTER FOR fir.dat					*/
/*----------------------------------------------------------------------*/
void FilterCharact(int NF,int WTYPE,int FTYPE,float FC,float FL,float FH,int N,int IEO,float G[],FILE *fp1)
//float FC,FL,FH,G[];
//int N,NF,WTYPE,FTYPE,IEO;
//FILE *fp1;
{
	int i,j,NR;
	float RESP[2048],PIz,SUM,SUMI,DB,XNR,FA,FB,XI,XJ;
	float DUM,TWN,TWNI,RIDEAL,FLOW,FHI;

/* NOT FOR THE TRIAGULAR WINDOW						*/
	if (WTYPE == 2) return;
/* DFT TO GET FREQ RESP							*/
	PIz=4.*atan(1.);
/* UP TO 4096 POINTS DFT						 */
	NR=8*NF;
	if (NR>2048) NR=2048;
	XNR=NR;
	TWN=PIz/XNR;
	SUMI = -G[0]/2.;
	if (IEO==0) SUMI=0.0;
	for (i=0;i<NR;++i){
		XI=i;
		TWNI = TWN*XI;
		SUM=SUMI;
		for(j=0;j<N;++j){
			XJ=j;
			if(IEO==0) XJ=XJ+0.5;
			SUM=SUM+G[j]*cos(XJ*TWNI);
		}
		RESP[i]=2.*SUM;
	}
/* DISPATCH ON FILTER TYPE						 */
	if(FTYPE==1) goto id3;
	if(FTYPE==2) goto id4;
	if(FTYPE==3) goto id5;
	if(FTYPE==4) goto id6;
/* LOWPASS								 */
id3: 	Ripple(NR,1.,0.0,FC,RESP,&FA,&FB,&DB);
	fprintf(fp1," Passband Cutoff = %f. Ripple (db) = %f. \n",FB,DB);
	Ripple(NR,0.,FC,.5,RESP,&FA,&FB,&DB);
	fprintf(fp1," Stopband Cutoff = %f. Ripple (db) = %f. \n",FA,DB);
	return;
/* HIGHPASS								 */
id4:	Ripple(NR,0.,0.,FC,RESP,&FA,&FB,&DB);
	fprintf(fp1," Stopband Cutoff = %f. Ripple (db) = %f. \n",FB,DB);
	Ripple(NR,1.,FC,.5,RESP,&FA,&FB,&DB);
	fprintf(fp1," Passband Cutoff = %f. Ripple (db) = %f. \n",FA,DB);
	return;
/* BANDPASS								 */
id5:	Ripple(NR,0.,0.,FL,RESP,&FA,&FB,&DB);
	fprintf(fp1," Stopband Cutoff = %f. Ripple (db) = %f \n",FB,DB);
	Ripple(NR,1.,FL,FH,RESP,&FA,&FB,&DB);
fprintf(fp1," Passband Cutoffs are %f & %f. Ripple (db) = %f. \n",FA,FB,DB);
	Ripple(NR,0.,FH,.5,RESP,&FA,&FB,&DB);
	fprintf(fp1," Stopband Cutoff = %f. Ripple (db) = %f. \n",FA,DB);
	return;
/* STOPBAND								 */
id6:	Ripple(NR,1.,0.,FL,RESP,&FA,&FB,&DB);
	fprintf(fp1," Passband Cutoff = %f. Ripple (db) = %f.\n",FB,DB);
	Ripple(NR,0.,FL,FH,RESP,&FA,&FB,&DB);
fprintf(fp1," Stopband cutoffs are %f & %f . Ripple (db) = %f.\n",FA,FB,DB);
	Ripple(NR,1.,FH,.5,RESP,&FA,&FB,&DB);
	fprintf(fp1," Passband Cutoff = %f. Ripple (db) = %f.\n",FA,DB);
	return;

}

/*----------------------------------------------------------------------*/
/* SUBROUTINE: Ripple 							*/
/* FINDS LARGEST RIPPLE IN BAND AND LOCATES BAND EDGES BASED ON THE	*/
/* POINT WHERE THE TRANSITION REGION CROSSES THE MEASURED RIPPLE BOUND	*/
/*									*/
/*     NR = SIZE OF RESP						*/
/* RIDEAL = IDEAL FREQUENCY RESPONSE					*/
/*   FLOW = LOW EDGE OF IDEAL BAND					*/
/*    FHI = HIGH EDGE OF IDEAL BAND					*/
/*   RESP = FREQUENCY RESPONSE OF SIZE NR				*/
/*     FA = COMPUTED LOWER BAND EDGE					*/
/*     FB = COMPUTED UPPER BAND EDGE					*/
/*     DB = DEVIATION FROM IDEAL RESPONSE IN DB				*/
/*----------------------------------------------------------------------*/
void Ripple(int NR,float RIDEAL,float FLOW,float FHI,float RESP[],float *FA,float *FB,float *DB)
//float RIDEAL,FLOW,FHI,RESP[],*FA,*FB,*DB;
//int NR;
{
	int I,J,IFLOW,IFHI;
	float RMIN,RMAX,RIPL;
	float XNR,XI,XA,XB,YA,YB;

	XNR=NR;
/* BAND	LIMITS								*/
	IFLOW=2.*XNR*FLOW +1.5;
	IFHI=2.*XNR*FHI +1.5;
	if(IFLOW == 0) IFLOW=1;
	if(IFHI>=NR) IFHI = NR-1;
/* FIND	MAX AND MIN PEAKS IN BAND					 */
	RMIN = RIDEAL;
	RMAX = RIDEAL;
	for(I=IFLOW-1;I<IFHI;++I){
  	  if(RESP[I]<=RMAX || RESP[I]<RESP[I-1] || RESP[I]<RESP[I+1]) goto id1;
	  RMAX=RESP[I];
id1:	  if(RESP[I]>=RMIN || RESP[I]>RESP[I-1] || RESP[I]>RESP[I+1]) goto id2;
	  RMIN=RESP[I];
id2:    ;
	}
/* PEAK DEVIATION FROM IDEAL 						 */
	if (RMAX-RIDEAL>RIDEAL-RMIN) {RIPL=RMAX-RIDEAL; goto id9;}
	else RIPL=RIDEAL-RMIN;
/* SEARCH FOR LOWER BAND EDGE						*/
id9:	*FA=FLOW;
	if(FLOW==0.0) goto id5;
	for(I=IFLOW-1; I<IFHI;++I){
		J=I;
	   	if(ABS(RESP[I]-RIDEAL)<=RIPL) goto id4;
	}
id4:	XI=J;
/* LINEAR INTERPOLATION OF BAND EDGE FREQUENCY TO IMPROVE ACCURACY	 */
	XB=0.5*XI/XNR;
	XA=0.5*(XI-1.)/XNR;
	YB=ABS(RESP[J]-RIDEAL);
	YA=ABS(RESP[J-1]-RIDEAL);
	*FA=(XB-XA)/(YB-YA)*(RIPL-YA)+XA;
/* SEARCH FOR UPPER BAND EDGE						 */
id5:	*FB=FHI;
	if(FHI==0.5) goto id8;
	for(I=IFLOW-1;I<IFHI;++I){
		J=IFHI+IFLOW -I;
		if (ABS(RESP[J]-RIDEAL)<=RIPL) goto id7;
	}
id7:	XI=J;
/* LINEAR INTERPOLATION OF BAND EDGE FREQUENCY TO IMPROVE ACCURACY	 */
	XB=0.5*XI/XNR;
	XA=0.5*(XI+1.)/XNR;
	YB=ABS(RESP[J]-RIDEAL);
	YA=ABS(RESP[J+1]-RIDEAL);
	*FB=(XB-XA)/(YB-YA)*(RIPL-YA) + XA;
/* DEVIATION FROM IDEAL IN DB						 */
id8:	*DB=20.*log10(RIPL+RIDEAL);
	return;
}
