
//#include <malloc.h>
#include <stdio.h>
#include <stdlib.h>



float *vector(int nn)

{
	float *v;

	v=(float *)malloc((unsigned) (nn+1)*sizeof(float));
	if (!v) fprintf(stderr,"allocation failure in vector()\n");
	return v;
}

