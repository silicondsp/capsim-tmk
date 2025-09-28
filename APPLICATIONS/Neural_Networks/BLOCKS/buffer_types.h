

typedef struct  {
        int     length;
        double   *vector_P;
} doubleVector_t, *doubleVector_Pt;

#define INVEC(BUFFER_NO,DELAY) \
         *(doubleVector_t *)BufferAccess(star_P->inBuffer_P[BUFFER_NO],1,DELAY)

#define OUTVEC(BUFFER_NO,DELAY) \
         *(doubleVector_t *)BufferAccess(star_P->outBuffer_P[BUFFER_NO],0,DELAY)



