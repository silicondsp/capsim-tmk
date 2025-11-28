
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


#include "capsim.h"

/*
 *  krn_traverse.c
 *
 * Written by Sasan H. Ardalan
 */

#define DELTA_X 10
#define DELTA_Y 40
#define DELTA_TEXT_Y 4
#define DELTA_TEXT_X 0
#define DELTA_GAL 25

extern int line_mode;
extern int model_count;
extern int graphics_mode;
extern block_Pt pb_error;
extern block_Pt pb_current;
extern block_Pt pg_current;

void Krn_DrawTopology(char	*fileName,int	starFlag);
void KrnDrawTopology(block_Pt blk_P,FILE *fp,float x,float y,int galNumber,int starFlag);

/********************************************************************
 *
 *                           Krn_Command.c
 *
 *   Sends a command to the Capsim line interpreter.
 *
 *********************************************************************
 */
 int Krn_Command(string)

char    string[];

{

        int     err;


if((err = string_com(string)))
        ErrorPrint(" Capsim line command error", err);

return(err);

}



 void KrnTraversePostOrder(blk_P,numberBlks_P,
		numberGalaxies_P,maxBlkLevel_P,depth_P)

block_Pt blk_P;
int	*depth_P;
int	*numberBlks_P;
int	*maxBlkLevel_P;
int	*numberGalaxies_P;

{
block_Pt blkSave_P;
block_Pt blkCurrent_P;
int	blkCount;

blk_P=blk_P->pchild;


	blkCurrent_P=blk_P;
	blkSave_P = blkCurrent_P;
	blkCount=0;
	/*
	 *  Go through current galaxy and count stars
	 */
	do {

                blkCurrent_P = blkCurrent_P->pfsibling;
		blkCount++;

	} while(blkCurrent_P != blkSave_P);

	*(numberBlks_P) += blkCount;
	if(*(maxBlkLevel_P) < blkCount)
		*(maxBlkLevel_P) = blkCount;


/*
 *  Go through current galaxy and count stars
 */
blkCurrent_P=blk_P;
blkSave_P = blkCurrent_P;
do {
        blkCurrent_P = blkCurrent_P->pfsibling;

	if(blkCurrent_P->type==GTYPE) {
		*(numberGalaxies_P) += 1;
		KrnTraversePostOrder(blkCurrent_P,
			numberBlks_P,numberGalaxies_P,maxBlkLevel_P,depth_P);
	}


} while(blkCurrent_P != blkSave_P);




return;;
}


 void Krn_GetState(int	*numberBlks_P,int	*numberGalaxies_P,int	*maxBlkLevel_P,int	*depth_P)


{
block_Pt blkGal_P;
block_Pt blk_P;
///void Krn_DrawTopology();

/*
 * Go to the top and get the universe
 */
blkGal_P=pg_current;

while(blkGal_P->pparent != NULL) {
          blk_P = blkGal_P;
          blkGal_P = blk_P->pparent;
}

/*
 * blkGal_P is now the universe
 */
*(maxBlkLevel_P)= 0;
*(numberGalaxies_P) = 0;
*(numberBlks_P) = 0;
KrnTraversePostOrder(blkGal_P,numberBlks_P,numberGalaxies_P,maxBlkLevel_P,depth_P);



return;;
}

#ifdef EMBEDDED_ECOS

 void Krn_DrawTopology(fileName,starFlag)
char	*fileName;
int	starFlag;
{
return;
}


#else
 void Krn_DrawTopology(char	*fileName,int	starFlag)

{
block_Pt blkGal_P;
block_Pt blk_P;
FILE	*fp;


fp=fopen(fileName,"w");
if(fp == NULL) {
	fprintf(stderr,"Could not open file for creating drawing\n");
	return;;
}


/*
 * Go to the top and get the universe
 */
blkGal_P=pg_current;

while(blkGal_P->pparent != NULL) {
          blk_P = blkGal_P;
          blkGal_P = blk_P->pparent;
}

/*
 * blkGal_P is now the universe
 */
fprintf(fp,"2.0    996.0 -1 %s\n",blkGal_P->name);
KrnDrawTopology(blkGal_P,fp,0.0,1000.0,(int)0,starFlag);

fclose(fp);




return;;
}



void KrnDrawTopology(block_Pt blk_P,FILE *fp,float x,float y,int galNumber,int starFlag)


{
block_Pt blkSave_P;
block_Pt blkCurrent_P;
int	blkCount;
float	yblk,xblk,width;
float	xText,yText;
int	galCount;

blk_P=blk_P->pchild;


blkCurrent_P=blk_P;
blkSave_P = blkCurrent_P;
blkCount=0;
/*
 *  Go through current galaxy and count stars
 */
do {

        blkCurrent_P = blkCurrent_P->pfsibling;
	blkCount++;

} while(blkCurrent_P != blkSave_P);

width=DELTA_X*blkCount;
xblk= x - width/2.0;
yblk= y-DELTA_Y-galNumber*DELTA_GAL;


blkCurrent_P=blk_P;
blkSave_P = blkCurrent_P;
/*
 *  Go through current galaxy and count stars
 */
do {

        blkCurrent_P = blkCurrent_P->pfsibling;

} while(blkCurrent_P != blkSave_P);



/*
 *  Go through current galaxy and count stars
 */
galCount=0;
blkCurrent_P=blk_P;
blkSave_P = blkCurrent_P;
do {

	if((blkCurrent_P->type==GTYPE && !starFlag) || starFlag) {

		xblk += DELTA_X;
		xText=xblk+ DELTA_TEXT_X;
		yText=yblk + DELTA_TEXT_Y;
		fprintf(fp,"%e %e -1 %s\n",xText,yText,blkCurrent_P->name);
		fprintf(fp,"%e %e  0\n",x,y);
		fprintf(fp,"%e %e  1\n",xblk,yblk);
	}


	if(blkCurrent_P->type==GTYPE) {
		KrnDrawTopology(blkCurrent_P,
			fp,xblk,yblk,galCount,starFlag);
		galCount++;
	}

        blkCurrent_P = blkCurrent_P->pfsibling;

} while(blkCurrent_P != blkSave_P);


fprintf(fp,"%e %e  0\n",xblk+DELTA_X,yblk);


return;;
}
#endif
