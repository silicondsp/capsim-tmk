/**********************************************************************
 				
				qpsk

 *********************************************************************
Description:
This star inputs data and ouputs the coordinates based on qpsk.
It produces an in pahse and quadrature component.

Not very efficient but illustrative.

Progrramer: Sasan Ardalan
Date: Dec 14, 2000

*/

input_buffer
	float data;
end

output_buffers
	float inPhase;
	float quadPhase;
end

states
	int	numberBits=0;
end

declarations
	int	i,k,j;
	static float a_A[4]= {1,1,-1,-1};
	static float b_A[4]= {1,-1,1,-1};
	float x,y;
end

initialization_code
	numberBits =0;
end

main_code
	while(it_in(0)) {

			
		numberBits++;
		if(numberBits == 2){	
			numberBits=0;

			
	                j=(int)(data(0)+2*data(1));
	                x=a_A[j];
	                y=b_A[j];
	
	                /* printf("data(0)=%f data(1)=%f j=%d x=%f y=%f \n",data(0),data(1),j,x,y); */


  			if(it_out(0)) {
				KrnOverflow("qpsk",0) ;
				return(99);
			}
			
  			if(it_out(1) ) {
				KrnOverflow("qpsk",0) ;
				return(99);
			}
  			inPhase(0) = x;
  			quadPhase(0) = y;
		}
		
	}
	return(0);
end



