

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

int FwQuant(float x,float xmax,int qbits)

{
   short int xq,ql,qlm1;
   ql=1; ql <<= qbits-1;
   qlm1=ql-1;
   xq = x/xmax*ql;
   if (xq >= qlm1 ) xq=qlm1;
   if (xq< -ql ) xq= -ql;
   return (xq);
}

int FwFrcn(float lambda)

{
   int j,lab;
   float fr;
       fr=1.0;
       lab=0;
       for (j=1;j<5;j++) {
          fr=fr/2.0;
          lab= lab << 1;
          if ((lambda-fr) >= 0.0) {
              lab += 1;
              lambda =lambda -fr;
          }
       }
   return (lab);
}






int FwAlpha(short int mu,short int nu,short int alf1,int Pr,int alf,int kf)

{
     int xl,x,overflow,i;
     int xp,xs;
        x=mu*nu;
        xs=x >> 15+kf-alf;
        overflow=0;
        xp=alf1;
        xl=alf1;
        for (i=1;i<Pr;i++) {
             xl=xl*xs;
             xl >>= alf;
             xp += xl;
             if (xp > 32767 ) overflow=1;
        }
        if (overflow == 1) xp = 32767;
        return(xp);
}


int FwRound(int x,int shift)

{
     int shift1,xr;
     if(shift == 0) return(x);
     shift1=shift-1;
     xr = x >> shift1;
     if  (xr != 0) {
     xr += 1;
     xr >>= 1;
     }
     return (xr);
}

