#include <stdio.h>
#include <math.h>
/* matrix multiply arr1 n1*m1 by arr2 m1*m2 and return in arr3 */
/* arr1 and arr2 may be the same matrices.                     */
void multmat (double arr1[1][1],double arr2[1][1],int n1,int m1,int m2,double arr3[1][1])
   
{
   int i,j,k;
   for (i=0;i<n1;++i){
      for (j=0;j<m2;++j){
         arr3[i*m2][j] = 0;
         for (k=0;k<m1;++k){
            arr3[i*m2][j] = arr3[i*m2][j] + arr1[i*m1][k]*arr2[k*m2][j];
         }
      }
   }
   return;
}



/* multiply arr1 n*m by scalar scal and return in arr2 */
/* arr1 and arr2 may be the same matrices.             */
void scalmult (double arr1[1][1],int n,int m,double arr2[1][1],double scal)
   
{
   int i,j;
   for (i=0; i<n; ++i) {
      for (j=0; j<m; ++j) {
         arr2[i*m][j] = scal * arr1[i*m][j];
      }
   }
}
