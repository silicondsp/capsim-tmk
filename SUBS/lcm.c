
/* lcm() */
/**********************************************************************/
/* This subroutine returns the Least Common Multiple of two integers. */
/* These integers are entered as arguments.                           */
/* 		LCM(a,b) = ab / GCD(a,b)                              */
/* The method of successive differences (Euclid's method) is used to  */
/* find the Greatest Common Denominator.                              */
/**********************************************************************/
int gcd(int a,int b);


int lcm(int a,int b)
	 
{
	int product = a*b;

return(product / gcd(a,b));	/* this division is always int! */

}	/* ends lcm() */

int gcd(int a,int b)
	 
{
while(a != b) {
	if(a > b) a -= b;
	else      b -= a;
}
return(a);

} 	/* ends gcd() */
