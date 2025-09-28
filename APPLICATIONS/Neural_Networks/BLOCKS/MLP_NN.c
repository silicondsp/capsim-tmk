 
#ifdef LICENSE

/*
 * (c) 2018 Silicon DSP Corporation 
 */


#endif
 
#ifdef SHORT_DESCRIPTION

 Multilayer Perceptron Neural Network

#endif
 
#ifdef PROGRAMMERS

#endif






#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>



 

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <math.h>
#include "buffer_types.h"




/*
 *           STATES STRUCTURE 
 */ 
typedef struct {
       int   __stateVariable;
       double*   __hiddenVal;
       double**   __weightsIH;
       double*   __weightsHO;
       double   __errThisPat;
       double   __outPred;
       double   __RMSerror;
       int   __patNum;
     } state_t,*state_Pt;

/*
 *         STATE DEFINES 
 */ 
#define  stateVariable  (state_P->__stateVariable)
#define  hiddenVal  (state_P->__hiddenVal)
#define  weightsIH  (state_P->__weightsIH)
#define  weightsHO  (state_P->__weightsHO)
#define  errThisPat  (state_P->__errThisPat)
#define  outPred  (state_P->__outPred)
#define  RMSerror  (state_P->__RMSerror)
#define  patNum  (state_P->__patNum)

/*         
 *    INPUT BUFFER DEFINES 
 */ 
#define x(DELAY) (*(( doubleVector_t   *)PIN(0,DELAY)))
#define desired(DELAY) (*(( float   *)PIN(1,DELAY)))

/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
#define error(delay) *( float   *)POUT(0,delay)
#define dest(delay) *( float   *)POUT(1,delay)

/*         
 *    PARAMETER DEFINES 
 */ 
#define numberOfInputs (param_P[0]->value.d)
#define numPatterns (param_P[1]->value.d)
#define LR_IH (param_P[2]->value.f)
#define LR_HO (param_P[3]->value.f)
#define numberOfHidden (param_P[4]->value.d)
#define thisSampleParameter (param_P[5]->value.f)
/*-------------- BLOCK CODE ---------------*/
 int  
MLP_NN
(int run_state,block_Pt block_P)

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     
	state_Pt state_P = (state_Pt)star_P->state_P;
     
/*
 *              Declarations 
 */
 

   	int i,j,k;
   	int ii;
   	float fpixel;
   	doubleVector_t  theVector ;
   	double sum;
   	double randVal;
   	double weightChange;
   	double xx;
   	double desiredbp;


switch (run_state) {

 
 


 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
     char   *pdef0 = "  number of inputs (includes bias) ";
     char   *ptype0 = "int";
     char   *pval0 = "3";
     char   *pname0 = "numberOfInputs";
     char   *pdef1 = " number of patterns (includes bias)";
     char   *ptype1 = "int";
     char   *pval1 = "4";
     char   *pname1 = "numPatterns";
     char   *pdef2 = " LR_IH";
     char   *ptype2 = "float";
     char   *pval2 = "0.7";
     char   *pname2 = "LR_IH";
     char   *pdef3 = " LR_HO";
     char   *ptype3 = "float";
     char   *pval3 = "0.07";
     char   *pname3 = "LR_HO";
     char   *pdef4 = " number Hidden ";
     char   *ptype4 = "int";
     char   *pval4 = "4";
     char   *pname4 = "numberOfHidden";
     char   *pdef5 = " Sample Parameter Definition ";
     char   *ptype5 = "float";
     char   *pval5 = "1999.99";
     char   *pname5 = "thisSampleParameter";
KrnModelParam(indexModel88,0 ,pdef0,ptype0,pval0,pname0);
KrnModelParam(indexModel88,1 ,pdef1,ptype1,pval1,pname1);
KrnModelParam(indexModel88,2 ,pdef2,ptype2,pval2,pname2);
KrnModelParam(indexModel88,3 ,pdef3,ptype3,pval3,pname3);
KrnModelParam(indexModel88,4 ,pdef4,ptype4,pval4,pname4);
KrnModelParam(indexModel88,5 ,pdef5,ptype5,pval5,pname5);

      }
break;
   


/*         
 *    OUTPUT BUFFER SYSTEM  INITS 
 */ 
 case OUTPUT_BUFFER_INIT: 
 {
 int indexOC = block_P->model_index;
     char   *ptypeOut0 = " float ";
     char   *pnameOut0 = " error ";
     char   *ptypeOut1 = " float ";
     char   *pnameOut1 = " dest ";
KrnModelConnectionOutput(indexOC,0 ,pnameOut0,ptypeOut0);
KrnModelConnectionOutput(indexOC,1 ,pnameOut1,ptypeOut1);
}
 break;

/*         
 *    INPUT BUFFER SYSTEM  INITS 
 */ 
 case INPUT_BUFFER_INIT:
 {
 int indexIC = block_P->model_index;
     char   *ptypeIn0 = " doubleVector_t ";
     char   *pnameIn0 = " x ";
     char   *ptypeIn1 = " float ";
     char   *pnameIn1 = " desired ";
KrnModelConnectionInput(indexIC,0 ,pnameIn0,ptypeIn0);
KrnModelConnectionInput(indexIC,1 ,pnameIn1,ptypeIn1);
}
 break;

/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
             stateVariable = 0 ;
        hiddenVal = 0 ;
        weightsIH = 0 ;
        weightsHO = 0 ;
        errThisPat = 0.0 ;
        outPred = 0.0 ;
        RMSerror = 0.0 ;
        patNum = 0  ;



         
   if(NO_OUTPUT_BUFFERS() != 2 ){
       fprintf(stdout,"%s:2 outputs expected; %d connected\n",
              STAR_NAME,NO_OUTPUT_BUFFERS());
	      return(201);
   }

   SET_CELL_SIZE_OUT(0,sizeof( float ));

   SET_CELL_SIZE_OUT(1,sizeof( float ));

         
   if(NO_INPUT_BUFFERS() != 2 ){
       fprintf(stdout,"%s:2 inputs expected; %d connected\n",
              STAR_NAME,NO_INPUT_BUFFERS());
	      return(200);
   }

   SET_CELL_SIZE_IN(0,sizeof( doubleVector_t ));

   SET_CELL_SIZE_IN(1,sizeof( float ));

break;

/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 

 


    SET_CELL_SIZE_IN(0,sizeof(doubleVector_t));

	hiddenVal = (double*) calloc(numberOfHidden, sizeof(double));
    if(hiddenVal==NULL) {
         fprintf(stderr,"MLP_NN could not allocate space for hiddenVal \n");
         return(1);
    }
    weightsHO = (double*) calloc(numberOfHidden, sizeof(double));
    if(weightsHO==NULL) {
         fprintf(stderr,"MLP_NN could not allocate space for weightsHO \n");
         return(1);
    }
    
    weightsIH = (double**) calloc(numberOfInputs, sizeof(double*));
    if(weightsIH==NULL) {
         fprintf(stderr,"MLP_NN could not allocate space for weightsIH \n");
         return(1);
    }
    for(k=0; k< numberOfInputs; k++) {
            weightsIH[k] = (double*) calloc(numberOfHidden, sizeof(double));
            
            if(weightsIH[k]==NULL) {
                    fprintf(stderr,"MLP_NN could not allocate space for weightsIH[k] k=%d \n",k);
                    return(1);
            }            
            
    }
    
    //************************************
    // set weights to random numbers 
 
     srand ( time(NULL) );
     for(int j = 0;j<numberOfHidden;j++)
     {
              randVal=((double)rand())/(double)RAND_MAX;
              weightsHO[j] = (double)(randVal - 0.5)/2;
              for(int i = 0;i<numberOfInputs;i++)
              {
                     randVal=((double)rand())/(double)RAND_MAX;
                     weightsIH[i][j] = (randVal - 0.5)/5;
                     printf("Weight = %f\n", weightsIH[i][j]);
              }
      }

   



break;

/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 

 




for(ii = MIN_AVAIL(); ii>0; ii--) {  
        
       
         IT_IN(0);
         IT_IN(1);
         
      //   theVector=INVEC(0,0);
      
        theVector=x(0);
         sum=0;
        for(i=0; i< theVector.length; i++) {
        
            
           //   sum=sum+theVector.vector_P[i];
          //    printf("MLP_NN:%d    %f \n", i,theVector.vector_P[i]);
               if(theVector.vector_P[i]==0) theVector.vector_P[i]=-1;
           //    printf("MLP_NN:%d    %f \n", i,theVector.vector_P[i]);
           
            
        }
        
         
         fprintf(stderr,"MLP_NN desired=%f\n",desired(0));
         if(desired(0)==0) desiredbp=-1;
         else
                            desiredbp=1;
                            
                            
        for(i=0; i< theVector.length; i++) {
        
            
            
               printf("MLP_NN VEC :%d    %f \n", i,theVector.vector_P[i]);              
                
             
            
        }
          printf("MLP_NN:desired     %f \n", desiredbp);                    
         
         if(theVector.length != numberOfInputs-1) {
             fprintf(stderr,"MLP_NN input vector length not equal to numberOfInputs-1 %d:%d\n",theVector.length,numberOfInputs);
             return(1);
         
         } 
       /*
        * This is just to show how to access the vector elements
        */
        
        sum=0;
        for(i=0; i< theVector.length; i++) {
        
            
              sum=sum+theVector.vector_P[i];
         //     printf("MLP_NN:%d    %f \n", i,theVector.vector_P[i]);
           
           
            
        }
        for(i = 0;i<numberOfHidden;i++)
        {
	             hiddenVal[i] = 0.0;

                 for(int j = 0;j<numberOfInputs;j++)
                 {
	//                    hiddenVal[i] = hiddenVal[i] + (trainInputs[patNum][j] * weightsIH[j][i]);
	                      if(j==numberOfInputs-1) {
	                           // bias 
	                           hiddenVal[i] = hiddenVal[i] +   weightsIH[j][i];
	                      } else {
	                          hiddenVal[i] = hiddenVal[i] + (theVector.vector_P[j] * weightsIH[j][i]);
	                      }
                 }

                 hiddenVal[i] = tanh(hiddenVal[i]);
         }
         //calculate the output of the network
         //the output neuron is linear
         outPred = 0.0;

         for(i = 0;i<numberOfHidden;i++)
         {
                 outPred = outPred + hiddenVal[i] * weightsHO[i];
         }
         //calculate the error
         
         errThisPat = outPred - desiredbp;
         
         
         //************************************
         //adjust the weights hidden-output
         //void WeightChangesHO(void)
 
         for( k = 0;k<numberOfHidden;k++)
         {
                  weightChange = LR_HO * errThisPat * hiddenVal[k];
                  weightsHO[k] = weightsHO[k] - weightChange;

                   //regularisation on the output weights
                   if (weightsHO[k] < -5)
                   {
                          weightsHO[k] = -5;
                    }
                    else if (weightsHO[k] > 5)
                    {
                          weightsHO[k] = 5;
                    }
          }

         //************************************
         // adjust the weights input-hidden
         //void WeightChangesIH(void)
 

          for( i = 0;i<numberOfHidden;i++)
          {
                for(  k = 0;k<numberOfInputs;k++)
                {
                      xx = 1 - (hiddenVal[i] * hiddenVal[i]);
                      xx = xx * weightsHO[i] * errThisPat * LR_IH;
                  //    xx = xx * trainInputs[patNum][k];
                      if(k==numberOfInputs-1) {
	                           // bias 
	                           xx=xx;
	                   } else {
                            xx = xx * theVector.vector_P[k];
                       }
                      
                      
                      weightChange = xx;
                      weightsIH[k][i] = weightsIH[k][i] - weightChange;
                 }
          }

         
   
           /*
	    * ready output buffer for sample
	    * check for overflow
	    */
	   if(IT_OUT(0)) {
				KrnOverflow("MLP_NN",0);
				return(99);
	   }
	   /*
	    * output the sample
	    */
	   error(0)=errThisPat;
	   
	   /*
	    * ready output buffer for sample
	    * check for overflow
	    */
	   if(IT_OUT(1)) {
				KrnOverflow("MLP_NN",0);
				return(99);
	   }
	    dest(0)=outPred;
	   


}
    


break;

/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 

 
#if 1111
    if(hiddenVal) {
         free(hiddenVal);
    
    }
    if(weightsHO) {
         free(weightsHO);
    
    }
    for(k=0; k<numberOfInputs ; k++) {
           free(weightsIH[k]); 
    
    }
    free(weightsIH);
#endif    


break;
}
return(0);
}
