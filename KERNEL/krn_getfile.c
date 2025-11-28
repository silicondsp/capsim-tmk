

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
#ifndef DOS
//#include <unistd.h>
#endif
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
#include "capsim.h"

/*
 * Given a file name and a buffer, read the whole
 * file into the buffer. Return the number of bytes read
 */


int KrnGetFileContent(char *fileName, char *buffer, int max) {

int fd;
int i;
int n;

for(i=0; i< max; i++) buffer[i]=0;

fd=open(fileName,O_RDONLY);
if(fd <0) return(-1);
n=read(fd,buffer, 10000);

close(fd);

return(n);

}


int KrnGetLine(char *line, int max, char *buffer, int *ptr_P, int bufferLength)
{
  int i;
  int ptr;

  ptr=*ptr_P;
  if(ptr  >= bufferLength) {
     return(0);

  }

  if(ptr  > MAX_TOP_FILE_SIZE) {
     return(0);

  }
  i=0;
  while(buffer[ptr] != 0x0a && i < max-1 && ptr <MAX_TOP_FILE_SIZE ) {
        line[i]=buffer[ptr];
        i++; ptr++;
  }
  line[i]=buffer[ptr];
  i++;
  ptr++;
  line[i]=0;
  *ptr_P=ptr;

  return(1);



}
