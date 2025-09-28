
#include <stdio.h>
#include <math.h>
/* multiply arr1 n*m by scalar scal and return in arr2 */
/* arr1 and arr2 may be the same matrices.             */
int iscalmult (int arr1[1][1],int n,int m,int arr2[1][1],int scal)
   
{
   int i,j;
   for (i=0; i<n; ++i) {
      for (j=0; j<m; ++j) {
         arr2[i*m][j] = scal * arr1[i*m][j];
      }
   }
}


