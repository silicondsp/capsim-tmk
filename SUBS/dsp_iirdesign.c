

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


/* Module iirdesign.c
 *
 * Created   : July 8,1987
 *
 * Revision  :  1.0  HPH  Jul/8/87     VMS 4.4
 *
 * This program is the hacked version of the "C" version of filter.f.The
 * C translation was done by Won Rae Lee.I have merely modified the i/o
 * interface to make it more user friendly, without touching the basic
 * algorithm(?!!!). My sympathies for the poor software maintainance
 * personnel who may have to decipher this gibberish some day.
 *
 * Use at your own risk. Sasan Ardalan. Oct. 30, 1989.
 */
#include <stdio.h>
#include <string.h>
#include "dsp.h"
#include "dsp_iirdesign.h"


void bwlpf(float f1,float db1,float f2,float db2,int *n,float *fc,float sr[],float si[]);
int dcel1(double *res,double ak);
void deli1(double * res,double x,double ck);
void djelf(double *sn,double *cn,double *dn,double x,double sck);
void sztran(float zsr[],float zsi[],float psr[],float psi[],float zzr[],float zzi[],float pzr[],float pzi[],int *nz,int *np,float fs);
double prwrp(float f,float fs);
int mod(int n,int m);
void cbylpf(float f1,float db1,float f2,float db2,int *n,float *fc,float sr[],float si[]);
void elplpf(float f1,float db1,float f2,float db2,float *fc,float psr[],float psi[],int *np,float zsr[],float zsi[],int *nz);
void lphp(float zzr[],float zzi[],float pzr[],float pzi[],int nz,int np,float zpr[],float zpi[],float ppr[],float ppi[],float fl,float fh,float fs);
void lpbp(float zzr[],float zzi[],float pzr[],float pzi[],int *nz,int *np,float zpr[],float zpi[],float ppr[],float ppi[],float fl,float f1,float f2,float fs);
void lpbs(float zzr[],float zzi[],float pzr[],float pzi[],int *nz,int *np,float zpr[],float zpi[],float ppr[],float ppi[],float fl,float f1,float f2,float fs);
void norcon(float zr[],float zi[],float pr[],float pi[],int nz,int np,int npt,double *gmax);





#define NP 50
#define NZ 50
#define NPT 200
#define FL (float)
#define DB (double)

FILE *iirDat_F;

int IIRDesign(char*modelName,float fs,float fpb,float fsb,float fpl,float fpu,float fsl,float fsu,float pbdb,float sbdb,int filterType,int desType)
#if 000 //COMMENTS
char *modelName;
float  fs,       /* Sampling frequency */
       fpb,      /* Passband freq. LP & HP filters */
       fsb,      /* Stopband freq. LP & HP filters */

       fpl,      /* Lower passband freq.BP & BS filters */
       fpu,      /* Upper  ______ ditto --------------  */
       fsl,      /* Lower stopband freq.BP & BS filters */
       fsu,      /* Upper ------- ditto --------------  */
       pbdb,     /* Passband ripple in db.  */
       sbdb;     /* Stopband attenuation in db.  */
int    filterType;
int	desType;
#endif

{




	double constant;
	float  fapb,fasb,thetap,alfa;
	float  zsr[51],zsi[51],psr[51],psi[51],zzr[51],zzi[51],pzr[51],pzi[51];
	float  c1r,c1i,zunr,zuni,tpdf,dfpl,dfpu,dfsl,dfsu,dfsb,fasb1,fasb2;
	float  k,dfpb,flpb,zc[2][100],pc[2][100],sub,x[250];
	char   ans,atype[2],ftype[32];
	float fc;
	int    iatype,iftype,ns,np,nzi,select,nz,i,ik,j;
	char fname[200];
	FILE *iirPZ_F;

	np = NP;
	nz = NZ;
	strcpy(fname,modelName);
	strcat(fname,".dat");
        iirDat_F = fopen(fname,"w");
        if(iirDat_F==NULL)   {
           printf("Could not open. \n");
        }

        iatype = desType;
	iftype = filterType;

	tpdf = 2.0*PI/fs;

	switch (iftype) {

	case LPASS:
        case HPASS:

                if (iftype == LPASS)
                   strcpy(ftype,"Lowpass");
                else
                   strcpy(ftype,"Highpass");

	        fprintf (iirDat_F,"Filter type : %s\nSampling Frequency [Hz]: %f\n",ftype,fs);
		fprintf (iirDat_F,"Maximum allowable ripple in passband [db] : %f\n",pbdb);
		fprintf (iirDat_F,"Minimum allowable stopband attenuation [db] : %f\n",sbdb);
		fprintf (iirDat_F,"Passband edge frequency [Hz] : %f\n",fpb);
		fprintf (iirDat_F,"Stopband edge frequency [Hz]  : %f\n",fsb);

		pbdb =  (-fabs( pbdb));
		sbdb =  (-fabs( sbdb));

        	if (iftype == LPASS) {
			fapb =  prwrp( fpb, fs);
			fasb =  prwrp( fsb, fs);
		}
                else  {
                        dfsb = tpdf*fsb;
            		dfpb = tpdf*fpb;
			fapb = 0.1*fs;
			thetap =  prwrp( fapb, fs);
			thetap = thetap*tpdf;
			alfa = (-cos((dfpb+thetap)/2)/cos((dfpb-thetap)/2));
			fasb = 2.*(1.+alfa)/(1.-alfa)/ tan( dfsb/2)/tpdf;
		}
		break;

	case BPASS:
	case BSTOP:

                if(iftype==BPASS)
                   strcpy(ftype,"Bandpass");
                else
                   strcpy(ftype,"Bandstop");

		fprintf (iirDat_F,"Filter type: %s\nSampling frequency [Hz] : %f\n",ftype,fs);
		fprintf (iirDat_F,"Maximum allowable ripple in passband [db] : %f\n",pbdb);
		fprintf (iirDat_F,"Maximum allowable attn. in stop band [db] : %f\n",sbdb);
		fprintf (iirDat_F,"Lower passband edge frequency [Hz] : %f\n",fpl);
		fprintf (iirDat_F,"Upper passband edge frequency [Hz] : %f\n",fpu);
		fprintf (iirDat_F,"Lower stopband edge frequency [Hz] : %f\n",fsl);
		fprintf (iirDat_F,"Upper stopband edge frequency [Hz] : %f\n",fsu);

		pbdb =  (-fabs( pbdb));
		sbdb =  (-fabs( sbdb));
		dfpl = tpdf*fpl;
		dfpu = tpdf*fpu;
		dfsl = tpdf*fsl;
		dfsu = tpdf*fsu;
		alfa =  (cos( (dfpu+dfpl)/2.)/cos( (dfpu-dfpl)/2.));
		if (iftype == 3){
			k = 0.1/ tan( (dfpu-dfpl)/2.);
			fasb1 =  fabs(fs*k*(alfa-cos( dfsu))/sin( dfsu));
			fasb2 =  fabs(fs*k*(alfa-cos( dfsl))/sin( dfsl));
			if (fasb1 > fasb2)
				fasb = fasb2;
			else
				fasb = fasb1;
			fapb = 0.1*fs;
		}


		else {
			k = 0.1* tan((dfpu-dfpl)/2.);
			fasb1 =  fabs(fs*k*sin( dfsu)/(cos( dfsu)-alfa));
			fasb2 = fabs(fs*k*sin( dfsl)/(cos( dfsl)-alfa));
			if (fasb1 > fasb2)
				fasb = fasb2;
			else
				fasb = fasb1;
			fapb = 0.1*fs;
		}
	}

	switch (iatype) {
	case BUTTERWORTH:
		bwlpf(fapb,pbdb,fasb,sbdb,&np,&fc,psr,psi);


		nz = 0;
		break;
	case CHEBYSHEV:
		cbylpf(fapb,pbdb,fasb,sbdb,&np,&fc,psr,psi);
		nz = 0;
		break;
	case ELLIPTIC:
		elplpf(fapb,pbdb,fasb,sbdb,&fc,psr,psi,&np,zsr,zsi,&nz);
		break ;
	}

       /*            ANALOG TO DIGITAL TRANSFORMATION
	      ALSO COMPUTE NORMALIZING CONSTANT FOR LATER USE    */

	sztran(zsr,zsi,psr,psi,zzr,zzi,pzr,pzi,&nz,&np,fs);
	flpb = fs/PI* atan((fapb*PI/fs));
	switch (iftype) {
	case LPASS:
	constant = 1.0;
	for (i = 1;i <= nz;++i)
		constant = constant/sqrt((1.0-zzr[i])*(1.0-zzr[i])+zzi[i]*zzi[i]);
	for (i = 1;i <= np;++i)
		constant = constant*sqrt((1.0-pzr[i])*(1.0-pzr[i])+pzi[i]*pzi[i]);
		break;
	case HPASS:

	/*         LOWPASS TO HIGHPASS TRANSFORMATION          */

		lphp(zzr,zzi,pzr,pzi,nz,np,zzr,zzi,pzr,pzi,flpb,fpb,fs);
                norcon(zzr,zzi,pzr,pzi,nz,np,NPT,&constant);
		break;
	case BPASS:

	/*         LOWPASS TO BANDPASS TRANSFORMATION           */

		lpbp(zzr,zzi,pzr,pzi,&nz,&np,zzr,zzi,pzr,pzi,flpb,fpl,fpu,fs);
                norcon(zzr,zzi,pzr,pzi,nz,np,NPT,&constant);
		break;
	case BSTOP:
		/*
	/*	   LOWPASS TO BANDSTOP TRANSFORMATION           */

		lpbs(zzr,zzi,pzr,pzi,&nz,&np,zzr,zzi,pzr,pzi,flpb,fpl,fpu,fs);
                norcon(zzr,zzi,pzr,pzi,nz,np,NPT,&constant);
		break;
	}
	strcpy(fname,modelName);
	strcat(fname,".pz");
        iirPZ_F = fopen(fname,"w");
        if(iirPZ_F == NULL){
           fprintf(stderr,"IIRDesign(): Could not open %s \n",fname);
	   return(1);
        }
        fprintf(iirPZ_F," %d %d \n",nz,np);

        for (i=1;i<=nz;++i)
           fprintf(iirPZ_F," %16.9e %16.9e \n",zzr[i],zzi[i]);
        for (i=1;i<=np;++i)
           fprintf(iirPZ_F," %16.9e %16.9e \n",pzr[i],pzi[i]);
	constant = 1.0/constant;
        fprintf(iirPZ_F," %f %16.9e \n",fs,constant);

	fclose(iirDat_F);
        fclose(iirPZ_F);


	return(0);

}
/*--------------------------------------------------------------------*/
/*	BUTTERWORTH LOW-PASS FILTER DESIGN. PROGRAM DETERMINES THE    */
/*	N LHP POLES S(1),S(2),...,S(N) IN THE S-PLANE FROM THE        */
/*	SPECIFICATIONS:						      */
/*							              */
/*		G(F1)**2=DB1  (IN DECIBELS)			      */
/*		G(F2)**2=DB2  (IN DECIBLES)			      */
/*--------------------------------------------------------------------*/
void bwlpf(float f1,float db1,float f2,float db2,int *n,float  *fc,float sr[],float si[])
//float sr[],si[],db1,f1,f2,db2,*fc;
//int *n;
{
	int nm,nt,k1,k2,i,k;
	float w,dw,wc,xn,t;
	nt = *n;

	/*	   CALCULATE FILTER ORDER N:                */

        xn =0.5*log((pow(10.0,-db1/10.0)-1)/(pow(10.0,-db2/10.0)-1))/log(f1/f2);
	*n = xn;
	t = xn-(*n);
	if (t > 0.0) *n += 1;

/* CHECK ARRAY SIZE PROVIDED. IF TOO SMALL, PRINT WARNING AND PROCEED */

	if (nt < *n)
		printf("Warning: Filter order = %d  greater than array size = %d\n",*n,nt);

/*     CALCULATE HALF-POWER FREQUENCY FC SUCH THAT FILTER  GAIN MEETS
 	      PASSBAND SPEC AND EXCEEDS STOPBAND SPEC.               */

	*fc = log(f1)-log(pow(10.0,-db1/10.0)-1.)/(2.*(*n));
	*fc = exp(*fc);
	wc = 2.*PI*(*fc);

	/*	      FIND LHP POLES		*/

	nm = mod(*n,2);
	k1 = *n/2+nm;
	k2 = 2*k1-1;
	dw = PI/(2.*(*n));
	for (k= k1;k <= k2;++k) {
		i = k-k1+1;
		w = k*PI/(*n);
		if (nm == 0) w += dw;
		sr[i] = wc*cos(w);
		si[i] = wc*sin(w);
		sr[*n-i+1] = sr[i];
		si[*n-i+1] = -si[i];
	}
	if (nm == 1) {
		si[k1] = 0.0;
	}

	/*  		PRINT RESULTS	         */

	fprintf (iirDat_F,"\n\n\n\n\n THE Butterworth lowpass filter design results are as follows:\n\n");
	fprintf (iirDat_F,"\n\n Filter order  = %d. Cutoff Frequency = %f \n\n",*n,*fc);
	fprintf (iirDat_F," The S-Plane Poles: Index     Real part          Imag part\n\n");
	for (i = 1;i <= *n;++i) {
		fprintf (iirDat_F,"\t\t      %3d     %14.7f    %14.7f\n",i,sr[i],si[i]);
	}
	return;
}
/*----------------------------------------------------------------*/
int dcel1(double *res,double ak)

{
	int ier;
	double geo,ari,aari,dum;
	ier = 0;
	ari = 2.0;
	geo = (0.5-ak)+0.5;
	geo = geo+geo*ak;
	*res = 0.5;
	if (geo < 0.0) {
		ier = 1;
		*res = 1.0e38;
	}
	else if (geo == 0.0) {
		*res = 1.0e38;
	}
	else {
		do {
			geo = sqrt(geo);
			geo = geo+geo;
			aari = ari;
			ari = ari+geo;
			*res += *res;
			dum = geo/aari-0.999999995;
			if (dum < 0.0) geo *= aari;
		}
		while (dum < 0.0);
		*res = *res/ari*2*PI;
	}
	return(ier);
}



void deli1(double * res,double x,double ck)

{
	double angle,geo,ari,pim,sqgeo,aari,test;
	int i,j,loop;
	i = 1;
	if (x == 0.0)  i = 2;
	switch(i) {
	case 1:
		j = 1;
		if (ck == 0.0) j = 2;
		switch(j) {
		case 1:
			angle = fabs(1.0/x);
			geo = fabs(ck);
			ari = 1.0;
			pim = 0.0;
			loop = 1;
			do {
				sqgeo = ari*geo;
				aari = ari;
				ari = geo+ari;
				angle = -sqgeo/angle+angle;
				sqgeo = sqrt(sqgeo);
				if (angle == 0.0)
					angle = sqgeo*1.0e-17;
				test = aari*1.0e-9;
				if (fabs(aari-geo)-test <= 0.0)
					loop = 0;
				else {
					geo = sqgeo+sqgeo;
					pim = pim+pim;
					if (angle < 0.0)
						pim += PI;
				}
			}
			while (loop == 1);
			if (angle < 0.0)
				pim += PI;
			*res = (atan(ari/angle)+pim)/ari;
			if (x < 0.0)
				*res = -*res;
			break;
		case 2:
			*res = log(fabs(x)+sqrt(1.0+x*x));
			if (x < 0.0)
				*res = -*res;
		}
		break;
	case 2:
		*res = 0.0;
	}
	return;
}
void djelf(double *sn,double *cn,double *dn,double x,double sck)
//double *sn,*cn,*dn,x,sck;
{
	double ari[12],geo[12],cm,y,a,b,c,d;
	int l,i,k;
	cm = sck;
	y = x;
	if (sck == 0.0) {
		d = exp(x);
		a = 1.0/d;
		b = a+d;
		*cn = 2.0/b;
		*dn = *cn;
		a = (d-a)/2.0;
		*sn = (*cn)*a;
	}
	else {
		if (sck < 0.0) {
			d = 1.0-sck;
			cm = -sck/d;
			d = sqrt(d);
			y = d*x;
		}
		a = 1.0;
		*dn = 1.0;
		for (i = 0;i < 12;i++) {
			l = i;
			ari[i] = a;
			cm = sqrt(cm);
			geo[i] = cm;
			c = (a+cm)*.5;
			if (fabs(a-cm)-1.0e-9*a <= 0.0)
				i = 13;
			else {
				cm *= a;
				a = c;
			}
		}
		y *= c;
		*sn = sin(y);
		*cn = cos(y);
		if (*sn != 0.0) {
			a = (*cn)/(*sn);
			c *= a;
			for (i = 0;i < l;i++) {
				k = l-i-1;
				b = ari[k];
				a *= c;
				c *= *dn;
				*dn = (geo[k]+a)/(b+a);
				a = c/b;
                        }
     			a = 1.0/sqrt(c*c+1.0);
			if (*sn < 0.0)
				*sn = -a;
			else
				*sn = a;
			*cn = (*sn)*c;
		}
		if (sck < 0.0) {
			a = *dn;
			*dn = *cn;
			*cn = a;
			*sn = *sn/d;
		}
	}
	return;
}
double prwrp(float f,float fs)

{
	double fp;
	fp = fs/PI*tan((f*PI/fs));
	return(fp);
}
/*--------------------------------------------------------------*/
/*     THIS ROUTINE PERFORMS THE S TO Z PLANE TRANSFORMATION.	*/
/*     THE ARGUMENTS ARE;					*/
/*								*/
/*             ZZ - Z-PLANE ZEROS (OUTPUT)			*/
/*             PZ - Z-PLANE POLES (OUTPUT)			*/
/*             ZS - S-PLANE ZEROS (INPUT)			*/
/*             PS - S-PLANE POLES (INPUT)			*/
/*             NZ - ON INPUT:  THE NUMBER OF S-PLANE ZEROS	*/
/*                  ON OUTPUT: THE NUMBER OF Z-PLANE ZEROS	*/
/*             NP - ON INPUT:  THE NUMBER OF S-PLANE POLES	*/
/*                  ON OUTPUT: THE NUMBER OF Z-PLANE POLES	*/
/*								*/
/*     NOTE: THE PZ ARRAY SHOULD BE DIMENSIONED			*/
/*                     NP   IF NP>NZ				*/
/*                     NZ   IF NP<NZ				*/
/*           THE ZZ ARRAY SHOULD BE DIMENSIONED			*/
/*                     NZ   IF NZ>NP				*/
/*                     NP   IF NZ<NP				*/
/*--------------------------------------------------------------*/

void sztran(float zsr[],float zsi[],float psr[],float psi[],float zzr[],float zzi[],float pzr[],float pzi[],int *nz,int *np,float fs)

//float zsr[],zsi[],psr[],psi[],zzr[],zzi[],pzr[],pzi[],fs;
//int *np,*nz;
{
	float tcnr,tcni,cfs,d;
	int nzt,nst,npt,i;
	/*
             DETERMINE AND PLACE THE POLES AND ZEROS AT Z=-1
								*/
	cfs = 2.*fs;
	npt = *nz-(*np);
	if (npt > 0) {
		for (i = 1;i <= npt;++i) {
			pzr[i] = -1.;
			pzi[i] = 0.0;
		}
	}
	nzt = *np-(*nz);
	if (nzt > 0) {
		for (i = 1;i <= nzt;++i) {
			zzr[i] = -1.;
			zzi[i] = 0.0;
		}
	}
	/*
	        DETERMINE AND PLACE THE REMAINING POLES
								*/
	if (npt < 0) npt = 0;
	if (*np != 0) {
		nst = npt+1;
		npt = npt+(*np);
		for (i = nst;i <= npt;++i) {
			tcnr = psr[i-nst+1];
			tcni = psi[i-nst+1];
			d = (cfs-tcnr)*(cfs-tcnr)+tcni*tcni;
			pzr[i] = (cfs*cfs-tcnr*tcnr-tcni*tcni)/d;
			pzi[i] = (2.*tcni*cfs)/d;
		}
	}
	/*
	       DETERMINE AND PLACE THE REMAINING ZEROS
				  		   	   */
	if (nzt < 0) nzt = 0;
	if (*nz != 0) {
		nst = nzt+1;
		nzt = nzt+(*nz);
		for (i = nst;i <= nzt;++i) {
			tcnr = zsr[i-nst+1];
			tcni = zsi[i-nst+1];
			d = (cfs-tcnr)*(cfs-tcnr)+tcni*tcni;
			zzr[i] = (cfs*cfs-tcnr*tcnr-tcni*tcni)/d;
			zzi[i] = (2.*tcni*cfs)/d;
		}
	}
	/*
     	    SET THE NUMBER OF POLES AND ZEROS AND PRINT RESULTS
						           	   */
	*np = npt;
	*nz = nzt;
	if (*nz <= 0)
		fprintf (iirDat_F,"\n\n\n No z-plane zeroes were found.\n");
	else {
		fprintf (iirDat_F,"\n\n\n\n\n The Bilinear transformation results for zeros are as below:\n\n");
		fprintf (iirDat_F,"\n The Z-Plane Zeros: Index     Real part          Imag part\n\n");
		for (i = 1;i <= *nz;++i)
			fprintf (iirDat_F,"\t\t     %3d     %14.7f     %14.7f\n",i,zzr[i],zzi[i]);
	}
	if (*np <= 0)
		fprintf (iirDat_F,"\n\n\n No z-plane poles were found.\n");
	else {
		fprintf (iirDat_F,"\n\n\n\n\n The bilinear transformation results for poles are as below:\n\n");
		fprintf (iirDat_F,"\n The Z-Plane Poles: Index     Real part          Imag part\n\n");
		for (i = 1;i <= *np;++i)
			fprintf (iirDat_F,"\t\t     %3d     %14.7f     %14.7f\n",i,pzr[i],pzi[i]);
	}
	return;
}
/*============================================================================*/
int mod(int n,int m)

{
	while(n >= 0) {
		if (n < m)
			return(n);
		n -= m;
	}
}
int max0(int x, int y)

{
	int r;
	if (x > y) r = x;
	else       r = y;
	return(r);
}
/*--------------------------------------------------------------*/
/*   CHEBYSHEV LOW-PASS FILTER DESIGN.  PROGRAM DETERMINES THE	*/
/*   FILTER ORDER N AND THE LOCATION OF THE N S-PLANE POLES	*/
/*   S(1),S(2),...S(N) FROM THE SPECIFICATIONS:			*/
/*								*/
/*            G(F1)**2=DB1   (IN DECIBELS)			*/
/*            G(F2)**2=DB2   (IN DECIBELS)			*/
/*								*/
/*     THE ARGUMENTS ARE:					*/
/*								*/
/*            F1  - PASSBAND FREQUENCY IN HZ (INPUT)		*/
/*            DB1 - MINIMUM PASSBAND GAIN IN DB (INPUT)		*/
/*            F2  - STOPBAND FREQUENCY IN HZ (INPUT)		*/
/*            DB2 - MAXIMUM STOPBAND GAIN IN DB (INPUT)		*/
/*            N   - ON INPUT:  SIZE OF S ARRAY			*/
/*                  ON OUTPUT: FILTER ORDER			*/
/*            FC  - CRITICAL FREQUENCY IN HZ (OUTPUT)		*/
/*            S   - COMPLEX ARRAY CONTAINING THE N		*/
/*                  S-PLANE POLES (OUTPUT)			*/
/*--------------------------------------------------------------*/
void cbylpf(float f1,float db1,float f2,float db2,int *n,float  *fc,float sr[],float si[])
//float f1,db1,f2,db2,sr[],si[],*fc;
//int *n;
{
	float eps,ws,cm,cn,cp1,gfst,gfs,cm1,alfa,sal,cal,dw,wc,w;
	int   k,k1,k2,nm,i,loop,nt;
	nt = *n;
	/*
		     CALCULATE FILTER ORDER
		*/
	eps = sqrt(1./pow(10.0,db1/10.)-1.0);
	*fc = f1;
	*n = 1;
	ws = f2/(*fc);
	gfs = pow(10.,db2/10.);
	cm1 =1.;
	cn =ws;
	loop = 1;
	while (loop == 1) {
		cp1 = 2.*ws*cn-cm1;
		gfst = 1./(1.+(eps*cn)*(eps*cn));
		cm1 = cn;
		cn = cp1;
		i = 1;
		if (gfst <= gfs) i = 2;
		switch(i) {
		case 1:
			*n += 1;
			if (*n != 50) break;
			printf("Warning: Filter order greater than 50.Truncated to 50 \n");
                          break;
		case 2:
			if (nt >= *n) {
				loop = 0;
				break;
			}
			printf ("WARNING: Filter order = %d",*n);
			printf (" is greater than array size = %d .\n",nt);
                        loop = 0;
			break;
		}
	}
	/*
		                FIND LHP POLES
		*/
	nm = mod(*n,2);
	k1 = *n/2+nm;
	k2 = 2*k1-1;
	alfa = 1./(*n)*log(1./eps+sqrt(1./(eps*eps)+1));
	sal = sinh(alfa);
	cal = cosh(alfa);
	dw = PI/(2.*(*n));
	wc = 2.*PI*(*fc);
	for (k = k1;k <= k2;k++) {
		i = k-k1+1;
		w = k*PI/(*n);
		if (nm == 0) w = w+dw;
		sr[i] = wc*sal*cos(w);
		si[i] = wc*cal*sin(w);
		sr[*n+1-i] = sr[i];
		si[*n+1-i] = -si[i];
	}
	if (nm == 1)
		si[k1] = 0.0;
	/*
		        PRINT RESULTS
		*/
	fprintf (iirDat_F,"\n\n\n\n\n The Chebyshev filter design results are as follows:\n\n");
	fprintf (iirDat_F,"\n Filter order = %d  Cutoff Frequency = %f\n\n",*n,*fc);
	fprintf (iirDat_F," THE S-Plane Poles: Index     Real part          Imag part\n\n");
	for (i = 1;i <= *n;i++)
		fprintf (iirDat_F,"\t\t     %3d     %14.7f     %14.7f\n",i,sr[i],si[i]);
	return;
}
/*--------------------------------------------------------------*/
/*  ELLIPTICAL LOW-PASS FILTER DESIGN.  PROGRAM DETERMINES THE	*/
/*  NUMBER OF POLES AND ZEROS AND THEIR LOCATIONS IN THE S-PLANE*/
/*  FROM THE SPECIFICATIONS:					*/
/*								*/
/*            G(F1)**2=DB1  (IN DECIBELS)			*/
/*            G(F2)**2=DB1  (IN DECIBELS)			*/
/*								*/
/*    THE ARGUMENTS ARE:					*/
/*								*/
/*            F1  - PASSBAND FREQUENCY IN HZ (INPUT)		*/
/*            DB1 - MINIMUM PASSBAND GAIN IN DB (INPUT)		*/
/*            F2  - STOPBAND FREQUENCY IN HZ (INPUT)		*/
/*            DB2 - MAXIMUM STOPBAND GAIN IN DB (INPUT)		*/
/*            FC  - CRITICAL FREQUENCY IN HZ (OUTPUT)		*/
/*            PS  - COMPLEX ARRAY CONTAINING POLES (OUTPUT)	*/
/*            NP  - ON INPUT:  SIZE OF ARRAY PC			*/
/*                  ON OUTPUT: NUMBER OF POLES			*/
/*            ZS  - COMPLEX ARRAY CONTAINING ZEROS (OUTPUT)	*/
/*            NZ  - ON INPUT:  SIZE OF ARRAY ZS			*/
/*                  ON OUTPUT: NUMBER OF ZEROS			*/
/*--------------------------------------------------------------*/
void elplpf(float f1,float db1,float f2,float db2,float *fc,float psr[],float psi[],int *np,float zsr[],float zsi[],int *nz)
//float psr[],psi[],zsr[],zsi[],f1,f2,db1,db2,*fc;
//int *np,*nz;
{
	double k,k1,kp,kt,ckk,ckk1,ckpk,ckpk1,wc,wr,swc,eps,a,u0,reps,qp,qz,sck;
	double cnqp,dnqp,r,den,snqp,dnr,xn,xp,snqz,cnqz,dnqz,snr,cnr;
	int i,nt,nm,k2,ier;
	nt = *np;
	wc = 2.*PI*f1;
	wr = 2.*PI*f2;
	swc = wc;
	*fc = f1;
	/*
	       DETERMINE EPS, A, K, AND K1
				*/
	eps = sqrt(1./pow(10., db1/10.)-1.);
	a = sqrt(1./pow(10.,db2/10.));
	k = wc/wr;
	k1 = eps/sqrt(a*a-1.);
	/*
	       CALCULATE CKK, CKPK, CKK1, CKPK1, U0, AND NP
				*/
	ier = dcel1(&ckk,k);
	ier = dcel1(&ckk1,k1);
	kp = sqrt(1.-k*k);
	ier = dcel1(&ckpk,kp);
	kt = sqrt(1.-k1*k1);
	ier = dcel1(&ckpk1,kt);
	xn = (ckpk1/ckk1)*(ckk/ckpk);
	*np = xn;
	if ((xn-(*np)) > 0.0)
		*np += 1;
	reps = 1./eps;
	deli1(&u0,reps,k1);
	u0 = (ckk/ckk1)*(fabs(u0)/(*np));
	/*
	        CHECK ARRAY SIZE PROVIDED.  IF TOO SMALL PRINT WARNING AND PROCEED
				*/
	if (nt <= *np) {
           printf ("WARNING: # of poles = %d greater than array size= %d specified in this program\n",*np,nt);
        }
	/*
	        DETERMINE POLES AND ZEROS IN S-PLANE
				*/
	nm = mod(*np,2);
	*nz = *np-nm;
	k2 = *np/2+nm;
	qp = -u0;
	qz = -ckpk;
	sck = 1.-kp*kp;
	djelf(&snqp,&cnqp,&dnqp,qp,sck);
	djelf(&snqz,&cnqz,&dnqz,qz,sck);
	sck = 1.-k*k;
	for (i = 1;i <= k2;++i) {
		r = ckk*(1.-(2*i-1.)/(*np));
		djelf(&snr,&cnr,&dnr,r,sck);
		den = 1.-snqp*snqp*dnr*dnr;
		psr[i] = FL (swc*snqp*cnqp*cnr*dnr/den);
		psi[i] = FL (swc*snr*dnqp/den);
		if (nm == 1 && i ==k2);
		else {
			den = 1.-snqz*snqz*dnr*dnr;
			zsr[i] = 0.0;
			zsi[i] = FL (swc*snr*dnqz/den);
			psr[*np-i+1] = psr[i];
			psi[*np-i+1] = -psi[i];
			zsr[*nz-i+1] = zsr[i];
			zsi[*nz-i+1] = -zsi[i];
		}
	}
	/*
	        PRINT RESULTS
				*/
	fprintf (iirDat_F,"\n\n\n\n\n The Elliptic filter design results are as follows:\n\n");
	fprintf (iirDat_F,"# of zeroes = %d. # of poles  = %d. Cutoff Frequency = %14.7f\n\n",*nz,*np,*fc);
	if (*nz != 0){
		fprintf (iirDat_F,"\n THE S-Plane Zeros: Index     Real part          Imag part\n\n");
		for (i = 1;i <= (*nz);++i)
			fprintf (iirDat_F,"\t\t     %3d     %14.7f     %14.7f\n",i,zsr[i],zsi[i]);
	}
	fprintf (iirDat_F,"\n\n THE S-Plane poles: Index     Real part          Imag part\n\n");
	for (i = 1;i <= (*np);++i)
		fprintf (iirDat_F,"\t\t     %3d     %14.7f    %14.7f\n",i,psr[i],psi[i]);
	return;
}
/*--------------------------------------------------------------*/
/*ROUTINE TO TRANSFORM A LOW-PASS TO A HIGH-PASS DIGITAL FILTER.*/
/*THE ARGUMENTS ARE:						*/
/*								*/
/*            ZZ - Z-PLANE ZEROS OF LP FILTER			*/
/*            PZ - Z-PLANE POLES OF LP FILTER			*/
/*            NZ - NUMBER OF ZEROS				*/
/*            NP - NUMBER OF POLES				*/
/*            ZP - Z-PLANE ZEROS OF HP FILTER			*/
/*            PP - Z-PLANE POLES OF HP FILTER			*/
/*            FL - LOW-PASS CUTOFF FREQUENCY (HZ)		*/
/*            FH - HIGH-PASS CUTOFF FREQUENCY (HZ)		*/
/*            FS - SAMPLING RATE (HZ)				*/
/*--------------------------------------------------------------*/
void lphp(float zzr[],float zzi[],float pzr[],float pzi[],int nz,int np,float zpr[],float zpi[],float ppr[],float ppi[],float fl,float fh,float fs)
//float zzr[],zzi[],pzr[],pzi[],zpr[],zpi[],ppr[],ppi[];
//float fl,fh,fs;
//int np,nz;
{
	float theta,omega,alfa,d;
	int i;
	/*
	        CALCULATE THETA,OMEGA, AND ALFA
		*/
	theta = 2.*fl/fs*PI;
	omega = 2.*fh/fs*PI;
	alfa = (-cos((theta+omega)/2.)/cos((omega-theta)/2.));
	/*
	        TRANSFORM POLES AND ZEROS
		*/
	for (i = 1; i<= nz;++i) {
		d = (1.+alfa*zzr[i])*(1.+alfa*zzr[i])+(alfa*zzi[i])*(alfa*zzi[i]);
		zpr[i] = -((alfa+zzr[i])*(1.+alfa*zzr[i])+alfa*zzi[i]*zzi[i])/d;
		zpi[i] = -((1.+alfa*zzr[i])*zzi[i]-(alfa+zzr[i])*alfa*zzi[i])/d;
	}
	for (i = 1; i<= np;++i) {
		d = (1.+alfa*pzr[i])*(1.+alfa*pzr[i])+(alfa*pzi[i])*(alfa*pzi[i]);
		ppr[i] = -((alfa+pzr[i])*(1.+alfa*pzr[i])+alfa*pzi[i]*pzi[i])/d;
		ppi[i] = -((1.+alfa*pzr[i])*pzi[i]-(alfa+pzr[i])*alfa*pzi[i])/d;
	}
	/*
	         PRINT RESULTS
		*/
	fprintf (iirDat_F,"\n\n\n\n\n The results of lowpass to highpass\n");
	fprintf (iirDat_F," filter transformation are as below:\n\n");
	fprintf (iirDat_F," The Z-Plane Zeros: Index     Real part           Imag part\n\n");
	for (i = 1;i <= nz;++i)
		fprintf (iirDat_F,"\t\t     %3d     %14.7f     %14.7f\n",i,zpr[i],zpi[i]);
	fprintf (iirDat_F,"\n The Z-Plane Poles: Index     Real part           Imag part\n\n");
	for (i = 1;i <= np;++i)
		fprintf (iirDat_F,"\t\t     %3d     %14.7f     %14.7f\n",i,ppr[i],ppi[i]);
	return;
}
/*--------------------------------------------------------------*/
/* ROUTINE TO TRANSFORM A LOW-PASS TO A BANDPASS DIGITAL FILTER.*/
/* THE ARGUMENTS ARE:						*/
/*								*/
/*            ZZ - Z-PLANE ZEROS OF LP FILTER			*/
/*            PZ - Z-PLANE POLES OF LP FILTER			*/
/*            NZ - ON INPUT:  NUMBER OF ZEROS IN LP FILTER	*/
/*                 ON OUTPUT: NUMBER OF ZEROS IN BP FILTER 	*/
/*            NP - ON INPUT:  NUMBER OF POLES IN LP FILTER	*/
/*                 ON OUTPUT: NUMBER OF POLES IN BP FILTER	*/
/*            ZP - Z-PLANE ZEROS OF BP FILTER			*/
/*            PP - Z-PLANE POLES OF BP FILTER			*/
/*            FL - CUTOFF FREQUENCY OF LP FILTER (HZ)		*/
/*            F1 - LOWER CUTOFF FREQUENCY OF BP FILTER (HZ)	*/
/*            F2 - UPPER CUTOFF FREQUENCY OF BP FILTER (HZ)	*/
/*            FS - SAMPLING RATE (HZ)				*/
/*--------------------------------------------------------------*/
void lpbp(float zzr[],float zzi[],float pzr[],float pzi[],int *nz,int *np,float zpr[],float zpi[],float ppr[],float ppi[],float fl,float f1,float f2,float fs)
//float zzr[],zzi[],zpr[],zpi[],ppr[],ppi[],pzr[],pzi[];
//float fl,f1,f2,fs;
//int *np,*nz;
{
	float aar,aai,bbr,bbi,ccr,cci,ddr,ddi,eer,eei;
	float alfa,k,omega1,omega2,theta,a,b,c,d,r,w;
	int i;
	/*
	        CALCULATE ALFA,K,OMEGA1,OMEGA2,AND THETA
		*/
	theta = 2.*fl/fs*PI;
	omega1 = 2.*f1/fs*PI;
	omega2 = 2.*f2/fs*PI;
	alfa = (cos((omega2+omega1)/2.)/cos((omega2-omega1)/2.));
	k = (tan(theta/2.)/tan((omega2-omega1)/2.));
	/*
	        CALCULATE ZEROS AND POLES
		*/
	c = -2.*alfa*k/(k+1.);
	d = (k-1.)/(k+1.);
	for (i = 1;i <= *nz;++i){
		aar = d+zzr[i];
		aai = zzi[i];
		bbr = c*(1.+zzr[i]);
		bbi = c*zzi[i];
		ccr = 1.+zzr[i]*d;
		cci = zzi[i]*d;
		ddr = -bbr;
		ddi = -bbi;
		a = bbr*bbr-bbi*bbi-4.*(aar*ccr-aai*cci);
		b = 2.*bbr*bbi-4.*(aar*cci+aai*ccr);
		r = sqrt(sqrt((a*a+b*b)));
		w = atan2(b,a)/2.0;
		eer = r*cos(w);
		eei = r*sin(w);
		a = (aar*aar+aai*aai)*2.;
		zpr[i] = ((ddr+eer)*aar+(ddi+eei)*aai)/a;
		zpi[i] = ((ddi+eei)*aar-(ddr+eer)*aai)/a;
		zpr[*nz+i] = ((ddr-eer)*aar+(ddi-eei)*aai)/a;
		zpi[*nz+i] = ((ddi-eei)*aar-(ddr-eer)*aai)/a;
                r = sqrt((zpr[i]*zpr[i]+zpi[i]*zpi[i]));
                if (r > 1.0) {
                        w = atan2(zpi[i],zpr[i]);
			zpr[i] = cos(w)/r;
			zpi[i] = sin(w)/r;
		}
                r = sqrt((zpr[*nz+i]*zpr[*nz+i]+zpi[*nz+i]*zpi[*nz+i]));
                if (r > 1.0) {
                        w = atan2(zpi[*nz+i],zpr[*nz+i]);
			zpr[*nz+i] = cos(w)/r;
			zpi[*nz+i] = sin(w)/r;
		}
	}
	for (i = 1;i <= *np;++i){
		aar = d+pzr[i];
		aai = pzi[i];
		bbr = c*(1.+pzr[i]);
		bbi = c*pzi[i];
		ccr = 1.+pzr[i]*d;
		cci = pzi[i]*d;
		ddr = -bbr;
		ddi = -bbi;
		a = bbr*bbr-bbi*bbi-4.*(aar*ccr-aai*cci);
		b = 2.*bbr*bbi-4.*(aar*cci+aai*ccr);
		r = sqrt(sqrt((a*a+b*b)));
		w = atan2(b,a)/2.0;
		eer = r*cos(w);
		eei = r*sin(w);
		a = (aar*aar+aai*aai)*2.;
		ppr[i] = ((ddr+eer)*aar+(ddi+eei)*aai)/a;
		ppi[i] = ((ddi+eei)*aar-(ddr+eer)*aai)/a;
		ppr[*np+i] = ((ddr-eer)*aar+(ddi-eei)*aai)/a;
		ppi[*np+i] = ((ddi-eei)*aar-(ddr-eer)*aai)/a;
                r = sqrt((ppr[i]*ppr[i]+ppi[i]*ppi[i]));
                if (r > 1.0) {
                        w = atan2(ppi[i],ppr[i]);
			ppr[i] = cos(w)/r;
			ppi[i] = sin(w)/r;
		}
                r = sqrt((ppr[*np+i]*ppr[*np+i]+ppi[*np+i]*ppi[*np+i]));
                if (r > 1.0) {
                        w = atan2(ppi[*np+i],ppr[*np+i]);
			ppr[*np+i] = cos(w)/r;
			ppi[*np+i] = sin(w)/r;
		}
	}
	*nz *= 2;
	*np *= 2;
	/*
	        PRINT RESULTS
		*/
	fprintf (iirDat_F,"\n\n\n\n\n The results of lowpass to bandpass\n");
	fprintf (iirDat_F," filter transformation are as follows:\n\n");
	fprintf (iirDat_F," The Z-Plane Zeros: Index     Real part          Imag part\n\n");
	for (i = 1;i <= *nz;++i)
		fprintf (iirDat_F,"\t\t     %3d     %14.7f     %14.7f\n",i,zpr[i],zpi[i]);
	fprintf (iirDat_F,"\n The Z-Plane poles: Index     Real part          Imag part\n\n");
	for (i = 1;i <= *np;++i)
		fprintf (iirDat_F,"\t\t     %3d     %14.7f     %14.7f\n",i,ppr[i],ppi[i]);
	return;
}
/*--------------------------------------------------------------*/
/* ROUTINE TO TRANSFORM A LOW-PASS TO A BANDSTOP DIGITAL FILTER.*/
/* THE ARGUMENTS ARE:						*/
/*								*/
/*            ZZ - Z-PLANE ZEROS OF LP FILTER			*/
/*            PZ - Z-PLANE POLES OF LP FILTER			*/
/*            NZ - ON INPUT:  NUMBER OF ZEROS IN LP FILTER	*/
/*                 ON OUTPUT: NUMBER OF ZEROS IN BS FILTER 	*/
/*            NP - ON INPUT:  NUMBER OF POLES IN LP FILTER	*/
/*                 ON OUTPUT: NUMBER OF POLES IN BS FILTER	*/
/*            ZP - Z-PLANE ZEROS OF BS FILTER			*/
/*            PP - Z-PLANE POLES OF BS FILTER			*/
/*            FL - CUTOFF FREQUENCY OF LP FILTER (HZ)		*/
/*            F1 - LOWER CUTOFF FREQUENCY OF BS FILTER (HZ)	*/
/*            F2 - UPPER CUTOFF FREQUENCY OF BS FILTER (HZ)	*/
/*            FS - SAMPLING RATE (HZ)				*/
/*--------------------------------------------------------------*/
void lpbs(float zzr[],float zzi[],float pzr[],float pzi[],int *nz,int *np,float zpr[],float zpi[],float ppr[],float ppi[],float fl,float f1,float f2,float fs)
//float zzr[],zzi[],zpr[],zpi[],ppr[],ppi[],pzr[],pzi[];
//float fl,f1,f2,fs;
//int *np,*nz;
{
	float aar,aai,bbr,bbi,ccr,cci,ddr,ddi,eer,eei;
	float alfa,k,omega1,omega2,theta,a,b,c,d,r,w;
	int i;
	/*
	        CALCULATE ALFA,K,OMEGA1,OMEGA2,AND THETA
		*/
	theta = 2.*fl/fs*PI;
	omega1 = 2.*f1/fs*PI;
	omega2 = 2.*f2/fs*PI;
        alfa= (cos((omega2+omega1)/2.)/cos((omega2-omega1)/2.));
	k = FL (tan(theta/2.)*tan((omega2-omega1)/2.));
	/*
	        CALCULATE ZEROS AND POLES
		*/
	c = -2.*alfa/(k+1.);
	d = (1.-k)/(1.+k);
	for (i = 1;i <= *nz;++i){
		aar = d-zzr[i];
		aai = -zzi[i];
		bbr = c*(1.-zzr[i]);
		bbi = -c*zzi[i];
		ccr = 1.-zzr[i]*d;
		cci = -zzi[i]*d;
		ddr = -bbr;
		ddi = -bbi;
		a = bbr*bbr-bbi*bbi-4.*(aar*ccr-aai*cci);
		b = 2.*bbr*bbi-4.*(aar*cci+aai*ccr);
		r = sqrt(sqrt((a*a+b*b)));
		w = atan2(b,a)/2.;
		eer = r*cos(w);
		eei = r*sin(w);
		a = (aar*aar+aai*aai)*2.;
		zpr[i] = ((ddr+eer)*aar+(ddi+eei)*aai)/a;
		zpi[i] = ((ddi+eei)*aar-(ddr+eer)*aai)/a;
		zpr[*nz+i] = ((ddr-eer)*aar+(ddi-eei)*aai)/a;
		zpi[*nz+i] = ((ddi-eei)*aar-(ddr-eer)*aai)/a;
                r = sqrt((zpr[i]*zpr[i]+zpi[i]*zpi[i]));
                if (r > 1.0) {
                        w = atan2(zpi[i],zpr[i]);
			zpr[i] = cos(w)/r;
			zpi[i] = sin(w)/r;
		}
                r = sqrt((zpr[*nz+i]*zpr[*nz+i]+zpi[*nz+i]*zpi[*nz+i]));
                if (r > 1.0) {
                        w = atan2(zpi[*nz+i],zpr[*nz+i]);
			zpr[*nz+i] = cos(w)/r;
			zpi[*nz+i] = sin(w)/r;
		}
	}
	for (i = 1;i <= *np;++i){
		aar = d-pzr[i];
		aai = -pzi[i];
		bbr = c*(1.-pzr[i]);
		bbi = -c*pzi[i];
		ccr = 1.-pzr[i]*d;
		cci = -pzi[i]*d;
		ddr = -bbr;
		ddi = -bbi;
		a = bbr*bbr-bbi*bbi-4.*(aar*ccr-aai*cci);
		b = 2.*bbr*bbi-4.*(aar*cci+aai*ccr);
		r = sqrt(sqrt((a*a+b*b)));
		w = atan2(b,a)/2.;
		eer = r* cos(w);
		eei = r* sin(w);
		a = (aar*aar+aai*aai)*2.;
		ppr[i] = ((ddr+eer)*aar+(ddi+eei)*aai)/a;
		ppi[i] = ((ddi+eei)*aar-(ddr+eer)*aai)/a;
		ppr[*np+i] = ((ddr-eer)*aar+(ddi-eei)*aai)/a;
		ppi[*np+i] = ((ddi-eei)*aar-(ddr-eer)*aai)/a;
                r = sqrt((ppr[i]*ppr[i]+ppi[i]*ppi[i]));
                if (r > 1.0) {
                        w = atan2(ppi[i],ppr[i]);
			ppr[i] = cos(w)/r;
			ppi[i] = sin(w)/r;
		}
                r = sqrt((ppr[*np+i]*ppr[*np+i]+ppi[*np+i]*ppi[*np+i]));
                if (r > 1.0) {
                        w = atan2(ppi[*np+i],ppr[*np+i]);
			ppr[*np+i] = cos(w)/r;
			ppi[*np+i] = sin(w)/r;
		}
	}
	*nz *= 2;
	*np *= 2;
	/*
	        PRINT RESULTS
		*/
	fprintf (iirDat_F,"\n\n\n\n\n The results of lowpass to bandstop\n");
	fprintf (iirDat_F," filter transformation results are as follows:\n\n");
	fprintf (iirDat_F," The Z-Plane Zeros: Index     Real part          Imag part\n\n");
	for (i = 1;i <= *nz;++i)
		fprintf (iirDat_F,"\t\t     %3d     %14.7f     %14.7f\n",i,zpr[i],zpi[i]);
	fprintf (iirDat_F,"\n The Z-Plane Poles: Index     Real part          Imag part\n\n");
	for (i = 1;i <= *np;++i)
		fprintf (iirDat_F,"\t\t     %3d     %14.7f    %14.7f\n",i,ppr[i],ppi[i]);
	return;
}



void norcon(float zr[],float zi[],float pr[],float pi[],int nz,int np,int npt,double *gmax)
//float zr[],zi[],pr[],pi[];
//double *gmax;
//int np,nz,npt;
{
    int i,j,dp;
    double x,y,w;
    float g[302];

	*gmax = 0.0;
     for (i = 0;i < npt;i++){
         w = PI/(float)(npt-1)*(float)i;
         g[i] = 1.0;
         for (j = 1;j <= np;j++){
             x = 1.0-pr[j]*cos(w)-pi[j]*sin(w);
             y = pr[j]*sin(w)-pi[j]*cos(w);
             g[i] = g[i]/sqrt(x*x+y*y);
         }
         for (j = 1;j <= nz;j++){
             x = 1.0-zr[j]*cos(w)-zi[j]*sin(w);
             y = zr[j]*sin(w)-zi[j]*cos(w);
             g[i] = g[i]* sqrt(x*x+y*y);
         }
         if (g[i] > *gmax)
            *gmax = g[i];
     }
     if(*gmax == 0) *gmax = 1.0;
     *gmax = 1.0/(*gmax);
     return;
}

